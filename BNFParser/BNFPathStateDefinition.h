//
//  BNFPathStateDefinition.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFPath.h"
#import "BNFStateDefinition.h"

@interface BNFPathStateDefinition : BNFPath

@property (nonatomic, retain) BNFStateDefinition *stateDefinition;
@property (nonatomic, assign) NSInteger position;

- (BOOL)hasNextSequence;
- (BNFState *)getNextSequence;
- (BNFState *)getNextState;

@end
