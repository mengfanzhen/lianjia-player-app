//
//  HaveDownloadTableViewCell.h
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/13.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaveDownloadTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *chapterName;
@property (retain, nonatomic) IBOutlet UILabel *size;
@property (retain, nonatomic) IBOutlet UIButton *checkBtn;
@property (retain, nonatomic) IBOutlet UIView *moveView;

@end
