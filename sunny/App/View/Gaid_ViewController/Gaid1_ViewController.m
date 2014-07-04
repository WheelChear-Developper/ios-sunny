//
//  Gaid1_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "Gaid1_ViewController.h"

@interface Gaid1_ViewController ()

@end

@implementation Gaid1_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //BackColor
    self.view.backgroundColor = [SetColor setBackGroundColor];
    
    // 戻るボタン設定
    UIButton *Left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Left_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [Left_Button setTitle:NSLocalizedString(@"Button_Back",@"") forState:UIControlStateNormal];
    [Left_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Left_Button addTarget:self action:@selector(btn_Return:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Left_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Left_Button];
    self.navigationItem.leftBarButtonItem = Left_buttonItem;
    // 進むボタン設定
    UIButton *Right_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Right_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [Right_Button setTitle:NSLocalizedString(@"Button_Next",@"") forState:UIControlStateNormal];
    [Right_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Right_Button addTarget:self action:@selector(btn_Next:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Right_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Right_Button];
    self.navigationItem.rightBarButtonItem = Right_buttonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//設定画面の再設定
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)btn_Return:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_Next:(id)sender
{
    UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Gaid2_ViewController"];
    [self.navigationController pushViewController:viewController animated:YES ];
}

@end

