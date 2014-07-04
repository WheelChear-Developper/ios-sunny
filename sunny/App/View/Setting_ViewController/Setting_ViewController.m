//
//  Setting_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, Inc. All rights reserved.
//

#import "Setting_ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface Setting_ViewController ()
{
    // Social
    IBOutlet UIButton *LineButton;
    IBOutlet UIButton *FacebookButton;
    IBOutlet UIButton *TwitterButton;
}
@end

@implementation Setting_ViewController

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
    
    // =========== iOSバージョンで、処理を分岐 ============
    // iOS Version
    NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([iosVersion floatValue] < 6.0) { // iOSのバージョンが6.0以上でないときは、ボタンを隠す
        // Twitter,Facebook連携はiOS6.0以降
        FacebookButton.hidden = YES;
        TwitterButton.hidden = YES;
    }
    // ===============================================
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //BackColor
    self.view.backgroundColor = [SetColor setBackGroundColor];
    
    //変更前の名前記録
    str_BackupName = [Configuration getProfileName];
}

// 画面変更時の終了メソッド
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //名前が無い場合、変更前の名前に戻す
    NSString *str_name = [Configuration getProfileName];
    NSCharacterSet *space = [NSCharacterSet whitespaceCharacterSet];
    NSString *str_ResultName = [str_name stringByTrimmingCharactersInSet:space];
    
    if([str_ResultName isEqualToString:@""]){
        [Configuration setProfileName:str_BackupName];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

//設定画面の再設定
-(void)viewWillAppear:(BOOL)animated
{
    if([Configuration getPushNotifications] == NO){
        [Sw_PushNotificationSet setOn:NO animated:NO];
    }else{
        [Sw_PushNotificationSet setOn:YES animated:NO];
    }
    
    lbl_userID.text = [@"ユーザーNo." stringByAppendingString:[Configuration getProfileID]];
    txt_userName.text = [Configuration getProfileName];
}

/////////////// ↓　入力系用メソッド　↓ ////////////////////
// テキストフィールド変更時のメソッド
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 文字数の制限
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    return ([text length] <= 10);
}

// リターンキー制御
- (BOOL)textFieldShouldReturn:(UITextField *)targetTextField {
   [targetTextField resignFirstResponder];
   return YES;
}

// テキスト入力後の処理
-(void)textFieldDidEndEditing:(UITextField*)textField
{
    // ウェーブへユーザー名設定
    NSString *URL = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_UserNameSetURL",@""), [Configuration getToken]];
    NSURL *URL_STRING = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSMutableDictionary *person = [NSMutableDictionary dictionary];
    [person setValue:textField.text forKey:@"name"];
    NSError *error = nil;
    NSData  *content = [NSJSONSerialization dataWithJSONObject:person options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:content];
    NSHTTPURLResponse   *response = nil;
    NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    // 例外エラー対策
    @try {
        content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exception) {
        // 読み込み中の表示削除
        [SVProgressHUD dismiss];
        // 名前を戻す
        txt_userName.text = [Configuration getProfileName];
        // 通信エラーメッセージ表示
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                         message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                               otherButtonTitles:nil];
        [errAlert show];
    }
   
    // 名前の設定
    [Configuration setProfileName:textField.text];
}
/////////////// ↑　入力系用メソッド　↑ ////////////////////

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing: YES];
}

- (IBAction)Sw_PushNotificationSet:(id)sender
{
    if([Configuration getPushNotifications] == NO){
        [Configuration setPushNotifications:YES];
        [Sw_PushNotificationSet setOn:YES animated:YES];
    }else{
        [Configuration setPushNotifications:NO];
        [Sw_PushNotificationSet setOn:NO animated:YES];
    }
}

// LINE
- (IBAction)postLine:(id)sender
{
    NSString *textString = NSLocalizedString(@"Twite_msg",@"");
    textString = [textString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *LINEUrlString = [NSString stringWithFormat:@"line://msg/text/%@",textString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINEUrlString]];
}
// Facebook
- (IBAction)postFacebook:(id)sender
{
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString* postContent = [NSString stringWithFormat:NSLocalizedString(@"Twite_msg",@"")];
    [facebookPostVC setInitialText:postContent];
    [self presentViewController:facebookPostVC animated:YES completion:nil];
}
// Twitter
- (IBAction)postTwitter:(id)sender
{
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:NSLocalizedString(@"Twite_msg",@"")];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}

///////////////////////// ↓　通信用メソッド　↓　//////////////////////////////
//通信開始時に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // リストデータの読み込み
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
    //初期化
    self.mData = [NSMutableData data];
}

//通信中常に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //通信したデータを入れていきます
    [self.mData appendData:data];
}

//通信終了時に呼ばれる
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    //値の取得
    id json = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *jsonParser = (NSMutableArray*)json;
    
    NSLog(@"name_update = %@",jsonParser);
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   // 読み込み中の表示削除
   [SVProgressHUD dismiss];
   // 名前を戻す
   txt_userName.text = [Configuration getProfileName];
   // 通信エラーメッセージ表示
   UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                      message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                            otherButtonTitles:nil];
   [errAlert show];
}
///////////////////////// ↑　通信用メソッド　↑　//////////////////////////////

@end
