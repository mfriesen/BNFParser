//
//  Copyright (c) 2013 Mike Friesen
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "BNFComponent.h"
#import "BNFState.h"

@implementation BNFComponent

@synthesize isQuotedString = _isQuotedString;
@synthesize stateName = _stateName;
@synthesize repetition = _repetition;

- (id)init {
    self = [super init];
    if (self) {
        [self setRepetition:BNFRepetitionNone];
    }
    return self;
}

- (void)debug:(NSInteger)depth{
    for (NSInteger i = 0; i < depth; i++) {
        printf("\t");
    }
    printf("\t");
}

- (void)parse:(BNFParserStatus *)status states:(NSMutableDictionary *)states {
    
    if (_isQuotedString) {

        BNFToken *token = [status current];
        NSString *trimmedStateName = [self trimmedValue:_stateName];
        NSString *stringValue = [token stringValue];
        
//        [self debug:[status depth]];
//        printf("%s compare to %s\n", [trimmedStateName UTF8String], [stringValue UTF8String]);

        if ([_stateName isEqualToString:@"QuotedString"]) {
            
            if ([self isQuotedString:stringValue]) {
                [status setStatus:STATE_COMPLETE];
            } else {
                [status setStatus:STATE_FAILED];
            }
        }
        else if ([trimmedStateName isEqualToString:stringValue]) {
  
            [status setStatus:STATE_COMPLETE];
        }
        else
        {
            [status setStatus:STATE_FAILED];
        }
        
    } else {
        
        BNFState *state = [states objectForKey:_stateName];
        if (state) {            
            [state parse:status states:states repetition:_repetition];
        }
    }
}

- (BOOL)isQuotedString:(NSString *)string {
    return [string hasPrefix:@"\""] && [string hasSuffix:@"\""];
}

- (NSString *)trimmedValue:(NSString *)s {
    
    NSUInteger len = [s length];
    
    if (len < 2) {
        return s;
    }
    
    NSRange r = NSMakeRange(0, len);
    
    unichar c = [s characterAtIndex:0];
    if (!isalnum(c)) {
        unichar quoteChar = c;
        r.location = 1;
        r.length -= 1;
        
        c = [s characterAtIndex:len - 1];
        if (c == quoteChar) {
            r.length -= 1;
        }
        return [s substringWithRange:r];
    } else {
        return s;
    }
}

- (void)dealloc {
    [_stateName release];
    [super dealloc];
}

@end
