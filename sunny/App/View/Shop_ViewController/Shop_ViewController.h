//
//  Shop_ViewController.h
//  Sunny
//
//  Created by Mobile-innovation, LLC. on 2014/07/01.
//  Copyright (c) 2014年 akafune. INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Shop_ViewController : UITableViewController <UIWebViewDelegate>
{

}

- (IBAction)btn_tel1:(id)sender;
- (IBAction)btn_tel2:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *map_view1;
@end
