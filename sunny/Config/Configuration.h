//
//  Configuration.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

#pragma mark - Synchronize
+ (void)synchronize;

#pragma mark - DeviceTokenKey
+ (NSString*)getDeviceTokenKey;
+ (void)setDeviceTokenKey:(NSString*)value;

#pragma mark - FIRST_START
+ (BOOL)getFirstStart;
+ (void)setFirstStart:(BOOL)value;

#pragma mark - StartoScreen
+ (NSInteger)getStartScreen;
+ (void)setStartScreen:(NSInteger)value;

#pragma mark - Topic_ID
+ (NSInteger)getTopic_ID;
+ (void)setTopic_ID:(NSInteger)value;

#pragma mark - PushNotifications
+ (BOOL)getPushNotifications;
+ (void)setPushNotifications:(BOOL)value;

#pragma mark - WebURL
+ (NSString*)getWebURL;
+ (void)setWebURL:(NSString*)value;

#pragma mark - ProfileID
+ (NSString*)getProfileID;
+ (void)setProfileID:(NSString*)value;

#pragma mark - ProfileName
+ (NSString*)getProfileName;
+ (void)setProfileName:(NSString*)value;

#pragma mark - Token
+ (NSString*)getToken;
+ (void)setToken:(NSString*)value;

#pragma mark - NewsID
+ (long)getNewsID;
+ (void)setNewsID:(long)value;

#pragma mark - NewsTitle
+ (NSString*)getNewsTitle;
+ (void)setNewsTitle:(NSString*)value;

@end
