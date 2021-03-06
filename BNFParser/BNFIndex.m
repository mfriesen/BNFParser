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

#import "BNFIndex.h"

@implementation BNFIndex

- (id)init {
    self = [super init];
    
    if (self) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setNodes:list];
        [list release];
    }
    
    return self;
}

- (void)addNode:(BNFIndexNode *)node {
    [_nodes addObject:node];
}

- (BNFIndexPath *)path:(NSString *)path {
    return [self path:_nodes path:path];
}

- (NSMutableArray *)paths {
    return _nodes;
}

- (void)dealloc {
    [_nodes release];
    [super dealloc];
}

@end
