//
//  CourseCell.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/1/22.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "CourseTableCell.h"

@implementation CourseTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_courseName release];
    [_downloadSchedule release];
    [_courseImg release];
    [_totalSizeLabel release];
    [super dealloc];
}
@end
