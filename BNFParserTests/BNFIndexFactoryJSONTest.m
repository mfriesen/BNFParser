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
#import "BNFIndexNode.h"

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
    NSMutableArray *nodes = [result nodes];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexNode *node0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"[", [node0 keyValue], @"got %@", [node0 keyValue]);
    STAssertNil([node0 stringValue], @"got %@", [node0 stringValue]);
    STAssertTrue([[node0 nodes] count] == 0, @"got %d", [[node0 nodes] count]);
    
    BNFIndexNode *node1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"]", [node1 keyValue], @"got %@", [node1 keyValue]);
    STAssertNil([node1 stringValue], @"got %@", [node1 stringValue]);
    STAssertTrue([[node1 nodes] count] == 0, @"got %d", [[node1 nodes] count]);
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
    NSMutableArray *nodes = [result nodes];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexNode *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 keyValue], @"got %@", [nodeA0 keyValue]);
    STAssertTrue([nodeA0 shouldSkip], @"got NOT Skipped");
    STAssertNil([nodeA0 stringValue], @"got %@", [nodeA0 stringValue]);
    STAssertTrue(1 == [[nodeA0 nodes] count], @"got %d", [[nodeA0 nodes] count]);
    
    BNFIndexNode *nodeB0 = [[nodeA0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"food\"", [nodeB0 keyValue], @"got %@", [nodeB0 keyValue]);
    STAssertEqualObjects(@"\"chicken\"", [nodeB0 stringValue], @"got %@", [nodeB0 stringValue]);
    STAssertTrue(0 == [[nodeB0 nodes] count], @"got %d", [[nodeB0 nodes] count]);
    
    BNFIndexNode *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 keyValue], @"got %@", [nodeA1 keyValue]);
    STAssertNil([nodeA1 stringValue], @"got %@", [nodeA1 stringValue]);
    STAssertTrue(0 == [[nodeA1 nodes] count], @"got %d", [[nodeA1 nodes] count]);
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
    NSMutableArray *nodes = [result nodes];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexNode *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 keyValue], @"got %@", [nodeA0 keyValue]);
    STAssertNil([nodeA0 stringValue], @"got %@", [nodeA0 stringValue]);
    STAssertTrue(3 == [[nodeA0 nodes] count], @"got %d", [[nodeA0 nodes] count]);
    
    BNFIndexNode *nodeB0 = [[nodeA0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"firstName\"", [nodeB0 keyValue], @"got %@", [nodeB0 keyValue]);
    STAssertEqualObjects(@"\"John\"", [nodeB0 stringValue], @"got %@", [nodeB0 stringValue]);
    STAssertTrue(0 == [[nodeB0 nodes] count], @"got %d", [[nodeB0 nodes] count]);
    
    BNFIndexNode *nodeB1 = [[nodeA0 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"\"address\"", [nodeB1 keyValue], @"got %@", [nodeB1 keyValue]);
    STAssertEqualObjects(@"{", [nodeB1 stringValue], @"got %@", [nodeB1 stringValue]);
    STAssertTrue(1 == [[nodeB1 nodes] count], @"got %d", [[nodeB1 nodes] count]);
    
    BNFIndexNode *nodeC0 = [[nodeB1 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"postalCode\"", [nodeC0 keyValue], @"got %@", [nodeC0 keyValue]);
    STAssertEqualObjects(@"10021", [nodeC0 stringValue], @"got %@", [nodeC0 stringValue]);
    STAssertTrue(0 == [[nodeC0 nodes] count], @"got %d", [[nodeC0 nodes] count]);
    
    BNFIndexNode *nodeB2 = [[nodeA0 nodes] objectAtIndex:2];
    STAssertEqualObjects(@"}", [nodeB2 keyValue], @"got %@", [nodeB2 keyValue]);
    STAssertNil([nodeB2 stringValue], @"got %@", [nodeB2 stringValue]);
    STAssertTrue(0 == [[nodeB2 nodes] count], @"got %d", [[nodeB2 nodes] count]);
    
    BNFIndexNode *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 keyValue], @"got %@", [nodeA1 keyValue]);
    STAssertNil([nodeA1 stringValue], @"got %@", [nodeA1 stringValue]);
    STAssertTrue(0 == [[nodeA1 nodes] count], @"got %d", [[nodeA1 nodes] count]);
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
    NSMutableArray *nodes = [result nodes];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexNode *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 keyValue], @"got %@", [nodeA0 keyValue]);
    STAssertNil([nodeA0 stringValue], @"got %@", [nodeA0 stringValue]);
    STAssertTrue(2 == [[nodeA0 nodes] count], @"got %d", [[nodeA0 nodes] count]);
    
    BNFIndexNode *nodeB0 = [[nodeA0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"phoneNumbers\"", [nodeB0 keyValue], @"got %@", [nodeB0 keyValue]);
    STAssertEqualObjects(@"[", [nodeB0 stringValue], @"got %@", [nodeB0 stringValue]);
    STAssertTrue(4 == [[nodeB0 nodes] count], @"got %d", [[nodeB0 nodes] count]);
    
    BNFIndexNode *nodeC0 = [[nodeB0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeC0 keyValue], @"got %@", [nodeC0 keyValue]);
    STAssertNil([nodeC0 stringValue], @"got %@", [nodeC0 stringValue]);
    STAssertTrue(2 == [[nodeC0 nodes] count], @"got %d", [[nodeC0 nodes] count]);
    
    BNFIndexNode *nodeD0 = [[nodeC0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"type\"", [nodeD0 keyValue], @"got %@", [nodeD0 keyValue]);
    STAssertEqualObjects(@"\"home\"", [nodeD0 stringValue], @"got %@", [nodeD0 stringValue]);
    STAssertTrue(0 == [[nodeD0 nodes] count], @"got %d", [[nodeD0 nodes] count]);
    
    BNFIndexNode *nodeD1 = [[nodeC0 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"\"number\"", [nodeD1 keyValue], @"got %@", [nodeD1 keyValue]);
    STAssertEqualObjects(@"\"212 555-1234\"", [nodeD1 stringValue], @"got %@", [nodeD1 stringValue]);
    STAssertTrue(0 == [[nodeD1 nodes] count], @"got %d", [[nodeD1 nodes] count]);
    
    BNFIndexNode *nodeC1 = [[nodeB0 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeC1 keyValue], @"got %@", [nodeC1 keyValue]);
    STAssertNil([nodeC1 stringValue], @"got %@", [nodeC1 stringValue]);
    STAssertTrue(0 == [[nodeC1 nodes] count], @"got %d", [[nodeC1 nodes] count]);
    
    BNFIndexNode *nodeC2 = [[nodeB0 nodes] objectAtIndex:2];
    STAssertEqualObjects(@"{", [nodeC2 keyValue], @"got %@", [nodeC2 keyValue]);
    STAssertNil([nodeC2 stringValue], @"got %@", [nodeC2 stringValue]);
    STAssertTrue(2 == [[nodeC2 nodes] count], @"got %d", [[nodeC2 nodes] count]);
    
    nodeD0 = [[nodeC2 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"type\"", [nodeD0 keyValue], @"got %@", [nodeD0 keyValue]);
    STAssertEqualObjects(@"\"fax\"", [nodeD0 stringValue], @"got %@", [nodeD0 stringValue]);
    STAssertTrue(0 == [[nodeD0 nodes] count], @"got %d", [[nodeD0 nodes] count]);
    
    nodeD1 = [[nodeC2 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"\"number\"", [nodeD1 keyValue], @"got %@", [nodeD1 keyValue]);
    STAssertEqualObjects(@"\"646 555-4567\"", [nodeD1 stringValue], @"got %@", [nodeD1 stringValue]);
    STAssertTrue(0 == [[nodeD1 nodes] count], @"got %d", [[nodeD1 nodes] count]);
    
    BNFIndexNode *nodeC3 = [[nodeB0 nodes] objectAtIndex:3];
    STAssertEqualObjects(@"}", [nodeC3 keyValue], @"got %@", [nodeC3 keyValue]);
    STAssertNil([nodeC3 stringValue], @"got %@", [nodeC3 stringValue]);
    STAssertTrue(0 == [[nodeC3 nodes] count], @"got %d", [[nodeC3 nodes] count]);
    
    BNFIndexNode *nodeB1 = [[nodeA0 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"]", [nodeB1 keyValue], @"got %@", [nodeB1 keyValue]);
    STAssertNil([nodeB1 stringValue], @"got %@", [nodeB1 stringValue]);
    STAssertTrue(0 == [[nodeB1 nodes] count], @"got %d", [[nodeB1 nodes] count]);
    
    BNFIndexNode *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 keyValue], @"got %@", [nodeA1 keyValue]);
    STAssertNil([nodeA1 stringValue], @"got %@", [nodeA1 stringValue]);
    STAssertTrue(0 == [[nodeA1 nodes] count], @"got %d", [[nodeA1 nodes] count]);
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
    NSMutableArray *nodes = [result nodes];
    STAssertTrue([nodes count] == 2, @"got %d", [nodes count]);
    
    BNFIndexNode *nodeA0 = [nodes objectAtIndex:0];
    STAssertEqualObjects(@"{", [nodeA0 keyValue], @"got %@", [nodeA0 keyValue]);
    STAssertNil([nodeA0 stringValue], @"got %@", [nodeA0 stringValue]);
    STAssertTrue(2 == [[nodeA0 nodes] count], @"got %d", [[nodeA0 nodes] count]);
    
    BNFIndexNode *nodeB0 = [[nodeA0 nodes] objectAtIndex:0];
    STAssertEqualObjects(@"\"list\"", [nodeB0 keyValue], @"got %@", [nodeB0 keyValue]);
    STAssertEqualObjects(@"[", [nodeB0 stringValue], @"got %@", [nodeB0 stringValue]);
    STAssertTrue(2 == [[nodeB0 nodes] count], @"got %d", [[nodeB0 nodes] count]);
    
    BNFIndexNode *nodeC0 = [[nodeB0 nodes] objectAtIndex:0];
    STAssertNil([nodeC0 keyValue], @"got %@", [nodeC0 keyValue]);
    STAssertEqualObjects(@"\"A\"", [nodeC0 stringValue], @"got %@", [nodeC0 stringValue]);
    STAssertTrue(0 == [[nodeC0 nodes] count], @"got %d", [[nodeC0 nodes] count]);
    
    BNFIndexNode *nodeC1 = [[nodeB0 nodes] objectAtIndex:1];
    STAssertNil([nodeC1 keyValue], @"got %@", [nodeC1 keyValue]);
    STAssertEqualObjects(@"\"B\"", [nodeC1 stringValue], @"got %@", [nodeC1 stringValue]);
    STAssertTrue(0 == [[nodeC1 nodes] count], @"got %d", [[nodeC1 nodes] count]);
    
    BNFIndexNode *nodeB1 = [[nodeA0 nodes] objectAtIndex:1];
    STAssertEqualObjects(@"]", [nodeB1 keyValue], @"got %@", [nodeB1 keyValue]);
    STAssertNil([nodeB1 stringValue], @"got %@", [nodeB1 stringValue]);
    STAssertTrue(0 == [[nodeB1 nodes] count], @"got %d", [[nodeB1 nodes] count]);
    
    BNFIndexNode *nodeA1 = [nodes objectAtIndex:1];
    STAssertEqualObjects(@"}", [nodeA1 keyValue], @"got %@", [nodeA1 keyValue]);
    STAssertNil([nodeA1 stringValue], @"got %@", [nodeA1 stringValue]);
    STAssertTrue(0 == [[nodeA1 nodes] count], @"got %d", [[nodeA1 nodes] count]);
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
    BNFIndexNode *resultNode = [result node];
    STAssertEqualObjects(@"\"number\"", [resultNode keyValue], @"got %@", [resultNode keyValue]);
    STAssertEqualObjects(@"\"212 555-1234\"", [resultNode stringValue], @"got %@", [resultNode stringValue]);
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
    BNFIndexNode *resultNode = [result node];
    STAssertEqualObjects(@"\"phoneNumbers\"", [resultNode keyValue], @"got %@", [resultNode keyValue]);
    STAssertEqualObjects(@"[", [resultNode stringValue], @"got %@", [resultNode stringValue]);
}

@end