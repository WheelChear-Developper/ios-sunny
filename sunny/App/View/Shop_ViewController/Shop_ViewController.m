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
@synthesize map_view2;
@synthesize map_view3;

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
    co1.latitude = 34.085927; // 経度
    co1.longitude = 134.500087; // 緯度
    MKCoordinateRegion cr1 = map_view1.region;
    cr1.center = co1;
    cr1.span.latitudeDelta = 0.004;
    cr1.span.longitudeDelta = 0.004;
    [map_view1 setRegion:cr1 animated:YES];
    
    MyAnnotation *annotation1;
    CLLocationCoordinate2D location1;
    location1.latitude  = 34.085927;
    location1.longitude = 134.500087;
    annotation1 =[[MyAnnotation alloc] initWithCoordinate:location1];
    annotation1.title = @"fiore(フィオーレ本店)";
//    annotation.subtitle = @"";
    [map_view1 addAnnotation:annotation1];
    
    CLLocationCoordinate2D co2;
    co2.latitude = 34.069648; // 経度
    co2.longitude = 134.579328; // 緯度
    MKCoordinateRegion cr2 = map_view1.region;
    cr2.center = co2;
    cr2.span.latitudeDelta = 0.004;
    cr2.span.longitudeDelta = 0.004;
    [map_view2 setRegion:cr2 animated:YES];
    
    MyAnnotation *annotation2;
    CLLocationCoordinate2D location2;
    location2.latitude  = 34.069648;
    location2.longitude = 134.579328;
    annotation2 =[[MyAnnotation alloc] initWithCoordinate:location2];
    annotation2.title = @"fiore(フィオーレ安宅店)";
    //    annotation.subtitle = @"";
    [map_view2 addAnnotation:annotation2];
    
    CLLocationCoordinate2D co3;
    co3.latitude = 34.047454; // 経度
    co3.longitude = 134.569813; // 緯度
    MKCoordinateRegion cr3 = map_view1.region;
    cr3.center = co3;
    cr3.span.latitudeDelta = 0.004;
    cr3.span.longitudeDelta = 0.004;
    [map_view3 setRegion:cr3 animated:YES];
    
    MyAnnotation *annotation3;
    CLLocationCoordinate2D location3;
    location3.latitude  = 34.047454;
    location3.longitude = 134.569813;
    annotation3 =[[MyAnnotation alloc] initWithCoordinate:location3];
    annotation3.title = @"スリムサポート みらくる";
    //    annotation.subtitle = @"";
    [map_view3 addAnnotation:annotation3];
}

- (void)dealloc {
    map_view1 = nil;
    map_view2 = nil;
    map_view3 = nil;
    self.tableView = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section){
        case 1:{
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
        default:{
            break;
        }
    }
    
    return headerView;
}

- (IBAction)btn_tel1:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0886785548"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_tel2:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0120142362"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_tel3:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0886788872"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_tel4:(id)sender
{
    NSURL *phone = [NSURL URLWithString:@"tel://0120309362"];
    [[UIApplication sharedApplication] openURL:phone];
}

- (IBAction)btn_web1:(id)sender
{
    [Configuration setWebURL:@"http://www.ssb-group.jp/newlycategory_8"];
}

- (IBAction)btn_web2:(id)sender
{
    [Configuration setWebURL:@"http://www.ssb-group.jp/newlycategory_6"];
}

@end

