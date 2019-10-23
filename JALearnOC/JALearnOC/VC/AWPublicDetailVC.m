//
//  AWPublicDetailVC.m
//  JALearnOC
//
//  Created by jason on 11/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPublicDetailVC.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "AWPublicEpisodeVC.h"

#import "UIButton+AWImageTitleSpace.h"
#import "AWDownloadEpisodeVC.h"
#define MaxEpisodeCount 25

@interface AWPublicDetailVC ()<SuperPlayerDelegate,WMPageControllerDelegate,WMPageControllerDataSource>{
 
    WMPageController *_pageController;
}

@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@property BOOL isAutoPaused;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *titlesArray;

@property(nonatomic,strong)NSString *recordPlayUrl;

@property(nonatomic,assign)NSInteger recordPlayIndex; //当前剧集播放index


@end

@implementation AWPublicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUIMethod];
    
    [self getVideoDetailMethod];
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
    //_playerView.isFullScreen = YES;
    [[(SPDefaultControlView *)_playerView.controlView titleLabel] setText:_receivePlayerModel.title];
    
    self.playerView.delegate = self;
    self.playerView.fatherView = self.playerContainer;
    
    [self.view addSubview:self.playerContainer];
    
#warning 添加下载按钮
    UIButton *downloadBtn = [UIButton new];
    [downloadBtn setImage:[UIImage imageNamed:@"ic_loadbtn_bg"] forState:UIControlStateNormal];
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:downloadBtn];
    
    CGFloat originalHeight = self.view.mm_w*9.0f/16.0f + 10;
    
    [downloadBtn layoutButtonWithEdgeInsetsStyle:AWButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(originalHeight);
        make.size.mas_equalTo(CGSizeMake(70,40));
    }];
    
    __block typeof(self) weakSelf = self;
    
    [downloadBtn addAction:^(id  _Nonnull sender) {
        
        if([weakSelf.dataArray count ] > 0){
            AWDownloadEpisodeVC *vc = [AWDownloadEpisodeVC new];
            vc.receiveDataArray = weakSelf.dataArray;
            vc.episodeNameStr = weakSelf.receivePlayerModel.title;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
             [weakSelf.view.window makeToast:@"暂时未获取到剧集列表"];
        }
      
    }];
    
    
}


-(void)playVideoMethod:(AWVideoDetailModel *)originalModel withTargetUrl:(NSString *)targetUrl;
{
   // [self.playerView resetPlayer];
    
    self.recordPlayUrl = originalModel.url;
    
    [[(SPDefaultControlView *)_playerView.controlView titleLabel] setText:[NSString stringWithFormat:@"%@-%@",_receivePlayerModel.title,originalModel.name]];
    
#warning 添加播放集数缓存
    NSArray *currentArray = [AWUserDefaultTool load:kApp_browseRecord];
    NSArray *urlArray = [AWUserDefaultTool load:kApp_playUrl];
    NSMutableArray *cacheUrlArray; //缓存url
    NSMutableArray *cacheDataArray; //混存数据
    if(urlArray && [urlArray count] > 0){
        cacheUrlArray = [NSMutableArray arrayWithArray:urlArray];
    }else{
        cacheUrlArray = [NSMutableArray array];
    }
    
    if(currentArray && [currentArray count] > 0){
        cacheDataArray = [NSMutableArray arrayWithArray:currentArray];
    }else{
        cacheDataArray = [NSMutableArray array];
    }
    
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionary];
    [cacheDic setObject:_receivePlayerModel.img?_receivePlayerModel.img:@"" forKey:@"img"];
    [cacheDic setObject:_receivePlayerModel.url?_receivePlayerModel.url:@"" forKey:@"url"];
    [cacheDic setObject:_receivePlayerModel.title?_receivePlayerModel.title:@"" forKey:@"title"];
    [cacheDic setObject:originalModel.name?originalModel.name:@"" forKey:@"episode"];
    
    if([cacheUrlArray count] > 0){
        
        if([cacheUrlArray containsObject:cacheDic[@"url"]]){
            
            NSInteger urlIndex = [cacheUrlArray indexOfObject:cacheDic[@"url"]];
            [cacheDataArray replaceObjectAtIndex:urlIndex withObject:cacheDic];
            
        }else{
            [cacheUrlArray addObject:cacheDic[@"url"]];
            [cacheDataArray addObject:cacheDic];
        }
        
    }else{
        [cacheUrlArray addObject:cacheDic[@"url"]];
        [cacheDataArray addObject:cacheDic];
    }
    
    [AWUserDefaultTool save:kApp_playUrl data:[NSArray arrayWithArray:cacheUrlArray]];
    
    [AWUserDefaultTool save:kApp_browseRecord data:[NSArray arrayWithArray:cacheDataArray]];
    
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    NSLog(@"this play url is %@",targetUrl);
    playerModel.videoURL = targetUrl;
    
    [_playerView playWithModel:playerModel];
}
//绘制集数控件
-(void)createPlayPageMethod
{
    
    _titlesArray = [NSMutableArray array];
    
    if([_dataArray count] < MaxEpisodeCount){
     
        [_titlesArray addObject:[NSString stringWithFormat:@"%d~%lu",1,(unsigned long)_dataArray.count]];
    }else{
     
        NSInteger currentCount = ([_dataArray count] / MaxEpisodeCount) + 1;
        
        for (int i = 0; i < currentCount; i++) {
            NSInteger startCount = (i*MaxEpisodeCount + 1);
            NSInteger finalCount = (i+1)*MaxEpisodeCount;
            
            if (finalCount > [_dataArray count]) {
                [_titlesArray addObject:[NSString stringWithFormat:@"%ld~%ld",(long)startCount,(long)[_dataArray count]]];
            }else{
                [_titlesArray addObject:[NSString stringWithFormat:@"%ld~%ld",(long)startCount,(long)finalCount]];
            }
           
        }
    }
    
    _pageController = [[WMPageController alloc] init];
    _pageController.pageAnimatable = YES;
    _pageController.delegate = self;
    _pageController.dataSource = self;
    _pageController.menuViewStyle =  WMMenuViewStyleLine;
    _pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    _pageController.menuItemWidth = SCREEN_WIDTHL/5;
    _pageController.titleColorNormal = [UIColor colorWithHexString:@"#ffffff"];
    _pageController.titleColorSelected = [UIColor colorWithHexString:@"#00c6ff"];
    _pageController.progressColor = [UIColor colorWithHexString:@"#00c6ff"];
    
    CGFloat originalHeight = self.view.mm_w*9.0f/16.0f + 10 + 40;
    _pageController.view.backgroundColor = KNormalBgColor;
    _pageController.view.frame = CGRectMake(0,originalHeight,SCREEN_WIDTHL,SCREEN_HEIGHTL - originalHeight);
    
    [self.view addSubview:_pageController.view];
    [self addChildViewController:_pageController];
    [_pageController reloadData];
}

