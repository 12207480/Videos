//
//  NetworkModel.h
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkModel : NSObject

@property (nonatomic,copy) NSString *m_name;
@property (nonatomic,copy) NSString *m_time;
@property (nonatomic,strong) NSString *m_image;
@property (nonatomic,copy) NSString *m_path;

@end
