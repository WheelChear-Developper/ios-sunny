//
//  Main_UITabBarController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News_ViewController.h"
#import "Beacon_LogListDataModel.h"
#import "SqlManager.h"

@interface Main_UITabBarController : UITabBarController <UITabBarControllerDelegate>
{
    UITabBarController *_rootController;
}
#pragma mark - property
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain)NSMutableData *mData;
@end