#pragma mark 屏幕旋转
////// 是否支持自动转屏
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//// 支持哪些屏幕方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//
////默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

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

#pragma 下集自动播放
- (void)superPlayerDidEnd:(SuperPlayerView *)player
{
//    if(self.playerView.isFullScreen){
//        return;
//    }
    
    //获取下一集的地址，采用代码点击按钮的方式
    
   __block NSInteger recordIndex;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        AWVideoDetailModel *model = (AWVideoDetailModel *)obj;
        
        if([model.url isEqualToString:self.recordPlayUrl]){
            
            recordIndex  = idx;
        }
    }];
    
    if(recordIndex == _dataArray.count -1){
     
        return;
    }else{
     
        NSInteger playIndex = recordIndex / MaxEpisodeCount;
        
        NSLog(@"this result is %@",_pageController);
        if(playIndex != _recordPlayIndex){
        
            _pageController.selectIndex = (int)playIndex;
        }
        NSInteger nextIndex = recordIndex + 1;
        
        AWPublicEpisodeVC *vc = (AWPublicEpisodeVC *)_pageController.currentViewController;
        
        AWVideoDetailModel *currentModel = [_dataArray objectAtIndex:nextIndex];
        
        //找到要点击的按钮
        UIButton *clickBtn = (UIButton *) [vc.view viewWithTag:100 + (nextIndex % MaxEpisodeCount)];
        
        [vc changeBtnColorMethod:clickBtn];
        [vc getVideoPlayerUrlMethod:currentModel];
        
       // [self getVideoPlayerUrlMethod:currentModel];
        
    }
}

#pragma mark - API Method
-(void)getVideoDetailMethod
{
    [SVProgressHUD showLoadingHUDInWindow:@"加载中..."];
    
    _dataArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_DETAIL_API] parameters:@{@"url":_receivePlayerModel.url} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
         
            NSArray *currentArray = responseObject[@"data"][@"list"];
            [currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                [weakSelf.dataArray addObject:[AWVideoDetailModel yy_modelWithJSON:obj]];
            }];
            
            [weakSelf createPlayPageMethod];
            
        }else{
            
            [weakSelf.view.window makeToast:@"暂时未获取到剧集列表"];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
    
}

-(void)getVideoPlayerUrlMethod:(AWVideoDetailModel *)transModel
{
   [SVProgressHUD showLoadingHUDInWindow:@"准备中..."];
    
    __weak typeof(self) weakSelf = self;
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_PLAYURL_API] parameters:@{@"url":transModel.url} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
            
            NSString *playUrl = responseObject[@"data"][@"url"];
            //播放视频
            [weakSelf playVideoMethod:transModel withTargetUrl:playUrl];
        }else{
            [weakSelf.view.window makeToast:@"暂时无法播放"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
}

#pragma mark UI WMPageControllerDelegate Method
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    return _titlesArray[index];
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return [_titlesArray count];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    NSInteger startCount = (index*MaxEpisodeCount + 1);
    NSInteger finalCount = (index+1)*MaxEpisodeCount;
    NSInteger length;
    
    if(finalCount > _dataArray.count){
        length = _dataArray.count - startCount +1;
    }else{
        length = finalCount - startCount + 1;
    }
    NSRange range = NSMakeRange(startCount-1,length);
    
    NSArray *transArray = [_dataArray subarrayWithRange:range];
    
    AWPublicEpisodeVC *vc = [AWPublicEpisodeVC new];
    vc.receiveEpisodeArray = transArray;
    vc.receiveOriginalVC = self;
    
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(10,0,self.view.frame.size.width -20, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0,45, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
    NSInteger index = [info[@"index"] integerValue];
    
    _recordPlayIndex = index;
    
    NSLog(@"this index is %ld",(long)index);
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
