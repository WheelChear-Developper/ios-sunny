//
//  Stamp_Cell.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"

@interface Stamp_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@property (nonatomic,retain)NSMutableData *mData;
@end