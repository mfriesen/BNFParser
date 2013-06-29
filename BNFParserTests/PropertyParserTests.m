//
//  PropertyParserTests.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-26.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "PropertyParserTests.h"

@implementation PropertyParserTests

- (void)setUp {
    [super setUp];
    PropertyParser *propertyParser = [[PropertyParser alloc] init];
    [self setPropertyParser:propertyParser];
    [propertyParser release];
}

- (void)tearDown {
    [_propertyParser release];
    [super tearDown];
}

- (void)testJson {
    
    // given
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json.bnf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *s = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    // when
    NSMutableDictionary *dic = [_propertyParser parse:s];
    
    // then
    STAssertEqualObjects(@"propertyName colon value;", [dic objectForKey:@"property"], @"got %@", [dic objectForKey:@"property"]);
}

@end
