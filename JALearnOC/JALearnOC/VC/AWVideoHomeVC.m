//
//  AWVideoHomeVC.m
//  JALearnOC
//
//  Created by jason on 11/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWVideoHomeVC.h"

#import "AWPlayerListVC.h"
#import "AWMeiDramaVC.h"
#import "AWMovieVC.h"
#import "AWSearchResultVC.h"
#import "AWHistoryWatchVC.h"
#import "AWDownLoadFilmVC.h"

@interface AWVideoHomeVC()<WMPageControllerDelegate,WMPageControllerDataSource>{
    
    NSMutableArray *_viewControllers;
    NSArray *_titlesArray;
    CGFloat _menuHeight;
    
   
}
@property(nonatomic,assign) NSInteger recordPlayIndex;

@end

@implementation AWVideoHomeVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createUIMethod];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Custom Method
-(void)createUIMethod
{
      _viewControllers = [NSMutableArray array];
    //@[[AWPlayerListVC class],[AWMeiDramaVC class],[AWMovieVC class]];
      //_titlesArray =@[@"动漫",@"美剧",@"电影"];
      _titlesArray = [AWUserDefaultTool load:@"RECORD_CHANNEL"];
      
      for (NSString *titleStr in _titlesArray) {
          
          if([titleStr isEqualToString:@"动漫"]){
              
              [_viewControllers addObject: [AWPlayerListVC class]];
              
          }else if ([titleStr isEqualToString:@"美剧"]){
              
              [_viewControllers addObject: [AWMeiDramaVC class]];
              
          }else if ([titleStr isEqualToString:@"电影"]){
              
              [_viewControllers addObject:[AWMovieVC class]];
          }
      }
    
    //CGFloat originalWidth = (SCREEN_WIDTHL -40) / [_viewControllers count];
    
    self.pageAnimatable = YES;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.showOnNavigationBar = YES;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    //self.menuItemWidth = originalWidth;
    self.titleColorNormal = [UIColor colorWithHexString:@"#ffffff"];
    self.titleColorSelected = [UIColor colorWithHexString:@"#00c6ff"];
    self.progressColor = [UIColor colorWithHexString:@"#00c6ff"];
    self.progressViewCornerRadius = 5;
    [self reloadData];
    
    /* 屏蔽当前两个按钮
    //添加观看记录按钮
    UIButton *historyBtn = [UIButton new];
    historyBtn.frame = CGRectMake(SCREEN_WIDTHL - 46,(Height_NavBar -36)/2,36,36);
    [historyBtn setImage:[UIImage imageNamed:@"ic_record_bg"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:historyBtn];
    
    [historyBtn addAction:^(id  _Nonnull sender) {
        AWHistoryWatchVC*vc = [AWHistoryWatchVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //下载按钮
    UIButton *downloadBtn = [UIButton new];
    downloadBtn.frame = CGRectMake(SCREEN_WIDTHL - 46 - 46 -46,(Height_NavBar - 36)/2,36,36);
    [downloadBtn setImage:[UIImage imageNamed:@"ic_down_bg"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:downloadBtn];
    
    [downloadBtn addAction:^(id  _Nonnull sender) {
        
        AWDownLoadFilmVC *vc = [AWDownLoadFilmVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    */
    
    //添加搜索按钮
    UIButton *searchBtn = [UIButton new];
    //searchBtn.frame = CGRectMake(SCREEN_WIDTHL - 46 - 46,(Height_NavBar -36)/2,36,36);
    searchBtn.frame = CGRectMake(SCREEN_WIDTHL - 46,(Height_NavBar -36)/2,36,36);
    [searchBtn setImage:[UIImage imageNamed:@"ic_btn_bg"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:searchBtn];
    
    [searchBtn addAction:^(id  _Nonnull sender) {
        AWSearchResultVC *vc = [AWSearchResultVC new];
        if(self.recordPlayIndex == 0){
            vc.searchType = @"bm";
        }else if(self.recordPlayIndex == 1){
            vc.searchType = @"mj";
        }else{
            vc.searchType = @"yb";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    

}

#pragma mark - WMPageControllerDelegate
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    
    return _titlesArray[index];
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    
    return [_viewControllers count];
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    
    NSString *currentTitle = _titlesArray[index];
    if([currentTitle isEqualToString:@"动漫"]){
        return [AWPlayerListVC new];
    }else if ([currentTitle isEqualToString:@"美剧"]){
        return [AWMeiDramaVC new];
    }else if ([currentTitle isEqualToString:@"电影"]){
         return [AWMovieVC new];
    }
    abort();
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(20,0,self.view.frame.size.width -40, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
     return CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
    NSInteger index = [info[@"index"] integerValue];
    
    _recordPlayIndex = index;
}

#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end
