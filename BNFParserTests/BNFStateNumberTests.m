//
//  BNFStateNumberTests.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateNumberTests.h"
#import "BNFToken.h"

@implementation BNFStateNumberTests

- (void)setUp {
    [super setUp];
    BNFStateNumber *s = [[BNFStateNumber alloc] init];
    [self setState:s];
    [s release];
    
    BNFToken *token = [[BNFToken alloc] init];
    [self setToken:token];
    [token release];
}

- (void)tearDown {
    [_state release];
    [_token release];
    [super tearDown];
}

- (void)testNumber {
    [_token setValueWithString:@"1"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"-1"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"1.34"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"123"];
    STAssertTrue([_state match:_token], @"expect true");
}

- (void)testString {
    [_token setValueWithString:@"1a"];
    STAssertFalse([_state match:_token], @"expect false");
    
    [_token setValueWithString:@"a1"];
    STAssertFalse([_state match:_token], @"expect false");
}

@end
