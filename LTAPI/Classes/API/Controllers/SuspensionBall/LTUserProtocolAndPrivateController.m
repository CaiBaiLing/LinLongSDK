//
//  LTUserProtocolAndPrivateController.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/8.
//

#import "LTUserProtocolAndPrivateController.h"
#import <WebKit/WebKit.h>
#import "PrefixHeader.h"
#import "Masonry.h"
API_AVAILABLE(ios(8.0))
@interface LTUserProtocolAndPrivateController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)WKWebViewConfiguration *webConfig;

@end

@implementation LTUserProtocolAndPrivateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.isHidenTitle?YES:NO animated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (!self.isHidenTitle && self.title.length <= 0) {
        self.title = webView.title;
    }
}

- (void)setLocalURL:(NSString *)localURL {
    _localURL = localURL;
    NSURL *url = [NSURL fileURLWithPath:_localURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5]];
}

- (void)setWebURL:(NSString *)webURL {
    _webURL = webURL;
    NSURL *url = [NSURL URLWithString:webURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5]];
}

- (WKWebView *)webView  API_AVAILABLE(ios(8.0)){
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfig  API_AVAILABLE(ios(8.0)) {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
    }
    return _webConfig;
}

@end
