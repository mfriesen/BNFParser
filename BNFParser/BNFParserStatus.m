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

#import "BNFParserStatus.h"

@interface BNFParserStatus ()
    @property (nonatomic, retain) BNFToken *itop;
    @property (nonatomic, retain) BNFToken *icurrent;
    @property (nonatomic, retain) BNFToken *ierror;
    @property (nonatomic, assign) BNFParserStatusType type;
    @property (nonatomic, assign) NSInteger positionError;
    @property (nonatomic, assign) NSInteger idepth;
@end

@implementation BNFParserStatus

- (id)initWithToken:(BNFToken *)token {
    self = [super init];
    
    if (self) {
        [self setItop:token];
        [self setIcurrent:token];
        [self setIdepth:-1];
        [self setPositionError:-1];
    }
    
    return self;
}

- (NSInteger)depth {
    return _idepth;
}

- (void)setCurrent:(BNFToken *)token {
    [self setIcurrent:token];
}

- (BNFToken *)top {
    return _itop;
}

- (BNFToken *)current {
    return _icurrent;
}

- (BNFToken *)error {
    return _ierror;
}

- (void)setStatus:(BNFParserStatusType)status {
    
    [self setType:status];
    
    if (status == STATE_COMPLETE) {
        
        BNFToken *next = [_icurrent nextToken];
        [self setIcurrent:next];
        
        if (!next || [next isLastToken]) {
            [self setType:STATE_COMPLETE];
            [self setPositionError:-1];
            [self setIerror:nil];
        } else {
            [self setType:STATE_OKAY];
        }
        
    } else if (status == STATE_FAILED) {
        
        NSInteger position = [_icurrent position];
        if (position > self.positionError) {
            [self setPositionError:position];
            [self setIerror:_icurrent];
        }
    }
}

- (void)incrementDepth {
    [self setIdepth:self.idepth + 1];
}

- (void)decrementDepth {
    [self setIdepth:self.idepth - 1];
}

- (BOOL)isComplete {
    return self.type == STATE_COMPLETE;
}

- (BOOL)isFailed {
    return self.type == STATE_FAILED;
}

- (BOOL)isOkay {
    return self.type == STATE_OKAY;
}

- (void)dealloc {
    
    [_itop release];
    [_icurrent release];
    [_ierror release];
    
    [super dealloc];
}

@end
