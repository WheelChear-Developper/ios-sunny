//
//  Comments_ViewController.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "Comments_ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Comments_Cell.h"
#import "UILabel+EstimatedHeight.h"

@interface Comments_ViewController ()
{
    // リスト用データ格納用
    NSMutableArray *_Comment_TotalDataBox;
    // スクロールダウンの再読み込みフラグ
    BOOL bln_TableReLoad;
}
@end

@implementation Comments_ViewController

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
    
    // 戻るボタン設定
    UIButton *Left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [Left_Button.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [Left_Button setTitle:NSLocalizedString(@"Button_Back",@"") forState:UIControlStateNormal];
    [Left_Button setTitleColor:[SetColor setButtonCharColor] forState:UIControlStateNormal];
    [Left_Button addTarget:self action:@selector(btn_Return:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* Left_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:Left_Button];
    self.navigationItem.leftBarButtonItem = Left_buttonItem;
    
    //BackColor
    Table_View.backgroundColor = [SetColor setBackGroundColor];
    self.view.backgroundColor = [SetColor setBackGroundColor];
    
    //タイトルセット
    lbl_commentTitle.text = [Configuration getNewsTitle];
    
    // スクロールダウンの再読み込みフラグ(Table用)
    bln_TableReLoad = NO;
    
    UINib *nib = [UINib nibWithNibName:@"Comments_Cell" bundle:nil];
    Comments_Cell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table_View.rowHeight = cell.frame.size.height;
    
    // Register CustomCell
    [Table_View registerNib:nib forCellReuseIdentifier:@"Comments_Cell"];
}

// 終了処理
- (void)viewDidUnload
{
    Table_View = nil;
    _Comment_TotalDataBox = nil;
    view_notComment = nil;
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
    view_notComment.hidden = NO;
    
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
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
    // 読み込み中の表示削除
    [SVProgressHUD dismiss];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Table_View = nil;
    _Comment_TotalDataBox = nil;
}

/////////////// ↓　テーブル用メソッド　↓ ////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_Comment_TotalDataBox count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルごとの大きさ調整
    if(_Comment_TotalDataBox.count > 0){
        NSUInteger row = (NSUInteger)indexPath.row;
        Comments_ListDataModel *commentDataModel = _Comment_TotalDataBox[row];
        
        // ラベルの高さ取得
        CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                    text:commentDataModel.comments_body size:CGSizeMake(255, MAXFLOAT)];
        flt_height += 10;
        
        // 行数によるポジションセット
        CGFloat photo_potision = [commentDataModel.comments_body lengthOfBytesUsingEncoding:NSShiftJISStringEncoding]/19;
        if(photo_potision > 6){
            photo_potision = 6;
        }
        
        return 50 + flt_height;
    }
    return 0;
}

