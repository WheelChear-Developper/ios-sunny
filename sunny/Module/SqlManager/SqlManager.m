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
#import "CZDateFormatterCache.h"

#define DBFILE @"service.db"

@implementation SqlManager

// NSDATEから日付型文字列変換
+ (NSString*)get_DateToSting:(NSDate*)dt
{
    [CZDateFormatterCache mainQueueCache].currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    NSString* setDt = [[CZDateFormatterCache mainQueueCache] localizedStringFromDate:dt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    setDt = [setDt stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return setDt;
}

// 日付型文字列からNSDATE変換
+(NSDate*)get_StringToDate:(NSString*)dt
{
    dt = [dt stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* setDt = [formatter dateFromString:dt];
    return setDt;
}

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
    
    //ニューステーブル作成
    NSString* tbl1_sql1 = @"CREATE TABLE IF NOT EXISTS tbl_list_record (";
    NSString* tbl1_sql2 = @" list_id           INTEGER,";
    NSString* tbl1_sql3 = @" list_time         INTEGER,";
    NSString* tbl1_sql4 = @" list_retime       TEXT,";
    NSString* tbl1_sql5 = @" list_title        TEXT,";
    NSString* tbl1_sql6 = @" list_imageUrl     TEXT,";
    NSString* tbl1_sql7 = @" list_body         TEXT);";
    NSString* tbl1_MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", tbl1_sql1, tbl1_sql2, tbl1_sql3, tbl1_sql4, tbl1_sql5, tbl1_sql6, tbl1_sql7];
    if (![DbAccess executeUpdate:tbl1_MakeSQL]) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //ビーコンログテーブル作成
    NSString* tbl2_sql1 = @"CREATE TABLE IF NOT EXISTS tbl_becon_log (";
    NSString* tbl2_sql2 = @" log_record_id   INTEGER UNIQUE PRIMARY KEY,";
    NSString* tbl2_sql3 = @" log_date        DATETIME,";
    NSString* tbl2_sql4 = @" log_UUID        TEXT,";
    NSString* tbl2_sql5 = @" log_major       INTEGER,";
    NSString* tbl2_sql6 = @" log_minor       INTEGER,";
    NSString* tbl2_sql7 = @" log_rssi        INTEGER,";
    NSString* tbl2_sql8 = @" log_accuracy    REAL,";
    NSString* tbl2_sql9 = @" log_state       INTEGER);";
    NSString* tbl2_MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", tbl2_sql1, tbl2_sql2, tbl2_sql3, tbl2_sql4, tbl2_sql5, tbl2_sql6, tbl2_sql7, tbl2_sql8, tbl2_sql9];
    if (![DbAccess executeUpdate:tbl2_MakeSQL]) {
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


// ビーコンデータ保存処理
+ (BOOL)Set_BeconLogList:(Beacon_LogListDataModel*)bicon_logDataListset
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //１日分のデータ範囲とする
    NSDateComponents *comps;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:bicon_logDataListset.log_date];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    NSDate *dt_start = [calendar dateFromComponents:comps];
    
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:bicon_logDataListset.log_date];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *dt_end = [calendar dateFromComponents:comps];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" log_record_id,";
    NSString* Sql3 = @" log_date,";
    NSString* Sql4 = @" log_uuid,";
    NSString* Sql5 = @" log_major,";
    NSString* Sql6 = @" log_minor,";
    NSString* Sql7 = @" log_rssi,";
    NSString* Sql8 = @" log_accuracy";
    NSString* Sql9 = @" FROM tbl_becon_log";
    NSString* Sql10 = @" WHERE";
    NSString* Sql11 = @" ? <= log_date AND log_date <= ?";
    NSString* Sql12 = [NSString stringWithFormat:@" AND log_major = %i AND log_minor = %i;", bicon_logDataListset.log_major, bicon_logDataListset.log_minor];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9,Sql10,Sql11,Sql12];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL,dt_start,dt_end];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    BOOL bln_chkday = NO;
    while( [results next] )
    {
        bln_chkday = YES;
    }
    
    //その日のデータが無い場合に保存
    if(bln_chkday == NO){
        //データ保存
        NSString* sql1 = @"INSERT INTO tbl_becon_log";
        NSString* sql2 = @" (log_date, log_uuid, log_major, log_minor, log_rssi, log_accuracy, log_state) VALUES ";
        NSString* sql3 = [NSString stringWithFormat:@"( ?, '%@', %i, %i, %ld, %f, %ld);",
                          bicon_logDataListset.log_UUID,
                          bicon_logDataListset.log_major,
                          bicon_logDataListset.log_minor,
                          bicon_logDataListset.log_rssi,
                          bicon_logDataListset.log_accuracy,
                          bicon_logDataListset.log_state];
        NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@",sql1, sql2, sql3];
        if (![DbAccess executeUpdate:MakeSQL, bicon_logDataListset.log_date]) {
            NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
        }
        
        return YES;
    }else{
        return NO;
    }
    
    //データベースクローズ
    [DbAccess close];
}

