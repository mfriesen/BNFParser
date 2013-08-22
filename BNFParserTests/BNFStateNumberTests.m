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

#import "BNFStateNumberTests.h"
#import "BNFToken.h"

@implementation BNFStateNumberTests

/*
- (void)setUp {
    [super setUp];
    BNFStateNumber *s = [[BNFStateNumber alloc] init];
    [self setState:s];
    [s release];
    
    BNFToken *token = [[BNFToken alloc] init];
    [self setToken:token];
    [token release];
}

- (void)tearDown {
    [_state release];
    [_token release];
    [super tearDown];
}

- (void)testNumber {
    [_token setValueWithString:@"1"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"-1"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"1.34"];
    STAssertTrue([_state match:_token], @"expect true");

    [_token setValueWithString:@"123"];
    STAssertTrue([_state match:_token], @"expect true");
}

- (void)testString {
    [_token setValueWithString:@"1a"];
    STAssertFalse([_state match:_token], @"expect false");
    
    [_token setValueWithString:@"a1"];
    STAssertFalse([_state match:_token], @"expect false");
}
*/
@end
