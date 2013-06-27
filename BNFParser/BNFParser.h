//
//  BNFParser.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFToken.h"
#import "BNFParseResult.h"
#import "BNFStack.h"

@interface BNFParser : NSObject

@property (nonatomic, retain) BNFStack *stack;
@property (nonatomic, retain) NSMutableDictionary *stateDefinitions;

- (id)initWithStateDefinitions:(NSMutableDictionary *)dic;

- (BNFParseResult *)parse:(BNFToken *)token;

@end
