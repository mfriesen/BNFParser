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

#import "BNFIndexFactoryJSONTest.h"
#import "BNFParserFactory.h"
#import "BNFIndex.h"
#import "BNFIndexPath.h"

@implementation BNFIndexFactoryJSONTest

- (void)setUp {
    
    [super setUp];
    
    BNFParserFactory *parserFactory = [[BNFParserFactory alloc] init];
    BNFParser *parser = [parserFactory json];
    [self setJsonParser:parser];
    [parserFactory release];
    
    BNFIndexFactoryJSON *indexFactory = [[BNFIndexFactoryJSON alloc] init];
    [self setIndexFactory:indexFactory];
    [indexFactory release];
}

- (void)tearDown {
    [_jsonParser release];
    [_indexFactory release];
    [super tearDown];
}

//
// testCreateIndex01.
//
- (void)testCreateIndex01 {
    
    // given
    NSString *s = @"[]";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *result = [_indexFactory createIndex:parseResult];
    
    // then
    NSMutableArray *nodes = [result paths];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexPath *node0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"[", [node0 pathName], @"got %@", [node0 pathName]);
    STAssertTrue([[node0 paths] count] == 0, @"got %d", [[node0 paths] count]);
    
    BNFIndexPath *node1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"]", [node1 pathName], @"got %@", [node1 pathName]);
    STAssertTrue([[node1 paths] count] == 0, @"got %d", [[node1 paths] count]);
}

//
// testCreateIndex02.
//
- (void)testCreateIndex02 {
    
    // given
    NSString *s = @"{ \"food\" : \"chicken\" }";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *result = [_indexFactory createIndex:parseResult];
    
    // then
    NSMutableArray *nodes = [result paths];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexPath *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 pathName], @"got %@", [nodeA0 pathName]);
    STAssertTrue(1 == [[nodeA0 paths] count], @"got %d", [[nodeA0 paths] count]);
    STAssertNotNil([nodeA0 path:@"\"food\""], @"expected not nil");
    
    BNFIndexPath *nodeB0 = [[nodeA0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"food\"", [nodeB0 pathName], @"got %@", [nodeB0 pathName]);
    STAssertTrue([nodeB0 eq:@"\"chicken\""], @"assume true");
    STAssertTrue(0 == [[nodeB0 paths] count], @"got %d", [[nodeB0 paths] count]);
    
    BNFIndexPath *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 pathName], @"got %@", [nodeA1 pathName]);
    STAssertTrue(0 == [[nodeA1 paths] count], @"got %d", [[nodeA1 paths] count]);
}

//
// testCreateIndex03.
//
- (void)testCreateIndex03 {
    
    // given
    NSString *s = @"{\"firstName\" : \"John\",\"address\" : {\"postalCode\" : 10021}}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *result = [_indexFactory createIndex:parseResult];
    
    // then
    NSMutableArray *nodes = [result paths];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexPath *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 pathName], @"got %@", [nodeA0 pathName]);
    STAssertTrue(3 == [[nodeA0 paths] count], @"got %d", [[nodeA0 paths] count]);
    
    BNFIndexPath *nodeB0 = [[nodeA0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"firstName\"", [nodeB0 pathName], @"got %@", [nodeB0 pathName]);
    STAssertTrue([nodeB0 eq:@"\"John\""], @"assume true");
    STAssertTrue(0 == [[nodeB0 paths] count], @"got %d", [[nodeB0 paths] count]);
    
    BNFIndexPath *nodeB1 = [[nodeA0 paths] objectAtIndex:1];
    STAssertEqualObjects(@"\"address\"", [nodeB1 pathName], @"got %@", [nodeB1 pathName]);
    STAssertTrue([nodeB1 eq:@"{"], @"assume true");
    STAssertTrue(1 == [[nodeB1 paths] count], @"got %d", [[nodeB1 paths] count]);
    
    BNFIndexPath *nodeC0 = [[nodeB1 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"postalCode\"", [nodeC0 pathName], @"got %@", [nodeC0 pathName]);
    STAssertTrue([nodeC0 eq:@"10021"], @"assume true");
    STAssertTrue(0 == [[nodeC0 paths] count], @"got %d", [[nodeC0 paths] count]);
    
    BNFIndexPath *nodeB2 = [[nodeA0 paths] objectAtIndex:2];
    STAssertEqualObjects(@"}", [nodeB2 pathName], @"got %@", [nodeB2 pathName]);
    STAssertTrue(0 == [[nodeB2 paths] count], @"got %d", [[nodeB2 paths] count]);
    
    BNFIndexPath *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 pathName], @"got %@", [nodeA1 pathName]);
    STAssertTrue(0 == [[nodeA1 paths] count], @"got %d", [[nodeA1 paths] count]);
}

