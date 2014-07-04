//
//  News_Cell.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"
#import "AsyncImageView.h"

@interface News_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_hyoudai;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_comment;
@property (weak, nonatomic) NSString *str_comment;
@property (weak, nonatomic) NSString *str_imageurl;
@property (nonatomic) long lng_newsId;

@property (nonatomic,retain)NSMutableData *mData;
@end