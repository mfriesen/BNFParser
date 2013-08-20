//
//  BNFSequenceFactoryTest.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-08-19.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFSequenceFactoryTest.h"
#import "BNFSequence.h"
#import "BNFSymbol.h"

@implementation BNFSequenceFactoryTest

- (void)setUp {
    
    [super setUp];
    
    BNFSequenceFactory *factory = [[BNFSequenceFactory alloc] init];
    [self setFactory:factory];
    [factory release];
}

- (void)tearDown {
    [_factory release];
    [super tearDown];
}

- (void)testJson01 {
 
    // given
    // when
    
    NSMutableDictionary *result = [_factory json];
 
    // then
    STAssertTrue([result count] == 23, @"got %d", [result count]);
 
    [self verifyAtStart:[result objectForKey:@"@start"]];

    [self verifyObject:[result objectForKey:@"object"]];

    [self verifyActualObject:[result objectForKey:@"actualObject"]];
    
    [self verifyColon:[result objectForKey:@"colon"]];
}

- (void)verifyAtStart:(NSMutableArray *)s {
    
    STAssertTrue([s count] == 3, @"got %d", [s count]);

    STAssertTrue(1 == [[self getSymbols:s position:0] count], @"got %d", [[self getSymbols:s position:0] count]);
    STAssertEqualObjects(@"array", [self getSymbolsName:s position:0 index:0], @"got %@", [self getSymbolsName:s position:0 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:0], @"got %d", [self getSymbolsRepetition:s position:0 index:0]);

    STAssertTrue(1 == [[self getSymbols:s position:1] count], @"got %d", [[self getSymbols:s position:1] count]);
    STAssertEqualObjects(@"object", [self getSymbolsName:s position:1 index:0], @"got %@", [self getSymbolsName:s position:1 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:1 index:0], @"got %d", [self getSymbolsRepetition:s position:1 index:0]);

    STAssertTrue(1 == [[self getSymbols:s position:2] count], @"got %d", [[self getSymbols:s position:2] count]);
    STAssertEqualObjects(@"Empty", [self getSymbolsName:s position:2 index:0], @"got %@", [self getSymbolsName:s position:2 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:2 index:0], @"got %d", [self getSymbolsRepetition:s position:2 index:0]);
}

- (void)verifyObject:(NSMutableArray *)s {
    
    STAssertTrue([s count] == 1, @"got %d", [s count]);

    STAssertTrue(3 == [[self getSymbols:s position:0] count], @"got %d", [[self getSymbols:s position:0] count]);
    
    STAssertEqualObjects(@"openCurly", [self getSymbolsName:s position:0 index:0], @"got %@", [self getSymbolsName:s position:0 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:0], @"got %d", [self getSymbolsRepetition:s position:0 index:0]);
    
    STAssertEqualObjects(@"objectContent", [self getSymbolsName:s position:0 index:1], @"got %@", [self getSymbolsName:s position:0 index:1]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:1], @"got %d", [self getSymbolsRepetition:s position:0 index:1]);
    
    STAssertEqualObjects(@"closeCurly", [self getSymbolsName:s position:0 index:2], @"got %@", [self getSymbolsName:s position:0 index:2]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:2], @"got %d", [self getSymbolsRepetition:s position:0 index:2]);
}

- (void)verifyActualObject:(NSMutableArray *)s {
    
    STAssertTrue([s count] == 1, @"got %d", [s count]);

    STAssertEqualObjects(@"property", [self getSymbolsName:s position:0 index:0], @"got %@", [self getSymbolsName:s position:0 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:0], @"got %d", [self getSymbolsRepetition:s position:0 index:0]);

    STAssertEqualObjects(@"commaProperty", [self getSymbolsName:s position:0 index:1], @"got %@", [self getSymbolsName:s position:0 index:1]);
    STAssertTrue(BNFRepetition_ZERO_OR_MORE == [self getSymbolsRepetition:s position:0 index:1], @"got %d", [self getSymbolsRepetition:s position:0 index:1]);
}

- (void)verifyColon:(NSMutableArray *)s {
    
    STAssertTrue([s count] == 1, @"got %d", [s count]);
    
    STAssertTrue([[self getSymbols:s position:0] count] == 1, @"got %d", [[self getSymbols:s position:0] count]);

    STAssertEqualObjects(@"':'", [self getSymbolsName:s position:0 index:0], @"got %@", [self getSymbolsName:s position:0 index:0]);
    STAssertTrue(BNFRepetition_NONE == [self getSymbolsRepetition:s position:0 index:0], @"got %d", [self getSymbolsRepetition:s position:0 index:0]);
}

- (NSString *)getSymbolsName:(NSMutableArray *)s position:(NSInteger)position index:(NSInteger)index {
    NSMutableArray *symbols = [self getSymbols:s position:position];
    return [[symbols objectAtIndex:index] name];
}

- (BNFRepetition)getSymbolsRepetition:(NSMutableArray *)s position:(NSInteger)position index:(NSInteger)index {
    NSMutableArray *symbols = [self getSymbols:s position:position];
    return [[symbols objectAtIndex:index] repetition];
}

- (NSMutableArray *)getSymbols:(NSMutableArray *)s position:(NSInteger)position {
    return [[s objectAtIndex:position] symbols];
}

@end
