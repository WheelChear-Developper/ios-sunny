//
//  News_Cell.m
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "News_Cell.h"
#import "UILabel+EstimatedHeight.h"

@implementation News_Cell
{
    VerticallyAlignedLabel *Comment;
    AsyncImageView *ai;
}

@synthesize str_comment, str_imageurl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    int int_PosisonHeight = 0;
    
    // ラベルの高さ取得
    CGFloat flt_height = [UILabel xx_estimatedHeight:[UIFont systemFontOfSize:13]
                                                text:self.str_comment size:CGSizeMake(255, MAXFLOAT)];
    flt_height += 15 * 2;
    
    // コメント（１９文字X６行）
    if(self.str_comment.length >0){
        [Comment removeFromSuperview];
        Comment = [[VerticallyAlignedLabel alloc] init];
        Comment.frame = CGRectMake(35, 55  , 255, flt_height);
        Comment.verticalAlignment = VerticalAlignmentTop;
        Comment.numberOfLines = 50;
        [Comment setFont:[UIFont systemFontOfSize:13]];
        Comment.textColor = [UIColor darkGrayColor];
        Comment.text = self.str_comment;
        [self addSubview:Comment];
    }
    int_PosisonHeight = 55 + flt_height;
    
    //画像の非同期セット
    [ai removeFromSuperview];
    if([str_imageurl isEqual:@"<null>"]){
    }else if([str_imageurl isEqual:[NSNull null]]){
    }else{
        ai = [[AsyncImageView alloc] initWithFrame:CGRectMake(30, int_PosisonHeight, 260, 200)];
        [ai loadImage:str_imageurl];
        [self addSubview:ai];
        
        int_PosisonHeight += 200;
    }
        
    // コメント取得
    self.lbl_comment.text = @"コメント";
    NSString *URL = [NSString stringWithFormat:@"%@%@%ld%@",NSLocalizedString(@"Service_DomainURL",@""), NSLocalizedString(@"Service_CommentGet1URL",@""), self.lng_newsId, NSLocalizedString(@"Service_CommentGet2URL",@"")];
    NSURL *URL_STRING = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_STRING];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

///////////////////////// ↓　通信用メソッド　↓　//////////////////////////////
//通信開始時に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //初期化
    self.mData = [NSMutableData data];
}

//通信中常に呼ばれる
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //通信したデータを入れていきます
    [self.mData appendData:data];
}

//通信終了時に呼ばれる
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    //値の取得
    id json = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *jsonParser = (NSMutableArray*)json;
    
    // コメント件数設定
    self.lbl_comment.text = [NSString stringWithFormat:@"コメント（ %ld 件）",(long)jsonParser.count];
}

//通信エラー時に呼ばれる
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.lbl_comment.text = @"コメント出来ません（オフライン）";
}
///////////////////////// ↑　通信用メソッド　↑　//////////////////////////////

@end
