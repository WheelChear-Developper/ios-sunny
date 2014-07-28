//
//  Shop_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Shop_ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface Shop_ViewController ()

@end

@implementation Shop_ViewController

@synthesize map_view1;

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

    CLLocationCoordinate2D co1;
    co1.latitude = 34.070557; // 経度
    co1.longitude = 134.469068; // 緯度
    MKCoordinateRegion cr1 = map_view1.region;
    cr1.center = co1;
    cr1.span.latitudeDelta = 0.004;
    cr1.span.longitudeDelta = 0.004;
    [map_view1 setRegion:cr1 animated:YES];
    
    MyAnnotation *annotation1;
    CLLocationCoordinate2D location1;
    location1.latitude  = 34.070557;
    location1.longitude = 134.469068;
    annotation1 =[[MyAnnotation alloc] initWithCoordinate:location1];
    annotation1.title = @"Sunny";
//    annotation.subtitle = @"";
    [map_view1 addAnnotation:annotation1];
    
}

- (void)dealloc {
    map_view1 = nil;
    self.tableView = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section){
        case 1:{
            return 44;
        }
        case 2:{
            return 44;
        }
        default:{
            return 0;
            break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 320.0f, 44)];
    UIImage *headerImage = [UIImage imageNamed:@"shop_koumoku.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    headerImageView.frame = CGRectMake(10.0f, 0.0f, 300.0f, 44);
    
    UILabel *title = [[UILabel alloc] init];
    title = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 12.0f, 270.0f, 21)];
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    
    switch(section){
        case 1:{
            [headerView addSubview:headerImageView];
            title.text = @"店舗情報";
            [headerView addSubview:title];
            break;
        }
        case 2:{
            [headerView addSubview:headerImageView];
            title.text = @"スキンケア会員大募集！";
            [headerView addSubview:title];
            break;
        }
        default:{
            break;
        }
    }
    
    return headerView;
}

- (IBAction)btn_tel1:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0120642305"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_tel2:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0886261875"];
    [[UIApplication sharedApplication] openURL:phone];
}

@end

