//
//  AppDelegate.m
//  sunny
//
//  Created by ka on 13/06/24.
//  Copyright (c) 2013年 akafune, Inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSLog(@"applicationDidFinishLaunching");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken {
    NSMutableString *tokenId = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",devToken]];
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@" " withString:@""]]; //余計な文字を消す
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@"<" withString:@""]];
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@">" withString:@""]];

    NSString *deviceToken = tokenId;
    [self sendProviderDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err {
    NSLog(@"Error in registration: %@", err);
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"didRegisterForRemoteNotificationsWithError; error: %@", err);
}

- (void)sendProviderDeviceToken:(NSString *)token {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://sunny.akafune.com/apns_devices"]];

    NSString *requestBody = [@"apns_device[token]=" stringByAppendingString:token];

    [request setHTTPMethod:@"POST"];

    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

    if (connection) {
        // start loading
    }
}

// プッシュ通知を受信した際の処理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
#if !TARGET_IPHONE_SIMULATOR
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSString *badge = [apsInfo objectForKey:@"badge"];
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
#endif
}
@end
