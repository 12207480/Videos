//
//  NSString+TimeLength.h
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeLength)

+(NSString*)videoTimeLength:(NSString*)videoUrl;

+(NSString *)timeFormatted:(int)totalSeconds;
@end