//
// testCreateIndex04.
//
- (void)testCreateIndex04 {
    
    // given
    NSString *s = @"{\"phoneNumbers\": [{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\": \"fax\",\"number\": \"646 555-4567\"}]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *result = [_indexFactory createIndex:parseResult];
    
    // then
    NSMutableArray *nodes = [result paths];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexPath *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 pathName], @"got %@", [nodeA0 pathName]);
    STAssertTrue(2 == [[nodeA0 paths] count], @"got %d", [[nodeA0 paths] count]);
    
    BNFIndexPath *nodeB0 = [[nodeA0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"phoneNumbers\"", [nodeB0 pathName], @"got %@", [nodeB0 pathName]);
    STAssertTrue([nodeB0 eq:@"["], @"assume true");
    STAssertTrue(4 == [[nodeB0 paths] count], @"got %d", [[nodeB0 paths] count]);
    
    BNFIndexPath *nodeC0 = [[nodeB0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeC0 pathName], @"got %@", [nodeC0 pathName]);
    STAssertTrue(2 == [[nodeC0 paths] count], @"got %d", [[nodeC0 paths] count]);
    
    BNFIndexPath *nodeD0 = [[nodeC0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"type\"", [nodeD0 pathName], @"got %@", [nodeD0 pathName]);
    STAssertTrue([nodeD0 eq:@"\"home\""], @"assume true");
    STAssertTrue(0 == [[nodeD0 paths] count], @"got %d", [[nodeD0 paths] count]);
    
    BNFIndexPath *nodeD1 = [[nodeC0 paths] objectAtIndex:1];
    STAssertEqualObjects(@"\"number\"", [nodeD1 pathName], @"got %@", [nodeD1 pathName]);
    STAssertTrue([nodeD1 eq:@"\"212 555-1234\""], @"assume true");
    STAssertTrue(0 == [[nodeD1 paths] count], @"got %d", [[nodeD1 paths] count]);
    
    BNFIndexPath *nodeC1 = [[nodeB0 paths] objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeC1 pathName], @"got %@", [nodeC1 pathName]);
    STAssertTrue(0 == [[nodeC1 paths] count], @"got %d", [[nodeC1 paths] count]);
    
    BNFIndexPath *nodeC2 = [[nodeB0 paths] objectAtIndex:2];
    STAssertEqualObjects(@"{", [nodeC2 pathName], @"got %@", [nodeC2 pathName]);
    STAssertTrue(2 == [[nodeC2 paths] count], @"got %d", [[nodeC2 paths] count]);
    
    nodeD0 = [[nodeC2 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"type\"", [nodeD0 pathName], @"got %@", [nodeD0 pathName]);
    STAssertTrue([nodeD0 eq:@"\"fax\""], @"assume true");
    STAssertTrue(0 == [[nodeD0 paths] count], @"got %d", [[nodeD0 paths] count]);
    
    nodeD1 = [[nodeC2 paths] objectAtIndex:1];
    STAssertEqualObjects(@"\"number\"", [nodeD1 pathName], @"got %@", [nodeD1 pathName]);
    STAssertTrue([nodeD1 eq:@"\"646 555-4567\""], @"assume true");
    STAssertTrue(0 == [[nodeD1 paths] count], @"got %d", [[nodeD1 paths] count]);
    
    BNFIndexPath *nodeC3 = [[nodeB0 paths] objectAtIndex:3];
    STAssertEqualObjects(@"}", [nodeC3 pathName], @"got %@", [nodeC3 pathName]);
    STAssertTrue(0 == [[nodeC3 paths] count], @"got %d", [[nodeC3 paths] count]);
    
    BNFIndexPath *nodeB1 = [[nodeA0 paths] objectAtIndex:1];
    STAssertEqualObjects(@"]", [nodeB1 pathName], @"got %@", [nodeB1 pathName]);
    STAssertTrue(0 == [[nodeB1 paths] count], @"got %d", [[nodeB1 paths] count]);
    
    BNFIndexPath *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 pathName], @"got %@", [nodeA1 pathName]);
    STAssertTrue(0 == [[nodeA1 paths] count], @"got %d", [[nodeA1 paths] count]);
}

