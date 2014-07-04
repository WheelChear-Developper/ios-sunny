//
//  Comments_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments_ListDataModel.h"
#import "VerticallyAlignedLabel.h"

@interface Comments_ViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate, UIWebViewDelegate, UITextViewDelegate>
{
    // テーブルビュー
    IBOutlet UITableView *Table_View;
    __weak IBOutlet UILabel *lbl_commentCount;
    __weak IBOutlet UILabel *lbl_comment_hint;
    __weak IBOutlet UITextView *txt_comments;
    
    //コメント無し
    __weak IBOutlet UIView *view_notComment;
    //コメントタイトル
    __weak IBOutlet UILabel *lbl_commentTitle;
    
}
- (IBAction)btn_comments:(id)sender;
@end
