//
//  BNFSequenceFactory.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-08-19.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNFSequenceFactory : NSObject

/**
 * @return Map<String, List<BNFSequence>> - for JSON grammar
 */
- (NSMutableDictionary *)json;

@end
