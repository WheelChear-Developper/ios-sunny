//
//  News_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "News_ViewController.h"
#import "News_Cell.h"
#import "UILabel+EstimatedHeight.h"
#import "ReachabilityCheck.h"

@interface News_ViewController ()
{
    //リスト用データ格納用
    NSMutableArray *_News_TotalDataBox;
    //スクロールダウンの再読み込みフラグ
    BOOL bln_TableReLoad;
}
@end

@implementation News_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 初期起動メソッド
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS6/7でのレイアウト互換設定
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //BackColor
    Table_View.backgroundColor = [SetColor setBackGroundColor];
    
    // スクロールダウンの再読み込みフラグ(Table用)
    bln_TableReLoad = NO;
    
    UINib *nib = [UINib nibWithNibName:@"News_Cell" bundle:nil];
    News_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"News_Cell"];
}

// 終了処理
- (void)viewDidUnload
{
    Table_View = nil;
    _News_TotalDataBox = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

// 起動・再開の時に起動するメソッド
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_News_TotalDataBox.count == 0){
        // リストデータの読み込み
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
        [self readWebData];
    }else if([Configuration getPushNews] == YES){
        // リストデータの読み込み
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
        [self readWebData];
    }
}

// 画面の表示の時に起動するメソッド
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// 画面変更時の終了メソッド
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Table_View = nil;
    _News_TotalDataBox = nil;
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_News_TotalDataBox count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルごとの大きさ調整
    if(_News_TotalDataBox.count > 0){
        NSUInteger row = (NSUInteger)indexPath.row;
        NewsView_ListDataModel *listDataModel = _News_TotalDataBox[row];
        
        // ラベルの高さ取得
        CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                    text:listDataModel.service_body size:CGSizeMake(255, MAXFLOAT)];
        flt_height += 15 * 2;
        
        // 行数によるポジションセット
        CGFloat photo_potision = [listDataModel.service_body lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]/19;
        if(photo_potision > 6){
            photo_potision = 6;
        }
        
        if([listDataModel.service_imageUrl isEqual:@"<null>"]){
            return 55 + flt_height + 15 + 33;
        }else if([listDataModel.service_imageUrl isEqual:[NSNull null]]){
            return 55 + flt_height + 15 + 33;
        }else{
            return 55 + flt_height + 200 + 15 + 33 + 5;
        }
    }
    return 0;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    News_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"News_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    NewsView_ListDataModel *listDataModel = _News_TotalDataBox[row];
    cell.lng_newsId = listDataModel.service_id;
    cell.lbl_hyoudai.text = listDataModel.service_title;
    cell.lbl_date.text = listDataModel.service_retime;
    cell.str_comment = listDataModel.service_body;
    cell.str_imageurl = listDataModel.service_imageUrl;
    
    return cell;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

//セルの選択時イベントメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([ReachabilityCheck getNetworkInfo] == YES){
        NewsView_ListDataModel *listDataModel = _News_TotalDataBox[indexPath.row];
        // 選択リスト設定
        [Configuration setNewsID:listDataModel.service_id];
        // 選択タイトル設定
        [Configuration setNewsTitle:listDataModel.service_title];
        
        // 画面遷移
        UIViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"comments"];
        [self.navigationController pushViewController:initialViewController animated:YES];
    }else{
        // オフラインで表示
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                           message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                 otherButtonTitles:nil];
        [errAlert show];
    }
}

// テーブルのスクロール時のイベントメソッド
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // テーブルビュー用
    if(Table_View){
        CGFloat table_positionY = [Table_View contentOffset].y;
        if(table_positionY < -100){
            bln_TableReLoad = YES;
        }else if(table_positionY == 0){
            if(bln_TableReLoad == YES){
                // リストデータの読み込み
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_ReReading",@"")];
                [self readWebData];
                
                bln_TableReLoad = NO;
            }
        }
    }
}
/////////////// ↑　テーブル用メソッド　↑ ////////////////////

