//
//  Quest_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2013年 SmartTecno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#include <sys/utsname.h>

@interface Quest_ViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UITextView *txt_comments;
    __weak IBOutlet UILabel *lbl_comment_hint;

    IBOutlet UILabel *lbl_device;
    IBOutlet UILabel *lbl_OS;
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_ver;
}
@end
