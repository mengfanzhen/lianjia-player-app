//
//  DownloadListController.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/1/21.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "DownloadListController.h"
#import "AppDelegate.h"
#import "CourseTableCell.h"
#import "FilesDownManage.h"

@interface DownloadListController ()
@property(retain,nonatomic) NSMutableArray *chapterArray;
@property(retain,nonatomic) UIBarButtonItem *editBtn;

@end
@implementation DownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下载中心";
    //self.navigationController.navigationBar.topItem.title=@"下载管理";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    _editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(setEditMode)];
    _editBtn.tag = 999;//可以编辑
    self.navigationItem.rightBarButtonItem = _editBtn;
    [_editBtn release];
    //_chapterArray = [[self getTableViewData] retain];
    _finishedTable.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];

    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_finishedTable setTableFooterView:v];
    
    
    self.downingSetEditModeFlag = @"0";
    
    
}
-(void)setEditMode{
    if (_editBtn.tag == 999) {
        [_finishedTable setEditing:YES animated:YES];
        _editBtn.tag = 0;
        _editBtn.title = @"完成";
    }else{
        [_finishedTable setEditing:NO animated:YES];
        _editBtn.tag = 999;
        _editBtn.title = @"编辑";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.chapterArray = [self getTableViewData] ;
    
    [_finishedTable reloadData];
    
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLayoutSubviews
{
    if ([_finishedTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_finishedTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_finishedTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_finishedTable setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)updateImageForCellAtIndexPath:(NSMutableDictionary *)dict
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSIndexPath *index = [dict objectForKey:@"indexPath"];
    NSDictionary *lineDict = [dict objectForKey:@"lineDic"];

    CourseTableCell *cell = [_finishedTable cellForRowAtIndexPath:index];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[lineDict objectForKey:@"IMG_PATH"]]];
    
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
    CourseTableCell *cell = [_finishedTable cellForRowAtIndexPath:index];
    cell.courseImg.image = [UIImage imageWithData:imageData];
}


- (IBAction)goDownloadingView:(UIButton *)sender {
    _downloadingTable.hidden = NO;
    _finishedTable.hidden =YES;
    //clearallbtn.hidden = YES;
    self.finieshedViewBtn.selected = NO;
    self.downloadingViewBtn.selected = YES;
    [self.downloadingTable reloadData];
    
    
}

- (IBAction)goFinishedView:(UIButton *)sender {
    _downloadingTable.hidden = YES;
    _finishedTable.hidden =NO;
    //clearallbtn.hidden = NO;
    self.finieshedViewBtn.selected =YES;
    self.downloadingViewBtn.selected = NO;
    [self.finishedTable reloadData];
    //self.noLoadsInfo.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chapterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    CourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    NSDictionary *lineDic = [_chapterArray objectAtIndex:indexPath.row];
//    NSDictionary *lineDic = [_chapterArray objectAtIndex:0];
    cell.courseName.text= [lineDic objectForKey:@"NAME"];
    
//    if ([[lineDic objectForKey:@"FINISH_COUNT"] isEqualToString:[lineDic objectForKey:@"TOTAL"]]) {
//        cell.downloadSchedule.text = @"已全部下载";
//    }else{
//        cell.downloadSchedule.text =[NSString stringWithFormat:@"%@/%@",[lineDic objectForKey:@"FINISH_COUNT"],[lineDic objectForKey:@"TOTAL"]] ;
//    }
    cell.downloadSchedule.text =[NSString stringWithFormat:@"下载 %@/%@",[lineDic objectForKey:@"FINISH_COUNT"],[lineDic objectForKey:@"TOTAL"]] ;


    
//    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[lineDic objectForKey:@"IMG_PATH"]]];
//
//    cell.courseImg.image = [UIImage imageWithData:data];
    NSMutableDictionary *lineDictTemp = [NSMutableDictionary dictionary];
    [lineDictTemp setObject:lineDic forKey:@"lineDic" ];
    [lineDictTemp setObject:indexPath forKey:@"indexPath" ];

    [NSThread detachNewThreadSelector:@selector(updateImageForCellAtIndexPath:) toTarget:self withObject:lineDictTemp];
    cell.totalSizeLabel.text = [NSString stringWithFormat:@"%@M",[lineDic objectForKey:@"TOTAL_SIZE"]];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView.tag == 10) {
            NSDictionary *lineDic = [_chapterArray objectAtIndex:indexPath.row];
            NSString *courseId = [lineDic objectForKey:@"ID"];
            [self deleteCourseWithCourseId:courseId];
            // Delete the row from the data source
            [_chapterArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//初始化数据，并将要下载章节入库
-(void)initDownLoadDataWithDic:(NSDictionary *) dic{
    
    
    NSArray *chapterList = [dic objectForKey:@"chapterList"];
    _chapterArray = chapterList;
    
    NSDictionary *lineContentDic = [dic objectForKey:@"lineContent"];
    
    NSString *courseId = [lineContentDic objectForKey:@"id"];
    
    NSString *courseName = [lineContentDic objectForKey:@"videoName"];

    NSString *teacher = [lineContentDic objectForKey:@"teacher"];
    
    NSString *imgPath = [lineContentDic objectForKey:@"videoUrl"];

    
    //入库课程表
    NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM COURSE_LIST WHERE ID='%@' " ,courseId ];
    
    NSLog(@"查询是否已经存在课程的sql = %@", querySql);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    int total = 0;
    if (rs.next) {
        total = [rs intForColumn:@"TOTAL"];
    }
    
    [appDelegate.db beginTransaction];

    if (total == 0) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO COURSE_LIST(ID,NAME,TEACHER,IMG_PATH) VALUES('%@','%@','%@','%@')",courseId,courseName,teacher,imgPath];
        
        NSLog(@"插入课程的sql = %@",insertSql);
        [appDelegate.db executeUpdate:insertSql];
        
    }
    
    //插入小节，先删后插
    for (int i =  0; i < chapterList.count; i++) {
        
        NSDictionary *lineDic = [chapterList objectAtIndex:i];
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE ID = '%@'",[lineDic objectForKey:@"id"]];
        
        NSLog(@"for each %d delete sql = %@",i,sql );

        [appDelegate.db executeUpdate:sql];
        
//        sql = [NSString stringWithFormat:@"INSERT INTO CHAPTER_LIST(ID,NAME,DOWNLOAD_PATH,DURATION,SCHEDULE,SIZE,COURSE_ID,DOWNLOAD_FINISH) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",[lineDic objectForKey:@"id"],[lineDic objectForKey:@"name"],[lineDic objectForKey:@"path"]];
        
        //获取文件名字
        NSString *downloadPath =[lineDic objectForKey:@"path"];
        NSArray *tempArray = [downloadPath componentsSeparatedByString:@"/"];
        NSString *fileName = [tempArray lastObject];
        
        sql = [NSString stringWithFormat:@"INSERT INTO CHAPTER_LIST(ID,NAME,DOWNLOAD_PATH,DURATION,SCHEDULE,SIZE,COURSE_ID,DOWNLOAD_FINISH,FILE_NAME) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",[lineDic objectForKey:@"id"],[lineDic objectForKey:@"name"],[lineDic objectForKey:@"path"],@"0",@"0",@"0",courseId,@"0",fileName];
        
        NSLog(@"for each %d insert sql = %@",i,sql );
        
        [appDelegate.db executeUpdate:sql];
    }
    
    [appDelegate.db commit];
    
}

//获取列表数据
-(NSArray *)getTableViewData{
    NSMutableArray *tvArray = [NSMutableArray array];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT COL.ID,COL.NAME,COL.TEACHER,COL.IMG_PATH,COUNT(1) TOTAL,SUM(CASE WHEN DOWNLOAD_FINISH = '2' THEN 1 ELSE 0 END ) FINISH_COUNT,SUM(CASE WHEN DOWNLOAD_FINISH = '2' THEN SIZE/1024/1024 ELSE 0 END) TOTAL_SIZE FROM COURSE_LIST COL,CHAPTER_LIST  CHL WHERE COL.ID = CHL.COURSE_ID GROUP BY COL.ID,COL.NAME,COL.TEACHER,COL.IMG_PATH"];
    
    NSLog(@"下载管理课程列表下载 sql = %@",querySql);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    while (rs.next) {
        NSMutableDictionary *lineDict = [NSMutableDictionary dictionary];
        [lineDict setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];
        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@"NAME"];
        [lineDict setObject:[rs stringForColumn:@"IMG_PATH"] forKey:@"IMG_PATH"];
        [lineDict setObject:[rs stringForColumn:@"TOTAL"] forKey:@"TOTAL"];
        [lineDict setObject:[rs stringForColumn:@"FINISH_COUNT"] forKey:@"FINISH_COUNT"];
        [lineDict setObject:[rs stringForColumn:@"TOTAL_SIZE"] forKey:@"TOTAL_SIZE"];

        [tvArray addObject:lineDict];
    }
    
    return tvArray;
}
//删除列表：删除本地文件,删除课程表，删除章节表，
-(void)deleteCourseWithCourseId:(NSString *)courseId{
    
    
    //删除finished的文件和记录
    while ([FilesDownManage sharedFilesDownManage].finishedlist.count > 0) {
        FileModel *selectFile = [[FilesDownManage sharedFilesDownManage].finishedlist objectAtIndex:0];
        [[FilesDownManage sharedFilesDownManage]  deleteFinishFile:selectFile];
    }
    
    //删除downloading的文件和记录
    while ([FilesDownManage sharedFilesDownManage].downinglist.count >0) {
        MidHttpRequest *theRequest=[[FilesDownManage sharedFilesDownManage].downinglist objectAtIndex:0];
        [[FilesDownManage sharedFilesDownManage] deleteRequest:theRequest];
        
    }
    
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//
//    //查询课程下有哪些章节
//    NSString *querySql = [NSString stringWithFormat:@"SELECT FILE_NAME FROM CHAPTER_LIST WHERE COURSE_ID = '%@'",courseId];
//    NSLog(@"查询课程下所有章节的sql=%@",querySql);
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//
//    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
//    
//    while ([rs next]) {
//        NSString *fileName = [rs stringForColumn:@"FILE_NAME"];
//        
//        NSString *deleteFilePath  = [NSString stringWithFormat:@"%@/downloads/%@",documentsDirectory,fileName];
//        NSLog(@"要删除的文件目录为%@",deleteFilePath);
//        [[NSFileManager defaultManager ] removeItemAtPath:deleteFilePath error:nil];
//        //根据fileName 到document目录下删除对应文件
//    }
//    
//    
//    NSString *delCourse = [NSString stringWithFormat:@"DELETE FROM COURSE_LIST WHERE ID ='%@'",courseId];
//    
//    NSLog(@"删除课程的sql=%@",delCourse);
//    NSString *delChapter = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE COURSE_ID ='%@'",courseId];
//    NSLog(@"删除章节的sql=%@",delChapter);
//    
//    
//
//    [appDelegate.db beginTransaction];
//    [appDelegate.db executeUpdate:delChapter];
//    [appDelegate.db executeUpdate:delCourse];
//    [appDelegate.db commit];

}


- (void)dealloc {
    [_chapterArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    [_chapterArray release];
    [super viewDidUnload];
}
@end
