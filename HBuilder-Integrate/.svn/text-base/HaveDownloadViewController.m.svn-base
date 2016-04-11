//
//  HaveDownloadViewController.m
//  HBuilder-Integrate
//
//  Created by mengfanzhen on 16/2/13.
//  Copyright © 2016年 DCloud. All rights reserved.
//

#import "HaveDownloadViewController.h"
#import "AppDelegate.h"
#import "FMResultSet.h"
#import "HaveDownloadTableViewCell.h"
#import "CommonHelper.h"
#import "FilesDownManage.h"
#import "MoviePlayerViewController.h"
#import "MBProgressHUD.h"
@interface HaveDownloadViewController ()

@end

@implementation HaveDownloadViewController

- (void)viewDidLoad {
    [self getTableArray];
    
    
    
//    self.title = @"已下载";

    [super viewDidLoad];
    
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
//    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//
//    [backButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    
//    //[backButton setBackgroundImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateNormal];
//    
//    
//    [backButton setBackgroundImage:[UIImage imageNamed:@"lrtico.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//    
//    
//    
//    
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

    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [rightButton addTarget:self action:@selector(setDeleteMode) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_delete_d.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    rightBtn.tag = 0;
    self.navigationItem.rightBarButtonItem = rightBtn;
    

    
    //[self showAllTextDialog:@"左滑进行删除操作" ];
    
    
    self.downloadSelectList  = [NSMutableArray array];
    

    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;

    //UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    //UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    // Do any additional setup after loading the view.
}
//-(void)setDeleteMode{
//    if (self.navigationItem.rightBarButtonItem.tag == 0 ) {
//        [UIView animateWithDuration:.1 animations:^{
//            
//            for (NSIndexPath* i in [finishedTable indexPathsForVisibleRows])
//            {
//                FinishedCell *cell = [finishedTable cellForRowAtIndexPath:i];
//                
//                if ([self.downloadSelectList containsObject:i]) {
//                    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
//                }else{
//                    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
//                }
//                
//                
//                cell.fileImage.frame = CGRectMake(cell.fileImage.frame.origin.x + 25, cell.fileImage.frame.origin.y, cell.fileImage.frame.size.width, cell.fileImage.frame.size.height);
//                cell.fileName.frame  = CGRectMake(cell.fileName.frame.origin.x + 25, cell.fileName.frame.origin.y, cell.fileName.frame.size.width, cell.fileName.frame.size.height);
//                cell.finishCountLabel.frame =CGRectMake(cell.finishCountLabel.frame.origin.x + 25, cell.finishCountLabel.frame.origin.y, cell.finishCountLabel.frame.size.width, cell.finishCountLabel.frame.size.height);
//                cell.fileSize.frame = CGRectMake(cell.fileSize.frame.origin.x + 25, cell.fileSize.frame.origin.y, cell.fileSize.frame.size.width, cell.fileSize.frame.size.height);
//                cell.checkBtn.hidden = NO;
//                [cell bringSubviewToFront:cell.checkBtn];
//                _cancelBtn.hidden = NO;
//                _deleteOKBtn.hidden = NO;
//                self.navigationItem.rightBarButtonItem.tag = 99;
//                
//                self.diskInfoLab1.frame = CGRectMake(self.diskInfoLab1.frame.origin.x, self.diskInfoLab1.frame.origin.y -45, self.diskInfoLab1.frame.size.width, self.diskInfoLab1.frame.size.height);
//                
//                self.diskInfoLab.frame = CGRectMake(self.diskInfoLab.frame.origin.x, self.diskInfoLab.frame.origin.y -45, self.diskInfoLab.frame.size.width, self.diskInfoLab.frame.size.height);
//                
//                
//                
//            }
//            
//        } completion:^(BOOL finished){
//            
//        }];
//    }
//    
//    
//    
//}
//
//
//-(IBAction)cancelClick{
//    self.navigationItem.rightBarButtonItem.tag = 0;
//    
//    [UIView animateWithDuration:.3 animations:^{
//        
//        for (NSIndexPath* i in [finishedTable indexPathsForVisibleRows])
//        {
//            FinishedCell *cell = [finishedTable cellForRowAtIndexPath:i];
//            
//            
//            
//            cell.fileImage.frame = CGRectMake(cell.fileImage.frame.origin.x - 25, cell.fileImage.frame.origin.y, cell.fileImage.frame.size.width, cell.fileImage.frame.size.height);
//            cell.fileName.frame  = CGRectMake(cell.fileName.frame.origin.x - 25, cell.fileName.frame.origin.y, cell.fileName.frame.size.width, cell.fileName.frame.size.height);
//            cell.finishCountLabel.frame =CGRectMake(cell.finishCountLabel.frame.origin.x - 25, cell.finishCountLabel.frame.origin.y, cell.finishCountLabel.frame.size.width, cell.finishCountLabel.frame.size.height);
//            cell.fileSize.frame = CGRectMake(cell.fileSize.frame.origin.x - 25, cell.fileSize.frame.origin.y, cell.fileSize.frame.size.width, cell.fileSize.frame.size.height);
//            cell.checkBtn.hidden = YES;
//            
//            self.diskInfoLab1.frame = CGRectMake(self.diskInfoLab1.frame.origin.x, self.diskInfoLab1.frame.origin.y + 45, self.diskInfoLab1.frame.size.width, self.diskInfoLab1.frame.size.height);
//            
//            self.diskInfoLab.frame = CGRectMake(self.diskInfoLab.frame.origin.x, self.diskInfoLab.frame.origin.y  + 45, self.diskInfoLab.frame.size.width, self.diskInfoLab.frame.size.height);
//            
//            _cancelBtn.hidden = YES;
//            _deleteOKBtn.hidden = YES;
//            
//        }
//        
//    } completion:^(BOOL finished){
//        
//        
//    }];
//    
//    
//}
//
//-(IBAction)deleteOKClick{
//    
//    
//    NSMutableArray *deleteCouresArray = [NSMutableArray array];
//    for (int i = 0 ; i < [_downloadSelectList count]; i++) {
//        NSIndexPath *indexPath = [_downloadSelectList objectAtIndex:i];
//        [deleteCouresArray addObject:[finishedList objectAtIndex:indexPath.row]];
//        [finishedList removeObjectAtIndex:indexPath.row];
//    }
//    [[FilesDownManage sharedFilesDownManage]  deleteFinishGroup:deleteCouresArray];
//    
//    
//    [_downloadSelectList removeAllObjects];
//    
//    self.navigationItem.rightBarButtonItem.tag = 0;
//    
//    [UIView animateWithDuration:.3 animations:^{
//        
//        for (NSIndexPath* i in [finishedTable indexPathsForVisibleRows])
//        {
//            FinishedCell *cell = [finishedTable cellForRowAtIndexPath:i];
//            
//            
//            
//            cell.fileImage.frame = CGRectMake(cell.fileImage.frame.origin.x - 25, cell.fileImage.frame.origin.y, cell.fileImage.frame.size.width, cell.fileImage.frame.size.height);
//            cell.fileName.frame  = CGRectMake(cell.fileName.frame.origin.x - 25, cell.fileName.frame.origin.y, cell.fileName.frame.size.width, cell.fileName.frame.size.height);
//            cell.finishCountLabel.frame =CGRectMake(cell.finishCountLabel.frame.origin.x - 25, cell.finishCountLabel.frame.origin.y, cell.finishCountLabel.frame.size.width, cell.finishCountLabel.frame.size.height);
//            cell.fileSize.frame = CGRectMake(cell.fileSize.frame.origin.x - 25, cell.fileSize.frame.origin.y, cell.fileSize.frame.size.width, cell.fileSize.frame.size.height);
//            cell.checkBtn.hidden = YES;
//            
//            self.diskInfoLab1.frame = CGRectMake(self.diskInfoLab1.frame.origin.x, self.diskInfoLab1.frame.origin.y + 45, self.diskInfoLab1.frame.size.width, self.diskInfoLab1.frame.size.height);
//            
//            self.diskInfoLab.frame = CGRectMake(self.diskInfoLab.frame.origin.x, self.diskInfoLab.frame.origin.y  + 45, self.diskInfoLab.frame.size.width, self.diskInfoLab.frame.size.height);
//            
//            _cancelBtn.hidden = YES;
//            _deleteOKBtn.hidden = YES;
//            
//        }
//        
//    } completion:^(BOOL finished){
//        [self.finishedTable reloadData];
//        self.diskInfoLab1.text = [CommonHelper getDiskSpaceInfo];
//        long totalDownloadSize = 0;
//        
//        for (int i = 0 ; i < [self.finishedList count]; i ++) {
//            NSDictionary *lineDict = [self.finishedList objectAtIndex:i];
//            NSString *totalSize = [lineDict objectForKey:@"TOTAL_SIZE"];
//            int size = totalSize.intValue;
//            totalDownloadSize += size;
//        }
//        self.diskInfoLab.text = [NSString stringWithFormat:@"已下载%.2fG",totalDownloadSize/1024.0f/1024.0f/1024.0f];
//        
//    }];
//    
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    NSLog(@"goback");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setDeleteMode{
    if (self.navigationItem.rightBarButtonItem.tag == 0 ) {
        [UIView animateWithDuration:.1 animations:^{
            
            for (NSIndexPath* i in [_tv indexPathsForVisibleRows])
            {
                HaveDownloadTableViewCell *cell = [_tv cellForRowAtIndexPath:i];
                
                if ([self.downloadSelectList containsObject:i]) {
                    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                }else{
                    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
                }
                
                

                cell.moveView.frame = CGRectMake(cell.moveView.frame.origin.x + 25, cell.moveView.frame.origin.y, cell.moveView.frame.size.width, cell.moveView.frame.size.height);
                cell.checkBtn.hidden = NO;
                [cell bringSubviewToFront:cell.checkBtn];

                
            }
            
        } completion:^(BOOL finished){
            _cancelBtn.hidden = NO;
            _deleteOKBtn.hidden = NO;
            self.navigationItem.rightBarButtonItem.tag = 99;
            
            
            [_deleteOKBtn setTitle:[NSString stringWithFormat:@"删除(%d)",[self.downloadSelectList count]] forState:UIControlStateNormal];
        }];
    }
    
    
    
}


-(IBAction)cancelClick{
    self.navigationItem.rightBarButtonItem.tag = 0;
    
    [UIView animateWithDuration:.3 animations:^{
        
        for (NSIndexPath* i in [_tv indexPathsForVisibleRows])
        {
            HaveDownloadTableViewCell *cell = [_tv cellForRowAtIndexPath:i];
            
            cell.moveView.frame = CGRectMake(cell.moveView.frame.origin.x - 25, cell.moveView.frame.origin.y, cell.moveView.frame.size.width, cell.moveView.frame.size.height);
            

            cell.checkBtn.hidden = YES;

            
            _cancelBtn.hidden = YES;
            _deleteOKBtn.hidden = YES;
            
        }
        
    } completion:^(BOOL finished){
        
        
    }];
    
    
}

-(IBAction)deleteOKClick{
    
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_tableArray];
    for (int i = 0 ; i < [_downloadSelectList count]; i++) {
        NSIndexPath *indexPath = [_downloadSelectList objectAtIndex:i];
        [[FilesDownManage sharedFilesDownManage]  deleteSingleFinishFile:[tempArray objectAtIndex:indexPath.row]];
        [_tableArray removeObject:[tempArray objectAtIndex:indexPath.row]];
    }

    [_downloadSelectList removeAllObjects];
    
    self.navigationItem.rightBarButtonItem.tag = 0;
    
    [UIView animateWithDuration:.3 animations:^{
        
        for (NSIndexPath* i in [_tv indexPathsForVisibleRows])
        {
            HaveDownloadTableViewCell *cell = [_tv cellForRowAtIndexPath:i];
            
            
            cell.moveView.frame = CGRectMake(cell.moveView.frame.origin.x - 25, cell.moveView.frame.origin.y, cell.moveView.frame.size.width, cell.moveView.frame.size.height);

            
        }
        _cancelBtn.hidden = YES;
        _deleteOKBtn.hidden = YES;
        
    } completion:^(BOOL finished){
        [self.tv reloadData];

    }];
    
    
}



