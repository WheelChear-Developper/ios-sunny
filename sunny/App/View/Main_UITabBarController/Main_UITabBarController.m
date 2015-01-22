//
//  Main_UITabBarController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Main_UITabBarController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"

@interface Main_UITabBarController () <CLLocationManagerDelegate, CBPeripheralManagerDelegate>
{
    //タブバーインスタンス
    UITabBar *tabBar;
    //Beacon再検出用フラグ
    NSString *str_SerchBeaconMejer;
    NSString *str_SerchBeaconMiner;
    
    UIAlertView *beaconAlert;
    
    UITabBarItem *tabBarItem1;
    UITabBarItem *tabBarItem2;
    UITabBarItem *tabBarItem3;
    UITabBarItem *tabBarItem4;
    UITabBarItem *tabBarItem5;
}
//ロケーションマネージャー
@property (nonatomic) CLLocationManager *locationManager;
//BeaconID設定用
@property (nonatomic) NSUUID *proximityUUID;
//Beacon情報
@property (nonatomic) CLBeaconRegion *beaconRegion;
//Bluetooth確認用
@property (nonatomic) CBPeripheralManager *peripheralManager;
@end

@implementation Main_UITabBarController

UILocalNotification *localNotification;

CLBeacon *nearestBeacon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    //通知の初期化
    [self sendLocalNotificationForReset];
    
    //タブバーインスタンス
    tabBar = self.tabBar;
    tabBarItem1 = [tabBar.items objectAtIndex:0];
    tabBarItem2 = [tabBar.items objectAtIndex:1];
    tabBarItem3 = [tabBar.items objectAtIndex:2];
    tabBarItem4 = [tabBar.items objectAtIndex:3];
    tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    tabBarItem1.title = NSLocalizedString(@"Tab_TitleName1",@"");
    tabBarItem2.title = NSLocalizedString(@"Tab_TitleName2",@"");
    tabBarItem3.title = NSLocalizedString(@"Tab_TitleName3",@"");
    tabBarItem4.title = NSLocalizedString(@"Tab_TitleName4",@"");
    tabBarItem5.title = NSLocalizedString(@"Tab_TitleName5",@"");
    
    tabBarItem1.image = [[UIImage imageNamed:@"news_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"news_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"menu_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"menu_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@"shop_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"shop_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if([Configuration getPushBeacon] == 0){
        tabBarItem4.image = [[UIImage imageNamed:@"stamp_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.selectedImage = [[UIImage imageNamed:@"stamp_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        tabBarItem4.image = [[UIImage imageNamed:@"stamp_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.selectedImage = [[UIImage imageNamed:@"stamp_on_get.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    tabBarItem5.image = [[UIImage imageNamed:@"other_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem5.selectedImage = [[UIImage imageNamed:@"other_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //タブ背景・選択背景設定
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select.png"]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000]];
    
    //タブのテキスト位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    //TabBarに表示されるテキストのフォントとサイズを指定
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0f];
    //タブ選択時のフォントとカラー
    NSDictionary *selectedAttributes = @{NSFontAttributeName:font,
                                         NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes
                                             forState:UIControlStateSelected];
    //通常時のフォントとカラー
    NSDictionary *attributesNormal = @{NSFontAttributeName:font,
                                       NSForegroundColorAttributeName:[UIColor colorWithRed:0.831 green:0.533 blue:0.008 alpha:1.000]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributesNormal
                                             forState:UIControlStateNormal];
    
    //通知の初期化
    [self sendLocalNotificationForReset];
    
    //ビーコン稼働可能端末の確認
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        
        //ビーコンアプリごとに設定するUUID
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:NSLocalizedString(@"Service_BeaconUUID",@"")];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                               identifier:@"com.akafune.sunny"];
        //Bluetooth確認
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        //送信解除
        [self.peripheralManager stopAdvertising];
    } else {
        NSLog(@"お使いの端末ではiBeaconを利用できません。");
    }
}

// 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //Beaconモニタリング開始
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    //アプリケーションがバックグラウンドから復帰し、アクティブになった時の処理
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    // ユーザー情報取得確認
    if([[Configuration getToken] isEqualToString:@""]){
        NSString *str_URL = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_UserGetURL",@"")];
        NSURL *URL_STRING = [NSURL URLWithString:str_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
        NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@" ,@"dummy@news.akafune.com",@"abcdefgh"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

//バックグラウンドからの復帰時起動メソッド
- (void)handleApplicationDidBecomeActive:(NSNotification *)notitication
{
    //通知の初期化
    [self sendLocalNotificationForReset];
}

- (void)dealloc {
    str_SerchBeaconMejer = @"";
    str_SerchBeaconMiner = @"";
}

// タブが切替られたときに呼び出されるデリゲートメソッド
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if(tabBarController.selectedIndex == 3){
        tabBarItem4.image = [[UIImage imageNamed:@"stamp_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.selectedImage = [[UIImage imageNamed:@"stamp_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

///////////////////////// ↓　通信用メソッド　↓　//////////////////////////////
//通信開始時に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //初期化
    self.mData = [NSMutableData data];
}

//通信中常に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //通信したデータを入れていきます
    [self.mData appendData:data];
}

//通信終了時に呼ばれる
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    //値の取得
    id json = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *jsonParser = (NSMutableArray*)json;
    
    if([[jsonParser valueForKey:@"id"] longValue]>0){
        NSLog(@"ユーザー情報取得 = %@",jsonParser);
        // プロファイルID設定
        [Configuration setProfileID:[jsonParser valueForKeyPath:@"id"]];
        // プロファイル名設定
        [Configuration setProfileName:[jsonParser valueForKeyPath:@"name"]];
        // Token設定(設定されていない場合のみ設定)
        [Configuration setToken:[jsonParser valueForKeyPath:@"token"]];
        
    }else{
        NSLog(@"ユーザー情報を取得できませんでした。");
    }
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

///////////////////////// ↑　通信用メソッド　↑　//////////////////////////////


#pragma mark - CLLocationManagerDelegate methods

//領域計測が開始した場合
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

//指定した領域に入った場合
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

//指定した領域から出た場合
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

//領域観測に失敗した場合
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

//Beacon信号を検出した場合
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        nearestBeacon = beacons.firstObject;
        
        NSLog(@"Beacon 受信距離 : %ld",(long)nearestBeacon.proximity);
        
        //同じ電波の受信を遮断
        if(str_SerchBeaconMejer == (NSString*)nearestBeacon.major && str_SerchBeaconMiner == (NSString*)nearestBeacon.minor){
        }else{
            //データベース保存処理
            NSDate *nowDate = [NSDate date];
            Beacon_LogListDataModel *beaconLogDataModel = [[Beacon_LogListDataModel alloc] init];
            beaconLogDataModel.log_date = nowDate;
            beaconLogDataModel.log_UUID = nearestBeacon.proximityUUID.UUIDString;
            beaconLogDataModel.log_major = nearestBeacon.major.intValue;
            beaconLogDataModel.log_minor = nearestBeacon.minor.intValue;
            beaconLogDataModel.log_rssi = nearestBeacon.rssi;
            beaconLogDataModel.log_accuracy = nearestBeacon.accuracy;
            beaconLogDataModel.log_state = 0;
            
            if([SqlManager Set_BeconLogList:beaconLogDataModel] == YES){
                
                //タブ画像更新
                [[tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"stamp_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"stamp_off_get.png"]];
                
                if([Configuration getPushNotificationsBeacon]){
                    //ローカル通知
                    [self sendLocalNotificationForMessage];
                    
                    //beacon通知
                    beaconAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_ShopInTitleBeaconMsg",@"")
                                                             message:NSLocalizedString(@"Dialog_ShopInBeaconMsg",@"")
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Dialog_No",@"")
                                                   otherButtonTitles:NSLocalizedString(@"Dialog_Yes",@""),nil];
                    [beaconAlert show];
                }
                //サーバー情報同期処理
                [SqlManager set_BeconLogList_serverReUp];
            }
            
            //Beacon受信パターンの状態セット
            str_SerchBeaconMejer = (NSString*)nearestBeacon.major;
            str_SerchBeaconMiner = (NSString*)nearestBeacon.minor;
        }
    }
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView == beaconAlert){
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self setSelectedIndex:3];
                break;
        }
    }
}

#pragma mark - Private methods
//通知の初期化
-(void)sendLocalNotificationForReset
{
    //通知の初期化
    localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    //通知件数セット
    NSLog(@"notication news=%ld beacon=%ld",[Configuration getPushNews],[Configuration getPushBeacon]);
    localNotification.applicationIconBadgeNumber =  [Configuration getPushNews] + [Configuration getPushBeacon];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

//通知
- (void)sendLocalNotificationForMessage
{
    //通知
    localNotification.alertBody = NSLocalizedString(@"beacon_Infomation",@"");
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = @"music1.caf";
    //ニュースプッシュ通知追加
    [Configuration setPushBeacon:[Configuration getPushBeacon]+1];
    //通知件数セット
    NSLog(@"notication news=%ld beacon=%ld",[Configuration getPushNews],[Configuration getPushBeacon]);
    localNotification.applicationIconBadgeNumber =  [Configuration getPushNews] + [Configuration getPushBeacon];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

//装置状態確認
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"電源切断");
            break;
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"リセット");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"Unauthorized");
            break;
        case CBPeripheralManagerStateUnknown:
            NSLog(@"Unknown");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"Unsupported");
            break;
            
        default:
            break;
    }
}

@end
