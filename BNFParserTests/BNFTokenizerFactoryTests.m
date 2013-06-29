//
//  BNFTokenizerFactoryTests.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-26.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
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

- (void)testEmpty {
    
    // given
    NSString *s = @"";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"", [token value], @"got %@", [token value]);
    STAssertFalse([token isWord], @"not expected");
    STAssertFalse([token isNumber], @"not expected");
    STAssertFalse([token isSymbol], @"not expected");
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testSymbolAndWhiteSpace {
    
    // given
    NSString *s = @"{ \n}";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"{", [token value], @"got %@", [token value]);
    STAssertTrue(1 == [token identifier], @"got %d", [token identifier]);
    STAssertTrue([token isSymbol], @"expected symbol");

    token = [token nextToken];
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertTrue(2 == [token identifier], @"got %d", [token identifier]);
    STAssertTrue([token isSymbol], @"expected symbol");
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testSingleLineComment {
    
    // given
    NSString *s = @"{ }//bleh\nasd";
 
    // when
    BNFToken *token = [_factory tokens:s];
 
    // then
    STAssertEqualObjects(@"{", [token value], @"got %@", [token value]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"asd", [token value], @"got %@", [token value]);
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testMultiLineComment {
    
    // given
    NSString *s = @"{ }/*bleh\n\nffsdf\n*/asd";

    // when
    BNFToken *token = [_factory tokens:s];

    // then
    STAssertEqualObjects(@"{", [token value], @"got %@", [token value]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"asd", [token value], @"got %@", [token value]);
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testQuotedString01 {
    
    // given
    NSString *s = @"hi \"asd\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"hi", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"\"asd\"", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}


- (void)testQuotedString02 {
    
    // given
    NSString *s = @"\"asd\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd\"", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

- (void)testQuotedString03 {
    
    // given
    NSString *s = @"\"asd's\"";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd's\"", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

- (void)testQuotedString04 {
    
    // given
    NSString *s = @"\"asd's";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"\"asd's", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
}

- (void)testQuotedString05 {
    
    // given
    NSString *s = @"{ \"asd\":\"123\"}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"{", [token value], @"got %@", [token value]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"asd\"", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token value], @"got %@", [token value]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"\"123\"", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testQuotedString06 {
    
    // given
    NSString *s = @"'asd':'123'}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"'asd'", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token value], @"got %@", [token value]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"'123'", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testQuotedNumber01 {
    
    // given
    NSString *s = @"'asd':123}";
    
    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"'asd'", [token value], @"got %@", [token value]);
    STAssertTrue([token isQuotedString], @"expected QuotedString");
    token = [token nextToken];
    
    STAssertEqualObjects(@":", [token value], @"got %@", [token value]);
    token = [token nextToken];
    
    STAssertEqualObjects(@"123", [token value], @"got %@", [token value]);
    STAssertTrue([token isNumber], @"not expected");
    token = [token nextToken];
    
    STAssertEqualObjects(@"}", [token value], @"got %@", [token value]);
    STAssertNil([token nextToken], @"expected nil");
}

- (void)testJsonGrammar {
    
    // given
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json.bnf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    // when
    BNFToken *token = [_factory tokens:s];
    
    // then
    STAssertEqualObjects(@"@", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"start", [token value], @"got %@", [token value]);
    STAssertTrue([token isWord], @"expected word");
    token = [token nextToken];
    STAssertEqualObjects(@"=", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"Empty", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"|", [token value], @"got %@", [token value]);
    STAssertTrue([token isSymbol], @"expected symbol");
    token = [token nextToken];
    STAssertEqualObjects(@"array", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"|", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"object", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@";", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"object", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"=", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"openCurly", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"objectContent", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@"closeCurly", [token value], @"got %@", [token value]);
    token = [token nextToken];
    STAssertEqualObjects(@";", [token value], @"got %@", [token value]);
}

@end