//
// testCreateIndex05.
//
- (void)testCreateIndex05 {
    
    // given
    NSString *s = @"{\"list\": [ \"A\", \"B\" ]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *result = [_indexFactory createIndex:parseResult];
    
    // then
    NSMutableArray *nodes = [result paths];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexPath *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 pathName], @"got %@", [nodeA0 pathName]);
    STAssertTrue(2 == [[nodeA0 paths] count], @"got %d", [[nodeA0 paths] count]);
    
    BNFIndexPath *nodeB0 = [[nodeA0 paths] objectAtIndex:0];
    STAssertEqualObjects(@"\"list\"", [nodeB0 pathName], @"got %@", [nodeB0 pathName]);
    STAssertTrue([nodeB0 eq:@"["], @"assume true");
    STAssertTrue(2 == [[nodeB0 paths] count], @"got %d", [[nodeB0 paths] count]);
    
    BNFIndexPath *nodeC0 = [[nodeB0 paths] objectAtIndex:0];
    STAssertNil([nodeC0 pathName], @"got %@", [nodeC0 pathName]);
    STAssertTrue([nodeC0 eq:@"\"A\""], @"assume true");
    STAssertTrue(0 == [[nodeC0 paths] count], @"got %d", [[nodeC0 paths] count]);
    
    BNFIndexPath *nodeC1 = [[nodeB0 paths] objectAtIndex:1];
    STAssertNil([nodeC1 pathName], @"got %@", [nodeC1 pathName]);
    STAssertTrue([nodeC1 eq:@"\"B\""], @"assume true");
    STAssertTrue(0 == [[nodeC1 paths] count], @"got %d", [[nodeC1 paths] count]);
    
    BNFIndexPath *nodeB1 = [[nodeA0 paths] objectAtIndex:1];
    STAssertEqualObjects(@"]", [nodeB1 pathName], @"got %@", [nodeB1 pathName]);
    STAssertTrue(0 == [[nodeB1 paths] count], @"got %d", [[nodeB1 paths] count]);
    
    BNFIndexPath *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 pathName], @"got %@", [nodeA1 pathName]);
    STAssertTrue(0 == [[nodeA1 paths] count], @"got %d", [[nodeA1 paths] count]);
}

//
// testCreateIndex06 ParseResult is not Successful.
//
- (void)testCreateIndex06 {
    
    // given
    NSString *s = @"{\"list\": \"A\", \"B\" ]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    STAssertFalse([parseResult success], @"should not be successful");
    
    // when
    BNFIndex *index = [_indexFactory createIndex:parseResult];
    
    STAssertNil(index, @"not nil should be");
}

//
// testFindIndex01.
//
- (void)testFindIndex01 {
    
    // given
    NSString *s = @"{\"firstName\":\"John\",\"address\" : {\"streetAddress\" : \"21 2nd Street\"},\"phoneNumbers\":[{\"type\" :\"home\",\"number\":\"212 555-1234\"}]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *resultIndex = [_indexFactory createIndex:parseResult];
    
    // then
    BNFIndexPath *result1 = [resultIndex path:@"\"address\""];
    STAssertNotNil(result1, @"is nil");
    
    BNFIndexPath *result2 = [resultIndex path:@"address\""];
    STAssertNil(result2, @"is not nil");
    
    BNFIndexPath *result3 = [resultIndex path:@"\"phoneNumbers\""];
    STAssertNotNil(result3, @"is nil");
    
    BNFIndexPath *result4 = [result3 path:@"\"type\""];
    STAssertNotNil(result4, @"is nil");
}

//
// testFindIndex02.
//
- (void)testFindIndex02 {
    
    // given
    NSString *s = @"{\"firstName\":\"John\",\"address\" : {\"streetAddress\" : \"21 2nd Street\"},\"phoneNumbers\":[{\"type\" :\"home\",\"number\":\"212 555-1234\"}]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *resultIndex = [_indexFactory createIndex:parseResult];
    
    // then
    BNFIndexPath *result = [[resultIndex path:@"\"phoneNumbers\""] path:@"\"number\""];
    BNFIndexPath *resultNode = [result node];
    STAssertNotNil(resultNode, @"is nil");
    STAssertTrue([resultNode eq:@"\"212 555-1234\""], @"got unexpected string");
}

//
// testFindIndex03.
//
- (void)testFindIndex03 {
    
    // given
    NSString *s = @"{\"firstName\":\"John\",\"address\" : {\"streetAddress\" : \"21 2nd Street\"},\"phoneNumbers\":[{\"type\" :\"home\",\"number\":\"212 555-1234\"}]}";
    BNFParseResult *parseResult = [_jsonParser parseString:s];
    
    // when
    BNFIndex *resultIndex = [_indexFactory createIndex:parseResult];
    
    // then
    BNFIndexPath *result = [resultIndex path:@"\"phoneNumbers\""];
    BNFIndexPath *resultNode = [result node];
    STAssertNotNil(resultNode, @"is nil");
    STAssertTrue([resultNode eq:@"["], @"got unexpected string");
}

@end