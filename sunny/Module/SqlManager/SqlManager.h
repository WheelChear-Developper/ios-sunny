//
//  SqlManager.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NewsView_ListDataModel.h"
#import "Beacon_LogListDataModel.h"

@interface SqlManager : NSObject

//初期設定
+ (void)InitialSql;

////////////////////////////////////　サービス登録データ関連　//////////////////////////////////////////

//サービスリストデータ取得処理
+ (NSMutableArray*)Get_ServiceList;

//サービスリストデータ更新保存処理
+ (void)Set_ServiceList_Insert_listid:(long)list_id
                             listtime:(long)list_time
                           listretime:(NSString*)list_retime
                                title:(NSString*)list_title
                             imageUrl:(NSString*)list_imageUrl
                                 body:(NSString*)list_body;

//サービスリスト一括削除処理
+ (void)AllDel_ServiceList_listid;

//ビーコンデータ保存処理
+ (BOOL)Set_BeconLogList:(Beacon_LogListDataModel*)bicon_logDataListset;

//ビーコンデータ サーバーデータ同期処理
+ (void)set_BeconLogList_serverReUp;




//ビーコンデータ取得処理（有効データ取得）
+ (NSMutableArray*)Get_BeconLogList_EffectiveData;

//ビーコンデータ取得処理（指定日一日分のデータ取得）
+ (NSMutableArray*)Get_BeconLogList_OnedaySerch:(NSDate*)dt;


@end
