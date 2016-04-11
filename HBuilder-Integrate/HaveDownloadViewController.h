//
//  HaveDownloadViewController.h
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/13.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaveDownloadViewController : UIViewController< UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) NSString *courseId;

@property(nonatomic,retain) NSMutableArray *tableArray;

@property (retain, nonatomic) IBOutlet UITableView *tv;
@property (retain,nonatomic) NSMutableArray *downloadSelectList;

@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *deleteOKBtn;



@end
