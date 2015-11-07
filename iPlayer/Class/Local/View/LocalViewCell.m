//
//  LocalViewCell.m
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import "LocalViewCell.h"
#import "LocalModel.h"

@implementation LocalViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"LocalViewCell";
    //自定义cell类
    LocalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setMyModel:(LocalModel *)myModel
{
    _myModel=myModel;
    self.videoImage.image=myModel.m_image;
    self.videoName.text=myModel.m_name;
    self.videoTime.text=myModel.m_time;
}


@end
