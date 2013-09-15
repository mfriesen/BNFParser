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

#import "BNFParser.h"
#import "BNFParserState.h"
#import "BNFSymbol.h"
#import "BNFTokenizerFactory.h"

@implementation BNFParser

- (id)initWithStateDefinitions:(NSMutableDictionary *)dic {
    self = [super init];
    
    if (self) {
        
        [self setSequenceMap:dic];
        
        Stack *stack = [[Stack alloc] init];
        [self setStack:stack];
        [stack release];
    }
    
    return self;
}

- (BNFParseResult *)parseString:(NSString *)s {
    BNFTokenizerFactory *tokenizer = [[BNFTokenizerFactory alloc] init];
    BNFToken *token = [tokenizer tokens:s];
    
    BNFParseResult *result = [self parse:token];
    [tokenizer release];
    
    return result;
}

- (BNFParseResult *)parse:(BNFToken *)token {
    return [self parse:token operation:nil];
}

- (BNFParseResult *)parse:(BNFToken *)token operation:(NSBlockOperation *)operation {
    NSMutableArray *sd = [_sequenceMap objectForKey:@"@start"];
    [self addParserStateSequences:sd token:token parserRepetition:BNFParserRepetition_NONE repetition:BNFRepetition_NONE];
    
    return [self parseSequences:token operation:operation];
}

- (BNFParseResult *)parseSequences:(BNFToken *)startToken operation:(NSBlockOperation *)operation {
    
    BOOL success = NO;
    BOOL cancelled = NO;
    
    BNFParseResult *result = [[BNFParseResult alloc] init];
    [result setTop:startToken];
    [result setMaxMatchToken:startToken];
    
    while (![_stack isEmpty]) {
        
        BNFParserState *holder = [_stack peek];
        
        if ([holder state] == ParserState_EMPTY) {
            
            [_stack pop];
            
            BNFToken *token = [[_stack peek] currentToken];
            if (![self isEmpty:token]) {
                [self rewindToNextSymbol];
            } else {
                success = YES;
                [result setError:nil];
                [self rewindToNextSequence];
            }
            
        } else if ([holder state] == ParserState_NO_MATCH_WITH_ZERO_REPETITION) {
            
            [self processNoMatchWithZeroRepetition];
            
        } else if ([holder state] == ParserState_MATCH_WITH_ZERO_REPETITION) {
            
            [self processMatchWithZeroRepetition];
            
        } else if ([holder state] == ParserState_NO_MATCH_WITH_ZERO_REPETITION_LOOKING_FOR_FIRST_MATCH) {
            
            BNFToken *maxMatchToken = [self processNoMatchWithZeroRepetitionLookingForFirstMatch];
            [result setMaxMatchToken:maxMatchToken];
            [result setError:nil];
            success = YES;
            
        } else if ([holder state] == ParserState_MATCH) {
            
            BNFToken *maxMatchToken = [self processMatch];
            [result setMaxMatchToken:maxMatchToken];
            [result setError:nil];
            success = YES;
            
        } else if ([holder state] == ParserState_NO_MATCH) {
            
            BNFToken *eToken = [self processNoMatch];
            BNFToken *errorToken = [self updateErrorToken:[result error] token2:eToken];
            [result setError:errorToken];
            success = NO;
            
        } else {
            [self processStack];
        }
        
        if ([operation isCancelled]) {
            cancelled = YES;
            break;
        }
    }
    
    if (cancelled) {
        [result release];
        return nil;
    }
    
    [self updateResult:result success:success];

    return [result autorelease];
}

/**
 * Update BNFParserResult.
 */
- (void)updateResult:(BNFParseResult *)result success:(BOOL)success {
    
    BOOL succ = success;
    BNFToken *maxMatchToken = [result maxMatchToken];
    
    if (maxMatchToken && [maxMatchToken nextToken]) {
        
        if (![result error]) {
            [result setError:[maxMatchToken nextToken]];
        }
        
        succ = NO;
    }
    
    [result setSuccess:succ];
}

- (BNFToken *)updateErrorToken:(BNFToken *)token1 token2:(BNFToken *)token2 {
    return token1 && [token1 identifier] > [token2 identifier] ? token1 : token2;
}

- (BNFToken *)processNoMatch {
    
    [self debugPrintIndents];
//    NSLog(@"-> no match, rewinding to next sequence");
    
    [_stack pop];
    
    BNFToken *token = [[_stack peek] currentToken];
    
    [self rewindToNextSequence];
    
    if (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        [holder resetToken];
    }
    
    return token;
}

