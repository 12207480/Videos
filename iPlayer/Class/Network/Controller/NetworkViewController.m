//
//  NetworkViewController.m
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import "NetworkViewController.h"
#import "NetworkModel.h"
#import "NetworkViewCell.h"
#import "SettingsViewController.h"
#import "ODRefreshControl.h"
#import <mediaplayer/MPMoviePlayerController.h>
#import <mediaplayer/MPMoviePlayerViewController.h>
#import "LoadMoreFooter.h"
#import "UIView+Extension.h"

@interface NetworkViewController ()

@property (nonatomic,assign) BOOL *isXXXXX;
@property (nonatomic,strong) NSMutableArray *allVideos;
@property (nonatomic,strong) ODRefreshControl *myrefreshControl;
@property (nonatomic, weak) LoadMoreFooter *footer;
@end

@implementation NetworkViewController

// 懒加载
- (NSMutableArray *)allVideos
{
    if (_allVideos == nil) {
        self.allVideos= [NSMutableArray array];
    }
    return _allVideos;
}

-(void)goTopPosition
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)addHeader
{
    self.edgesForExtendedLayout=UIRectEdgeNone;
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(getNetworkVideo) forControlEvents:UIControlEventValueChanged];
    self.myrefreshControl=refreshControl;
}

-(void)addFooter
{
    LoadMoreFooter *footer = [LoadMoreFooter footer];
    self.footer=footer;
    self.tableView.tableFooterView = footer;
}

-(void)getNetworkVideo
{
    // 获取文件名
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"network"ofType:@"json"];
    // 根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    // 格式化成json数据
    NSError*error;
    NSDictionary *videosDic =[NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:&error];
    NSArray *videosArray=[videosDic objectForKey:@"Data"];
    
    for (NSDictionary *tempVideoDic in videosArray) {
        
        NetworkModel *model=[[NetworkModel alloc] init];
        model.m_time=tempVideoDic[@"duration"];
        model.m_image=tempVideoDic[@"image"];
        model.m_path=tempVideoDic[@"url"];
        model.m_name=tempVideoDic[@"name"];
        
        [self.allVideos addObject:model];
    }
    
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myrefreshControl endRefreshing];
    });
}

// 跳转设置页面
-(void)goSettingsPage
{
    SettingsViewController *tplusOVC  =(SettingsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    tplusOVC.title=@"设置";
    [self.navigationController pushViewController:tplusOVC animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"顶部" style:UIBarButtonItemStylePlain target:self action:@selector(goTopPosition)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(goSettingsPage)];
    [self addHeader];
    [self addFooter];
    [self getNetworkVideo];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allVideos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetworkViewCell *cell=[NetworkViewCell cellWithTableView:tableView];
    cell.myModel=[self.allVideos objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetworkModel *model=[self.allVideos objectAtIndex:indexPath.row];
    NSString *fileName=model.m_path;
    [self video_play:fileName];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)video_play:(NSString*)filename
{
    NSURL*videoPathURL=[NSURL URLWithString:filename];//urlStr是视频播放地址
    MPMoviePlayerViewController*playViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:videoPathURL];
    MPMoviePlayerController*player=[playViewController moviePlayer];
    player.scalingMode=MPMovieScalingModeFill;
    player.controlStyle=MPMovieControlStyleFullscreen;
    [player play];
    [self.navigationController presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark - tableView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.allVideos.count <= 0 || self.footer.isRefreshing) return;
    // 1.差距
    CGFloat delta = scrollView.contentSize.height - scrollView.contentOffset.y;
    // 刚好能完整看到footer的高度
    CGFloat sawFooterH = self.view.height - self.tabBarController.tabBar.height;
    
    // 2.如果能看见整个footer
    if (delta <= (sawFooterH - 0)) {
        // 进入上拉刷新状态
        [self.footer beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载数据
            [self getNetworkVideo];
            [self.footer endRefreshing];
        });
    }
}


@end
