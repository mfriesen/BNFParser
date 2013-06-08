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

#import "BNFState.h"

@implementation BNFState

@synthesize paths = _paths;
@synthesize name = _name;
@synthesize supportEmpty = _supportEmpty;

- (id)init {
    
    self = [super init];
    
    if (self) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setPaths:list];
        [list release];
    }
    
    return self;
}

- (void)addPath:(BNFPath *)path {
    [_paths addObject:path];
}

- (void)debug:(NSString *)str depth:(NSInteger)depth{
    for (NSInteger i = 0; i < depth; i++) {
        printf("\t");
    }
    printf("%s\n", [str UTF8String]);
}

- (void)parse:(BNFParserStatus *)pstatus states:(NSMutableDictionary *)states {
    [self parse:pstatus states:states repetition:BNFRepetitionNone];
}

- (void)parse:(BNFParserStatus *)pstatus states:(NSMutableDictionary *)states repetition:(BNFRepetition)repetition {
    
    BNFToken *startToken = [pstatus current];
    
    [pstatus incrementDepth];
//    [self debug:_name depth:[pstatus depth]];
    
    for (BNFPath *path in _paths) {
        
        BNFToken *token = [pstatus current];
        [path parse:pstatus states:states];
        
        if ([pstatus isFailed]) {
            [pstatus setCurrent:token];
        } else {
            break;
        }
    }
    
    if (_supportEmpty && [pstatus isFailed]) {
        if ([pstatus depth] == 0 && !startToken) {
            [pstatus setStatus:STATE_COMPLETE];
        } else {
            [pstatus setStatus:STATE_OKAY];
        }
        
        [self debug:@"Empty" depth:[pstatus depth]];
    }
    
    if (repetition == BNFRepetitionZeroOrMore) {
        
        if ([pstatus isFailed]) {
            [pstatus setStatus:STATE_OKAY];
        } else if ([pstatus isOkay]) {
            [self parse:pstatus states:states repetition:repetition];
        }
    }
    
    [pstatus decrementDepth];
    
    if ([pstatus depth] == 0 && ![pstatus isComplete]) {
        [pstatus setStatus:STATE_FAILED];
    }
}

- (void)dealloc {
    [_name release];
    [_paths release];
    [super dealloc];
}

@end
