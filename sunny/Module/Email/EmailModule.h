//
//  EmailModule.h
//  Sunny
//
//  Created by Developper_Masashi on 2013/05/16.
//  Copyright (c) 2013年 SmartTecno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EmailModule : NSObject <MFMailComposeViewControllerDelegate>

+ (void) setAlert:(NSString *) aTitle :(NSString *) aDescription;
+ (void) showComposerSheet:(MFMailComposeViewController*)mailcompose;

@end
