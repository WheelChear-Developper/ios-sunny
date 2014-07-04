//
//  Comments_ListDataModel.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments_ListDataModel : NSObject

@property(nonatomic) long comments_id;
@property(nonatomic) long comments_userId;
@property(nonatomic, copy) NSString *comments_userName;
@property(nonatomic, copy) NSString *comments_body;
@property(nonatomic, copy) NSString *comments_createdAt;
@end