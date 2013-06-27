//
//  BNFParseResult.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFToken.h"

@interface BNFParseResult : NSObject

@property (nonatomic, retain) BNFToken *top;
@property (nonatomic, retain) BNFToken *error;
@property (nonatomic, retain) BNFToken *maxMatchToken;
@property (nonatomic, assign) BOOL success;

- (void)complete;

@end
