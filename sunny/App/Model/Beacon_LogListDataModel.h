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
@property(nonatomic, copy) NSString *log_major;     //機器番号１
@property(nonatomic, copy) NSString *log_minor;     //機器番号２
@property(nonatomic) long log_proximity;            //認識距離
@property(nonatomic) double log_accuracy;           //精度
@end
