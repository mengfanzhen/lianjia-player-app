//
//  DownloadNav.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/1/21.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "DownloadNav.h"

@interface DownloadNav ()
@property (retain, nonatomic) IBOutlet UITableView *downloadList;

@end


@implementation DownloadNav
@synthesize downloadList=_downloadList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
