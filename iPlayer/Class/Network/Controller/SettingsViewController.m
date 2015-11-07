//
//  SettingsViewController.m
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import "SettingsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "SDImageCache.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2f M",(unsigned long)[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
    
    self.tableView.tableFooterView=[UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showMessage:@"正在清除..."];
    [[SDImageCache sharedImageCache] clearDisk];
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2f M",(unsigned long)tmpSize/1.0];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"缓存已清空"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