/////////////// ↓　通信用メソッド　↓　////////////////////
// Webからのリストデータ取得
- (void)readWebData
{
    // リストデータの初期化
    _News_TotalDataBox = [[NSMutableArray alloc] init];
    
    // ニュース取得
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@",
                  NSLocalizedString(@"Service_DomainURL",@""),
                  NSLocalizedString(@"Service_NewsURL",@"")]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //NSLog(@"ニュース一覧取得用 = %@",responseObject);
          
          //MutableArrayへ格納
          NSMutableArray *array_json = (NSMutableArray*)responseObject;
          //アプリ内のデータ取得
          NSMutableArray *RecordDataBox = [SqlManager Get_ServiceList];
          if(RecordDataBox.count>0){
              long chk_dt1 = [[RecordDataBox[0] valueForKeyPath:@"service_time"] longValue];
              long chk_dt2 = [[[array_json valueForKeyPath:@"created_at"] objectAtIndex:0] longValue];
              if(chk_dt1 == chk_dt2){
                  NSLog(@"ニュースデータ変更なし");
                  _News_TotalDataBox = RecordDataBox;
              }else{
                  [SqlManager AllDel_ServiceList_listid];
                  
                  // データ格納(Webからの再取得)
                  for(int i=0;i<array_json.count;i+=1){
                      NewsView_ListDataModel *listDataModel = [[NewsView_ListDataModel alloc] init];
                      listDataModel.service_id = [[[array_json valueForKeyPath:@"id"] objectAtIndex:i] longValue];
                      listDataModel.service_title = [[array_json valueForKeyPath:@"title"] objectAtIndex:i];
                      listDataModel.service_body = [[array_json valueForKeyPath:@"body"] objectAtIndex:i];
                      listDataModel.service_imageUrl = [[array_json valueForKeyPath:@"image"] objectAtIndex:i];
                      
                      // 時間の再定義
                      NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
                      [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                      NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
                      // 基本時間からの加算
                      NSDate* setDate = [rootDate initWithTimeInterval:[[[array_json valueForKeyPath:@"created_at"] objectAtIndex:i] longValue] sinceDate:rootDate];
                      //日本時間設定
                      NSDate *getDate = [setDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:setDate];
                      
                      // 時間のフォーマット変更
                      NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                      [formatter setDateFormat:@"MM月dd日 HH時"];
                      NSString* str_time = [formatter stringFromDate:getDate];
                      listDataModel.service_retime = str_time;
                      
                      [_News_TotalDataBox addObject:listDataModel];
                      
                      [SqlManager Set_ServiceList_Insert_listid:listDataModel.service_id
                                                       listtime:[[[array_json valueForKeyPath:@"created_at"] objectAtIndex:i] longValue]
                                                     listretime:listDataModel.service_retime
                                                          title:listDataModel.service_title
                                                       imageUrl:listDataModel.service_imageUrl
                                                           body:listDataModel.service_body];
                      listDataModel = nil;
                  }
              }
          }else{
              [SqlManager AllDel_ServiceList_listid];
              
              // データ格納(Webからの再取得)
              for(int i=0;i<array_json.count;i+=1){
                  NewsView_ListDataModel *listDataModel = [[NewsView_ListDataModel alloc] init];
                  listDataModel.service_id = [[[array_json valueForKeyPath:@"id"] objectAtIndex:i] longValue];
                  listDataModel.service_title = [[array_json valueForKeyPath:@"title"] objectAtIndex:i];
                  listDataModel.service_body = [[array_json valueForKeyPath:@"body"] objectAtIndex:i];
                  listDataModel.service_imageUrl = [[array_json valueForKeyPath:@"image"] objectAtIndex:i];
                  
                  // 時間の再定義
                  NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
                  [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                  NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
                  // 基本時間からの加算
                  NSDate* setDate = [rootDate initWithTimeInterval:[[[array_json valueForKeyPath:@"created_at"] objectAtIndex:i] longValue] sinceDate:rootDate];
                  //日本時間設定
                  NSDate *getDate = [setDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:setDate];
                  
                  // 時間のフォーマット変更
                  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                  [formatter setDateFormat:@"MM月dd日 HH時"];
                  NSString* str_time = [formatter stringFromDate:getDate];
                  listDataModel.service_retime = str_time;
                  
                  [_News_TotalDataBox addObject:listDataModel];
                  
                  [SqlManager Set_ServiceList_Insert_listid:listDataModel.service_id
                                                   listtime:[[[array_json valueForKeyPath:@"created_at"] objectAtIndex:i] longValue]
                                                 listretime:listDataModel.service_retime
                                                      title:listDataModel.service_title
                                                   imageUrl:listDataModel.service_imageUrl
                                                       body:listDataModel.service_body];
                  listDataModel = nil;
              }
          }
          
          //テーブルデータの再構築
          [Table_View reloadData];
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          
          NSMutableArray *RecordDataBox = [SqlManager Get_ServiceList];
          if(RecordDataBox.count>0){
              //アプリ内データのセット
              _News_TotalDataBox = RecordDataBox;
              //テーブルデータの再構築
              [Table_View reloadData];
          }else{
              // 読み込み中の表示削除
              [SVProgressHUD dismiss];
              // 通信エラーメッセージ表示
              UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                                 message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                       otherButtonTitles:nil];
              [errAlert show];
          }
          
          
      }];
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
}
/////////////// ↑　通信用メソッド　↑　////////////////////

// アラートのボタンが押された時に呼ばれるメソッド
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            break;
    }
}

@end
