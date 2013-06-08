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

#import "BNFPath.h"

@implementation BNFPath

@synthesize components = _components;

- (id)init {
    
    self = [super init];
    
    if (self ) {
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setComponents:list];
        [list release];
    }
    
    return self;
}

- (void)parse:(BNFParserStatus *)status states:(NSMutableDictionary *)states {
    
    NSEnumerator *enumerator = [_components objectEnumerator];
    BNFComponent *component;

    while (component = [enumerator nextObject]) {
        [component parse:status states:states];
        
        if ([status isFailed]) {
            break;
        }
    }   
}

- (void)addComponent:(BNFComponent *)component {
    [_components addObject:component];
}

- (void)dealloc {
    [_components release];
    [super dealloc];
}
@end