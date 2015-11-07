//
//  NetworkViewCell.m
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import "NetworkViewCell.h"
#import "NetworkModel.h"
#import "UIImageView+WebCache.h"

@implementation NetworkViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"NetworkViewCell";
    //自定义cell类
    NetworkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setMyModel:(NetworkModel *)myModel
{
    _myModel=myModel;
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:myModel.m_image] placeholderImage:[UIImage imageNamed:@"networkPlace"]];//
    self.videoName.text=myModel.m_name;
    self.videoTime.text=myModel.m_time;
}


@end
