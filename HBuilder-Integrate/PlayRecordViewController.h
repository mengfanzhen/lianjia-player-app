//
//  PlayRecordViewController.h
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/29.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRecordViewController : UIViewController< UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,retain) NSMutableArray *tableArray;

@property (retain, nonatomic) IBOutlet UITableView *tv;

@end
