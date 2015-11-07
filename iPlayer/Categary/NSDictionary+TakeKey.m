//
//  NSDictionary+TakeKey.m
//  mPOS
//
//  Created by 德益富 on 15/5/25.
//  Copyright (c) 2015年 Dyf. All rights reserved.
//

#import "NSDictionary+TakeKey.h"

@implementation NSDictionary (TakeKey)

- (NSString *)strNotNullObjectForKey:(NSString *)key{
    NSString *str = [self objectForKey:key];
    if (str == nil || [str isKindOfClass:[NSNull class]]||[str isEqualToString:@"null"]) {
        return @"";
    }else{
        return str;
    }
}

@end
