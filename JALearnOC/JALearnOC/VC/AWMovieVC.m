//
//  AWMovieVC.m
//  JALearnOC
//
//  Created by jason on 14/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWMovieVC.h"
#import "AWDramaCell.h"
#import "AWVideoListModel.h"
#import "AWPublicDetailVC.h"

#import "AWVideoCommandModel.h"
#import "AWVideoIntroduceVC.h"

@interface AWMovieVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSString *showCommand;

@end

@implementation AWMovieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createUIMethod];
}

#pragma mark - Custom Method
-(void)createUIMethod
{
    _dataArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = KNormalBgColor;
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.showsVerticalScrollIndicator = false;
    [_collectionView registerClass:[AWDramaCell class] forCellWithReuseIdentifier:@"AWDramaCell"];
    _collectionView.userInteractionEnabled = true;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getDramaListMethod];
        
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    _collectionView.mj_header = refreshHeader;
    
    [_collectionView.mj_header beginRefreshing];
}

#pragma mark - API
-(void)getDramaListMethod
{
    if(_dataArray){
        
        [_dataArray removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_LIST_API] parameters:@{@"type":@"yb"} success:^(id  _Nonnull responseObject) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        
        if([responseObject[@"code"] integerValue] == 0){
            
            weakSelf.showCommand = responseObject[@"data"][@"command"];
            
            NSArray *currentArray = responseObject[@"data"][@"list"];
            
            [currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                AWVideoListModel *model = [AWVideoListModel yy_modelWithJSON:obj];
                model.command = weakSelf.showCommand;
                [weakSelf.dataArray addObject:model];
            }];
            
            [weakSelf.collectionView reloadData];
            
        }else{
            
            [weakSelf.view.window makeToast:@"暂时未获取到数据"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        
        [weakSelf.view.window makeToast:@"获取视频资源失败"];
    }];
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
        
        return CGSizeMake((SCREEN_WIDTHL - 40)/3,200);
    }else{
        
        return CGSizeZero;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AWDramaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AWDramaCell" forIndexPath:indexPath];
    
    if(indexPath.item < _dataArray.count){
        AWVideoListModel *listModel = [_dataArray objectAtIndex:indexPath.item];
        
        if([listModel.command isEqualToString:@"1"]){
            cell.coverImageView.image = [UIImage imageNamed:@"ic_film_bg"];
        }else{
            [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:listModel.img] placeholderImage:[UIImage imageNamed:@"ic_film_bg"]];
        }
      
        cell.videoTitleLabel.text = listModel.title;
        
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item < _dataArray.count){
         kPreventRepeatClickTime(0.5);
        AWVideoListModel *listModel = [_dataArray objectAtIndex:indexPath.item];
        [self getVideoCommandMethod:listModel];
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
//                AWWebViewController *vc = [[AWWebViewController alloc] init];
//                vc.urlString = commandModel.url;
//                [self.navigationController pushViewController:vc animated:YES];
                
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
