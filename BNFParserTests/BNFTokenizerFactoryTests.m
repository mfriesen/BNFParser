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

#import "BNFTokenizerFactoryTests.h"

@implementation BNFTokenizerFactoryTests

- (void)setUp {
    [super setUp];
    BNFTokenizerFactory *f = [[BNFTokenizerFactory alloc] init];
    [self setFactory:f];
    [f release];
}

- (void)tearDown {
    [_factory release];
    [super tearDown];
}

/**
 * testEmpty.
 */
- (void)testTokens01 {
    
    // given
    NSString *s = @"";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"", [token stringValue], @"got %@", [token stringValue]);
    STAssertFalse([token isWord], @"not expected");
    STAssertFalse([token isNumber], @"not expected");
    STAssertFalse([token isSymbol], @"not expected");
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testSymbolAndWhiteSpace.
 */
- (void)testTokens02 {
    
    // given
    NSString *s = @"{ \n}";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue(1 == [token identifier], @"got %d", [token identifier]);
    STAssertTrue([token isSymbol], @"expected symbol");

    token = [token nextToken];
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue(2 == [token identifier], @"got %d", [token identifier]);
    STAssertTrue([token isSymbol], @"expected symbol");
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testSingleLineComment.
 */
- (void)testTokens03 {
    
    // given
    NSString *s = @"{ }//bleh\nasd";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"asd", [token stringValue], @"got %@", [token stringValue]);
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testMultiLineComment.
 */
- (void)testTokens04 {
    
    // given
    NSString *s = @"{ }/*bleh\n\nffsdf\n*/asd";

    // when
    BNFToken *token = [_factory tokens:s];

    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"asd", [token stringValue], @"got %@", [token stringValue]);
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testQuotedString01.
 */
- (void)testTokens05 {
    
    // given
    NSString *s = @"hi \"asd\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"hi", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"\"asd\"", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

/**
 * testQuotedString02.
 */
- (void)testTokens06 {
    
    // given
    NSString *s = @"\"asd\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd\"", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

/**
 * testQuotedString03.
 */
- (void)testTokens07 {
    
    // given
    NSString *s = @"\"asd's\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd's\"", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

/**
 * testQuotedString04.
 */
- (void)testTokens08 {
    
    // given
    NSString *s = @"\"asd's";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd's", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

/**
 * testQuotedString05.
 */
- (void)testTokens09 {
    
    // given
    NSString *s = @"{ \"asd\":\"123\"}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"asd\"", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"123\"", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testQuotedString06.
 */
- (void)testTokens10 {
    
    // given
    NSString *s = @"'asd':'123'}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"'asd'", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"'123'", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testQuotedNumber01.
 */
- (void)testTokens11 {
    
    // given
    NSString *s = @"'asd':123}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"'asd'", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"123", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isNumber], @"not expected");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    STAssertNil([token nextToken], @"expected nil");
}

/**
 * testAHrefLink.
 */
- (void)testTokens12 {
    
    // given
    NSString *s = @"{\"notes\":\"Different browsers have support for different video formats, see sub-features for details. \\r\\n\\r\\nThe Android browser (before 2.3) requires <a href=\\\"http://www.broken-links.com/2010/07/08/making-html5-video-work-on-android-phones/\\\">specific handling</a> to run the video element.\"}";

    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"notes\"", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"Different browsers have support for different video formats, see sub-features for details. \\r\\n\\r\\nThe Android browser (before 2.3) requires <a href=\\\"http://www.broken-links.com/2010/07/08/making-html5-video-work-on-android-phones/\\\">specific handling</a> to run the video element.\"", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertNil(token, @"expected nil");
}

/**
 * testJsonGrammar.
 */
- (void)testTokens13 {
    
    // given
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json.bnf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"@", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"start", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isWord], @"expected word");
    token = [token nextToken];
    STAssertEqualObjects(@"=", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"Empty", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"|", [token stringValue], @"got %@", [token stringValue]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"array", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"|", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"object", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@";", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"object", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"=", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"openCurly", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"objectContent", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@"closeCurly", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    STAssertEqualObjects(@";", [token stringValue], @"got %@", [token stringValue]);
}

/**
 * testRussianCharacters.
 */
- (void)testTokens14 {
    
    // given
    NSString *s = @"{\"text\":\"Й\"}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"{", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"text\"", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"Й\"", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];
    
    STAssertNil(token, @"expected nil");
}

/**
 * testUnicodeCharacter.
 */
- (void)testTokens15 {
    
    // given
    NSString *s = @"\u042d\u0442\u043e\u0440\u0443\u0441\u0441\u043a\u0438\u0439\u0442\u0435\u043a\u0441\u0442";
        
    // when
    BNFToken *token = [_factory tokens:s];

    // then
    STAssertEqualObjects(@"Эторусскийтекст", [token stringValue], @"got %@", [token stringValue]);
    token = [token nextToken];

    STAssertNil(token, @"expected nil");
}

/**
 * testTokens16.
 */
- (void)testTokens16 {
    
    // given
    NSString *s = @"adsdasdasdsa";
    NSBlockOperation *operation = [[[NSBlockOperation alloc] init] autorelease];
    [operation cancel];
    
    // when
    BNFToken *token = [_factory tokens:s operation:operation];
    
    // then
    STAssertNil(token, @"assume nil");
}

@end