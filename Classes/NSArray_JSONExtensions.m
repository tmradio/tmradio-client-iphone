//
//  NSArray_JSONExtensions.m
//  TMRadio
//
//  Created by Jimi Dini on 22.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import "NSArray_JSONExtensions.h"


#import "CJSONDeserializer.h"

@implementation NSArray (NSArray_JSONExtensions)

+ (id)arrayWithJSONData:(NSData *)inData error:(NSError **)outError
{
    return([[CJSONDeserializer deserializer] deserializeAsArray:inData error:outError]);
}

+ (id)arrayWithJSONString:(NSString *)inJSON error:(NSError **)outError;
{
    NSData *theData = [inJSON dataUsingEncoding:NSUTF8StringEncoding];
    return([self arrayWithJSONData:theData error:outError]);
}

@end
