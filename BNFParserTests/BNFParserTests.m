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

#import "BNFParserTests.h"

@implementation BNFParserTests

- (void)setUp {
    [super setUp];
    self.factory = [[BNFParserFactory alloc] init];
}

- (void)tearDown {
    [_factory release];
    [super tearDown];
}

- (void)testEmpty {
    NSString *json = @"";
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    STAssertTrue([status isComplete], @"json is valid");
    STAssertNil([status error], @"no error");
}

- (void)testSimpleEmpty {
    NSString *json = @"{}";
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    STAssertTrue([status isComplete], @"json is valid");
    STAssertNil([status error], @"no error");
}

- (void)testQuotedString {
    NSString *json = @"{ \"asd\":\"123\"}";
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    STAssertTrue([status isComplete], @"json is valid");
    STAssertNil([status error], @"no error");
}

- (void)testSimpleNumber {
    NSString *json = @"{ \"asd\":123}";
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testSimple {
    BNFParserStatus *status = [self validateJsonFile:@"simple.json"];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testSimpleNested {
    BNFParserStatus *status = [self validateJsonFile:@"simple_nested.json"];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testSimpleArray {
    BNFParserStatus *status = [self validateJsonFile:@"simple_array.json"];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testArrayNested {
    BNFParserStatus *status = [self validateJsonFile:@"array_nested.json"];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testBadSimple {
    NSString *json = @"asdasd";
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    STAssertFalse([status isFailed], @"json is NOT valid");
}

- (void)testLargeJson {
    BNFParserStatus *status = [self validateJsonFile:@"group-members.json"];
    STAssertTrue([status isComplete], @"json is valid");
}

- (void)testBadJson {
    BNFParserStatus *status = [self validateJsonFile:@"bad.json"];
    STAssertFalse([status isFailed], @"json is not valid");
    
    BNFToken *token = [status error];
    NSString *value = [token stringValue];
    STAssertEqualObjects(value, @"]", @"got %@", value);
    STAssertTrue([token position] == 30, @"positon %d", [token position]);
}

- (BNFParserStatus *)validateJsonFile:(NSString *)file {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:file ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BNFParser *parser = [_factory json];
    BNFParserStatus *status = [parser parse:json];
    
    return status;
}

@end
