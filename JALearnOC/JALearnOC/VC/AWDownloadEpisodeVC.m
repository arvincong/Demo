//
//  AWDownloadEpisodeVC.m
//  JALearnOC
//
//  Created by jason on 23/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDownloadEpisodeVC.h"
#import "AWVideoDetailModel.h"
#import "AWDownEpisodeCell.h"
#import "AWDownLoadFilmVC.h"

@interface AWDownloadEpisodeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation AWDownloadEpisodeVC

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

#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Custom Method
- (void)createUIMethod
{
    UIView *topView = [UIView new];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = KNavBgColor;
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(Height_TopBar);
    }];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"ic_nav_bg"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(KFullScreen){
            make.centerY.equalTo(topView.mas_centerY).offset(15);
        }else{
            make.centerY.equalTo(topView.mas_centerY).offset(8);
        }
        make.size.mas_equalTo(CGSizeMake(44,44));
        make.left.equalTo(topView.mas_left).offset(5);
    }];
    
    [backBtn addAction:^(id  _Nonnull sender) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = _episodeNameStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.mas_right);
        make.right.equalTo(topView.mas_right).offset(-40);
        if(KFullScreen){
            make.centerY.equalTo(topView.mas_centerY).offset(15);
        }else{
            make.centerY.equalTo(topView.mas_centerY).offset(8);
        }
        make.height.mas_equalTo(20);
    }];
    
    //创建剧集列表
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = KNormalBgColor;
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.showsVerticalScrollIndicator = false;
    [_collectionView registerClass:[AWDownEpisodeCell class] forCellWithReuseIdentifier:@"AWDownEpisodeCell"];
    _collectionView.userInteractionEnabled = true;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(Height_TopBar);
    }];
    
    _dataArray = [NSMutableArray arrayWithArray:[_receiveDataArray reversedArray]];
    [_collectionView reloadData];
}

#pragma mark - 获取剧集的下载地址
-(void)getVideoPlayerUrlMethod:(AWVideoDetailModel *)detailModel
{
    [SVProgressHUD showLoadingHUDInWindow:@"准备中..."];
    
    __weak typeof(self) weakSelf = self;
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_PLAYURL_API] parameters:@{@"url":detailModel.url} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *playUrl = responseObject[@"data"][@"url"];
                //检查网络状态，下载播放视频
                NSInteger statusCode = [[AWNetworkManager sharedInstance] networkStatusCode];
                if(statusCode == 2){
                    //wifi
                    [weakSelf downEpisodeMethod:playUrl withInfo:detailModel];
                    
                }else if (statusCode == 1){
                 //移动网络
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为移动网络，注意流量消耗哦" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                             
                                                                         }];
                    
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weakSelf downEpisodeMethod:playUrl withInfo:detailModel];
                    }];
                    
                    [alertController  addAction:sureAction];
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }else{
                    //未知网络，或者无法使用的网络
                     [weakSelf.view.window makeToast:@"请检查您的网络"];
                }
                
            });
            
        }else{
            [weakSelf.view.window makeToast:@"未获取到下载资源"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"this errot result is %@ code is %ld",error.description,(long)error.code);
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
}

//下载剧集操作
-(void)downEpisodeMethod:(NSString *)downUrl withInfo:(AWVideoDetailModel *)originalModel{
    
    //缓存下载信息
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSLog(@"this down url is %@",downUrl);
    NSString *cacheUrl = downUrl;
    //NSString *cacheUrl = @"http://218.200.160.29/rdp2/test/mac/listen.do?contentid=6990539Z0K8&ua=Mac_sst&version=1.0";
    [dic setObject:cacheUrl forKey:@"downUrl"];
    
    NSString *cacheName;
    if([cacheUrl containsString:@".mp4"]){
        cacheName = [NSString stringWithFormat:@"%@-%@.%@",_episodeNameStr,originalModel.name,@"mp4"];
    }else if ([cacheUrl containsString:@".m3u8"]){
        //cacheName = [NSString stringWithFormat:@"%@-%@.%@",_episodeNameStr,originalModel.name,@"m3u8"];
        [self.view makeToast:@"暂时不支持该格式下载" duration:2 position:CSToastPositionCenter];
        
        return;
    }
    
    [dic setObject:cacheName forKey:@"downName"];
    
    NSArray *currentArray = [AWUserDefaultTool load:kApp_downDataArray];
    NSMutableArray *cacheArray;
    if(currentArray && [currentArray count] > 0){
        cacheArray = [NSMutableArray arrayWithArray:currentArray];
    }else{
        cacheArray = [NSMutableArray array];
    }
    
    [cacheArray addObject:dic];
    
    [AWUserDefaultTool save:kApp_downDataArray data:[NSArray arrayWithArray:cacheArray]];
    
    AWDownLoadFilmVC *vc = [AWDownLoadFilmVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - UICollectionViewDelegate Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item < _dataArray.count){
        //AWVideoListModel *listModel = [_dataArray objectAtIndex:indexPath.item];
        
        // CGFloat originalHeight = [listModel.title sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake((SCREEN_WIDTHL -40)/3, CGFLOAT_MAX)].height;
        CGFloat originalWidth = (SCREEN_WIDTHL - 15*6)/5;
        return CGSizeMake(originalWidth,30);
    }else{
        
        return CGSizeZero;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AWDownEpisodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AWDownEpisodeCell" forIndexPath:indexPath];
    
    if(indexPath.item < _dataArray.count){
        AWVideoDetailModel *listModel = [_dataArray objectAtIndex:indexPath.item];
        [cell.episodeBtn setTitle:listModel.name forState:UIControlStateNormal];
        
        if(listModel.isSelected){
            cell.episodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#00c6ff"].CGColor;
            [cell.episodeBtn setTitleColor:[UIColor colorWithHexString:@"#00c6ff"] forState:UIControlStateNormal];
        }else{
            cell.episodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
            [cell.episodeBtn setTitleColor:[UIColor colorWithHexString:@"#6e6f71"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item < _dataArray.count){
        
        kPreventRepeatClickTime(0.5);
        
        AWVideoDetailModel *listModel = [_dataArray objectAtIndex:indexPath.item];
       
        listModel.isSelected = YES;
        
        [_dataArray replaceObjectAtIndex:indexPath.item withObject:listModel];
        
        [_collectionView reloadData];
        
        [self getVideoPlayerUrlMethod:listModel];
        
    }
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
