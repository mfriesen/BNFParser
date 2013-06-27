//
//  BNFTokenizerParams.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-24.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNFTokenizerParams : NSObject

@property (nonatomic, assign) BOOL includeWhitespace;
@property (nonatomic, assign) BOOL includeWhitespaceOther;
@property (nonatomic, assign) BOOL includeWhitespaceNewlines;

@end
