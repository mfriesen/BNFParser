//
//  BNFStateNumberTests.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BNFStateNumber.h"
#import "BNFToken.h"

@interface BNFStateNumberTests : SenTestCase

@property (nonatomic, retain) BNFStateNumber *state;
@property (nonatomic, retain) BNFToken *token;

@end