-(void)getTableArray{
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT CHL.NAME,CHL.SIZE,CHL.ID,COURSE_ID,CHL.FILE_NAME,COL.NAME COURSE_NAME,COL.IMG_PATH FROM CHAPTER_LIST CHL,COURSE_LIST COL WHERE CHL.COURSE_ID = COL.ID AND COURSE_ID = '%@' AND DOWNLOAD_FINISH = '2' ORDER BY CAST(CHL.ID AS INT)",_courseId];
    
    NSLog(@"查询已经下载完成的小节的sql == %@",querySql);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    if (_tableArray == nil ) {
        _tableArray  = [[NSMutableArray alloc] init];
    }else{
        [_tableArray removeAllObjects];
    }
    
    while (rs.next) {
        NSMutableDictionary *lineDict =  [ NSMutableDictionary dictionary];
        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@"NAME"];
        [lineDict setObject:[CommonHelper getFileSizeString:[rs stringForColumn:@"SIZE"]] forKey:@"SIZE"];
        [lineDict setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];
        [lineDict setObject:[rs stringForColumn:@"COURSE_ID"] forKey:@"COURSE_ID"];
        [lineDict setObject:[rs stringForColumn:@"FILE_NAME"] forKey:@"FILE_NAME"];
        [lineDict setObject:[rs stringForColumn:@"COURSE_NAME"] forKey:@"COURSE_NAME"];
        [lineDict setObject:[rs stringForColumn:@"IMG_PATH"] forKey:@"IMG_PATH"];
        [_tableArray  addObject:lineDict];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *downCellIdentifier=@"haveDownload";
    HaveDownloadTableViewCell *cell=(HaveDownloadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:downCellIdentifier];
    
    NSDictionary *lineDict = [_tableArray objectAtIndex:indexPath.row];
    
    
    cell.chapterName.text = [lineDict objectForKey:@"NAME"];
    cell.size.text = [lineDict objectForKey:@"SIZE"];
    cell.checkBtn.tag  = 10 + indexPath.row;
    [cell.checkBtn addTarget:self action:@selector(checked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[FilesDownManage sharedFilesDownManage]  deleteSingleFinishFile:[_tableArray objectAtIndex:indexPath.row]];

        [_tableArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (self.navigationItem.rightBarButtonItem.tag == 99) {//如果是删除状态
        HaveDownloadTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self checked:cell.checkBtn];
        return;
    }
    NSDictionary *lineDict = [_tableArray objectAtIndex:indexPath.row];
    
    NSString *courseName = [lineDict objectForKey:@"COURSE_NAME"];
    
    int playIndex = indexPath.row;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.firstFlag = nil;
    
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc] initLocalMoviePlayerViewControllerWithChapterList:_tableArray playIndex:playIndex courseName:courseName ];
    [self presentViewController:movieVC animated:YES completion:nil];
    
    
