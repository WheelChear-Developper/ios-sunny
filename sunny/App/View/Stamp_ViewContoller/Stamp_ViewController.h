//
//  Stamp_ViewContollerViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stamp_ListDataModel.h"

@interface Stamp_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UITextViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;    
}
@end
