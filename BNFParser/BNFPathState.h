//
//  BNFPathState.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BNFPath.h"
#import "BNFState.h"

@interface BNFPathState : BNFPath

@property (nonatomic, retain) BNFState *state;

- (id)init;
- (id)initWithState:(BNFState *)state token:(BNFToken *)token;

@end
