//
//  AWPlayerListVC.m
//  JALearnOC
//
//  Created by jason on 8/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWPlayerListVC.h"
#import "AWPlayerListCell.h"
#import "AWVideoModel.h"
#import "AWVideoListModel.h"
#import "AWPublicDetailVC.h"

#import "AWVideoCommandModel.h"
#import "AWVideoIntroduceVC.h"

@interface AWPlayerListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSString *showCommand;

@end

@implementation AWPlayerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUIMethod];
    
}

#pragma mark - Custom Method
-(void)createUIMethod
{
 
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = KNormalBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 150;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[AWPlayerListCell class] forCellReuseIdentifier:@"AWPlayerListCell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
       [weakSelf getVideoListMethod];
        
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = refreshHeader;
    
    [_tableView.mj_header beginRefreshing];
    
//    //获取数据
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
//
//    _dataArray = [NSArray yy_modelArrayWithClass:[AWVideoModel class] json:json];
//
//    [_tableView reloadData];
}

-(void)changeVideoListContentViewMethod:(BOOL)status index:(NSIndexPath *)indexPath
{
    AWVideoListModel *model = [_dataArray objectAtIndex:indexPath.section];
    model.isOpen = !status;
    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
    [self getVideoDetailMethod:indexPath];
   
}

#pragma mark - GET API
-(void)getVideoListMethod
{
    if(_dataArray){
     
        [_dataArray removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_LIST_API] parameters:@{@"type":@"bm"} success:^(id  _Nonnull responseObject) {
        
           [weakSelf.tableView.mj_header endRefreshing];
        
        if([responseObject[@"code"] integerValue] == 0){
         
            weakSelf.showCommand = responseObject[@"data"][@"command"];
            
            NSArray *currentArray = responseObject[@"data"][@"list"];
            [currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                AWVideoListModel *model = [AWVideoListModel yy_modelWithJSON:obj];
                model.command = weakSelf.showCommand;
                [weakSelf.dataArray addObject:model];
            
            }];
            
            [weakSelf.tableView reloadData];
            
        }else{
            
           [weakSelf.view.window makeToast:@"暂时未获取到数据"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
}

//获取视频详情
-(void)getVideoDetailMethod:(NSIndexPath *)indexPath
{
    [SVProgressHUD showLoadingHUDInWindow:@"加载中..."];
    
    AWVideoListModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    __weak typeof(self) weakSelf = self;
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_DETAIL_API] parameters:@{@"url":model.url} success:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        
        if([responseObject[@"code"] integerValue] == 0){
            model.detailArray = [NSArray yy_modelArrayWithClass:[AWVideoDetailModel class] json:responseObject[@"data"][@"list"]];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
            
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
             });
            
        }else{
            model.isOpen = NO;
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
             [weakSelf.view.window makeToast:@"暂时未获取到剧集列表"];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
    
}

#pragma mark - UITableViewDelegate Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return [_dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [_dataArray count]){
        AWVideoListModel *model = [_dataArray objectAtIndex:indexPath.section];
        
        if(model.isOpen){
            
            NSInteger count = [model.series getNumberMethod];
            
            CGFloat originalHeight = (count / 5 + 1) *45;
            
            return originalHeight + 160;
            
        }else{
            return 160;
        }
    }else{
        return CGFLOAT_MIN;
    }
//    AWVideoModel *model = [_dataArray objectAtIndex:indexPath.section];
//
//    NSArray *currentArray = model.url_list;
//
//    NSInteger count = [currentArray count];
//
//    CGFloat originalHeight = (count / 5 + 1) *45;
//
//    return originalHeight + 40;
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
   __block AWPlayerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AWPlayerListCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = KNormalBgColor;
    
    if([_dataArray count] > indexPath.section){
     
       __block AWVideoListModel *model = [_dataArray objectAtIndex:indexPath.section];
        
        if([model.command isEqualToString:@"1"]){
            cell.videoImageView.image = [UIImage imageNamed:@"ic_film_bg"];
        }else{
              [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"ic_film_bg"]];
        }
        
        
        cell.videoTitleLabel.text = model.title;
        
        NSString *introduceStr = [NSString stringWithFormat:@"%@",model.series];
        
        CGFloat originalWidth = [introduceStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(CGFLOAT_MAX,20)].width;

        [cell.videoListBtn setTitle:introduceStr forState:UIControlStateNormal];
        
            
        [cell.videoListBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(originalWidth + 25,30));
            }];
       
        /* 显示
        [cell.videoListBtn addAction:^(id  _Nonnull sender) {
             //查看剧集
            if(model.isOpen){
                if([model.detailArray count] > 0){
                    model.isOpen = NO;
                    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else{
                     [self changeVideoListContentViewMethod:model.isOpen index:indexPath];
                }
            }else{
                if([model.detailArray count] > 0){
                    model.isOpen = YES;
                    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else{
                     [self changeVideoListContentViewMethod:model.isOpen index:indexPath];
                }
            }
            
        }];
         */
        
        //有无数据都重载数据
         [cell fillVideoContentViewMethod:model withOriginalVC:self];
        
        if(model.isOpen){
            cell.videoContentView.hidden = NO;
        }else{
            cell.videoContentView.hidden = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if(indexPath.section < _dataArray.count){
        
        kPreventRepeatClickTime(0.5);
    
        AWVideoListModel *model = [_dataArray objectAtIndex:indexPath.section];
        [self getVideoCommandMethod:model];
    }
}


#pragma mark - 获取command
-(void)getVideoCommandMethod:(AWVideoListModel *)transModel
{
    __weak typeof(self) weakSelf = self;
    
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_DETAIL_API] parameters:@{@"url":transModel.url} success:^(id  _Nonnull responseObject) {
        
        if([responseObject[@"code"] integerValue] == 0){
            
            AWVideoCommandModel *commandModel = [AWVideoCommandModel yy_modelWithJSON:responseObject[@"data"]];
            
            if([commandModel.command isEqualToString:@"1"]){
                /* 修改
                AXWebViewController *vc = [[AXWebViewController alloc] initWithURL:[NSURL URLWithString:commandModel.url]];
                vc.showsToolBar = YES;
                vc.navigationController.navigationBar.translucent = NO;
                vc.navigationType = AXWebViewControllerNavigationToolItem;
                [self.navigationController pushViewController:vc animated:YES];
                 */
                /* 调整web 播放
                AWWebViewController *vc = [[AWWebViewController alloc] init];
                vc.urlString = commandModel.url;
                [self.navigationController pushViewController:vc animated:YES];
                 */
                AWVideoIntroduceVC *vc = [[AWVideoIntroduceVC alloc] init];
                vc.transInfo = commandModel.content;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                AWPublicDetailVC *vc = [AWPublicDetailVC new];
                vc.receivePlayerModel = transModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            
             [weakSelf.view.window makeToast:@"获取视频资源失败"];
        }
    } failure:^(NSError * _Nonnull error) {
        
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
    
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
