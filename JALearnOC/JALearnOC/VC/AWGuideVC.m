//
//  AWGuideVC.m
//  JALearnOC
//
//  Created by jason on 24/9/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWGuideVC.h"
#import "AWVideoHomeVC.h"
#import "AppDelegate.h"
#import "AWUserAgreementVC.h"
#import "AWWebViewController.h"

@interface AWGuideVC ()

@property(nonatomic,strong)NSMutableArray *recordArray;
@end

@implementation AWGuideVC

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
-(void)createUIMethod{
    
    UIView *topView = [UIView new];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = KNavBgColor;
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(Height_TopBar);
    }];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"频道选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(40);
        make.right.equalTo(topView.mas_right).offset(-40);
        if(KFullScreen){
            make.centerY.equalTo(topView.mas_centerY).offset(15);
        }else{
            make.centerY.equalTo(topView.mas_centerY).offset(8);
        }
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *introduceLabel = [UILabel new];
    introduceLabel.text = @"请选择您喜欢的频道";
    introduceLabel.font = [UIFont systemFontOfSize:17];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:introduceLabel];
    
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom).offset(60);
        make.height.mas_equalTo(20);
    }];
    
    //创建频道选择
    NSArray *channelArray = @[@"动漫",@"美剧",@"电影"];
    
    _recordArray = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat originalX = (SCREEN_WIDTHL - 70 * [channelArray count])/4;
    
    UIButton *lastBtn;
    
    for (NSString *titleStr  in channelArray) {
        
        UIButton *currentBtn = [UIButton new];
        currentBtn.layer.masksToBounds = YES;
        currentBtn.layer.cornerRadius = 4;
        currentBtn.layer.borderWidth = 1;
        currentBtn.layer.borderColor = [UIColor colorWithHexString:@"#6e6f71"].CGColor;
        currentBtn.backgroundColor = [UIColor clearColor];
        [currentBtn setTitle:titleStr forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        currentBtn.selected = NO;
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.view addSubview:currentBtn];
        
        //按钮响应方法
        [currentBtn addAction:^(id  _Nonnull sender) {
            
            [weakSelf dealChooseChannelMethod:(UIButton *)sender];
        }];
        
        
        
        
        [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              
            if(lastBtn){
                make.left.equalTo(lastBtn.mas_right).offset(originalX);
            }else{
                make.left.equalTo(self.view.mas_left).offset(originalX);
            }
            
            make.top.equalTo(introduceLabel.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(70,40));
            
        }];
        
        lastBtn = currentBtn;
    
    }
    
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.text = @"提示：您选择的频道中包含第三方内容源的文章，来源明细详见下方条款。";
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.textColor = [UIColor colorWithHexString:@"#ff6229"];
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:noticeLabel];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(originalX);
        make.top.equalTo(lastBtn.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-originalX);
    }];
    
    //创建底部协议
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = KNavBgColor;
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    
    UIButton *sureBtn = [UIButton new];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#ff344b"];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(15);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTHL,50));
    }];
    
    [sureBtn addAction:^(id  _Nonnull sender) {
        
        [weakSelf suerChoooseMethod];
    }];
    
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.text = @"点击按钮即视为同意";
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureBtn.mas_left).offset(35);
        make.top.equalTo(sureBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *loanAgreementLabel = [UILabel new];
    loanAgreementLabel.text = @"《 Dark Phoenix 第三方内容条款 》";
    loanAgreementLabel.font = [UIFont systemFontOfSize:12];
    loanAgreementLabel.textColor = [UIColor colorWithHexString:@"#ff6229"];
    [bottomView addSubview:loanAgreementLabel];
    
    [loanAgreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLabel.mas_right).offset(5);
        make.top.equalTo(infoLabel.mas_top);
        make.height.mas_equalTo(15);
    }];
    
    //查看用户协议
    [loanAgreementLabel addAction:^(id  _Nonnull sender) {
        
       AWUserAgreementVC *vc = [AWUserAgreementVC new];
        
        //AWWebViewController *vc = [AWWebViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

//处理相关选择
-(void)dealChooseChannelMethod:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if(btn.selected){
        btn.backgroundColor = [UIColor colorWithHexString:@"#ff344b"];
        if([_recordArray containsObject:btn.currentTitle]){
        
        }else{
           [_recordArray addObject:btn.currentTitle];
        }
    }else{
        btn.backgroundColor = [UIColor clearColor];
        
        if([_recordArray containsObject:btn.currentTitle]){
            [_recordArray removeObject:btn.currentTitle];
        }
    }
}

//确认筛选项
-(void)suerChoooseMethod{
    
    if([_recordArray count] > 0){
        [AWUserDefaultTool save:@"RECORD_CHANNEL" data:[NSArray arrayWithArray:_recordArray]];
        
        AWVideoHomeVC *vc = [[AWVideoHomeVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [AppDelegate shareDelegate].window.rootViewController = nav;
        
    }else{
        [self.view.window makeToast:@"请您选择喜欢的频道"];
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
