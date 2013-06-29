//
//  BNFParserTests.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-28.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BNFTokenizerFactory.h"
#import "BNFParser.h"

@interface BNFParserTests : SenTestCase

@property (nonatomic, retain) BNFTokenizerFactory *tokenizerFactory;
@property (nonatomic, retain) BNFParser *parser;

@end
