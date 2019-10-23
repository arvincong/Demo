//
//  AWVideoIntroduceVC.m
//  JALearnOC
//
//  Created by arvin wang on 2019/9/22.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWVideoIntroduceVC.h"
#import "AWVideoCommentCell.h"

@interface AWVideoIntroduceVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation AWVideoIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUIMethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark statusbar
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Cusotm  method
-(void)createUIMethod{
    
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
    titleLabel.text = @"剧集简介";
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
     _tableView.backgroundColor = KNormalBgColor;
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.estimatedRowHeight = 150;
       _tableView.rowHeight = UITableViewAutomaticDimension;
       _tableView.estimatedSectionHeaderHeight = 0;
       _tableView.estimatedSectionFooterHeight = 0;
       _tableView.showsVerticalScrollIndicator = NO;
       _tableView.showsHorizontalScrollIndicator = NO;
       [_tableView registerClass:[AWVideoCommentCell class] forCellReuseIdentifier:@"AWVideoCommentCell"];
       _tableView.tableHeaderView = [self createTableHeaderViewMethod];
       _tableView.tableFooterView = [UIView new];
       [self.view addSubview:_tableView];
       
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(topView.mas_bottom);
              make.left.right.equalTo(self.view);
              make.bottom.equalTo(self.view.mas_bottom).offset(-60);
          }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = KNavBgColor;
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    /* 输入框
    UIView *inputBgView = [UIView new];
    inputBgView.backgroundColor = [UIColor whiteColor];
    inputBgView.userInteractionEnabled = YES;
    [bottomView addSubview:inputBgView];
    
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.right.equalTo(bottomView.mas_right).offset(-100);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(40);
    }];
     */
}

-(UIView *)createTableHeaderViewMethod{
 
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTHL,200)];
    
    UIImageView *videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 100,120)];
    videoImageView.image = [UIImage imageNamed:@"ic_film_bg"];
    [headerView addSubview:videoImageView];
    
//    [videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(headerView.mas_top).offset(10);
//        make.left.equalTo(headerView.mas_left).offset(10);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(120);
//        //make.size.mas_equalTo(CGSizeMake(100,120));
//    }];
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(videoImageView.frame) + 10, CGRectGetMinY(videoImageView.frame),SCREEN_WIDTHL - 130,130)];
    
    introduceLabel.font = [UIFont systemFontOfSize:15];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introduceLabel.numberOfLines = 0;
    introduceLabel.text = [NSString stringWithFormat:@"剧情介绍：\r\n %@",_transInfo];
    [headerView addSubview:introduceLabel];
    
//    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//         
//        make.top.equalTo(videoImageView.mas_top);
//        make.left.equalTo(videoImageView.mas_right).offset(10);
//        make.right.equalTo(headerView.mas_right).offset(-10);
//        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
//    }];
    
    CGSize size = [_transInfo sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTHL - 130,CGFLOAT_MAX)];
    
    introduceLabel.frame = CGRectMake(CGRectGetMaxX(videoImageView.frame) + 10, CGRectGetMinY(videoImageView.frame),SCREEN_WIDTHL - 130,size.height+20);
    
    if(size.height > 120){
        headerView.frame = CGRectMake(0,0,SCREEN_WIDTHL,size.height + 30);
    }else{
        headerView.frame = CGRectMake(0,0,SCREEN_WIDTHL,160);
    }
    
    return headerView;
}

#pragma mark -UITableViewDelegate Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
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
    
    AWVideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AWVideoCommentCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
    
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
