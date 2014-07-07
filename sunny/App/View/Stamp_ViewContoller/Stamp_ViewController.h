//
//  Stamp_ViewContollerViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stamp_ListDataModel.h"
#import "SqlManager.h"

@interface Stamp_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UITextViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;
    
    __weak IBOutlet UIImageView *img_stamp1;
    __weak IBOutlet UIImageView *img_stamp2;
    __weak IBOutlet UIImageView *img_stamp3;
    __weak IBOutlet UIImageView *img_stamp4;
    __weak IBOutlet UIImageView *img_stamp5;
    __weak IBOutlet UIImageView *img_stamp6;
    __weak IBOutlet UIImageView *img_stamp7;
    __weak IBOutlet UIImageView *img_stamp8;
    __weak IBOutlet UIImageView *img_stamp9;
    
}
@end
