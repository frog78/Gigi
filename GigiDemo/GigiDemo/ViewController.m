//
//  ViewController.m
//  GigiDemo
//
//  Created by qiliu on 2017/7/26.
//  Copyright © 2017年 qiliu. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Gigi/Gigi.h>
#import "SecondViewController.h"

//typedef WKWebView WebView;
typedef UIWebView WebView;

@interface ViewController ()

@property (nonatomic, retain) WebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"/Html5/test.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (WebView *)webView {
    if (!_webView) {
        _webView = [[WebView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:_webView atIndex:0];
    }
    return _webView;
}

- (void)onFileInputClicked {
    
    NSLog(@"xxxxxonFileInputClickedxxxxx");
    SecondViewController *svc = [[SecondViewController alloc] init];
    [self presentViewController:svc animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
