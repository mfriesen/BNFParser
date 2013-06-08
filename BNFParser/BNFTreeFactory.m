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

#import "BNFTreeFactory.h"
#import "Stack.h"

@implementation BNFTreeFactory

- (BNFTree *)json:(BNFParserStatus *)status {
    
    NSInteger errorPosition = [self errorPosition:[status error]];
    
    BNFTree *tree = [self buildTree:[status top] errorPosition:errorPosition];
    
    return tree;
}

- (NSInteger)errorPosition:(BNFToken *)error {
    return error ? [error position] : -1;
}

- (void)debug:(BNFTree *)tree {
    
    for (BNFTreeNode *n in [tree nodes]) {
        NSLog(@"%@", [n value]);
        [self debugNode:n];
    }
}

- (void)debugNode:(BNFTreeNode *)node {
    
    for (BNFTreeNode *n in [node nodes]) {
        NSLog(@"%@", [n value]);
        [self debugNode:n];
    }
}

- (NSString *)formatValidString:(BNFParserStatus *)status {
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    BNFToken *error = [status error];
    BNFToken *token = [status top];
    
    [self buildJsonToken:token error:error intoString:ms tab:0];
    
    NSString *s = [NSString stringWithString:ms];
    [ms release];
    
    return s;
}

- (NSString *)formatInvalidString:(BNFParserStatus *)status {
    
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    BNFToken *token = [status error];
    
    while (token && ![token isLastToken]) {
        [ms appendString:[token stringValue]];
        token = [token nextToken];
    }
    
    NSString *s = [NSString stringWithString:ms];
    [ms release];
    
    return s;
}

- (BNFTree *)buildTree:(BNFToken *)token errorPosition:(NSInteger)errorPosition {
    
    BNFTree *tree = [[[BNFTree alloc] init] autorelease];
    
    Stack *stack = [[Stack alloc] init];
    [stack push:tree];
        
    NSMutableString *ms = [[NSMutableString alloc] init];
    
    while (![token isLastToken]) {
        
        BNFTreeNode *top = [stack top];
        BOOL haserror = errorPosition > -1 && errorPosition <= [token position];
        NSString *s = [token stringValue];
        
        if ([s hasSuffix:@"["] || [s hasSuffix:@"{"]) {
  
            [ms appendString:s];
            BNFTreeNode *node = [self addTreeNode:top string:[NSString stringWithString:ms] haserror:haserror];
            [stack push:node];
            [ms setString:@""];
        
        } else if ([s isEqualToString:@":"]) {
            
            [ms appendString:@" : "];
            
        } else if ([s hasSuffix:@","]) {
            
            [ms appendString:s];
            [self addTreeNode:top string:[NSString stringWithString:ms] haserror:haserror];
            [ms setString:@""];
            
        } else if ([s hasSuffix:@"]"] || [s hasSuffix:@"}"]) {

            if ([ms length] > 0) {
                [self addTreeNode:top string:[NSString stringWithString:ms] haserror:haserror];
                [ms setString:@""];
            }
            
            [stack pop];
            [self addTreeNode:[stack top] string:[NSString stringWithString:s] haserror:haserror];

        } else {
            
            [ms appendString:s];
        }
        
        token = [token nextToken];
    }
    
    [stack release];
    [ms release];
    
    return tree;
}

- (BNFTreeNode *)addTreeNode:(BNFTreeNode *)node string:(NSString *)s haserror:(BOOL)haserror {
   
    BNFTreeNode *newNode = [[BNFTreeNode alloc] init];
    [newNode setValue:s];
    [newNode setHasError:haserror];
    
    [node addNode:newNode];
    
    [newNode release];
    
    return newNode;
}

- (void)appendTabs:(NSMutableString *)ms tab:(NSInteger)tab {
    for (int i = 0; i < tab; i++) {
        [ms appendString:@"\t"];
    }
}

- (void)buildJsonToken:(BNFToken *)token error:(BNFToken *)error intoString:(NSMutableString *)ms tab:(NSInteger)tab {
    
    while (![token isLastToken] && token != error) {
        
        NSString *s = [token stringValue];

        if ([s isEqualToString:@"{"] || [s isEqualToString:@"["]) {
            
            tab++;
            [ms appendFormat:@"%@\n", s];
            [self appendTabs:ms tab:tab];
            
        } else if ([s isEqualToString:@":"]) {
            
            [ms appendString:@" : "];
            
        } else if ([s isEqualToString:@","]) {
            
            [ms appendFormat:@"%@\n", s];
            [self appendTabs:ms tab:tab];
            
        } else if ([s isEqualToString:@"}"] || [s isEqualToString:@"]"]) {
            
            tab--;
            [ms appendFormat:@"\n"];
            [self appendTabs:ms tab:tab];
            [ms appendFormat:@"%@", s];
            
        } else {
            [ms appendFormat:@"%@", s];
        }
        
        token = [token nextToken];
    }
}

@end