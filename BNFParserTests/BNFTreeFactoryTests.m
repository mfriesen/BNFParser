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

#import "BNFTreeFactoryTests.h"
#import "BNFParserFactory.h"

@implementation BNFTreeFactoryTests

- (void)setUp {
    [super setUp];
    self.factory = [[BNFTreeFactory alloc] init];
}

- (void)tearDown {
    [_factory release];
    [super tearDown];
}

- (void)testNull {
    
    BNFParserStatus *status = [[BNFParserStatus alloc] init];
    
    BNFTree *tree = [_factory json:status];
    STAssertTrue([[tree nodes] count] == 0, @"assume no childre");

    [status release];
}

- (void)testFormatValidString01 {
    NSString *str = @"{\"id\":\"118019484951173_228591\"}";
    BNFParserStatus *status = [self buildFromString:str];
    NSString *s = [_factory formatValidString:status];
    NSString *expect = @"{\n\t\"id\" : \"118019484951173_228591\"\n}";
    STAssertEqualObjects(expect, s, @"got %@", s);
}

- (void)testFormatValidString02 {
    NSString *str = @"[{\"name\":\"jack\"}]";
    BNFParserStatus *status = [self buildFromString:str];
    NSString *s = [_factory formatValidString:status];
    NSString *expect = @"[\n\t{\n\t\t\"name\" : \"jack\"\n\t}\n]";
    STAssertEqualObjects(expect, s, @"got %@", s);
}

- (void)testFormatInValidString {
    NSString *str = @"{\"id\":\"118019484951173_228591\",adsadasdas}";
    BNFParserStatus *status = [self buildFromString:str];
    NSString *s = [_factory formatInvalidString:status];
    NSString *expect = @"adsadasdas}";
    STAssertEqualObjects(expect, s, @"got %@", s);
}

- (void)testSimple {
    
    BNFTree *tree = [self buildTree:@"simple.json"];
    NSMutableArray *n0 = [tree nodes];
    STAssertTrue([n0 count] == 2, @"got %d", [n0 count]);
    
    BNFTreeNode *n00 = [n0 objectAtIndex:0];
    STAssertEqualObjects([n00 value], @"{", @"got %@", [n00 value]);
    STAssertTrue([[n00 nodes] count] == 3, @"got %d", [[n00 nodes] count]);
    
    BNFTreeNode *n000 = [[n00 nodes] objectAtIndex:0];
    STAssertEqualObjects([n000 value], @"\"id\" : \"118019484951173_228591\",", @"got %@", [n000 value]);
    STAssertTrue([[n000 nodes] count] == 0, @"got %d", [[n000 nodes] count]);
    
    BNFTreeNode *n001 = [[n00 nodes] objectAtIndex:1];
    STAssertEqualObjects([n001 value], @"\"message\" : \"test test\",", @"got %@", [n001 value]);
    STAssertTrue([[n001 nodes] count] == 0, @"got %d", [[n001 nodes] count]);

    BNFTreeNode *n002 = [[n00 nodes] objectAtIndex:2];
    STAssertEqualObjects([n002 value], @"\"created_time\" : \"2011-06-19T09:14:16+0000\"", @"got %@", [n002 value]);
    STAssertTrue([[n002 nodes] count] == 0, @"got %d", [[n002 nodes] count]);
    
    BNFTreeNode *n01 = [n0 objectAtIndex:1];
    STAssertEqualObjects([n01 value], @"}", @"got %@", [n01 value]);
    STAssertTrue([[n01 nodes] count] == 0, @"got %d", [[n01 nodes] count]);
}

- (void)testArray {
    
    NSString *json = @"[{\"name\":\"Brad Hayward\",\"id\":\"769775313\"},{\"name\":\"David Archibald\",\"id\":\"684745596\"}]";
    BNFParserStatus *status = [self buildFromString:json];
    BNFTree *tree = [_factory json:status];
  
    NSMutableArray *c0 = [self validate:tree value:nil children:2];
    BNFTreeNode *n1 = [c0 objectAtIndex:0];
    
    NSMutableArray *c1 = [self validate:n1 value:@"[" children:5];
    BNFTreeNode *n2 = [c1 objectAtIndex:0];
    
    NSMutableArray *c2 = [self validate:n2 value:@"{" children:2];
    BNFTreeNode *n200 = [c2 objectAtIndex:0];
    [self validate:n200 value:@"\"name\" : \"Brad Hayward\"," children:0];
    
    BNFTreeNode *n201 = [c2 objectAtIndex:1];
    [self validate:n201 value:@"\"id\" : \"769775313\"" children:0];
    
    BNFTreeNode *n3 = [c1 objectAtIndex:1];
    [self validate:n3 value:@"}" children:0];
    
    BNFTreeNode *n4 = [c1 objectAtIndex:2];
    [self validate:n4 value:@"," children:0];
    
    BNFTreeNode *n5 = [c1 objectAtIndex:3];
    NSMutableArray *c3 = [self validate:n5 value:@"{" children:2];
    BNFTreeNode *n500 = [c3 objectAtIndex:0];
    [self validate:n500 value:@"\"name\" : \"David Archibald\"," children:0];
    
    BNFTreeNode *n501 = [c3 objectAtIndex:1];
    [self validate:n501 value:@"\"id\" : \"684745596\"" children:0];
    
    BNFTreeNode *n6 = [c1 objectAtIndex:4];
    [self validate:n6 value:@"}" children:0];
    
    BNFTreeNode *n100 = [c0 objectAtIndex:1];
    [self validate:n100 value:@"]" children:0];
}

- (void)testNested {
    
    NSString *json = @"{\"data\":{\"id\":\"118019484951173_228591\"}}";
    BNFParserStatus *status = [self buildFromString:json];
    BNFTree *tree = [_factory json:status];

    NSMutableArray *c0 = [self validate:tree value:nil children:2];
    BNFTreeNode *n1 = [c0 objectAtIndex:0];
    
    NSMutableArray *c1 = [self validate:n1 value:@"{" children:2];
    BNFTreeNode *n2 = [c1 objectAtIndex:0];
    NSMutableArray *c2 = [self validate:n2 value:@"\"data\" : {" children:1];
    BNFTreeNode *n4 = [c2 objectAtIndex:0];
    [self validate:n4 value:@"\"id\" : \"118019484951173_228591\"" children:0];
    
    BNFTreeNode *n3 = [c1 objectAtIndex:1];
    [self validate:n3 value:@"}" children:0];
    
    BNFTreeNode *n100 = [c0 objectAtIndex:1];
    [self validate:n100 value:@"}" children:0];
}

- (NSMutableArray *)validate:(BNFTreeNode *)node value:(NSString *)value children:(NSInteger)count {
    if (value) {
        STAssertEqualObjects([node value], value, @"got %@", [node value]);
    }
    
    STAssertTrue([[node nodes] count] == count, @"got %d", [[node nodes] count]);
    return [node nodes];
}

- (BNFTree *)buildTree:(NSString *)file {
    
    BNFParserStatus *status = [self buildFromPath:@"simple.json"];
    
    BNFTree *tree = [_factory json:status];
    return tree;
}

- (BNFParserStatus *)buildFromPath:(NSString *)file {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:file ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
    BNFParserFactory *parserFactory = [[BNFParserFactory alloc] init];
    BNFParser *parser = [parserFactory json];
    return [parser parse:json];
}

- (BNFParserStatus *)buildFromString:(NSString *)json {
        
    BNFParserFactory *parserFactory = [[BNFParserFactory alloc] init];
    BNFParser *parser = [parserFactory json];
    return [parser parse:json];
}

@end
