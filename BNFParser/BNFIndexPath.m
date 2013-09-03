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
#import "BNFIndexNode.h"

@implementation BNFIndexPath

- (BNFIndexPath *)path:(NSMutableArray *)nodes path:(NSString *)path {
    
    BNFIndexPath *result = nil;
    
    for (BNFIndexNode *node in nodes) {
        
        if ([node shouldSkip]) {
            
            result = [self path:[node nodes] path:path];
            break;
            
        } else {
            
            if ([[node keyValue] isEqualToString:path]) {
                result = node;
                break;
            }
        }
    }
    
    return result;
}

- (BNFIndexPath *)path:(NSString *)path {
    return nil;
}

- (BNFIndexNode *)node {
    return nil;
}

@end
