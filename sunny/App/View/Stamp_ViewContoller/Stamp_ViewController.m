//
//  Stamp_ViewContollerViewController.m
//  sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "Stamp_ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Stamp_Cell.h"
#import "UILabel+EstimatedHeight.h"

@interface Stamp_ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_Stamp_TotalDataBox;
    // スクロールダウンの再読み込みフラグ
    BOOL bln_TableReLoad;
}
@end

@implementation Stamp_ViewController

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
    self.view.backgroundColor = [SetColor setBackGroundColor];
    
    // スクロールダウンの再読み込みフラグ(Table用)
    bln_TableReLoad = NO;
    
    UINib *nib = [UINib nibWithNibName:@"Stamp_Cell" bundle:nil];
    Stamp_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"Stamp_Cell"];
}

// 終了処理
- (void)viewDidUnload
{
    Table_View = nil;
    _Stamp_TotalDataBox = nil;
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
    // リストデータの読み込み
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Reading",@"")];
    [self readWebData];
    
    [super viewWillAppear:animated];
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
    _Stamp_TotalDataBox = nil;
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_Stamp_TotalDataBox count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルごとの大きさ調整
    return 82;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    Stamp_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stamp_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    Stamp_ListDataModel *stampDataModel = _Stamp_TotalDataBox[row];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@",stampDataModel.stamp_Name];
//    cell.str_comment = commentDataModel.comments_body;
//    cell.lbl_date.text = commentDataModel.comments_createdAt;
    
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
    _Stamp_TotalDataBox = [[NSMutableArray alloc] init];
    
    // コメント取得
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@",
                  NSLocalizedString(@"Service_DomainURL",@""),
                  NSLocalizedString(@"Service_StampURL",@"")]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //NSLog(@"チケット一覧取得用 = %@",responseObject);
          
          //MutableArrayへ格納
          NSMutableArray *array_json = (NSMutableArray*)responseObject;
          
          // データ格納(Webからの再取得)
          for(int i=0;i<array_json.count;i+=1){
              Stamp_ListDataModel *stampDataModel = [[Stamp_ListDataModel alloc] init];
              stampDataModel.stamp_id = [[[array_json valueForKeyPath:@"id"] objectAtIndex:(array_json.count-1)-i] longValue];
              stampDataModel.stamp_Name = [[array_json valueForKeyPath:@"title"] objectAtIndex:(array_json.count-1)-i];
              
              // 時間の再定義
              NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
              [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
              NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
              // 基本時間からの加算
              NSDate* setDate = [rootDate initWithTimeInterval:[[[array_json valueForKeyPath:@"created_at"] objectAtIndex:(array_json.count-1)-i] longValue] sinceDate:rootDate];
              //日本時間設定
              NSDate *getDate = [setDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:setDate];
              
              //文字列変換
              stampDataModel.stamp_createdAt = [inputDateFormatter stringFromDate:getDate];
              
              [_Stamp_TotalDataBox addObject:stampDataModel];
              
              stampDataModel = nil;
          }
          
          //テーブルデータの再構築
          [Table_View reloadData];
          
          // 読み込み中の表示削除
          [SVProgressHUD dismiss];
          
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          
          // 読み込み中の表示削除
          [SVProgressHUD dismiss];
          // 通信エラーメッセージ表示
          UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Dialog_IntenetNotConnectTitleMsg",@"")
                                                             message:NSLocalizedString(@"Dialog_IntenetNotConnectMsg",@"")
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Dialog_KakuninMsg",@"")
                                                   otherButtonTitles:nil];
          [errAlert show];
      }];
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

// 全画面に戻るメソッド
- (void)btn_Return:(id)sender
{
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

@end
