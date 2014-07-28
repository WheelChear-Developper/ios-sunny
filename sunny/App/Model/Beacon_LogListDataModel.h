//
//  Beacon_LogListDataModel.h
//  matchingslot
//
//  Created by SMARTTECNO. on 2014/03/11.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon_LogListDataModel : NSObject

@property(nonatomic) long log_record_id;
@property(nonatomic, strong) NSDate *log_date;      //取得日付
@property(nonatomic, copy) NSString *log_UUID;      //UUID
@property(nonatomic) NSInteger log_major;           //機器番号１
@property(nonatomic) NSInteger log_minor;           //機器番号２
@property(nonatomic) long log_rssi;                 //認識距離
@property(nonatomic) double log_accuracy;           //精度
@property(nonatomic) long log_state;                //ログ保存のサーバーへの状態（０：未登録、１：登録済み）
@end
