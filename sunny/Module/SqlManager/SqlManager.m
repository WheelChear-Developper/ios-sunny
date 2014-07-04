//
//  SqlManager.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import "SqlManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#define DBFILE @"service.db"

@implementation SqlManager

// データベースインスタンスを返す
+(FMDatabase*)_getDB:(NSString*)dbName
{
	NSArray*  pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* docdir = [pathArray objectAtIndex:0];
	NSString* dbpath = [docdir stringByAppendingPathComponent:dbName];
	FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        @throw [NSException exceptionWithName:@"DBOpenException" reason:@"couldn't open specified db file" userInfo:nil];
    }
    return db;
}

+ (void)InitialSql
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //通院記録情報登録テーブル作成
    NSString* sql1 = @"CREATE TABLE IF NOT EXISTS tbl_list_record (";
    NSString* sql2 = @" list_id           INTEGER,";
    NSString* sql3 = @" list_time         INTEGER,";
    NSString* sql4 = @" list_retime       TEXT,";
    NSString* sql5 = @" list_title        TEXT,";
    NSString* sql6 = @" list_imageUrl     TEXT,";
    NSString* sql7 = @" list_body         TEXT);";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",sql1,sql2,sql3,sql4,sql5,sql6,sql7];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// サービスリストデータ取得処理
+ (NSMutableArray*)Get_ServiceList
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" list_id,";
    NSString* Sql3 = @" list_time,";
    NSString* Sql4 = @" list_retime,";
    NSString* Sql5 = @" list_title,";
    NSString* Sql6 = @" list_imageUrl,";
    NSString* Sql7 = @" list_body";
    NSString* Sql8 = @" FROM tbl_list_record";
    NSString* Sql9 = @" ORDER BY list_id DESC;";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        NewsView_ListDataModel *listDataModel = [[NewsView_ListDataModel alloc] init];
        listDataModel.service_id = [results longForColumn:@"list_id"];
        listDataModel.service_time = [results longForColumn:@"list_time"];
        listDataModel.service_retime = [results stringForColumn:@"list_retime"];
        listDataModel.service_title = [results stringForColumn:@"list_title"];
        listDataModel.service_imageUrl = [results stringForColumn:@"list_imageUrl"];
        listDataModel.service_body = [results stringForColumn:@"list_body"];
        [dbBox addObject:listDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}

// サービスリストデータ更新保存処理
+ (void)Set_ServiceList_Insert_listid:(long)list_id
                             listtime:(long)list_time
                           listretime:(NSString*)list_retime
                                title:(NSString*)list_title
                             imageUrl:(NSString*)list_imageUrl
                                 body:(NSString*)list_body
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存
    NSString* sql1 = @"INSERT INTO tbl_list_record";
    NSString* sql2 = @" (list_id, list_time, list_retime, list_title, list_imageUrl, list_body) VALUES ";
    NSString* sql3 = [NSString stringWithFormat:@"(%lu, %lu, '%@', '%@', '%@', '%@');",
                      list_id,
                      list_time,
                      list_retime,
                      list_title,
                      list_imageUrl,
                      list_body];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@",sql1, sql2, sql3];
    if (![DbAccess executeUpdate:MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データベースクローズ
    [DbAccess close];
}

// サービスリスト一括削除処理
+ (void)AllDel_ServiceList_listid
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //データ保存前データ削除
    NSString* MakeSQL = [NSString stringWithFormat:@"DELETE FROM tbl_list_record"];
    [DbAccess executeUpdate:MakeSQL];
    
    //データベースクローズ
    [DbAccess close];
}

@end
