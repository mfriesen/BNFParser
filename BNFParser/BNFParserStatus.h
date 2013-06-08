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

#import <Foundation/Foundation.h>
#import "BNFToken.h"

@interface BNFParserStatus : NSObject

typedef enum {
    STATE_OKAY,
    STATE_FAILED,
    STATE_COMPLETE
} BNFParserStatusType;

- (id)initWithToken:(BNFToken *)token;

- (void)incrementDepth;
- (void)decrementDepth;
- (NSInteger)depth;

- (void)setStatus:(BNFParserStatusType)status;

- (void)setCurrent:(BNFToken *)token;
- (BNFToken *)current;

- (BNFToken *)error;
- (BNFToken *)top;

- (BOOL)isFailed;
- (BOOL)isOkay;
- (BOOL)isComplete;

@end