// １行ごとのセル生成（表示時）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Instantiate or reuse cell
    Comments_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comments_Cell"];
    
    // セル枠線削除
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 背景色
    cell.backgroundColor = [SetColor setBackGroundColor];
    // Set contents
    NSUInteger row = (NSUInteger)indexPath.row;
    Comments_ListDataModel *commentDataModel = _Comment_TotalDataBox[row];
    cell.lbl_name.text = [NSString stringWithFormat:@"%@（%ld）",commentDataModel.comments_userName,commentDataModel.comments_userId];
    cell.str_comment = commentDataModel.comments_body;
    cell.lbl_date.text = commentDataModel.comments_createdAt;
    
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
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
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
    _Comment_TotalDataBox = [[NSMutableArray alloc] init];
    
    // コメント取得
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@%ld%@",
                  NSLocalizedString(@"Service_DomainURL",@""),
                  NSLocalizedString(@"Service_CommentGet1URL",@""),
                  (long)[Configuration getNewsID],
                  NSLocalizedString(@"Service_CommentGet2URL",@"")]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {          
          //NSLog(@"コメント一覧取得用 = %@",responseObject);
          
          //MutableArrayへ格納
          NSMutableArray *array_json = (NSMutableArray*)responseObject;
          
          // コメントカウント設定
          lbl_commentCount.text = [NSString stringWithFormat:@"コメント( %ld 件)",(long)array_json.count];
          
          // データ格納(Webからの再取得)
          for(int i=0;i<array_json.count;i+=1){
              Comments_ListDataModel *commentDataModel = [[Comments_ListDataModel alloc] init];
              commentDataModel.comments_id = [[[array_json valueForKeyPath:@"id"] objectAtIndex:(array_json.count-1)-i] longValue];
              commentDataModel.comments_userId = [[[array_json valueForKeyPath:@"iosUserId"] objectAtIndex:(array_json.count-1)-i] longValue];
              commentDataModel.comments_userName = [[array_json valueForKeyPath:@"iosUserName"] objectAtIndex:(array_json.count-1)-i];
              commentDataModel.comments_body = [[array_json valueForKeyPath:@"body"] objectAtIndex:(array_json.count-1)-i];
              
              // 時間の再定義
              NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
              [inputDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
              NSDate* rootDate = [inputDateFormatter dateFromString:@"1970/01/01 00:00:00"];
              // 基本時間からの加算
              NSDate* setDate = [rootDate initWithTimeInterval:[[[array_json valueForKeyPath:@"createdAt"] objectAtIndex:(array_json.count-1)-i] longValue] sinceDate:rootDate];
              //日本時間設定
              NSDate *getDate = [setDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:setDate];
              
              commentDataModel.comments_createdAt = [self getElapsedTime:getDate];
              
              [_Comment_TotalDataBox addObject:commentDataModel];
              
              commentDataModel = nil;
          }
          
          //コメント無しの時のコメント表示
          if(array_json.count == 0) {
              view_notComment.hidden = NO;
          }else{
              view_notComment.hidden = YES;
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

- (NSString*)getElapsedTime:(NSDate*)dt
{
    NSDate *now = [NSDate date];
    float tmp= [now timeIntervalSinceDate:dt];
    int int_hh = (int)(tmp / 3600);
    
    if(int_hh <= 1){
        int int_mm = (int)((tmp - int_hh) / 60);
        if(int_mm <= 10){
            return @"１０分前";
        }else if(int_mm <= 20){
            return @"２０分前";
        }else if(int_mm <= 30){
            return @"３０分前";
        }else if(int_mm <= 40){
            return @"４０分前";
        }else if(int_mm <= 50){
            return @"５０分前";
        }else{
            return @"１時間前";
        }
    }else if(int_hh <= 2){
        return @"２時間前";
    }else if(int_hh <= 3){
        return @"３時間前";
    }else if(int_hh <= 4){
        return @"４時間前";
    }else if(int_hh <= 5){
        return @"５時間前";
    }else if(int_hh <= 6){
        return @"６時間前";
    }else if(int_hh <= 7){
        return @"７時間前";
    }else if(int_hh <= 8){
        return @"８時間前";
    }else if(int_hh <= 9){
        return @"９時間前";
    }else if(int_hh <= 10){
        return @"１０時間前";
    }else if(int_hh <= 11){
        return @"１１時間前";
    }else if(int_hh <= 12){
        return @"１２時間前";
    }else if(int_hh <= 13){
        return @"１３時間前";
    }else if(int_hh <= 14){
        return @"１４時間前";
    }else if(int_hh <= 15){
        return @"１５時間前";
    }else if(int_hh <= 16){
        return @"１６時間前";
    }else if(int_hh <= 17){
        return @"１７時間前";
    }else if(int_hh <= 18){
        return @"１８時間前";
    }else if(int_hh <= 19){
        return @"１９時間前";
    }else if(int_hh <= 20){
        return @"２０時間前";
    }else if(int_hh <= 21){
        return @"２１時間前";
    }else if(int_hh <= 22){
        return @"２２時間前";
    }else if(int_hh <= 23){
        return @"２３時間前";
    }else if(int_hh <= 24){
        return @"２４時間前";
    }else{
        int int_day = int_hh / 24;
        return [NSString stringWithFormat:@"%d日前",int_day];
    }
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

/////////////// ↓　入力系用メソッド　↓ ////////////////////
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    // ホント表示を消す
    lbl_comment_hint.hidden = YES;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if(txt_comments.text.length == 0){
        // ヒント表示表示
        lbl_comment_hint.hidden = NO;
    }
    // キーボード隠す
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int maxInputLength = 50;
    
    // 入力済みのテキストを取得
    NSMutableString *str = [textView.text mutableCopy];
    
    // 入力済みのテキストと入力が行われたテキストを結合
    [str replaceCharactersInRange:range withString:text];
    
    if ([str length] > maxInputLength) {
        return NO;
    }
    
    return YES;
}
/////////////// ↑　入力系用メソッド　↑ ////////////////////

// 全画面に戻るメソッド
- (void)btn_Return:(id)sender
{
    // 前画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

// コメント投稿メソッド
- (IBAction)btn_comments:(id)sender
{
    // キーボード隠す
    [txt_comments resignFirstResponder];
    
    // トリム処理
    txt_comments.text = [txt_comments.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([txt_comments.text isEqualToString:@""])
    {
        // ヒント表示表示
        lbl_comment_hint.hidden = NO;
    }
    
    if(![txt_comments.text isEqualToString:@""]){
        // リストデータの読み込み
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress_Writeing",@"")];
        
        // コメント保存(サーバー用)
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        NSDictionary* param = @{@"body" : txt_comments.text};
        [manager POST:[NSString stringWithFormat:@"%@%@%@%@%ld%@%@",
                       NSLocalizedString(@"Service_DomainURL",@""),
                       NSLocalizedString(@"Service_CommentSetURL1",@""),
                       NSLocalizedString(@"Service_ID",@"") ,
                       NSLocalizedString(@"Service_CommentSetURL2",@""),
                       [Configuration getNewsID],
                       NSLocalizedString(@"Service_CommentSetURL3",@""),
                       [Configuration getToken]]
           parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
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
        
/*
        NSString *URL = [NSString stringWithFormat:@"%@%@%@%@%ld%@%@",
                         NSLocalizedString(@"Service_DomainURL",@""),
                         NSLocalizedString(@"Service_CommentSetURL1",@""),
                         NSLocalizedString(@"Service_ID",@"") ,
                         NSLocalizedString(@"Service_CommentSetURL2",@""),
                         [Configuration getNewsID],
                         NSLocalizedString(@"Service_CommentSetURL3",@""),
                         [Configuration getToken]];
        NSURL *URL_STRING = [NSURL URLWithString:URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
        NSString *requestBody = [@"body=" stringByAppendingString:txt_comments.text];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (connection) {
            // start loading
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
*/
        // 前画面に戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
