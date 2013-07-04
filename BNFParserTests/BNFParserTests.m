//
//  BNFParserTests.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-28.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFParserTests.h"
#import "BNFStateDefinitionFactory.h"

@implementation BNFParserTests

- (void)setUp {
    [super setUp];
    
    BNFTokenizerFactory *tokenizerFactory = [[BNFTokenizerFactory alloc] init];
    [self setTokenizerFactory:tokenizerFactory];
    [tokenizerFactory release];
  
    BNFStateDefinitionFactory *stateDefinitionFactory = [[BNFStateDefinitionFactory alloc] init];
    NSMutableDictionary *dic = [stateDefinitionFactory json];
    
    BNFParser *parser = [[BNFParser alloc] initWithStateDefinitions:dic];
    [self setParser:parser];
    [parser release];
    [stateDefinitionFactory release];
}

- (void)tearDown {
    [_tokenizerFactory release];
    [_parser release];
    [super tearDown];
}

- (void)testOpenClose {
    
    // given
    NSString *json = @"{}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
    STAssertTrue([result success], @"assume success");
}

- (void)testEmpty {
    
    // given
    NSString *json = @"";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testQuotedString {
    
    // given
    NSString *json = @"{ \"asd\":\"123\"}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testNumber {
    
    // given
    NSString *json = @"{ \"asd\":123}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testSimple01 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\"}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testSimple02 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\",\"created_time\": \"2011-06-19T09:14:16+0000\"}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testNested {
    
    // given
    NSString *json = @"{\"card\":\"2\",\"numbers\":{\"Conway\":[1,11,21,1211,111221,312211],\"Fibonacci\":[0,1,1,2,3,5,8,13,21,34]}}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testArray {
    
    // given
    NSString *json = @"[1,11,21,1211,111221,312211]";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

- (void)testBadSimple00 {
    
    // given
    NSString *json = @"asdasd";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertEqualObjects([result error], [result top], @"assume equals");
    STAssertEqualObjects(json, [[result error] stringValue], @"assume equals");
}

- (void)testBadSimple01 {
    
    // given
    NSString *json = @"{ asdasd";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not error");
    STAssertTrue([[result error] identifier] == 2, @"got %d",[[result error] identifier]);
    STAssertEqualObjects(@"asdasd", [[result error] stringValue], @"assume equals");
}

- (void)testBadSimple02 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\",\"created_time\"! \"2011-06-19T09:14:16+0000\"}";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not nil");
    STAssertEqualObjects(@"!", [[result error] stringValue], @"assume equals");
}

- (void)testBadSimple03 {
    
    // given
    NSString *json = @"[";
    BNFToken *token = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:token];
    
    // then
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not nil");
    STAssertFalse([result success], @"assume fail");
    STAssertEqualObjects(@"[", [[result error] stringValue], @"assume equals");
}

@end
