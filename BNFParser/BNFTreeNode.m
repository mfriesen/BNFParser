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

#import "BNFTreeNode.h"

@implementation BNFTreeNode

@synthesize key = _key;
@synthesize value = _value;
@synthesize nodes = _nodes;
@synthesize hasError = _hasError;

- (void)addNode:(BNFTreeNode *)node {

    if (!_nodes) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setNodes:list];
        [list release];
    }
    
    [_nodes addObject:node];
}

- (void)dealloc {
    [_nodes release];
    [_key release];
    [_value release];
    [super dealloc];
}

@end
