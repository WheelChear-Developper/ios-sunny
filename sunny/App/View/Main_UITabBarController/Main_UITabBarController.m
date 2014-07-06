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
    //Beacon再検出用フラグ
    NSString *str_SerchBeaconMejer;
    NSString *str_SerchBeaconMiner;
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
    
    //通知の初期化
    [self sendLocalNotificationForReset];
    
    // 初期起動フラグ設定
    [Configuration setFirstStart:NO];
    
    //タブバー設定
    UITabBar *tabBar = self.tabBar;
    
    [[tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"news_30x30_off.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"news_30x30_on.png"]];
    [[tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"menu_30x30_off.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"menu_30x30_on.png"]];
    [[tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"shop_30x30_off.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"shop_30x30_on.png"]];
    [[tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"stamp_30x30_off.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"stamp_30x30_on.png"]];
    [[tabBar.items objectAtIndex:4] setFinishedSelectedImage:[UIImage imageNamed:@"other_30x30_off.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"other_30x30_on.png"]];
    
    //タブ背景・選択背景設定
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select.png"]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000]];
    
    //タブのテキスト位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    //TabBarに表示されるテキストのフォントとサイズを指定
    //タブバーの文字色と文字サイズを設定(選択前)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.831 green:0.533 blue:0.008 alpha:1.000], NSForegroundColorAttributeName,[UIFont systemFontOfSize:9.000], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //タブバーの文字色と文字サイズを設定(選択中)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000], NSForegroundColorAttributeName,[UIFont systemFontOfSize:9.000], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    
    //通知の初期化
    [self sendLocalNotificationForReset];
    
    //ビーコン稼働可能端末の確認
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        
        //ビーコンアプリごとに設定するUUID
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"A7466A9F-905B-1801-94CC-001C4DCA52B9"];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                               identifier:@"jp.mobile-innovation.testapp"];
        //Bluetooth確認
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        //送信解除
        [self.peripheralManager stopAdvertising];
    } else {
        NSLog(@"お使いの端末ではiBeaconを利用できません。");
    }
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
/*
        errAlert_exit = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_API_NotConnectTitleMsg",@"")
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Dialog_API_NotConnectMsg",@"")
                                         otherButtonTitles:nil];
        [errAlert_exit show];
 */
    }
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
/*
    // 通信エラーメッセージ表示
    errAlert_exit = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_API_NotConnectTitleMsg",@"")
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Dialog_API_NotConnectMsg",@"")
                                     otherButtonTitles:nil];
    [errAlert_exit show];
*/
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
/*
    if(alertView == errAlert_exit){
        switch (buttonIndex) {
            case 0:
//                exit(0);
                break;
        }
    }
*/
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
        
        NSLog(@"Beacon 受信距離 : %d",nearestBeacon.proximity);
        
        //同じ電波の受信を遮断
        if(str_SerchBeaconMejer == (NSString*)nearestBeacon.major && str_SerchBeaconMiner == (NSString*)nearestBeacon.minor){
        }else{
            //データベース保存処理
            NSDate *nowDate = [NSDate date];
            Beacon_LogListDataModel *beaconLogDataModel = [[Beacon_LogListDataModel alloc] init];
            beaconLogDataModel.log_date = nowDate;
            beaconLogDataModel.log_UUID = nearestBeacon.proximityUUID.UUIDString;
            beaconLogDataModel.log_major = (NSString*)nearestBeacon.major;
            beaconLogDataModel.log_minor = (NSString*)nearestBeacon.minor;
            beaconLogDataModel.log_proximity = (long)nearestBeacon.proximity;
            beaconLogDataModel.log_accuracy = (double)nearestBeacon.accuracy;
            
            if([SqlManager Set_BeconLogList:beaconLogDataModel] == YES){
                //ローカル通知
                [self sendLocalNotificationForMessage];
                
                // オフラインで表示
                UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"通知情報を受信"
                                                                   message:@"ポイントを追加しました。"
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                         otherButtonTitles:nil];
                [errAlert show];
            }
            
            //Beacon受信パターンの状態セット
            str_SerchBeaconMejer = (NSString*)nearestBeacon.major;
            str_SerchBeaconMiner = (NSString*)nearestBeacon.minor;
        }
    }
}

#pragma mark - Private methods
//通知の初期化
-(void)sendLocalNotificationForReset
{
    //通知の初期化
    localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3]; //3秒後
    localNotification.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

//通知
- (void)sendLocalNotificationForMessage
{
    //通知
    localNotification.alertBody = NSLocalizedString(@"beacon_Infomation",@"");
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

//装置状態確認
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSString *message;
    
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOff:
            message = @"■電源切断\n\n";
            break;
        case CBPeripheralManagerStatePoweredOn:
            message = @"";
            
            break;
        case CBPeripheralManagerStateResetting:
            message = @"■リセット\n\n";
            break;
        case CBPeripheralManagerStateUnauthorized:
            message = @"■Unauthorized\n\n";
            break;
        case CBPeripheralManagerStateUnknown:
            message = @"■Unknown\n\n";
            break;
        case CBPeripheralManagerStateUnsupported:
            message = @"■Unsupported\n\n";
            break;
            
        default:
            break;
    }
}

@end
