//
//  Web_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "Web_ViewController.h"
#import "SVProgressHUD.h"

@interface Web_ViewController ()
{
    // 戻るボタンインスタンス
    UIButton *Left_Button;
    // 読み込み中フラグ
    BOOL bln_download;
}
@end

@implementation Web_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 戻るボタン設定
    Left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Left_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [Left_Button setTitle:NSLocalizedString(@"Button_Back",@"") forState:UIControlStateNormal];
    [Left_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Left_Button addTarget:self action:@selector(btn_Return:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Left_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Left_Button];
    self.navigationItem.leftBarButtonItem = Left_buttonItem;
    
    //BackColor
    Web_View.backgroundColor = [SetColor setRollUpBackGroundColor];
    // webview用スクロールデリゲート追加
    Web_View.scrollView.delegate = self;
    
    // スナップアクション再読み込みフラグ
    bln_download = YES;
    
    // 本体データ取得
    Web_View.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:[Configuration getWebURL]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [Web_View loadRequest:req];
}

// 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// 画面の表示の時に起動するメソッド
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc {
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [Web_View setDelegate:nil];
    [Web_View stopLoading];
    Web_View =nil;
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // 読み込み中の表示
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    bln_download = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Errcode_%ld",(long)error.code);
    if(!error.code == NSURLErrorCancelled){
        // 読み込み中の表示削除
        [SVProgressHUD dismiss];
        bln_download = NO;
        // 通信エラーメッセージ表示
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                           message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                 otherButtonTitles:nil];
        [errAlert show];
    }
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat positionY = Web_View.scrollView.contentOffset.y;
    NSLog(@"%.1f",positionY);
    
    // 一番下までスクロールしたかどうか
    if(positionY < -100){
        if(bln_download == NO){
            bln_download = YES;
            [Web_View reload];
        }
    }
}

-(void)btn_Return:(id)sender
{
    if([Web_View canGoBack]){
        // ページを戻す
        [Web_View goBack];
    }else{
        Web_View.scrollView.delegate = nil;
        Web_View.delegate = nil;
        [Web_View stopLoading];
        [Web_View removeFromSuperview];
        
        // 戻るボタンの無効化
        Left_Button.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
