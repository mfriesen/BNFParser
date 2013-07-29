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

#import "Stack.h"

@implementation Stack

- (id)init {
    
    if (self = [super init] ) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setObjects:list];
        [list release];
        
        [self setCount:0];
    }
    
    return self;
}

- (void)dealloc {
    [_objects release];
    [super dealloc];
}

- (id)firstElement {
    id obj = nil;
    if ([_objects count] > 0) {
        obj = [[[_objects objectAtIndex:0] retain] autorelease];
    }
    
    return obj;
}

- (void)push:(id)anObject {
    [_objects addObject:anObject];
    [self setCount:[_objects count]];
}

- (id)peek {
    
    id obj = nil;
    if ([_objects count] > 0) {
        obj = [[[_objects lastObject] retain] autorelease];
    }
    
    return obj;
}

- (id)pop {
    
    id obj = nil;
    if ([_objects count] > 0) {
        obj = [[[_objects lastObject] retain] autorelease];
        [_objects removeLastObject];
        [self setCount:[_objects count]];
    }
    
    return obj;
}

- (void)clear {
    [_objects removeAllObjects];
    [self setCount:0];
}

- (BOOL)isEmpty {
    return _count == 0;
}

@end