- (BNFToken *)processMatchWithZeroRepetition {
    
    [_stack pop];
    
    BNFToken *token = [[_stack peek] currentToken];
    
    [self debugPrintIndents];
//    NSLog(@"-> matched token %@ rewind to start of repetition", [token stringValue]);
    
    [self rewindToOutsideOfRepetition];
    
    if (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        [holder advanceToken:[token nextToken]];
    }
    
    return token;
}

- (BNFToken *)processNoMatchWithZeroRepetitionLookingForFirstMatch {
    
    [_stack pop];
    
    BNFToken *token = [[_stack peek] currentToken];
    
    [self debugPrintIndents];
//    NSLog(@"-> no match Zero Or More Looking for First Match token %@ rewind outside of Repetition", [self debug:token]);
    
    [self rewindToOutsideOfRepetition];
    [self rewindToNextSymbol];
    
    if (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        [holder advanceToken:token];
    }
    
    return token;
}

- (BNFToken *)processMatch {
    
    [_stack pop];
    
    BNFToken *token = [[_stack peek] currentToken];
    
    [self debugPrintIndents];
//    NSLog(@"-> matched token %@ rewind to next symbol", [token stringValue]);
    
    [self rewindToNextSymbolOrRepetition];
    
    if (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        
        token = [token nextToken];
        [holder advanceToken:token];
    }
    
    return token;
}

- (void)processNoMatchWithZeroRepetition {
    
    [self debugPrintIndents];
//    NSLog(@"-> NO_MATCH_WITH_ZERO_REPETITION, rewind to next symbol");
    
    [_stack pop];
    
    BNFToken *token = [[_stack peek] currentToken];
    
    [self rewindToNextSymbol];
    
    if (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        [holder advanceToken:token];
    }
}

- (void)rewindToOutsideOfRepetition {
    
    while (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        
        if ([holder parserRepetition] != BNFParserRepetition_NONE) {
            [_stack pop];
        } else {
            break;
        }
    }
}

/**
 * Rewinds to next incomplete sequence or to ZERO_OR_MORE repetition which
 * ever one is first.
 */
- (void)rewindToNextSymbolOrRepetition {
    
    while (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        
        if ([holder repetition] == BNFRepetition_ZERO_OR_MORE && [holder isComplete]) {
            [holder reset];
            if ([holder repetition] != BNFRepetition_NONE) {
                [holder setParserRepetition:BNFParserRepetition_ZERO_OR_MORE_LOOKING_FOR_FIRST_MATCH];
            }
            break;
        } else if ([holder sequence] && ![holder isComplete]) {
            if ([holder parserRepetition] == BNFParserRepetition_ZERO_OR_MORE_LOOKING_FOR_FIRST_MATCH) {
                [holder setParserRepetition:BNFParserRepetition_NONE];
            }
            
            break;
        }
        
        [_stack pop];
    }
}

/**
 * Rewinds to next incomplete sequence or to ZERO_OR_MORE repetition which
 * ever one is first.
 */
- (void)rewindToNextSymbol {
    while (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        
        if ([holder sequence] && ![holder isComplete]) {
            break;
        }
        
        [_stack pop];
    }
}

/**
 * rewindToNextSequence.
 */
- (void)rewindToNextSequence {
    
    while (![_stack isEmpty]) {
        BNFParserState *holder = [_stack peek];
        if ([holder sequences]) {
            break;
        }
        
        [_stack pop];
    }
}

/**
 * processStack.
 */
- (void)processStack {
    
    BNFParserState *holder = [_stack peek];
    
    if ([holder isComplete]) {
        [_stack pop];
    } else {
        
        BNFToken *currentToken = [holder currentToken];
        
        if ([holder sequences]) {
            
            BNFSequence *sequence = [holder nextSequence];
            [self addParserStateSequence:sequence token:currentToken parserRepetition:[holder parserRepetition] repetition:BNFRepetition_NONE];
            
        } else if ([holder sequence]) {
            
            BNFSymbol *symbol = [holder nextSymbol];
            NSMutableArray *sd = [_sequenceMap objectForKey:[symbol name]];
            
            BNFParserRepetition parserRepetition = [self parserRepetition:holder symbol:symbol];
            
            if (sd) {
                
                [self addParserStateSequences:sd token:currentToken parserRepetition:parserRepetition repetition:[symbol repetition]];
                 
            } else {
                     
                ParserState state = [self parserState:symbol token:currentToken parserRepetition:parserRepetition];
                [self addParserState:state];
            }
        }
    }
}
                 
/**
 * Gets the Parser State.
 */
