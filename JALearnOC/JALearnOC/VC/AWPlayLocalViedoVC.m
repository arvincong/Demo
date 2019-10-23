//
//  AWPlayLocalViedoVC.m
//  JALearnOC
//
//  Created by jason on 25/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPlayLocalViedoVC.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>

@interface AWPlayLocalViedoVC ()<SuperPlayerDelegate>

@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@property BOOL isAutoPaused;

@end

@implementation AWPlayLocalViedoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isAutoPaused) {
        [self.playerView resume];
        self.isAutoPaused = NO;
    }
}
#pragma mark - Custom Method
-(void)createUIMethod
{
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.mm_width(self.view.mm_w).mm_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    
    [[(SPDefaultControlView *)_playerView.controlView titleLabel] setText:_videoTitle];
    
     SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = _localVideoUrl;
    [_playerView playWithModel:playerModel];
    
    self.playerView.delegate = self;
    self.playerView.fatherView = self.playerContainer;
    [self.view addSubview:self.playerContainer];
    
      _playerView.isFullScreen = YES;
}


#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    if(self.playerView.isFullScreen){
        
        SPDefaultControlView *currentView = (SPDefaultControlView *)self.playerView.controlView;
        
        return currentView.isShowStatusBar;
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

- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why
{
    [self.view makeToast:why];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
