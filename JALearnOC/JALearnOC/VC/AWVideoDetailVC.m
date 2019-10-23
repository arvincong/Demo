//
//  AWVideoDetailVC.m
//  JALearnOC
//
//  Created by jason on 8/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWVideoDetailVC.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>

@interface AWVideoDetailVC()<SuperPlayerDelegate>

@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@property BOOL isAutoPaused;

@end

@implementation AWVideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUIMethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark -- Custom Method
-(void)createUIMethod
{
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.mm_width(self.view.mm_w).mm_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    //_playerView.isFullScreen = YES;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = _receiveVideoUrl;
    self.playerView.delegate = self;
    self.playerView.fatherView = self.playerContainer;
    
    [[(SPDefaultControlView *)_playerView.controlView titleLabel] setText:_receiveTitle];
    
    // 开始播放
    [_playerView playWithModel:playerModel];
    [self.view addSubview:self.playerContainer];
}

#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    if(self.playerView.isFullScreen){
        
        return [(SPDefaultControlView *)self.playerView.controlView isShowStatusBar];
    }
    return NO;
}


- (void)superPlayerBackAction:(SuperPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        [self.playerView resetPlayer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isAutoPaused) {
        [self.playerView resume];
        self.isAutoPaused = NO;
    }
}

@end
