//
//  LocalViewController.m
//  iPlayer
//
//  Created by Thomas on 15/11/6.
//  Copyright © 2015年 Thomas. All rights reserved.
//

#import "LocalViewController.h"
#include<AssetsLibrary/AssetsLibrary.h>
#import "LocalModel.h"
#import "LocalViewCell.h"
#import "UIImage+Extension.h"
#import "NSString+TimeLength.h"
#import "ODRefreshControl.h"

#import <mediaplayer/MPMoviePlayerController.h>
#import <mediaplayer/MPMoviePlayerViewController.h>

#import "MBProgressHUD+MJ.h"

@interface LocalViewController ()

@property (nonatomic,strong) NSMutableArray *allVideos;
@property (nonatomic,strong) ODRefreshControl *myrefreshControl;
@property (nonatomic,strong) MPMoviePlayerController *theMovie;

@end

@implementation LocalViewController

- (NSMutableArray *)theMovie
{
    if (_theMovie == nil) {
        self.theMovie= [[MPMoviePlayerController alloc] init];
    }
    return _theMovie;
}
// 懒加载
- (NSMutableArray *)allVideos
{
    if (_allVideos == nil) {
        self.allVideos= [NSMutableArray array];
    }
    return _allVideos;
}

- (void)addHeader
{
    self.edgesForExtendedLayout=UIRectEdgeNone;
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.myrefreshControl=refreshControl;
}

-(void)refreshData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getLocalVideo];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"搜素中..." toView:self.view];
        [self getLocalVideo];
    });
}

-(void)getLocalVideo
{
    [self.allVideos removeAllObjects];
    
    __block int mIndex=0;
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group)
         {
             [group setAssetsFilter:[ALAssetsFilter allVideos]];
             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset)
                  {
                      LocalModel *model=[[LocalModel alloc] init];
                      ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                      NSString *uti = [defaultRepresentation UTI];
                      NSURL  *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                      NSString *title = [NSString stringWithFormat:@"video %d",mIndex];
                      UIImage *image = [UIImage imageFromVideoURL:videoURL];
                      
                      model.m_path=[videoURL absoluteString];
                      model.m_name=title;
                      model.m_image=image;
                      model.m_name=title;
                      model.m_time=[NSString timeFormatted:[NSString videoTimeLength:[videoURL absoluteString]].intValue];
                      [self.allVideos addObject:model];
                      mIndex++;
                  }
              }];
             
             
             [self.tableView reloadData];
             [self.myrefreshControl endRefreshing];
         }
     }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"访问的权限未打开");
     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 清楚底部
    self.tableView.tableFooterView=[UIView new];
    [self addHeader];
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
    LocalViewCell *cell=[LocalViewCell cellWithTableView:tableView];
    cell.myModel=[self.allVideos objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.allVideos.count)
    {
        LocalModel *model=[self.allVideos objectAtIndex:indexPath.row];
        NSString *fileName=model.m_path;
        [self video_play:fileName];
    }
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

@end
