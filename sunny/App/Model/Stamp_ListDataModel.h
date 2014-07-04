//
//  Stamp.h
//  sunny
//
//  Created by MacNote on 2014/07/02.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stamp_ListDataModel : NSObject

@property(nonatomic) long stamp_id;
@property(nonatomic, copy) NSString *stamp_Name;
@property(nonatomic, copy) NSString *stamp_createdAt;
@end
