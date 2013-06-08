//
//  Copyright (c) 2013 Mike Friesen
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "BNFParserFactoryTests.h"
#import "BNFParserFactory.h"
#import "BNFParser.h"

@implementation BNFParserFactoryTests

- (void)testInitJSONParser {
    
    BNFParserFactory *factory = [[BNFParserFactory alloc] init];
    BNFParser *parser = [factory json];
    
    STAssertTrue([[parser states] count] == 25, @"got %d states", [[parser states] count]);
    
    // @start
    BNFState *start = [parser state:@"@start"];
    NSMutableArray *startPaths = [start paths];
    STAssertTrue([startPaths count] == 2, @"got %d", [startPaths count]);
    [self verifyNBFComponent:[startPaths objectAtIndex:0] stateName:@"array" repetition:BNFRepetitionNone];
    [self verifyNBFComponent:[startPaths objectAtIndex:1] stateName:@"object" repetition:BNFRepetitionNone];
    
    // actualObject
    BNFState *actualObject = [parser state:@"actualObject"];
    NSMutableArray *actualObjectPaths = [actualObject paths];
    STAssertTrue([actualObjectPaths count] == 1, @"got %d", [actualObjectPaths count]);
    BNFPath *actualObjectPath = [actualObjectPaths objectAtIndex:0];
    NSMutableArray *actualObjectComponents = [actualObjectPath components];
    STAssertTrue([actualObjectComponents count] == 2, @"got %d", [actualObjectComponents count]);
    BNFComponent *c0 = [actualObjectComponents objectAtIndex:0];
    STAssertEqualObjects([c0 stateName], @"property", @"got %@", c0);
    STAssertTrue([c0 repetition] == BNFRepetitionNone, @"got %d", [c0 repetition]);
    BNFComponent *c1 = [actualObjectComponents objectAtIndex:1];
    STAssertEqualObjects([c1 stateName], @"commaProperty", @"got %@", c1);
    STAssertTrue([c1 repetition] == BNFRepetitionZeroOrMore, @"got %d", [c1 repetition]);
    
    // openCurly
    BNFState *openCurly = [parser state:@"openCurly"];
    NSMutableArray *openCurlyPaths = [openCurly paths];
    STAssertTrue([openCurlyPaths count] == 1, @"got %d", [openCurlyPaths count]);
    BNFPath *openCurlyPath = [openCurlyPaths objectAtIndex:0];
    NSMutableArray *openCurlyComponents = [openCurlyPath components];
    STAssertTrue([openCurlyComponents count] == 1, @"got %d", [openCurlyComponents count]);
    BNFComponent *cc0 = [openCurlyComponents objectAtIndex:0];
    STAssertEqualObjects([cc0 stateName], @"'{'", @"got %@", cc0);
    STAssertTrue([cc0 repetition] == BNFRepetitionNone, @"got %d", [cc0 repetition]);
    STAssertTrue([cc0 isQuotedString], @"got %d", [cc0 isQuotedString]);
    
    [factory release];
}

- (void)verifyNBFComponent:(BNFPath *)path stateName:(NSString *)stateName repetition:(BNFRepetition)repetition {
    STAssertTrue([[path components] count] == 1, @"got %d components", [[path components] count]);
    BNFComponent *comp = [[path components] objectAtIndex:0];
    STAssertEqualObjects(stateName, [comp stateName], @"expect %@ got %@", stateName, [comp stateName]);
    STAssertTrue([comp repetition] == repetition, @"expect %d got %d", repetition, [comp repetition]);
}

@end
