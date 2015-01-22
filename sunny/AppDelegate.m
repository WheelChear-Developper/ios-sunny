//
//  AppDelegate.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "AppDelegate.h"
#import "SqlManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //トピック初期化
    [Configuration synchronize];
    
    //データベース前処理
    [SqlManager InitialSql];
    
    // push通知呼び出し用
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"iOS %f", iOSVersion);
    if(iOSVersion >= 8.0)
    {
        // push通知呼び出し用
        UIUserNotificationType types =    UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:mySettings];
    }else{
        // push通知呼び出し用
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|
                                                          UIRemoteNotificationTypeSound|
                                                          UIRemoteNotificationTypeAlert)];
    }
    
    //バックグラウンド処理の登録
	[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //ナビゲーションのバック画像設定
    UIImage *image = [UIImage imageNamed:@"navibar_ios7.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //ステータスバーの文字色設定
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //ステータスバーの非表示から表示へ
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //起動方法振り分け
    if([Configuration getFirstStart]){
        //初期起動の場合
        UIViewController *mainViewController = (UIViewController *)self.window.rootViewController;
        UIViewController *GaidViewController = [mainViewController.storyboard instantiateViewControllerWithIdentifier:@"FirstGaidView"];
        self.window.rootViewController = GaidViewController;
        [self.window makeKeyAndVisible];
        return YES;
    }else{
        //起動View変更
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

// 終了処理
- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //ニュースプッシュ通知リセット
    [Configuration setPushNews:0];
    //通知件数セット
    NSLog(@"notication news=%ld beacon=%ld",[Configuration getPushNews],[Configuration getPushBeacon]);
    application.applicationIconBadgeNumber =  [Configuration getPushNews] + [Configuration getPushBeacon];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

// デバイストークン取得成功
- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // デバイストークンの両端の「<>」を取り除く
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    // デバイストークン中の半角スペースを除去する
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self sendProviderDeviceToken:deviceTokenString];
}

// デバイストークン取得失敗
- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError*)err
{
    NSLog(@"Error in registration: %@", err);
}

- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"didRegisterForRemoteNotificationsWithError; error: %@", err);
}

// デバイストークンの登録
- (void)sendProviderDeviceToken:(NSString *)deviceToken
{
    // デバイストークン保存(アプリ用)
    [Configuration setDeviceTokenKey:deviceToken];
    
    NSLog(@"取得デバイストークンキー＿%@",deviceToken);
    
    // デバイストークン保存(サーバー用)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), @"/apns_devices"]]];
    NSString *requestBody = [@"apns_device[token]=" stringByAppendingString:deviceToken];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// フォアグラウンドかスタンバイのプッシュ通知からの起動
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive){
        if([Configuration getPushNotificationsNews]){
            //ニュースプッシュ通知ON
            [Configuration setPushNews:1];
            //通知件数セット
            [UIApplication sharedApplication].applicationIconBadgeNumber = [Configuration getPushNews] + [Configuration getPushBeacon];
            // 通信エラーメッセージ表示
            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_SiteReupMsg",@"")
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                     otherButtonTitles:nil];
            [errAlert show];
        }
    }
}

//バックグラウンド処理
- (void)application:(UIApplication*)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //サーバー情報同期処理
    [SqlManager set_BeconLogList_serverReUp];
}

///////////////////////// ↓　通信用メソッド　↓　//////////////////////////////
//通信開始時に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    
    NSLog(@"デバイストークン登録 = %@",jsonParser);
    
    if(![[jsonParser valueForKey:@"message"] isEqualToString:@"failure"]){
        NSLog(@"ユーザー情報を取得できませんでした。"); 
    }
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

///////////////////////// ↑　通信用メソッド　↑　//////////////////////////////

@end
