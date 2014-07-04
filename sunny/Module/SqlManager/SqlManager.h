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

@interface SqlManager : NSObject

// 初期設定
+ (void)InitialSql;

////////////////////////////////////　サービス登録データ関連　//////////////////////////////////////////

// サービスリストデータ取得処理
+ (NSMutableArray*)Get_ServiceList;

// サービスリストデータ更新保存処理
+ (void)Set_ServiceList_Insert_listid:(long)list_id
                             listtime:(long)list_time
                           listretime:(NSString*)list_retime
                                title:(NSString*)list_title
                             imageUrl:(NSString*)list_imageUrl
                                 body:(NSString*)list_body;

// サービスリスト一括削除処理
+ (void)AllDel_ServiceList_listid;

@end