//ビーコンデータ サーバーデータ同期処理
+ (void)set_BeconLogList_serverReUp
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //サーバーとの同期処理
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" log_record_id,";
    NSString* Sql3 = @" log_date,";
    NSString* Sql4 = @" log_uuid,";
    NSString* Sql5 = @" log_major,";
    NSString* Sql6 = @" log_minor,";
    NSString* Sql7 = @" log_rssi,";
    NSString* Sql8 = @" log_accuracy,";
    NSString* Sql9 = @" log_state";
    NSString* Sql10 = @" FROM tbl_becon_log";
    NSString* Sql11 = @" WHERE";
    NSString* Sql12 = @" log_state = 0";
    NSString* Sql13 = @" ORDER BY log_date;";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9,Sql10,Sql11,Sql12,Sql13];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        Beacon_LogListDataModel *beaconLogDataModel = [[Beacon_LogListDataModel alloc] init];
        beaconLogDataModel.log_record_id = [results longForColumn:@"log_record_id"];
        beaconLogDataModel.log_date = [results dateForColumn:@"log_date"];
        beaconLogDataModel.log_UUID = [results stringForColumn:@"log_uuid"];
        beaconLogDataModel.log_major = [results longForColumn:@"log_major"];
        beaconLogDataModel.log_minor = [results longForColumn:@"log_minor"];
        beaconLogDataModel.log_rssi = [results longForColumn:@"log_rssi"];
        beaconLogDataModel.log_accuracy = [results doubleForColumn:@"log_accuracy"];
        beaconLogDataModel.log_state = [results longForColumn:@"log_state"];
        [dbBox addObject:beaconLogDataModel];
    }
    
    if(dbBox.count > 0){
        NSLog(@"サーバーと更新処理を実行");
        
        
        
        
        
        
        
    }
    
    //データベースクローズ
    [DbAccess close];
}




// ビーコンデータ取得処理（有効データ取得）
+ (NSMutableArray*)Get_BeconLogList_EffectiveData
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" log_record_id,";
    NSString* Sql3 = @" log_date,";
    NSString* Sql4 = @" log_uuid,";
    NSString* Sql5 = @" log_major,";
    NSString* Sql6 = @" log_minor,";
    NSString* Sql7 = @" log_rssi,";
    NSString* Sql8 = @" log_accuracy,";
    NSString* Sql9 = @" log_state";
    NSString* Sql10 = @" FROM tbl_becon_log";
    NSString* Sql11 = @" WHERE";
    NSString* Sql12 = @" log_state = 0";
    NSString* Sql13 = @" ORDER BY log_date;";
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9,Sql10,Sql11,Sql12,Sql13];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        Beacon_LogListDataModel *beaconLogDataModel = [[Beacon_LogListDataModel alloc] init];
        beaconLogDataModel.log_record_id = [results longForColumn:@"log_record_id"];
        beaconLogDataModel.log_date = [results dateForColumn:@"log_date"];
        beaconLogDataModel.log_UUID = [results stringForColumn:@"log_uuid"];
        beaconLogDataModel.log_major = [results longForColumn:@"log_major"];
        beaconLogDataModel.log_minor = [results longForColumn:@"log_minor"];
        beaconLogDataModel.log_rssi = [results longForColumn:@"log_rssi"];
        beaconLogDataModel.log_accuracy = [results doubleForColumn:@"log_accuracy"];
        beaconLogDataModel.log_state = [results longForColumn:@"log_state"];
        [dbBox addObject:beaconLogDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}

// ビーコンデータ取得処理（指定日一日分のデータ取得）
+ (NSMutableArray*)Get_BeconLogList_OnedaySerch:(NSDate*)dt
{
    //データベース接続
    FMDatabase* DbAccess = [self _getDB:DBFILE];
    
    //１日分のデータ範囲とする
    NSDateComponents *comps;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dt];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    NSDate *dt_start = [calendar dateFromComponents:comps];
    
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dt];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *dt_end = [calendar dateFromComponents:comps];
    
    //管理データ取得
    NSString* Sql1 = @"SELECT";
    NSString* Sql2 = @" log_record_id,";
    NSString* Sql3 = @" log_date,";
    NSString* Sql4 = @" log_uuid,";
    NSString* Sql5 = @" log_major,";
    NSString* Sql6 = @" log_minor,";
    NSString* Sql7 = @" log_rssi,";
    NSString* Sql8 = @" log_accuracy,";
    NSString* Sql9 = @" log_state";
    NSString* Sql10 = @" FROM tbl_becon_log";
    NSString* Sql11 = @" WHERE";
    NSString* Sql12 = [NSString stringWithFormat:@" '%@' <= log_date AND log_date <= '%@';", dt_start, dt_end];
    NSString* MakeSQL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",Sql1,Sql2,Sql3,Sql4,Sql5,Sql6,Sql7,Sql8,Sql9,Sql10,Sql11,Sql12];
    FMResultSet* results = [DbAccess executeQuery:MakeSQL];
    if (!results) {
        NSLog(@"ERROR: %d: %@", [DbAccess lastErrorCode], [DbAccess lastErrorMessage]);
    }
    
    //データ格納
    NSMutableArray *dbBox = [NSMutableArray array];
    while( [results next] )
    {
        Beacon_LogListDataModel *beaconLogDataModel = [[Beacon_LogListDataModel alloc] init];
        beaconLogDataModel.log_record_id = [results longForColumn:@"log_record_id"];
        beaconLogDataModel.log_date = [results dateForColumn:@"log_date"];
        beaconLogDataModel.log_UUID = [results stringForColumn:@"log_uuid"];
        beaconLogDataModel.log_major = [results longForColumn:@"log_major"];
        beaconLogDataModel.log_minor = [results longForColumn:@"log_minor"];
        beaconLogDataModel.log_rssi = [results longForColumn:@"log_rssi"];
        beaconLogDataModel.log_accuracy = [results doubleForColumn:@"log_accuracy"];
        beaconLogDataModel.log_state = [results longForColumn:@"log_state"];
        [dbBox addObject:beaconLogDataModel];
    }
    
    //データベースクローズ
    [DbAccess close];
    
    return dbBox;
}


@end
