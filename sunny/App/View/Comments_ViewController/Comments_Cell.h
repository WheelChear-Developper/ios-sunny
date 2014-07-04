//
//  Comments_Cell.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"

@interface Comments_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) NSString *str_comment;

@property (nonatomic,retain)NSMutableData *mData;
@end