//
//    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString*documentsDirectory =[paths objectAtIndex:0];
//    NSDictionary *lineDict = [_tableArray objectAtIndex:indexPath.row];
//    NSMutableArray *array = [NSMutableArray array];
//
//    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
//    
//    NSString *filePath = [NSString stringWithFormat:@"file://%@/%@/DownLoad/dest/%@",documentsDirectory,appDelegate.userId,[lineDict objectForKey:@"FILE_NAME"]];
//
//    [dict setObject:filePath forKey:@"path"];
//
//    [dict setObject:[lineDict objectForKey:@"NAME"] forKey:@"name"];
//
//    [array addObject:dict];
//
//
//    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithChapterList:array playIndex:0 courseName:@""];
//    [self presentViewController:movieVC animated:YES completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)checked:(id)sender{
    
    UIButton *btn = (UIButton *) sender;
    
    int index = btn.tag - 10 ;
    
    NSIndexPath *indexPath = [[_tv indexPathsForVisibleRows]  objectAtIndex:index];
    
    if ([self.downloadSelectList containsObject:indexPath]) {
        
        [self.downloadSelectList  removeObject:indexPath];
        [btn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        
    }else{
        [self.downloadSelectList addObject:indexPath];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
   [_deleteOKBtn setTitle:[NSString stringWithFormat:@"删除(%d)",[self.downloadSelectList count]] forState:UIControlStateNormal];
    
}
- (void)dealloc {
    [_tv release];
    [super dealloc];
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
@end
