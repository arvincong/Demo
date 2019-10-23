//
//  AWDownLoadFilmVC.m
//  JALearnOC
//
//  Created by jason on 23/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWDownLoadFilmVC.h"
#import "AWDownLoadListCell.h"
#import "AWDownloadManager.h"
#import "AWPlayLocalViedoVC.h"

@interface AWDownLoadFilmVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation AWDownLoadFilmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUIMethod];
    
    // 创建观察者
    [self addObseerverAction];
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
    titleLabel.text = @"我的下载";
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
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = KNormalBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[AWDownLoadListCell class] forCellReuseIdentifier:@"AWDownLoadListCell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];
    
    UIButton *downAllBtn = [UIButton new];
    downAllBtn.backgroundColor = KNavBgColor;
    [downAllBtn setTitle:@"全部下载" forState:UIControlStateNormal];
    [downAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:downAllBtn];
    
    [downAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTHL/2,60));
    }];
    
    __weak typeof(self) weakSelf = self;
    //全部下载
    [downAllBtn addAction:^(id  _Nonnull sender) {
        
        [weakSelf resumeAllActionMethod];
    }];
    
    
    UIButton *stopAllBtn = [UIButton new];
    stopAllBtn.backgroundColor = KNavBgColor;
    [stopAllBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
    [stopAllBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    [self.view addSubview:stopAllBtn];
    
    [stopAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTHL/2,60));
    }];
    
    //全部暂停
    [stopAllBtn addAction:^(id  _Nonnull sender) {
        
        [weakSelf suspendAllActionMethod];
    }];
    
    
    //获取缓存的下载数据，并显示
    
    _dataArray = [NSMutableArray array];
    
    [AWDownloadManager shareManager].AW_MaxTaskCount = 4;
    
    NSArray *cacheArray = [AWUserDefaultTool load:@"kApp_downDataArray"];
    if(cacheArray && [cacheArray count] > 0){
        for (NSDictionary *dic in cacheArray) {
            [[AWDownloadManager shareManager] AW_DownloadWithUrl:dic[@"downUrl"] withCustomCacheName:dic[@"downName"]];
        }
        
        [_dataArray addObjectsFromArray:[AWDownloadManager shareManager].AW_DownloadArray];
        
        [_tableView reloadData];
        
    }else{
        [self.view makeToast:@"没有可以下载的任务" duration:2 position:CSToastPositionCenter];
    }
    
}

/**
 *
 *  添加通知观察者
 */
- (void)addObseerverAction {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:AWDownloadFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:AWCancelAllSong object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:AWCancelOneSong object:nil];
}
/**
 *
 *  更新ui
 */
- (void)changeAction:(NSNotification *)info {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[AWDownloadManager shareManager].AW_DownloadArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - API  method
//取消某一集
-(void)cancelOneFilmActionMethod:(NSString *)filmUrl
{
     [[AWDownloadManager shareManager] AW_CancelWithUrl:filmUrl];
}

//暂停全部
-(void)suspendAllActionMethod
{
    [[AWDownloadManager shareManager] AW_SuspendAllRequest];
}

//暂停某一集
-(void)suspendOneFilmActionMethod:(NSString *)filmUrl
{
     [[AWDownloadManager shareManager] AW_SuspendWithUrl:filmUrl];
}

//恢复全部
-(void)resumeAllActionMethod
{
    [[AWDownloadManager shareManager] AW_ResumeAllRequest];
}


//恢复某一集
-(void)resumeOneFilmActionMethod:(NSString *)filmUrl
{
    [[AWDownloadManager shareManager] AW_ResumeWithUrl:filmUrl];
}



#pragma mark - UITableViewDelegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AWDownLoadListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AWDownLoadListCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = KNormalBgColor;
    
    __weak typeof(cell) weakCell = cell;
    
    if([_dataArray count] > indexPath.row){
        AWDownloadItem *item = self.dataArray[indexPath.row];
        cell.loadItem = item;
        
        [cell.statusBtn addAction:^(id  _Nonnull sender) {
            if(item.downloadStatus == AWDownloadStatusWaiting){
                [weakCell.statusBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self cancelOneFilmActionMethod:item.requestUrl];
                
            }else if (item.downloadStatus == AWDownloadStatusDownloading){
                [weakCell.statusBtn setTitle:@"暂停" forState:UIControlStateNormal];
                [self suspendOneFilmActionMethod:item.requestUrl];
                
            }else if (item.downloadStatus == AWDownloadStatusDownloadFinish){
                
            }else if (item.downloadStatus == AWDownloadStatusDownloadSuspend){
                [weakCell.statusBtn setTitle:@"继续" forState:UIControlStateNormal];
                [self resumeOneFilmActionMethod:item.requestUrl];
            }
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < _dataArray.count){
        
        kPreventRepeatClickTime(0.5);
        AWDownloadItem *item = self.dataArray[indexPath.row];
        AWPlayLocalViedoVC *vc = [AWPlayLocalViedoVC  new];
        vc.localVideoUrl = item.cachePath;
        vc.videoTitle = item.customCacheName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        //如果编辑样式为删除样式
        if (indexPath.row < [_dataArray count]) {
            //移除数据源的数据
            
            [_dataArray removeObjectAtIndex:indexPath.row];
            
            //移除tableView中的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        }
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";
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
