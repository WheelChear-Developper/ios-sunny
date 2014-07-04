//
//  NewsView_ListDataModel.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsView_ListDataModel : NSObject

@property(nonatomic) long service_id;
@property(nonatomic) long service_time;
@property(nonatomic, copy) NSString *service_retime;
@property(nonatomic, copy) NSString *service_imageUrl;
@property(nonatomic, copy) UIImage *service_image;
@property(nonatomic, copy) NSString *service_title;
@property(nonatomic, copy) NSString *service_body;
@end
