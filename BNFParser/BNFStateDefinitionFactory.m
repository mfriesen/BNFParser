//
// Copyright 2013 Mike Friesen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "BNFStateDefinitionFactory.h"
#import "PropertyParser.h"
#import "BNFStateDefinition.h"
#import "BNFStateEnd.h"
#import "BNFState.h"
#import "BNFStateNumber.h"
#import "BNFStateQuotedString.h"
#import "BNFStateEmpty.h"

@implementation BNFStateDefinitionFactory

- (NSMutableDictionary *)json {
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSMutableDictionary *prop = [self loadProperties];
    
    for (NSString *key in prop) {
        
        NSString *value = [prop objectForKey:key];
        NSArray *values = [value componentsSeparatedByString:@"|"];
        
        NSMutableArray *states = [self createStates:key states:values];
        NSMutableArray *sorted = [self sort:states];
        
        BNFStateDefinition *def = [[BNFStateDefinition alloc] init];
        [def setName:key];
        [def setStates:sorted];
        [dic setValue:def forKey:key];
        
        [def release];
    }

    return dic;
}

- (NSMutableArray *)sort:(NSMutableArray *)states {
    
    NSArray *sortedArray;
    sortedArray = [states sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        BNFState *first = (BNFState*)a;
        BNFState *second = (BNFState*)b;
        if ([first isKindOfClass:[BNFStateEmpty class]]) {
            return 1;
        } else if ([second isKindOfClass:[BNFStateEmpty class]]) {
            return -1;
        }
        return 0;
    }];
    
    return [[sortedArray mutableCopy] autorelease];
}

- (NSMutableDictionary *)loadProperties {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json.bnf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    PropertyParser *parser = [[PropertyParser alloc] init];
    NSMutableDictionary *dic = [parser parse:s];
    [parser release];
    
    return dic;
}


- (NSMutableArray *)createStates:(NSString *)name states:(NSArray *)states {

    NSMutableArray *c = [[[NSMutableArray alloc] init] autorelease];
 
    for (NSString *s in states) {

        BNFState *firstState = nil;
        BNFState *previousState = nil;
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *values = [s componentsSeparatedByString:@" "];
 
        for (NSString *ss in values) {
 
            BNFState *state = [self createState:ss];
 
            if (!firstState) {
                firstState = state;
            }
 
            if (previousState) {
                [previousState setNextState:state];
            }
 
            previousState = state;
        }
 
        if (previousState && [name isEqualToString:@"@start"]) {
            BNFStateEnd *end = [[BNFStateEnd alloc] init];
            [previousState setNextState:end];
            [end release];
        }
 
        [c addObject:firstState];
    }
 
    return c;
}

- (BNFState *)createState:(NSString *) ss {
    
    BOOL isTerminal = [self isTerminal:ss];
    NSString *name = [self fixQuotedString:ss];
    BNFRepetition repetition = BNFRepetitionNONE;
 
    if ([name hasSuffix:@"*"]) {
        repetition = BNFRepetitionZERO_OR_MORE;
        name = [name substringToIndex:[name length] - 1];
    }
 
    BNFState *state = [self createStateInstance:name isTerminal:isTerminal];
    [state setName:name];
    [state setRepetition:repetition];
 
    return state;
}

- (BNFState *)createStateInstance:(NSString *)ss isTerminal:(BOOL)terminal {
    BNFState *state = nil;
 
    if (terminal) {
        state = [[[BNFStateTerminal alloc] init] autorelease];
    } else if ([ss isEqualToString:@"Number"]) {
        state = [[[BNFStateNumber alloc] init] autorelease];
    } else if ([ss isEqualToString:@"QuotedString"]) {
        state = [[[BNFStateQuotedString alloc] init] autorelease];
    } else if ([ss isEqualToString:@"Empty"]) {
        state = [[[BNFStateEmpty alloc] init] autorelease];
    } else {
        state = [[[BNFState alloc] init] autorelease];
    }
 
    return state;
}
 
- (BOOL)isTerminal:(NSString *) ss {
    return [ss hasPrefix:@"'"] || [ss hasPrefix:@"\""];
}
 
- (NSString *)fixQuotedString:(NSString *)ss {
 
    NSInteger len = [ss length];
    NSInteger start = [ss hasPrefix:@"'"] ? 1 : 0;
    NSInteger end = [ss hasSuffix:@";"] ? len - 1 : len;
    end = [ss hasSuffix:@"';"] ? len - 2 : end;
 
    if (start > 0 || end < len) {
        ss = [ss substringWithRange:NSMakeRange(start, end - start)];
    }
 
    return ss;
}

@end
