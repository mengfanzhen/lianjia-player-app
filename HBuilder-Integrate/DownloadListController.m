//
//  DownloadListController.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/1/21.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "DownloadListController.h"
#import "AppDelegate.h"

@interface DownloadListController ()
@property (retain, nonatomic) IBOutlet UITableView *tv;
@property(retain,nonatomic) NSArray *chapterArray;

@end
@implementation DownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"下载管理";
    //self.navigationController.navigationBar.topItem.title=@"下载管理";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE ID = '%@'",[lineContentDic objectForKey:@"ID"]];
        [appDelegate.db executeUpdate:sql];
        
//        sql = [NSString stringWithFormat:@"INSERT INTO CHAPTER_LIST(ID,NAME,DOWNLOAD_PATH,DURATION,SCHEDULE,SIZE,COURSE_ID,DOWNLOAD_FINISH) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",[lineDic objectForKey:@"id"],[lineDic objectForKey:@"name"],[lineDic objectForKey:@"path"]];
        
        
        sql = [NSString stringWithFormat:@"INSERT INTO CHAPTER_LIST(ID,NAME,DOWNLOAD_PATH,DURATION,SCHEDULE,SIZE,COURSE_ID,DOWNLOAD_FINISH) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",[lineDic objectForKey:@"id"],[lineDic objectForKey:@"name"],[lineDic objectForKey:@"path"],@"0",@"0",@"0",courseId,@"0"];
        
        NSLog(@"for each %d sql = %@",i,sql );
        
        [appDelegate.db executeUpdate:sql];
    }
    
    [appDelegate.db commit];
    
}

-(NSArray *)getTableViewData{
    NSArray *tvArray = [NSArray array];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT ID,NAME,TEACHER,IMG_PATH FROM COURSE_LIST"];
    
    
    return tvArray;
}
- (void)dealloc {
    [_tv release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDownloadList:nil];
    [super viewDidUnload];
}
@end
