//
//  BNFFastForward.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-24.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
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
- (void)appendIfActiveChar:(char)c;
- (void)appendIfActiveNSString:(NSString *)s;
- (NSString *)getString;
- (void)setEndWithType:(BNFTokenizerType)type;
- (void)setEndWithType:(BNFTokenizerType)type1 type2:(BNFTokenizerType)type2;

@end
