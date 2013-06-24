//
//  ViewController.m
//  sunny
//
//  Created by ka on 13/06/24.
//  Copyright (c) 2013年 akafune, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // create WebView
    webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    // generate a request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sunny.akafune.com"]];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
