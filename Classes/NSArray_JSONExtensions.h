//
//  NSArray_JSONExtensions.h
//  TMRadio
//
//  Created by Jimi Dini on 22.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_JSONExtensions)

+ (id)arrayWithJSONData:(NSData *)inData error:(NSError **)outError;
+ (id)arrayWithJSONString:(NSString *)inJSON error:(NSError **)outError;

@end
