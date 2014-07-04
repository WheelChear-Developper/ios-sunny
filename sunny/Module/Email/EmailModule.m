//
//  EmailModule.m
//  Sunny
//
//  Created by Developper_Masashi on 2013/05/16.
//  Copyright (c) 2013年 SmartTecno. All rights reserved.
//

#import "EmailModule.h"

@implementation EmailModule

#pragma mark アラート表示
+ (void) setAlert:(NSString *) aTitle :(NSString *) aDescription {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle message:aDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+ (void) showComposerSheet:(MFMailComposeViewController*)mailcompose
{
    //各設定（設定しない場合空欄となるだけです）
	//メール本文の設定
	[mailcompose setMessageBody:[NSString stringWithFormat:@"お問い合わせ内容を通知します。\n"] isHTML:NO];
	//題名の設定
	[mailcompose setSubject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]]];
	//宛先の設定
	[mailcompose setToRecipients:nil];
    //色を変更
    [[mailcompose navigationBar] setTintColor:[UIColor brownColor]];
}

@end
