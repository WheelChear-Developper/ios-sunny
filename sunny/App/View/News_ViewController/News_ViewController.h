//
//  News_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsView_ListDataModel.h"
#import "VerticallyAlignedLabel.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SqlManager.h"

@interface News_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIWebViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;
}
@end
