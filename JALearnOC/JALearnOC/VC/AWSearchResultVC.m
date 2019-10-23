//
//  AWSearchResultVC.m
//  JALearnOC
//
//  Created by jason on 13/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWSearchResultVC.h"
#import "AWDramaCell.h"
#import "AWVideoListModel.h"
#import "AWPublicDetailVC.h"

#import "AWVideoCommandModel.h"
#import "AWVideoIntroduceVC.h"

@interface AWSearchResultVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UISearchBar *_searchBar;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSString *showCommand;

@end

@implementation AWSearchResultVC


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

#pragma mark - Custom Method
-(void)createUIMethod
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
    
    
    _searchBar = [UISearchBar new];
    _searchBar.barTintColor = KNavBgColor;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索动漫或美剧";
    [topView addSubview:_searchBar];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.mas_right);
        make.right.equalTo(topView.mas_right).offset(-10);
        if(KFullScreen){
            make.centerY.equalTo(topView.mas_centerY).offset(15);
        }else{
            make.centerY.equalTo(topView.mas_centerY).offset(8);
        }
        make.height.mas_equalTo(40);
    }];
    
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
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
    }];
    
}

#pragma mark - API
-(void)getSearchVideoMethod:(NSString *)searchWords
{
    if(_dataArray){
        
        [_dataArray removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showLoadingHUDInWindow:@"搜索中..."];
    [[AWNetworkManager sharedInstance] getWithURLString:[NSString stringWithFormat:@"%@%@",MLGB_API_URL,VIDEO_SEARCH_API] parameters:@{@"wd":searchWords,@"type":_searchType} success:^(id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        [self.view.window makeToast:@"获取视频资源失败"];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if(!searchBar.text.length){
        [self.view makeToast:@"请输入搜索内容"];
    }else{
        [self getSearchVideoMethod:searchBar.text];
    }
    
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
        
        [self.view endEditing:YES];
        
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


- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.view endEditing:YES];
    
    [_searchBar resignFirstResponder];
}

#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
