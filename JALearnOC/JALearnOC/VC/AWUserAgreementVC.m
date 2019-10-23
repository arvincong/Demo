//
//  AWUserAgreementVC.m
//  JALearnOC
//
//  Created by jason on 24/9/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWUserAgreementVC.h"

@interface AWUserAgreementVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation AWUserAgreementVC

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
    titleLabel.text = @"用户协议";
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
    
    
    _webView = [UIWebView new];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [SVProgressHUD showLoadingHUDInWindow:@"加载中..."];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user_agreement" ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    //创建NSURLRequest
    NSURLRequest* request = [NSURLRequest requestWithURL:fileURL];
    //加载
    [_webView loadRequest:request];
}



#pragma mark - UIWebViewDelegate Method
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
