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

#import "BNFParserFactory.h"
#import "BNFState.h"
#import "BNFStateEmpty.h"
#import "BNFStateNumber.h"
#import "BNFStateQuotedString.h"
#import "BNFTokenizerFactory.h"

@implementation BNFParserFactory

- (BNFParser *)json {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json.bnf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BNFParser *parser = [[[BNFParser alloc] init] autorelease];
    [self addDefaultStates:parser];
    [self buildParser:parser fromString:json];
    
    [json release];
    
    return parser;
}

- (void)addDefaultStates:(BNFParser *)parser {

    // QuotedString
    BNFStateQuotedString *quotedString = [[BNFStateQuotedString alloc] init];
    [quotedString setName:@"QuotedString"];
    [parser addState:quotedString];
    [quotedString release];

    // Number
    BNFStateNumber *number = [[BNFStateNumber alloc] init];
    [number setName:@"Number"];
    [parser addState:number];
    [number release];
}

- (void)buildParser:(BNFParser *)parser fromString:(NSString *)str {
  
    BNFState *cState = nil;
    BNFPath *cPath = nil;
    BNFComponent *cComponent = nil;
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    BNFTokenizerFactory *tokenizerFactory = [[BNFTokenizerFactory alloc] init];
    BNFTokenizer *tokenizer = [tokenizerFactory tokenizerWithString:str];

    BNFToken *tok = [tokenizer top];
    while (![tok isLastToken]) {
        
        NSString *str = [tok stringValue];

        if ([str isEqualToString:@"="]) {
            
            BNFState *state = [[BNFState alloc] init];
            [state setName:[NSString stringWithString:ms]];
            [parser addState:state];
            cState = state;
            [state release];
            
            [ms setString:@""];
            
        } else if ([str isEqualToString:@";"]) {
            
            [ms setString:@""];
            cState = nil;
            cPath = nil;
            cComponent = nil;
            
        } else if ([str isEqualToString:@"*"]) {
            
            [cComponent setRepetition:BNFRepetitionZeroOrMore];
            
        } else if ([str isEqualToString:@"+"]) {

            //[cComponent setRepetition:BNFRepetitionOneOrMore];
            
        } else if ([str isEqualToString:@"|"]) {
            
            cPath = nil;
            
        } else if (cState) {

            if ([str isEqualToString:@"Empty"]) {
                [cState setSupportEmpty:YES];
            } else {
                
                if (!cPath) {
                    BNFPath *p = [[BNFPath alloc] init];
                    [cState addPath:p];
                    cPath = p;
                    [p release];
                }

                BNFComponent *component = [[BNFComponent alloc] init];
                [component setStateName:str];
                
                if (([str hasPrefix:@"'"] && [str hasSuffix:@"'"]) || [str isEqualToString:@"QuotedString"]) {
                    [component setIsQuotedString:YES];
                }

                [cPath addComponent:component];
                cComponent = component;
                [component release];
            }

        } else {
            [ms appendString:str];
        }
        
        tok = [tok nextToken];
    }
    
    [ms release];
    [tokenizerFactory release];
}

@end
