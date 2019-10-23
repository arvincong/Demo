//
//  AWHistoryWatchVC.m
//  JALearnOC
//
//  Created by jason on 14/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWHistoryWatchVC.h"
#import "AWHistoryListCell.h"
#import "AWVideoListModel.h"
#import "AWPublicDetailVC.h"

@interface AWHistoryWatchVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *urlArray;

@end

@implementation AWHistoryWatchVC

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
    
    UIButton *cleanBtn = [UIButton new];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cleanBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [topView addSubview:cleanBtn];
    
    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(KFullScreen){
            make.centerY.equalTo(topView.mas_centerY).offset(15);
        }else{
            make.centerY.equalTo(topView.mas_centerY).offset(8);
        }
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(topView.mas_right).offset(-20);
    }];
    
    [cleanBtn addAction:^(id  _Nonnull sender) {
        
        [self clearAllHistoryMethod];
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我的足迹";
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
    [_tableView registerClass:[AWHistoryListCell class] forCellReuseIdentifier:@"AWHistoryListCell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //获取缓存数据
    _dataArray = [NSMutableArray array];
    _urlArray = [NSMutableArray array];
    
    NSArray *currentArray = [AWUserDefaultTool load:kApp_browseRecord];
    [_dataArray addObjectsFromArray:currentArray];
    
    [_urlArray addObjectsFromArray:[AWUserDefaultTool load:kApp_playUrl]];
    
    if([_dataArray count] > 0){
        [_tableView reloadData];
    }else{
        [self.view makeToast:@"还没有观看记录"];
    }
    
}

//清空浏览记录
-(void)clearAllHistoryMethod
{
    __weak typeof(self) weakSelf = self;
    
    if(_dataArray.count > 0){
       
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要清除浏览记录嘛？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AWUserDefaultTool deleteKeyData:kApp_browseRecord];
            [AWUserDefaultTool deleteKeyData:kApp_playUrl];
            
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.urlArray removeAllObjects];
            [weakSelf.tableView reloadData];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
      
          [self.view makeToast:@"还没有观看记录"];
    }

}
    

#pragma mark - UITableViewDelegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
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
    AWHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AWHistoryListCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = KNormalBgColor;
    
    if([_dataArray count] > indexPath.row){
        
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        
       // [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"ic_film_bg"]];
        cell.videoImageView.image = [UIImage imageNamed:@"ic_film_bg"];
        
        cell.videoTitleLabel.text = dic[@"title"];
        
        cell.videoRecordLabel.text = [NSString stringWithFormat:@"上次观看到%@",dic[@"episode"]];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < _dataArray.count){
        
        kPreventRepeatClickTime(0.5);
        
        AWVideoListModel *model = [AWVideoListModel new];
        NSDictionary *dic =  [_dataArray objectAtIndex:indexPath.row];
        model.url = dic[@"url"];
        model.title = dic[@"title"];
        model.img = dic[@"img"];
        model.episode = dic[@"episode"];
        AWPublicDetailVC *vc = [AWPublicDetailVC new];
        vc.receivePlayerModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TRUE;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        //如果编辑样式为删除样式
        if (indexPath.row<[_dataArray count]) {
            //移除数据源的数据
            
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_urlArray removeObjectAtIndex:indexPath.row];
            
            [AWUserDefaultTool save:kApp_playUrl data:[NSArray arrayWithObject:_urlArray]];
            
            [AWUserDefaultTool save:kApp_browseRecord data:[NSArray arrayWithArray:_dataArray]];
            
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

