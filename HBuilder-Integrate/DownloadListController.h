//
//  DownloadListController.h
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/1/21.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadListController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *downloadingViewBtn;
@property (retain, nonatomic) IBOutlet UIButton *finieshedViewBtn;
@property(nonatomic,retain)IBOutlet UITableView *downloadingTable;
@property(nonatomic,retain)IBOutlet UITableView *finishedTable;
@property(nonatomic,retain) NSString *downingSetEditModeFlag;//下载列表是否能够删除的标记

-(void)initDownLoadDataWithDic:(NSDictionary *) dic;
@end
