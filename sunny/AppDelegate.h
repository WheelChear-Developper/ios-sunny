//
//  AppDelegate.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // ナビゲーションコントローラー制御用
    UINavigationController *naviController;
    //    UIAlertView *errAlert_exit;
}
@property (strong, nonatomic) UIWindow *window;
@end
