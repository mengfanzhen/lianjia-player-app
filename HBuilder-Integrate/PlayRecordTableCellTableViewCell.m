//
//  PlayRecordTableCellTableViewCell.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/29.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "PlayRecordTableCellTableViewCell.h"

@implementation PlayRecordTableCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_courseImg release];
    [_courseName release];
    [_progress release];
    [_date release];
    [super dealloc];
}
@end
