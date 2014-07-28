//
//  Configuration.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

#pragma mark - Synchronize
+ (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - DeviceTokenKey
static NSString *CONFIGURATION_PUSH_DEVICETOKENKEY = @"Configuration.DeviceTokenKey";
+ (NSString*)getDeviceTokenKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_DEVICETOKENKEY : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_DEVICETOKENKEY];
}
+ (void)setDeviceTokenKey:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_DEVICETOKENKEY];
    [userDefaults synchronize];
}

#pragma mark - Setting
static NSString *CONFIGURATION_FIRST_START = @"Configuration.FirstStart";
+ (BOOL)getFirstStart
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_FIRST_START : @(YES)}];
    return [userDefaults boolForKey:CONFIGURATION_FIRST_START];
}
+ (void)setFirstStart:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:CONFIGURATION_FIRST_START];
    [userDefaults synchronize];
}

#pragma mark - StartScreen
static NSString *CONFIGURATION_STARTSCREEN = @"Configuration.StartScreen";
+ (NSInteger)getStartScreen;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_STARTSCREEN : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_STARTSCREEN];
}
+ (void)setStartScreen:(NSInteger)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_STARTSCREEN];
    [userDefaults synchronize];
}

#pragma mark - Topic_ID
static NSString *CONFIGURATION_TOPIC_ID = @"Configuration.Topic_ID";
+ (NSInteger)getTopic_ID;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_TOPIC_ID : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_TOPIC_ID];
}
+ (void)setTopic_ID:(NSInteger)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_TOPIC_ID];
    [userDefaults synchronize];
}

#pragma mark - PushNotificationsNews
static NSString *CONFIGURATION_PUSH_NOTIFICATIONSNEWS = @"Configuration.PushNotificationsNews";
+ (BOOL)getPushNotificationsNews
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_NOTIFICATIONSNEWS : @(YES)}];
    return [userDefaults boolForKey:CONFIGURATION_PUSH_NOTIFICATIONSNEWS];
}
+ (void)setPushNotificationsNews:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:CONFIGURATION_PUSH_NOTIFICATIONSNEWS];
    [userDefaults synchronize];
}

#pragma mark - PushNotificationsBeacon
static NSString *CONFIGURATION_PUSH_NOTIFICATIONSBEACON = @"Configuration.PushNotificationsBeacon";
+ (BOOL)getPushNotificationsBeacon
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_NOTIFICATIONSBEACON : @(YES)}];
    return [userDefaults boolForKey:CONFIGURATION_PUSH_NOTIFICATIONSBEACON];
}
+ (void)setPushNotificationsBeacon:(BOOL)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:CONFIGURATION_PUSH_NOTIFICATIONSBEACON];
    [userDefaults synchronize];
}

#pragma mark - WebURL
static NSString *CONFIGURATION_PUSH_WEBURL = @"Configuration.WebURL";
+ (NSString*)getWebURL
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_WEBURL : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_WEBURL];
}
+ (void)setWebURL:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_WEBURL];
    [userDefaults synchronize];
}

#pragma mark - ProfileID
static NSString *CONFIGURATION_PUSH_PROFILEID = @"Configuration.ProfileID";
+ (NSString*)getProfileID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_PROFILEID : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_PROFILEID];
}
+ (void)setProfileID:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_PROFILEID];
    [userDefaults synchronize];
}

#pragma mark - ProfileName
static NSString *CONFIGURATION_PUSH_PROFILENAME = @"Configuration.ProfileName";
+ (NSString*)getProfileName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_PROFILENAME : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_PROFILENAME];
}
+ (void)setProfileName:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_PROFILENAME];
    [userDefaults synchronize];
}

#pragma mark - Token
static NSString *CONFIGURATION_PUSH_TOKEN = @"Configuration.Token";
+ (NSString*)getToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSH_TOKEN : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_PUSH_TOKEN];
}
+ (void)setToken:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_PUSH_TOKEN];
    [userDefaults synchronize];
}

#pragma mark - NewsID
static NSString *CONFIGURATION_NEWSID = @"Configuration.NewsID";
+ (long)getNewsID;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_NEWSID : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_NEWSID];
}
+ (void)setNewsID:(long)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_NEWSID];
    [userDefaults synchronize];
}

#pragma mark - NewsTitle
static NSString *CONFIGURATION_NEWSTITLE = @"Configuration.NewsTitle";
+ (NSString*)getNewsTitle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_NEWSTITLE : @("")}];
    return [userDefaults stringForKey:CONFIGURATION_NEWSTITLE];
}
+ (void)setNewsTitle:(NSString*)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:CONFIGURATION_NEWSTITLE];
    [userDefaults synchronize];
}

#pragma mark - PushNews
static NSString *CONFIGURATION_PUSHNEWS= @"Configuration.PushNews";
+ (long)getPushNews;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSHNEWS : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_PUSHNEWS];
}
+ (void)setPushNews:(long)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_PUSHNEWS];
    [userDefaults synchronize];
}

#pragma mark - PushBeacon
static NSString *CONFIGURATION_PUSHBEACON = @"Configuration.PushBeacon";
+ (long)getPushBeacon;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{CONFIGURATION_PUSHBEACON : @(0)}];
    return [userDefaults integerForKey:CONFIGURATION_PUSHBEACON];
}
+ (void)setPushBeacon:(long)value
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:CONFIGURATION_PUSHBEACON];
    [userDefaults synchronize];
}

@end
