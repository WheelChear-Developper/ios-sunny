//
//  Menu_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Menu_ViewController : UIViewController <UIScrollViewDelegate>
{
    // ウェーブ用インスタンス
    IBOutlet UIWebView *Web_View;
    //再接続用アラート
    UIAlertView *reconnectAlert;
}
@end
