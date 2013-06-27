//
//  BNFState.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFToken.h"

@interface BNFState : NSObject

typedef enum BNFRepetition : NSInteger {
    BNFRepetitionNONE,
    BNFRepetitionZERO_OR_MORE
} BNFRepetition;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) BNFState *nextState;
@property (nonatomic, assign) BNFRepetition repetition;

- (id)init;
- (id)initWithName:(NSString *)name;

- (BOOL)match:(BNFToken *)token;
- (BOOL)isEnd;
- (BOOL)isTerminal;

@end
