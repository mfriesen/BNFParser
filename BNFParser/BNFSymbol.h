//
//  BNFSymbol.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-08-19.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNFSymbol : NSObject

typedef enum BNFRepetition : NSInteger {
    BNFRepetition_NONE,
    BNFRepetition_ZERO_OR_MORE
} BNFRepetition;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BNFRepetition repetition;

- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name repetition:(BNFRepetition)repetition;
    
@end
