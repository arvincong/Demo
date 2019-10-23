//
//  AWWebViewController.m
//  JALearnOC
//
//  Created by jason on 12/8/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "AWWebViewController.h"
#import <WebKit/WebKit.h>

@interface AWWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *wkWebView;  //  WKWebView
@property (nonatomic,strong) MJRefreshNormalHeader *refreshControl;  //刷新
@property (nonatomic,strong) UIProgressView *progress;  //进度条
@property (nonatomic,strong) UIButton *reloadBtn;  //重新加载按钮

@property (nonatomic,strong)  UIView *navBgView;
@property (nonatomic, strong) UIButton *backBarButton;   //返回按钮
@property (nonatomic, strong) UIButton *closeBarButton;  //关闭按钮

@end

@implementation AWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KNormalBgColor;
    [self showLeftBarButtonItem];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.reloadBtn];
    
    [self loadRequest];
}


#pragma mark lazy load
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        // 设置WKWebView基本配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.selectionGranularity = YES;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"jsCallOC"];
        
        if (self.jsString) {
            WKUserScript *jsString = [[WKUserScript alloc] initWithSource:self.jsString injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
            [userContentController addUserScript:jsString];
        }
        configuration.userContentController = userContentController;
        
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,Height_TopBar,SCREEN_WIDTHL, SCREEN_HEIGHTL-Height_TopBar) configuration:configuration];
        _wkWebView.backgroundColor = KNormalBgColor;
        // 设置代理
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 是否开启下拉刷新
        if (_canDownRefresh) {
             _wkWebView.scrollView.mj_header = self.refreshControl;
        }
        // 添加进度监听
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
        
    }
    return _wkWebView;
}

- (MJRefreshNormalHeader *)refreshControl{
    if (!_refreshControl) {
        self.refreshControl = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(wkWebViewReload)];
        _refreshControl.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshControl;
}

- (UIProgressView* )progress {
    if (!_progress) {
        self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0,Height_TopBar, self.view.bounds.size.width, 2)];
        _progress.progressTintColor = _loadingProgressColor?_loadingProgressColor:[UIColor greenColor];
    }
    return _progress;
}

- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        self.reloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _reloadBtn.frame = CGRectMake(0, 0, 200, 140);
        _reloadBtn.center = self.view.center;
        [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"loadingError"] forState:UIControlStateNormal];
        [_reloadBtn setTitle:@"网络异常，点击重新加载" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventTouchUpInside)];
        [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadBtn.titleLabel.numberOfLines = 0;
        _reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadBtn.frame;
        rect.origin.y -= 100;
        _reloadBtn.frame = rect;
        _reloadBtn.hidden = YES;
    }
    return _reloadBtn;
}

- (UIButton *)backBarButton {
    if (!_backBarButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,(Height_TopBar -36)/2,44,44)];
        [button setImage:[UIImage imageNamed:@"ic_nav_bg"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _backBarButton = button;
    }
    return _backBarButton;
}

- (UIButton *)closeBarButton {
    if (!_closeBarButton) {
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(CGRectGetMaxX(self.backBarButton.frame)+10,CGRectGetMinY(self.backBarButton.frame),44,44);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        
        _closeBarButton = button;
        
    }
    return _closeBarButton;
}

#pragma mark - Custom Method
- (void)loadRequest {
    if (![self.urlString hasPrefix:@"http"]) {//容错处理 不要忘记plist文件中设置http可访问 App Transport Security Settings
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
    [_wkWebView loadRequest:request];
}

- (void)wkWebViewReload{
    [_wkWebView reload];
}

- (void)showLeftBarButtonItem {
    
    _navBgView = [UIView new];
    _navBgView.backgroundColor = KNavBgColor;
    _navBgView.userInteractionEnabled = YES;
    [self.view addSubview:_navBgView];
    
    [_navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(Height_TopBar);
    }];
    
    if ([_wkWebView canGoBack]) {
        
        [_navBgView addSubview:self.backBarButton];
        [_navBgView addSubview:self.closeBarButton];
        
    } else {
        
      [_navBgView addSubview:self.backBarButton];
    }
}
#pragma mark 导航按钮
- (void)back:(id)sender {
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progress.progress = [change[@"new"] floatValue];
        if (_progress.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_progress.hidden = YES;
            });
        }
    }
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progress.hidden = NO;
    _wkWebView.hidden = NO;
    _reloadBtn.hidden = YES;
    // 看是否加载空网页
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //执行JS方法获取导航栏标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
}

// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    webView.hidden = YES;
    _reloadBtn.hidden = NO;
}

#pragma mark UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    
}

#pragma mark WKScriptMessageHandler js 拦截 调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    //    // 方法名
    //    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    //    SEL selector = NSSelectorFromString(methods);
    //    // 调用方法
    //    if ([self respondsToSelector:selector]) {
    //        [self performSelector:selector withObject:message.body];
    //    } else {
    //        NSLog(@"未实行方法：%@", methods);
    //    }
    
    if([message.name isEqualToString:@"jsCallOc"]){
        // do something
    }
}
#pragma mark Dealloc
- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView stopLoading];
    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
