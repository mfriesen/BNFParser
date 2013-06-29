//
//  BNFStateDefinitionFactoryTests.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-26.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateDefinitionFactoryTests.h"
#import "BNFStateDefinition.h"
#import "BNFStateEnd.h"
#import "BNFStateQuotedString.h"

@implementation BNFStateDefinitionFactoryTests

- (void)setUp {
    [super setUp];
    BNFStateDefinitionFactory *f = [[BNFStateDefinitionFactory alloc] init];
    [self setFactory:f];
    [f release];
}

- (void)tearDown {
    [_factory release];
    [super tearDown];
}

- (void)testStartJson {

    // given
    // when
    NSMutableDictionary *map = [_factory json];
    
    // then
    BNFStateDefinition *start = [map objectForKey:@"@start"];
    STAssertNotNil(start, @"expected not nil");
    STAssertTrue(3 == [[start states] count], @"got %@", [[start states] count]);
    STAssertEqualObjects(@"array", [[[start states] objectAtIndex:0] name], @"got %@", [[[start states] objectAtIndex:0] name]);
    STAssertEqualObjects(@"object", [[[start states] objectAtIndex:1] name], @"got %@", [[[start states] objectAtIndex:1] name]);
    STAssertEqualObjects(@"Empty", [[[start states] objectAtIndex:2] name], @"got %@", [[[start states] objectAtIndex:2] name]);
    
    for (BNFState *ss in [start states]) {
        STAssertEqualObjects(@"@end", [[ss nextState] name], @"got %@", [[ss nextState] name]);
        BNFState *bss = [ss nextState];
        STAssertTrue([bss isEnd], @"assume END");
    }
}

- (void)testOpenCurly {
    
    // given
    // when
    NSMutableDictionary *map = [_factory json];

    // then
    BNFStateDefinition *openCurly = [map objectForKey:@"openCurly"];
    STAssertNotNil(openCurly, @"assume not nil");
    STAssertTrue([[openCurly states] count] == 1, @"got %d", [[openCurly states] count]);

    BNFState *ss = [[openCurly states] objectAtIndex:0];
    STAssertEqualObjects(@"{", [ss name], @"got %@", [ss name]);
    STAssertTrue([ss isTerminal], @"assumed isTerminal");
}

- (void)testObject {
    
    // given
    // when
    NSMutableDictionary *map = [_factory json];

    // then
    BNFStateDefinition *object = [map objectForKey:@"object"];
    STAssertNotNil(object, @"assume not nil");
    STAssertTrue([[object states] count] == 1, @"got %d", [[object states] count]);

    BNFState *ss0 = [[object states] objectAtIndex:0];
    STAssertEqualObjects(@"openCurly", [ss0 name], @"got %@", [ss0 name]);

    BNFState *ss1 = [ss0 nextState];
    STAssertEqualObjects(@"objectContent", [ss1 name], @"got %@", [ss1 name]);
    
    BNFState *ss2 = [ss1 nextState];
    STAssertEqualObjects(@"closeCurly", [ss2 name], @"got %@", [ss2 name]);
}

- (void)testQuotedString {
    
    // given
    // when
    NSMutableDictionary *map = [_factory json];

    // then
    BNFStateDefinition *string = [map objectForKey:@"string"];
    STAssertNotNil(string, @"assume not nil");
    STAssertTrue([[string states] count] == 1, @"got %d", [[string states] count]);

    BNFState *ss = [[string states] objectAtIndex:0];
    STAssertEqualObjects([BNFStateQuotedString class], [ss class], @"got %@", [ss class]);
}

- (void)testKeys {
    
    // given
    // when
    NSMutableDictionary *map = [_factory json];

    // then
    NSArray *keys = [map allKeys];
    STAssertTrue([keys containsObject:@"@start"], @"assume exists");

    STAssertTrue([keys containsObject:@"object"], @"assume exists");
    STAssertTrue([keys containsObject:@"objectContent"], @"assume exists");
    STAssertTrue([keys containsObject:@"actualObject"], @"assume exists");
    STAssertTrue([keys containsObject:@"property"], @"assume exists");
    STAssertTrue([keys containsObject:@"commaProperty"], @"assume exists");
    STAssertTrue([keys containsObject:@"propertyName"], @"assume exists");
    STAssertTrue([keys containsObject:@"arrayContent"], @"assume exists");
    STAssertTrue([keys containsObject:@"actualArray"], @"assume exists");
    STAssertTrue([keys containsObject:@"commaValue"], @"assume exists");
    STAssertTrue([keys containsObject:@"value"], @"assume exists");
    STAssertTrue([keys containsObject:@"string"], @"assume exists");
    STAssertTrue([keys containsObject:@"number"], @"assume exists");
    STAssertTrue([keys containsObject:@"null"], @"assume exists");
    STAssertTrue([keys containsObject:@"true"], @"assume exists");
    STAssertTrue([keys containsObject:@"false"], @"assume exists");
    STAssertTrue([keys containsObject:@"openCurly"], @"assume exists");
    STAssertTrue([keys containsObject:@"closeCurly"], @"assume exists");
    STAssertTrue([keys containsObject:@"openBracket"], @"assume exists");
    STAssertTrue([keys containsObject:@"closeBracket"], @"assume exists");
    STAssertTrue([keys containsObject:@"comma"], @"assume exists");
    STAssertTrue([keys containsObject:@"colon"], @"assume exists");
}

@end
