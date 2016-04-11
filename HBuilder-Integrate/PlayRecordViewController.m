//
//  PlayRecordViewController.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/29.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "PlayRecordViewController.h"
#import "AppDelegate.h"
#import "PlayRecordTableCellTableViewCell.h"
#import "MBProgressHUD.h"
#import "MoviePlayerViewController.h"

@interface PlayRecordViewController ()

@end

@implementation PlayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTableArray];
    
    
    if ([self.tableArray count] == 0) {
        [self showAllTextDialog:@"暂无播放记录"];
    }
    
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    //左侧按钮
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    
//    [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"lrtico.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    
//    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIImage *backImg = [UIImage imageNamed:@"lrtico.png"];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg.size.width/2, backImg.size.height/2)];
    
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setImage:backImg forState:UIControlStateNormal];
    UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, -6, 0);
    [backBtnView addSubview:backBtn];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    self.navigationItem.leftBarButtonItem = backBarBtn;

    
    
    //右侧按钮
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [rightButton addTarget:self action:@selector(deletePlayRecord) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_delete_d.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    rightBtn.tag = 0;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    self.navigationItem.title = @"播放记录";
    

    // Do any additional setup after loading the view.
}
-(void)goback{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)deletePlayRecord{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除" message:@"是否删除全部播放记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getTableArray{
    
    NSString *querySql = @"SELECT IMG_PATH,CHAPTER_NAME,SECONDS,DATE,COURSE_ID,CHAPTER_ID FROM PLAY_RECORDS ORDER BY DATE DESC";
    
    NSLog(@"查询播放记录sql == %@",querySql);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    if (_tableArray == nil ) {
        _tableArray  = [[NSMutableArray alloc] init];
    }else{
        [_tableArray removeAllObjects];
    }
    
    while (rs.next) {
        NSMutableDictionary *lineDict =  [ NSMutableDictionary dictionary];
        [lineDict setObject:[rs stringForColumn:@"IMG_PATH"] forKey:@"IMG_PATH"];
        NSString *secondsStr = [rs stringForColumn:@"SECONDS"];
        [lineDict setObject:[self formateTime:secondsStr] forKey:@"SECONDS"];
        [lineDict setObject:[rs stringForColumn:@"CHAPTER_NAME"] forKey:@"NAME"];
        NSString *date = [rs stringForColumn:@"DATE"];
        [lineDict setObject:[date substringToIndex:11] forKey:@"DATE"];
        [lineDict setObject:[rs stringForColumn:@"COURSE_ID"] forKey:@"COURSE_ID"];
        [lineDict setObject:[rs stringForColumn:@"CHAPTER_ID"] forKey:@"CHAPTER_ID"];

        [_tableArray  addObject:lineDict];
    }
}
//将秒转为分钟
-(NSString *)formateTime:(NSString *)seconds{
    
    int secondsInt = seconds.intValue;
    
    int minute = secondsInt/60;
    
    int hour = minute/60;
    
    int second = secondsInt%60;
    
    minute %= 60;
    
    NSString * minuteStr = [NSString stringWithFormat:@"%d",minute];
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%@",minuteStr];
    }
    
    
    NSString * secondStr = [NSString stringWithFormat:@"%d",second];
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%@",secondStr];
    }
    
    NSString *hourStr = [NSString stringWithFormat:@"%d",hour];
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%@",hourStr];
    }
    
    
    if (hour == 0) {
        return [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    }else{
        return [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondStr];

    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"playrecordcell";
    PlayRecordTableCellTableViewCell *cell=(PlayRecordTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *lineDict = [_tableArray objectAtIndex:indexPath.row];
    
    
    cell.courseName.text = [lineDict objectForKey:@"NAME"];
    cell.progress.text = [NSString stringWithFormat:@"观看进度: %@",[lineDict objectForKey:@"SECONDS"]];
    cell.date.text = [NSString stringWithFormat:@"观看时间: %@",[lineDict objectForKey:@"DATE"]];

    
    NSString *imagePath = [lineDict objectForKey:@"IMG_PATH"];;
    NSMutableDictionary *lineDictTemp = [NSMutableDictionary dictionary];
    [lineDictTemp setObject:imagePath forKey:@"imagePath" ];
    [lineDictTemp setObject:indexPath forKey:@"indexPath" ];
    
    [NSThread detachNewThreadSelector:@selector(updateImageForCellAtIndexPath:) toTarget:self withObject:lineDictTemp];
        return cell;
    
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
    
}


//点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *lineDict = [_tableArray objectAtIndex:indexPath.row];
    
    NSString *courseId = [lineDict objectForKey:@"COURSE_ID"];
    
    NSString *playIndexId = [lineDict objectForKey:@"CHAPTER_ID"];

//
//    int playIndex = indexPath.row;
//    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.firstFlag = nil;
//    
//    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc] initLocalMoviePlayerViewControllerWithChapterList:_tableArray playIndex:playIndex courseName:courseName];
//    [self presentViewController:movieVC animated:YES completion:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.ljabc.com.cn/app/classRoom/getCourseByCourseId.html?courseId=%@",courseId]];
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRange subRange = NSMakeRange(5, jsonStr.length - 6);
    
    jsonStr = [jsonStr substringWithRange:subRange];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:nil];
    
    NSDictionary *resultDict = [dic objectForKey:@"result"];
    
    
    NSArray *chapterList = [resultDict objectForKey:@"chapterList"];
    
    NSDictionary *lineContentDic = [resultDict objectForKey:@"lineContent"];
    NSString *courseName = [lineContentDic objectForKey:@"videoName"];
    NSString *imgPath = [lineContentDic objectForKey:@"videoUrl"];
    
    
    int playIndex = 99999;
    for (int i = 0; i< [chapterList count]; i++) {
        NSDictionary *lineDict = [chapterList objectAtIndex:i];
        if ([playIndexId isEqualToString:[lineDict objectForKey:@"id"]]) {
            playIndex = i;
            //测试
        }
    }
    if (playIndex == 99999) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"参数错误" message:@"传入参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    
    //            MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithJsonString:cbId playIndex:playIndex];
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithChapterList:chapterList playIndex:playIndex courseName:courseName courseId:courseId imgPath:imgPath];
    [self presentViewController:movieVC animated:YES completion:nil];
    [movieVC release];
    
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [self getTableArray];
    [_tv reloadData];
}
- (void)updateImageForCellAtIndexPath:(NSMutableDictionary *)dict
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSIndexPath *index = [dict objectForKey:@"indexPath"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"imagePath"]]];
    
    if (imageData != nil) {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:imageData forKey:@"imageData"];
        [parmDict setObject:index forKey:@"indexPath"];
        
        [self performSelectorOnMainThread:@selector(setImage:) withObject:parmDict waitUntilDone:NO];
    }
    
    
    [pool release];
}



-(void)setImage:(NSMutableDictionary *)dict{
    NSIndexPath *index = [dict objectForKey:@"indexPath"];
    NSData *imageData = [dict objectForKey:@"imageData"];
    PlayRecordTableCellTableViewCell *cell = [_tv cellForRowAtIndexPath:index];
    cell.courseImg.image = [UIImage imageWithData:imageData];
}
-(void)showAllTextDialog:(NSString *)str
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelFont = [UIFont systemFontOfSize:13.0f];
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    HUD.yOffset = 200.0f;
    //HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //        [HUD release];
    }];
    
}


//删除所有记录
- (void)deletePlayRecords {
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM  PLAY_RECORDS"];
    
    NSLog(@"删除所有播放记录的sql==%@",deleteSql);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate.db beginTransaction];
    
    [appDelegate.db executeUpdate:deleteSql];

    [appDelegate.db commit];
    
    [self getTableArray];
    
    [_tv reloadData];

}

//删除确认
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deletePlayRecords];
    }
}


- (void)dealloc {
    [_tv release];
    [super dealloc];
}
@end
