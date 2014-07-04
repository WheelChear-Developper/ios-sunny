//
//  Setting_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface Setting_ViewController : UITableViewController
{
    IBOutlet UISwitch *Sw_PushNotificationSet;
    __weak IBOutlet UILabel *lbl_userID;
    __weak IBOutlet UITextField *txt_userName;
    
    NSString *str_BackupName;
}
- (IBAction)Sw_PushNotificationSet:(id)sender;
@property (nonatomic,retain)NSMutableData *mData;
@end
