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

#import "Stack.h"

@implementation Stack

@synthesize m_array = _m_array;
@synthesize count = _count;

- (id)init {
    
    if (self = [super init] ) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setM_array:list];
        [list release];
        
        [self setCount:0];
    }
    
    return self;
}

- (void)dealloc {
    [_m_array release];
    [super dealloc];
}

- (void)push:(id)anObject {
    [_m_array addObject:anObject];
    [self setCount:[_m_array count]];
}

- (id)top {
    
    id obj = nil;
    if ([_m_array count] > 0) {
        obj = [[[_m_array lastObject]retain]autorelease];
    }
    
    return obj;
}

- (id)pop {
    
    id obj = nil;
    if ([_m_array count] > 0) {
        obj = [[[_m_array lastObject]retain]autorelease];
        [_m_array removeLastObject];
        [self setCount:[_m_array count]];
    }
    
    return obj;
}

- (void)clear {
    [_m_array removeAllObjects];
    [self setCount:0];
}

- (BOOL)empty {
    return _count == 0;
}

@end