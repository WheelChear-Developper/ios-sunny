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
    //データベース前処理
    [SqlManager InitialSql];
    
    // 通知のリセット
    application.applicationIconBadgeNumber = 0;
    
    // push通知呼び出し用
//    [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge|
//                                                      UIRemoteNotificationTypeSound|
//                                                      UIRemoteNotificationTypeAlert)];
    
    //トピック初期化
    [Configuration synchronize];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        // iOS7移行の設定
        //ナビゲーションのバック画像設定
        [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
        UIImage *image = [UIImage imageNamed:@"navibar_320x64.png"];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
    }else{
        // iOS7以下の設定
        //ナビゲーションのバック画像設定
        UIImage *image = [UIImage imageNamed:@"navibar_320x44.png"];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 終了処理
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 通知のリセット
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), @"/apns_devices"]]];
//    NSString *requestBody = [@"apns_device[token]=" stringByAppendingString:deviceToken];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
//    [NSURLConnection connectionWithRequest:request delegate:self];
}

// フォアグラウンドかスタンバイのプッシュ通知からの起動
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive){
        if([Configuration getPushNotifications]){
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

@end
