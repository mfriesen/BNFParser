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

#import "BNFParserTests.h"
#import "BNFSequenceFactory.h"

@implementation BNFParserTests

- (void)setUp {
    [super setUp];
    
    BNFTokenizerFactory *tokenizerFactory = [[BNFTokenizerFactory alloc] init];
    [self setTokenizerFactory:tokenizerFactory];
    [tokenizerFactory release];
  
    BNFSequenceFactory *stateDefinitionFactory = [[BNFSequenceFactory alloc] init];
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

/**
 * testOpenCloseBrace.
 *
 */
- (void)testParse01 {
    
    // given
    NSString *json = @"{}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
    STAssertTrue([result success], @"assume success");
}

/**
 * testOpenCloseBracket.
 *
 */
- (void)testParse02 {
    
    // given
    NSString *json = @"[]";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testEmpty.
 *
 */
- (void)testParse03 {
    
    // given
    NSString *json = @"";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testQuotedString.
 *
 */
- (void)testParse04 {
    
    // given
    NSString *json = @"{ \"asd\":\"123\"}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testNumber.
 *
 */
- (void)testParse05 {
    
    // given
    NSString *json = @"{ \"asd\":123}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testSimple01.
 *
 */
- (void)testParse06 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\"}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testSimple02.
 *
 */
- (void)testParse07 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\",\"created_time\": \"2011-06-19T09:14:16+0000\"}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testNested.
 *
 */
- (void)testParse08 {
    
    // given
    NSString *json = @"{\"card\":\"2\",\"numbers\":{\"Conway\":[1,11,21,1211,111221,312211],\"Fibonacci\":[0,1,1,2,3,5,8,13,21,34]}}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testArray.
 *
 */
- (void)testParse09 {
    
    // given
    NSString *json = @"[1,11,21,1211,111221,312211]";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * testBadSimple00.
 *
 */
- (void)testParse10 {
    
    // given
    NSString *json = @"asdasd";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertEqualObjects([result error], [result top], @"assume equals");
    STAssertEqualObjects(json, [[result error] stringValue], @"assume equals");
}

/**
 * testBadSimple01.
 *
 */
- (void)testParse11 {
    
    // given
    NSString *json = @"{ asdasd";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not error");
    STAssertTrue([[result error] identifier] == 2, @"got %d",[[result error] identifier]);
    STAssertEqualObjects(@"asdasd", [[result error] stringValue], @"assume equals");
}

/**
 * testBadSimple02.
 *
 */
- (void)testParse12 {
    
    // given
    NSString *json = @"{\"id\": \"118019484951173_228591\",\"message\": \"test test\",\"created_time\"! \"2011-06-19T09:14:16+0000\"}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertFalse([result success], @"assume fail");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not nil");
    STAssertEqualObjects(@"!", [[result error] stringValue], @"assume equals");
}

/**
 * testBadSimple03.
 *
 */
- (void)testParse13 {
    
    // given
    NSString *json = @"[";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not nil");
    STAssertFalse([result success], @"assume fail");
    STAssertEqualObjects(@"[", [[result error] stringValue], @"assume equals");
}

/**
 * good JSON.
 *
 */
- (void)testParse14 {
    
    // given
    NSString *json = @"{\"A\":null}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertTrue([result success], @"assume success");
    STAssertNotNil([result top], @"assume not nil");
    STAssertNil([result error], @"assume nil");
}

/**
 * bad JSON.
 *
 */
- (void)testParse15 {
    // given
    NSString *json = @"{\"A\":\"B\",\"C\":}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then    
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume not nil");
    STAssertFalse([result success], @"assume fail");
    STAssertEqualObjects(@"}", [[result error] stringValue], @"assume equals");

}

/**
 * test extra characters at the end.
 *
 */
- (void)testParse16 {
    
    // given
    NSString *json = @"{}a";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    
    // when
    BNFParseResult *result = [_parser parse:tokens];
    
    // then
    STAssertNotNil([result top], @"assume not nil");
    STAssertNotNil([result error], @"assume nil");
    STAssertFalse([result success], @"assume success");
    STAssertEqualObjects(@"a", [[result error] stringValue], @"assume equals");
}

/**
 * cancelled operation.
 *
 */
- (void)testParse100 {
    // given
    NSString *json = @"{\"A\":\"B\",\"C\":}";
    BNFTokens *tokens = [_tokenizerFactory tokens:json];
    NSBlockOperation *operation = [[[NSBlockOperation alloc] init] autorelease];
    [operation cancel];
    
    // when
    BNFParseResult *result = [_parser parse:tokens operation:operation];
    
    // then
    STAssertNil(result, @"assume nil");
}

@end
