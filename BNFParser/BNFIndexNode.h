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

#import "BNFIndexPath.h"

@interface BNFIndexNode : BNFIndexPath

/** key for the node. */
@property (nonatomic, retain) NSString *keyValue;

/** value for the node. */
@property (nonatomic, retain) NSString *stringValue;

/** whether this node should be searched or skipped. */
@property (nonatomic, assign) BOOL shouldSkip;

/** list of children nodes. */
@property (nonatomic, retain) NSMutableArray *nodes;

- (id)init;
- (id)initWithKeyValue:(NSString *)keyValue stringValue:(NSString *)stringValue;

@end