- (ParserState)parserState:(BNFSymbol *)symbol token:(BNFToken *)token parserRepetition:(BNFParserRepetition) repetition {

    ParserState state = ParserState_NO_MATCH;

    NSString *symbolName = [symbol name];

    if ([symbolName isEqualToString:@"Empty"]) {

        state = ParserState_EMPTY;

    } else if ([self isMatch:symbolName token:token]) {

        state = ParserState_MATCH;

    } else if (repetition == BNFParserRepetition_ZERO_OR_MORE_LOOKING_FOR_FIRST_MATCH) {

        state = ParserState_NO_MATCH_WITH_ZERO_REPETITION_LOOKING_FOR_FIRST_MATCH;

    } else if (repetition == BNFParserRepetition_ZERO_OR_MORE) {

        state = ParserState_NO_MATCH_WITH_ZERO_REPETITION;
    }

    return state;
}

- (BOOL)isMatch:(NSString *)symbolName token:(BNFToken *)token {

    BOOL match = NO;

    if (token) {
        NSString *s = [self isQuotedString:symbolName] ? [symbolName substringWithRange:NSMakeRange(1, [symbolName length] - 2)] : symbolName;
        match = [s isEqualToString:[token stringValue]] || [self isQuotedString:symbolName token:token] || [self isNumber:symbolName token:token];
    }

    return match;
}

- (BOOL)isQuotedString:(NSString *)value {
    return ([value hasPrefix:@"\""] && [value hasSuffix:@"\""]) || ([value hasPrefix:@"'"] && [value hasSuffix:@"'"]);
}

- (BOOL)isQuotedString:(NSString *)symbolName token:(BNFToken *)token {
    NSString *value = [token stringValue];
    return [symbolName isEqualToString:@"QuotedString"] && [self isQuotedString:value];
}

- (BOOL)isNumber:(NSString *)symbolName token:(BNFToken *)token {

    BOOL match = NO;
    
    if (token && [symbolName isEqualToString:@"Number"]) {
        NSError *error = NULL;
        
        NSString *string = [token stringValue];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\d\\-\\.]+$"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
        match = numberOfMatches > 0;
    }
    
    return match;
}

- (void)addParserState:(ParserState)state {
    BNFParserState *pstate = [[BNFParserState alloc] initWithParserState:state];
    [_stack push:pstate];
    [pstate release];
}

- (void)addParserStateSequences:(NSMutableArray *)sequences token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRepetition repetition:(BNFRepetition)repetition {

    if ([sequences count] == 1) {
        [self addParserStateSequence:[sequences objectAtIndex:0] token:token parserRepetition:parserRepetition repetition:repetition];
    } else {
        [self debugSequences:sequences token:token parserRepetition:parserRepetition];

        BNFParserState *state = [[BNFParserState alloc] initWithSequences:sequences token:token parserRepetition:parserRepetition repetition:repetition];
        [_stack push:state];
        [state release];
    }
}

- (void)addParserStateSequence:(BNFSequence *)sequence token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRepetition repetition:(BNFRepetition)repetition {
    [self debugSequence:sequence token:token parserRepetition:parserRepetition];

    BNFParserState *state = [[BNFParserState alloc] initWithSequence:sequence token:token parserRepetition:parserRepetition repetition:repetition];
    [_stack push:state];
    [state release];
}

- (BNFParserRepetition)parserRepetition:(BNFParserState *)holder symbol:(BNFSymbol *)symbol {
   
   BNFRepetition symbolRepetition = [symbol repetition];
   BNFParserRepetition holderRepetition = [holder parserRepetition];
   
   if (symbolRepetition != BNFRepetition_NONE && holderRepetition == BNFParserRepetition_NONE) {
       holderRepetition = BNFParserRepetition_ZERO_OR_MORE_LOOKING_FOR_FIRST_MATCH;
   } else if (symbolRepetition != BNFRepetition_NONE && holderRepetition != BNFParserRepetition_NONE) {
       holderRepetition = BNFParserRepetition_ZERO_OR_MORE;
   }
   
   return holderRepetition;
}

- (BOOL)isEmpty:(BNFToken *)currentToken {
   return !([[currentToken stringValue] length] > 0);
}

- (void)debugPrintIndents {
//   NSInteger size = [_stack count] - 1;
//   for (int i = 0; i < size; i++) {
//       NSLog(@" ");
//   }
}

- (NSString *)debug:(BNFToken *)token {
   return token ? [token stringValue] : NULL;
}

     
- (void)debugSequence:(BNFSequence *)sequence token:(BNFToken *)token parserRepetition:(BNFParserRepetition)repetition {
//   [self debugPrintIndents];
//   NSLog(@"-> procesing pipe line %@ for token %@ with repetition %ld", sequence, [self debug:token], repetition);
}

- (void)debugSequences:(NSMutableArray *)sd token:(BNFToken *)token parserRepetition:(BNFParserRepetition)repetition {
//   [self debugPrintIndents];
//   NSLog(@"-> adding pipe lines %@ for token %@ with repetition %ld", sd, [self debug:token], repetition);
}

@end
