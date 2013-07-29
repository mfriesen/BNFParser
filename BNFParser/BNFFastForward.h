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

#import <Foundation/Foundation.h>
#import "BNFTokenizerFactory.h"

@interface BNFFastForward : NSObject

@property (nonatomic, assign) BNFTokenizerType start;
@property (nonatomic, retain) NSMutableArray *end;
@property (nonatomic, retain) NSMutableString *ms;

- (id)init;
- (BOOL)isActive;
- (BOOL)isComplete:(BNFTokenizerType)type lastType:(BNFTokenizerType) lastType position:(NSInteger)i length:(NSInteger)len;
- (void)complete;
- (void)appendIfActiveChar:(unichar)c;
- (void)appendIfActiveNSString:(NSString *)s;
- (NSString *)getString;
- (void)setEndWithType:(BNFTokenizerType)type;
- (void)setEndWithType:(BNFTokenizerType)type1 type2:(BNFTokenizerType)type2;

@end
