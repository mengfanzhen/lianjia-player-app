
//  FilesDownManage.m
//  Created by yu on 13-1-21.
//

#import "FilesDownManage.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

#define TEMPPATH [CommonHelper getTempFolderPathWithBasepath:_basepath]

@implementation FilesDownManage
@synthesize downinglist=_downinglist;
@synthesize fileInfo = _fileInfo;
@synthesize downloadDelegate=_downloadDelegate;
@synthesize finishedlist=_finishedList;
@synthesize isFistLoadSound=_isFirstLoadSound;
@synthesize basepath = _basepath;
@synthesize filelist = _filelist;
@synthesize targetPathArray = _targetPathArray;
@synthesize VCdelegate = _VCdelegate;
@synthesize count;
static   FilesDownManage *sharedFilesDownManage = nil;
NSInteger  maxcount;

#pragma mark -- init methods --
+ (FilesDownManage *) sharedFilesDownManage{
    @synchronized(self){
        if (sharedFilesDownManage == nil) {
            sharedFilesDownManage = [[self alloc] init];
            
            
        }
    }
    return  sharedFilesDownManage;
}

+ (FilesDownManage *) sharedFilesDownManageWithBasepath:(NSString *)basepath
                                         TargetPathArr:(NSArray *)targetpaths{
    @synchronized(self){
        if (sharedFilesDownManage == nil) {
            sharedFilesDownManage = [[self alloc] initWithBasepath: basepath  TargetPathArr:targetpaths];
            
            Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            
            [[NSNotificationCenter defaultCenter] addObserver:[FilesDownManage sharedFilesDownManage]                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            
            [reach startNotifier];

        }
    }
    if (![sharedFilesDownManage.basepath isEqualToString:basepath]) {
        //如果你更换了下载缓存目录，之前的缓存目录下载信息的plist文件将被删除，无法使用
        [sharedFilesDownManage cleanLastInfo];
        sharedFilesDownManage.basepath = basepath;
        [sharedFilesDownManage loadTempfiles];
        [sharedFilesDownManage loadFinishedfiles];
    }
    sharedFilesDownManage.basepath = basepath;
    sharedFilesDownManage.targetPathArray =[NSMutableArray arrayWithArray:targetpaths];
    return  sharedFilesDownManage;
}
- (id)init{
    self = [super init];
    if (self != nil) {
        self.count = 0;
        if (self.basepath!=nil) {
            [self loadFinishedfiles];
            [self loadTempfiles];
            
        }
        
    }
    return self;
}
//接到通知
-(void)reachabilityChanged:(NSNotification *)notification{
    
    Reachability *reach = [notification object];
    
    if([reach isKindOfClass:[Reachability class]]){
        
        NetworkStatus status = [reach currentReachabilityStatus];
        
        if(status == 1){
            for (int i = 0 ; i < self.downinglist.count; i++) {
                MidHttpRequest *theRequest=[self.downinglist objectAtIndex:i];
//                if([theRequest isExecuting])
//                {
//                    [self stopRequest:theRequest];
//                }
                [self stopRequest:theRequest];
            }
            
            //通知正在下载的table reloadData
            NSNotification* notification = [NSNotification notificationWithName:@"refreshDowndingTable" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            for (int i = 0 ; i < self.downinglist.count; i++) {
//                MidHttpRequest *theRequest=[self.downinglist objectAtIndex:i];
//                
//                [self stopRequest:theRequest];
//            }
        }
        NSLog(@"通知暂停下载的status ==%d",status);

    }
    
    
}

-(id)initWithBasepath:(NSString *)basepath
        TargetPathArr:(NSArray *)targetpaths{
    self = [super init];
    if (self != nil) {
        self.basepath = basepath;
        _targetPathArray = [[NSMutableArray alloc]initWithArray:targetpaths];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * Max= [userDefaults valueForKey:@"kMaxRequestCount"];
        if (Max==nil) {
            [userDefaults setObject:@"1" forKey:@"kMaxRequestCount"];
            Max =@"1";
        }
                    Max =@"1";
        [userDefaults synchronize];
        maxcount = [Max integerValue];
        _filelist = [[NSMutableArray alloc]init];
        _downinglist=[[NSMutableArray alloc] init];
        _finishedList = [[NSMutableArray alloc] init];
        self.isFistLoadSound=YES;
        self.count = 0;
        if (self.basepath!=nil) {
            [self loadFinishedfiles];
            [self loadTempfiles];
            
        }
        
    }
    return self;
}

-(void)cleanLastInfo{
    for (MidHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
    }
    
    


    
    //[self saveFinishedFile];
    [_downinglist removeAllObjects];
    [_finishedList removeAllObjects];
    [_filelist removeAllObjects];
    
}



#pragma mark- -- 创建一个下载任务 --
-(void)downFileUrl:(NSString*)url
          filename:(NSString*)name
        filetarget:(NSString *)path
         fileimage:(UIImage *)image
         courseId:(NSString *)courseId
         courseName:(NSString *)courseName
         teacher:(NSString *)teacher
         imgPath:(NSString *)imgPath
         chapterId:(NSString *)chapterId
         chapterName:(NSString *)chapterName
         courseDesc:(NSString *)courseDesc
         chapterDesc:(NSString *)chapterDesc
     effectiveTime:(NSString *)effectiveTime

{
    
    //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    self.TargetSubPath = path;
    
    _fileInfo = [[FileModel alloc]init];
    if (!name) {
        name = [url lastPathComponent];
    }
    _fileInfo.fileName = name;
    _fileInfo.fileURL = url;
    
    NSDate *myDate = [NSDate date];
    _fileInfo.time = [CommonHelper dateToString:myDate];
    // NSInteger index=[name rangeOfString:@"."].location;
    _fileInfo.fileType=[name pathExtension];
    path= [CommonHelper getTargetPathWithBasepath:_basepath subpath:path];
    path = [path stringByAppendingPathComponent:name];
    _fileInfo.targetPath = path ;
    _fileInfo.fileimage = image;
    _fileInfo.downloadState = Downloading;
    _fileInfo.error = NO;
    _fileInfo.courseId = courseId;
    _fileInfo.courseName = courseName;
    _fileInfo.teacher = teacher;
    _fileInfo.imgPath = imgPath;
    _fileInfo.chapterId = chapterId;
    _fileInfo.chapterName = chapterName;
    _fileInfo.courseDesc = courseDesc;
    _fileInfo.chapterDesc = chapterDesc;
    _fileInfo.effectiveTime = effectiveTime;

     NSString *tempfilePath= [TEMPPATH stringByAppendingPathComponent: _fileInfo.fileName]  ;
    _fileInfo.tempPath = tempfilePath;
    BOOL isHaveDownload = NO;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT DOWNLOAD_FINISH FROM CHAPTER_LIST WHERE ID ='%@'",chapterId];
    
    NSLog(@"查询是否已经下载完成过的sql%@",querySql);
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    while (rs.next) {
        NSString *downloadFinish = [rs stringForColumn:@"DOWNLOAD_FINISH"];
        if ([downloadFinish isEqualToString:@"2"]) {
            isHaveDownload = YES;
        }
    }
    
    
    
    
    //if([CommonHelper isExistFile: _fileInfo.targetPath])//已经下载过一次
    if (isHaveDownload)
    {
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [alert show];
        //        });
        return;
    }
    BOOL isInDownloadList = NO;
    
    querySql = [NSString stringWithFormat:@"SELECT DOWNLOAD_FINISH FROM CHAPTER_LIST WHERE ID ='%@'",chapterId];
    NSLog(@"查询是否已经下载过，但没有下载完的sql ====%@",querySql);
    
    rs = [appDelegate.db executeQuery:querySql];
    
    while (rs.next) {
        NSString *inDownloadList = [rs stringForColumn:@"DOWNLOAD_FINISH"];
        if (![inDownloadList isEqualToString:@"2"]) {
            isInDownloadList = YES;
        }
    }
    
    
    
    //    //存在于临时文件夹里
    //tempfilePath =[tempfilePath stringByAppendingString:@".plist"];
    //    if([CommonHelper isExistFile:tempfilePath])
    if(isInDownloadList)
    {
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经在下载列表中了，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [alert show];
        //        });
        return;
    }
    
    //若不存在文件和临时文件，则是新的下载
    [self.filelist addObject:_fileInfo];
    
    [self startLoad];
    if(self.VCdelegate!=nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)])
    {
        [self.VCdelegate allowNextRequest];
    }else{
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件成功添加到下载队列" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [alert show];
        //        });
    }
    

    return;
    

    
}

#pragma mark- -- 创建一个下载任务 --
-(void)downFileWithDict:(NSDictionary *)dict
{
    _downLoadDict =dict;
    _chapterList = [dict objectForKey:@"chapterList"];
    
    NSDictionary *lineContentDic = [dict objectForKey:@"lineContent"];
    
    NSString *courseId = [lineContentDic objectForKey:@"id"];
    
    NSString *courseName = [lineContentDic objectForKey:@"videoName"];
    
    NSString *teacher = [lineContentDic objectForKey:@"teacher"];
    
    NSString *imgPath = [lineContentDic objectForKey:@"videoUrl"];
    

    
    
    NSMutableArray *downLoadResult = [NSMutableArray array];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    for (int i = 0 ; i < _chapterList.count; i++) {
        NSDictionary *lineDic = [_chapterList objectAtIndex:i];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT 1  FROM CHAPTER_LIST WHERE ID = '%@'",[lineDic objectForKey:@"id"]];
        
        NSLog(@"筛选已下载的sql ===%@",querySql);
        FMResultSet *rs = [appDelegate.db executeQuery:querySql];
        if(!rs.next) {
            [downLoadResult addObject:[_chapterList objectAtIndex:i]];
        }
        
    }
    _chapterList = downLoadResult;
    
    _downloadCount = _chapterList.count;

    
    if (_chapterList.count >0) {
        _downloadIndex = 0;
        NSDictionary *lineDict = [_chapterList objectAtIndex:0];
        
        NSString *url = [lineDict objectForKey:@"path"];
        
        NSArray *tempArray = [url componentsSeparatedByString:@"/"];
        NSString *fileName = [tempArray lastObject];
        
        NSString *desDir = @"dest";
        [self downFileUrl: url filename: fileName  filetarget:desDir fileimage:nil courseId:courseId courseName:courseName teacher:teacher imgPath:imgPath chapterId:[lineDict objectForKey:@"id"] chapterName:[lineDict objectForKey:@"name"] courseDesc:[lineDict objectForKey:@"detail"] chapterDesc:[lineDict objectForKey:@"detail"] effectiveTime:[lineDict objectForKey:@"effectiveTime"]];

    }


   

    
//    int testCount = [_chapterList count];
//    
//    for (int i = 0; i<2; i++) {
//        NSDictionary *lineDict = [_chapterList objectAtIndex:i];
//        
//        NSString *url = [lineDict objectForKey:@"path"];
//        
//        NSArray *tempArray = [url componentsSeparatedByString:@"/"];
//        NSString *fileName = [tempArray lastObject];
//        
//        NSString *desDir = @"dest";
//        [self downFileUrl: url filename: fileName  filetarget:desDir fileimage:nil courseId:courseId courseName:courseName teacher:teacher imgPath:imgPath chapterId:[lineDict objectForKey:@"id"] chapterName:[lineDict objectForKey:@"name"]];
//
//    }
}
#pragma mark  --下载开始--

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    for(MidHttpRequest *tempRequest in self.downinglist)
    {
        /**
         注意这里判读是否是同一下载的方法，asihttprequest 有三种url：
         url，originalurl，redirectURL
         经过实践，应该使用originalurl,就是最先获得到的原下载地址
         **/
        
        NSLog(@"%@",[tempRequest.url absoluteString]);
        if([[[tempRequest.originalURL absoluteString]lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]])
        {
            if ([tempRequest isExecuting]&&isBeginDown) {
                return;
            }else if ([tempRequest isExecuting]&&!isBeginDown)
            {
                [tempRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];
                [tempRequest cancel];
                [self.downloadDelegate updateCellProgress:tempRequest];
                return;
            }
        }
    }
    
    [self saveDownloadFile:fileInfo];
    
    //NSLog(@"targetPath %@",fileInfo.targetPath);
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *fileData=[fileManager contentsAtPath:fileInfo.tempPath];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%zd", receivedDataLength];
    
    NSLog(@"start down::已经下载：%@",fileInfo.fileReceivedSize);
    MidHttpRequest* midRequest = [[MidHttpRequest alloc]initWithURL: [NSURL URLWithString:fileInfo.fileURL]];
    midRequest.downloadDestinationPath = fileInfo.targetPath;
    midRequest.temporaryFileDownloadPath = fileInfo.tempPath;
    midRequest.delegate = self;
    [midRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
     if (isBeginDown) {
        [midRequest startAsynchronous];
    }
    
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    BOOL exit = NO;
    for(MidHttpRequest *tempRequest in self.downinglist)
    {
        //  NSLog(@"!!!!---::%@",[tempRequest.url absoluteString]);
        if([[[tempRequest.url absoluteString]lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent] ])
        {
            [self.downinglist replaceObjectAtIndex:[_downinglist indexOfObject:tempRequest] withObject:midRequest ];
            
            
            exit = YES;
            break;
        }
    }
    
    if (!exit) {
        
        [self.downinglist addObject:midRequest];
        NSLog(@"EXIT!!!!---::%@",[midRequest.url absoluteString]);
        
    }
    if ([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)]) {
        [self.downloadDelegate updateCellProgress:midRequest];
    }
    


    

    
}
#pragma mark --存储下载信息到一个plist文件--
-(void)saveDownloadFile:(FileModel*)fileinfo{
    NSData *imagedata =UIImagePNGRepresentation(fileinfo.fileimage);
    
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileinfo.fileName,@"filename",fileinfo.fileURL,@"fileurl",fileinfo.time,@"time",_basepath,@"basepath",_TargetSubPath,@"tarpath" ,fileinfo.fileSize,@"filesize",fileinfo.fileReceivedSize,@"filerecievesize",imagedata,@"fileimage",nil];
    
    NSString *plistPath = [fileinfo.tempPath stringByAppendingPathExtension:@"plist"];
    
    
    
    
    //---------------------------------------入库----------------------------------------------------

    //入库课程表
    NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM COURSE_LIST WHERE ID='%@' " ,fileinfo.courseId ];
    
    NSLog(@"查询是否已经存在课程的sql = %@", querySql);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    int total = 0;
    if (rs.next) {
        total = [rs intForColumn:@"TOTAL"];
    }
    [appDelegate.db beginTransaction];
    if (total == 0) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO COURSE_LIST(ID,NAME,TEACHER,IMG_PATH,DESC) VALUES('%@','%@','%@','%@','%@')",fileinfo.courseId,fileinfo.courseName,fileinfo.teacher,fileinfo.imgPath,fileinfo.courseDesc];
        
        NSLog(@"插入课程的sql = %@",insertSql);
        [appDelegate.db executeUpdate:insertSql];
    }
    
    
    total = 0;

    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM CHAPTER_LIST WHERE ID = '%@'",fileinfo.chapterId];
    rs = [appDelegate.db executeQuery:sql];

    if (rs.next) {
        total = [rs intForColumn:@"TOTAL"];
    }
    NSLog(@"查询是否有章节的sql = %@",sql );
    
    
    if (total  == 0) {
        //获取文件名字
        NSString *downloadPath =fileinfo.fileURL;
        NSArray *tempArray = [downloadPath componentsSeparatedByString:@"/"];
        NSString *fileName = [tempArray lastObject];
        
        sql = [NSString stringWithFormat:@"INSERT INTO CHAPTER_LIST(ID,NAME,DOWNLOAD_PATH,DURATION,SCHEDULE,SIZE,COURSE_ID,DOWNLOAD_FINISH,FILE_NAME,DESC,EFFECTIVE_TIME) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",fileinfo.chapterId,fileinfo.chapterName,fileinfo.fileURL,@"0",@"0",fileinfo.fileSize,fileinfo.courseId,@"0",fileName,fileinfo.chapterDesc,fileinfo.effectiveTime];
        
        NSLog(@"insert sql = %@",sql);
        
        [appDelegate.db executeUpdate:sql];
        [appDelegate.db commit];

    }else{
        sql = [NSString stringWithFormat:@"UPDATE CHAPTER_LIST SET SIZE = '%@' WHERE ID = '%@'",fileinfo.fileSize,fileinfo.chapterId];
        [appDelegate.db executeUpdate:sql];
        [appDelegate.db commit];
    }
    
    
    //---------------------------------------入库----------------------------------------------------

    if (![filedic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
}



#pragma mark- --自动处理下载状态的算法--

/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 
 当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 可以主动切换下载状态
 所有任务以添加时间排序。
 */

-(void)startLoad{
    NSInteger num = 0;
    NSInteger max = maxcount;
    for (FileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState==Downloading) {
                
                if (num>=max) {
                    file.downloadState=WillDownload;
                }else
                    num++;
                
            }
        }
    }
    if (num<max) {
        for (FileModel *file in _filelist) {
            if (!file.error) {
                if (file.downloadState==WillDownload) {
                    num++;
                    if (num>max) {
                        break;
                    }
                    file.downloadState=Downloading;
                }
            }
        }
        
    }
    for (FileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState==Downloading) {
                [self beginRequest:file isBeginDown:YES];
            }else
                [self beginRequest:file isBeginDown:NO];
        }
    }
    self.count = [_filelist count];
}
#pragma mark -
#pragma mark - --恢复下载--
-(void)resumeRequest:(MidHttpRequest *)request{
    NSInteger max = maxcount;
    FileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    NSInteger downingcount =0;
    NSInteger indexmax =-1;
    for (FileModel *file in _filelist) {
        if (file.downloadState==Downloading) {
            downingcount++;
            if (downingcount==max) {
                indexmax = [_filelist indexOfObject:file];
            }
        }
    }//此时下载中数目是否是最大，并获得最大时的位置Index
    if (downingcount==max) {
        FileModel *file  = [_filelist objectAtIndex:indexmax];
            if (file.downloadState==Downloading) {
                file.downloadState=WillDownload;
            }
    }//中止一个进程使其进入等待

    for (FileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
			file.downloadState = Downloading;
            file.error = NO;
        }
    }//重新开始此下载
    [self startLoad];
}
#pragma mark - --暂停下载--
-(void)stopRequest:(MidHttpRequest *)request{
    NSInteger max = maxcount;
    if([request isExecuting])
    {
        [request cancel];
    }
    FileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    for (FileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {

			file.downloadState = StopDownload;
            break;
        }
    }
    NSInteger downingcount =0;

    for (FileModel *file in _filelist) {
        if (file.downloadState==Downloading) {
            downingcount++;
        }
    }
    if (downingcount<max) {
        for (FileModel *file in _filelist) {
            if (file.downloadState==WillDownload){
				file.downloadState=Downloading;
                break;
            }
        }
    }

    [self startLoad];

    
}
#pragma mark - --删除下载--
-(void)deleteRequest:(MidHttpRequest *)request{
    bool isexecuting = NO;
    if([request isExecuting])
    {
        [request cancel];
        isexecuting = YES;
    }
    
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    FileModel *fileInfo=(FileModel*)[request.userInfo objectForKey:@"File"];
    NSString *path=fileInfo.tempPath;
    
    //先删除数据库的记录:先删除小节，如果小节对应的课程下没有了小节，则将课程删除
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.db beginTransaction];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE ID = '%@'",fileInfo.chapterId];
    NSLog(@"删除小节的sql == %@",deleteSql);
    [appDelegate.db executeUpdate:deleteSql];
    
    int chapterCount = 0;
    NSString *selectCourseCount  = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",fileInfo.courseId];
    
    NSLog(@"查询小节所在课程下的小节数量 sql == %@",selectCourseCount);
    
    FMResultSet *rs =[appDelegate.db executeQuery:selectCourseCount];
    
    if ([rs next]) {
        chapterCount = [rs intForColumn:@"TOTAL"];
    }
    if(chapterCount == 0){
        deleteSql = [NSString stringWithFormat:@"DELETE FROM COURSE_LIST WHERE ID = '%@'",fileInfo.courseId];
        NSLog(@"查询小节所在课程的 sql == %@",selectCourseCount);
        [appDelegate.db executeUpdate:deleteSql];
        
    }
    
    [appDelegate.db commit];
    

    NSString *configPath=[NSString stringWithFormat:@"%@.plist",path];
    [fileManager removeItemAtPath:path error:&error];
    [fileManager removeItemAtPath:configPath error:&error];
   // [self deleteImage:fileInfo];
    
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }

    NSInteger delindex =-1;
    for (FileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            delindex = [_filelist indexOfObject:file];
            break;
        }
    }
    if (delindex!=NSNotFound) 
    [_filelist removeObjectAtIndex:delindex];
  
    [_downinglist removeObject:request];
    
    if (isexecuting) {
       // [self startWaitingRequest];
        [self startLoad];
    }
     self.count = [_filelist count];
}

#pragma mark - --可能的UI操作接口 --
-(void)clearAllFinished{
    [_finishedList removeAllObjects];
}
-(void)clearAllRquests{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    for (MidHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
        FileModel *fileInfo=(FileModel*)[request.userInfo objectForKey:@"File"];
        NSString *path=fileInfo.tempPath;;
        NSString *configPath=[NSString stringWithFormat:@"%@.plist",path];
        [fileManager removeItemAtPath:path error:&error];
        [fileManager removeItemAtPath:configPath error:&error];
        //  [self deleteImage:fileInfo];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
        
    }
    [_downinglist removeAllObjects];
    [_filelist removeAllObjects];
}

-(void)restartAllRquests{
    
    for (MidHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];
    }
    
    [self startLoad];
}
#pragma mark- --从这里获取上次未完成下载的信息--
/*
 将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
 
 */
-(void)loadTempfiles
{
    
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    NSError *error;
//    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:TEMPPATH error:&error];
//    if(!error)
//    {
//        NSLog(@"%@",[error description]);
//    }
//    NSMutableArray *filearr = [[NSMutableArray alloc]init];
//    for(NSString *file in filelist)
//    {
//        NSString *filetype = [file  pathExtension];
//        if([filetype isEqualToString:@"plist"])
//            [filearr addObject:[self getTempfile:[TEMPPATH stringByAppendingPathComponent:file]]];
//    }
//    
//    NSArray* arr =  [self sortbyTime:(NSArray *)filearr];
//    [_filelist addObjectsFromArray:arr];
    
    NSMutableArray *filearr = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT CHL.ID,CHL.NAME,CHL.DOWNLOAD_PATH,CHL.DURATION,CHL.SCHEDULE,CHL.SIZE,CHL.COURSE_ID,DOWNLOAD_FINISH,FILE_NAME,COL.NAME COURSE_NAME,COL.TEACHER,COL.IMG_PATH,CHL.DESC FROM CHAPTER_LIST CHL,COURSE_LIST COL WHERE CHL.COURSE_ID = COL.ID AND CHL.DOWNLOAD_FINISH !='2'"];
    
    NSLog(@"查询没有下载完的sql = %@",querySql);
    
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    while (rs.next) {
        FileModel *fileinfo = [[FileModel alloc] init];
        fileinfo.chapterId = [rs stringForColumn:@"ID"];
        fileinfo.fileName = [rs stringForColumn:@"FILE_NAME"];
        fileinfo.fileURL = [rs stringForColumn:@"DOWNLOAD_PATH"];
        fileinfo.fileName = [rs stringForColumn:@"FILE_NAME"];
        fileinfo.fileSize = [rs stringForColumn:@"SIZE"];
        fileinfo.fileType = [fileinfo.fileName pathExtension ];
        fileinfo.courseId = [rs stringForColumn:@"COURSE_ID"];
        fileinfo.courseName = [rs stringForColumn:@"COURSE_NAME"];
        fileinfo.teacher = [rs stringForColumn:@"TEACHER"];
        fileinfo.imgPath = [rs stringForColumn:@"IMG_PATH"];
        fileinfo.chapterName = [rs stringForColumn:@"NAME"];
        fileinfo.courseDesc = [rs stringForColumn:@"DESC"];


        
        self.basepath = [NSString stringWithFormat:@"%@/%@",appDelegate.userId,@"DownLoad"];
        self.TargetSubPath = @"dest";
        NSString*  path1= [CommonHelper getTargetPathWithBasepath:_basepath subpath:_TargetSubPath];
        path1 = [path1 stringByAppendingPathComponent:fileinfo.fileName];
        fileinfo.targetPath = path1;
        NSString *tempfilePath= [TEMPPATH stringByAppendingPathComponent: fileinfo.fileName];
        fileinfo.tempPath = tempfilePath;
        fileinfo.time = @"";
        fileinfo.fileimage = nil;
        fileinfo.downloadState =StopDownload;
        fileinfo.error = NO;
        NSData *fileData=[[NSFileManager defaultManager ] contentsAtPath:fileinfo.tempPath];
        NSInteger receivedDataLength=[fileData length];
        fileinfo.fileReceivedSize=[NSString stringWithFormat:@"%zd",receivedDataLength];
        [filearr addObject:fileinfo];
    }
    
    NSArray* arr =  [self sortbyTime:(NSArray *)filearr];
    [_filelist addObjectsFromArray:arr];
    
    
    [self startLoad];
}

-(FileModel *)getTempfile:(NSString *)path{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    FileModel *file = [[FileModel alloc]init];
    file.fileName = [dic objectForKey:@"filename"];
    file.fileType = [file.fileName pathExtension ];
    file.fileURL = [dic objectForKey:@"fileurl"];
    file.fileSize = [dic objectForKey:@"filesize"];
    file.fileReceivedSize= [dic objectForKey:@"filerecievesize"];
    self.basepath = [dic objectForKey:@"basepath"];
    self.TargetSubPath = [dic objectForKey:@"tarpath"];
    NSString*  path1= [CommonHelper getTargetPathWithBasepath:_basepath subpath:_TargetSubPath];
    path1 = [path1 stringByAppendingPathComponent:file.fileName];
    file.targetPath = path1;
    NSString *tempfilePath= [TEMPPATH stringByAppendingPathComponent: file.fileName];
    file.tempPath = tempfilePath;
    file.time = [dic objectForKey:@"time"];
    file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
    file.downloadState =StopDownload;
     file.error = NO;
    
    NSData *fileData=[[NSFileManager defaultManager ] contentsAtPath:file.tempPath];
    NSInteger receivedDataLength=[fileData length];
    file.fileReceivedSize=[NSString stringWithFormat:@"%zd",receivedDataLength];
    return file;
}
-(NSArray *)sortbyTime:(NSArray *)array{
    NSArray *sorteArray1 = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        FileModel *file1 = (FileModel *)obj1;
        FileModel *file2 = (FileModel *)obj2;
        NSDate *date1 = [CommonHelper makeDate:file1.time];
        NSDate *date2 = [CommonHelper makeDate:file2.time];
        if ([[date1 earlierDate:date2]isEqualToDate:date2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[date1 earlierDate:date2]isEqualToDate:date1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    return sorteArray1;
}
#pragma mark- --已完成的下载任务在这里处理--
/*
	将本地已经下载完成的文件加载到已下载列表里
 */
-(void)loadFinishedfiles
{
//    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *plistPath = [[document stringByAppendingPathComponent:self.basepath]stringByAppendingPathComponent:@"finishPlist.plist"];
//    if ([[NSFileManager defaultManager]fileExistsAtPath:plistPath]) {
//        NSMutableArray *finishArr = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
//        for (NSDictionary *dic in finishArr) {
//            FileModel *file = [[FileModel alloc]init];
//            file.fileName = [dic objectForKey:@"filename"];
//            file.fileType = [file.fileName pathExtension ];
//            file.fileSize = [dic objectForKey:@"filesize"];
//            file.targetPath = [dic objectForKey:@"filepath"];
//            file.time = [dic objectForKey:@"time"];
//            file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
//            [_finishedList addObject:file];
//        }
//        //self.finishedlist = finishArr;
//    }
    
    NSMutableArray *finishedArray = [NSMutableArray array];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT COL.ID,COL.NAME,COL.TEACHER,COL.IMG_PATH,COUNT(1) TOTAL,SUM(CASE WHEN DOWNLOAD_FINISH = '2' THEN 1 ELSE 0 END ) FINISH_COUNT,SUM(CASE WHEN DOWNLOAD_FINISH = '2' THEN SIZE ELSE 0 END) TOTAL_SIZE FROM COURSE_LIST COL,CHAPTER_LIST  CHL WHERE COL.ID = CHL.COURSE_ID GROUP BY COL.ID,COL.NAME,COL.TEACHER,COL.IMG_PATH"];
    FMResultSet *rs = [appDelegate.db executeQuery:querySql];
    
    NSLog(@"查询已下载完成的sql == %@",querySql);
    
    while (rs.next) {
//        FileModel *fileinfo = [[FileModel alloc] init];
//        fileinfo.chapterId = [rs stringForColumn:@"ID"];
//        fileinfo.fileName = [rs stringForColumn:@"FILE_NAME"];
//        fileinfo.fileURL = [rs stringForColumn:@"DOWNLOAD_PATH"];
//        fileinfo.fileName = [rs stringForColumn:@"FILE_NAME"];
//        fileinfo.fileSize = [rs stringForColumn:@"TOTAL_SIZE"];
//        fileinfo.fileType = [fileinfo.fileName pathExtension ];
//        fileinfo.courseId = [rs stringForColumn:@"COURSE_ID"];
//        fileinfo.courseName = [rs stringForColumn:@"COURSE_NAME"];
//        fileinfo.teacher = [rs stringForColumn:@"TEACHER"];
//        fileinfo.imgPath = [rs stringForColumn:@"IMG_PATH"];
//        fileinfo.chapterName = [rs stringForColumn:@"NAME"];
        NSMutableDictionary *lineDict = [NSMutableDictionary dictionary];
        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@"NAME"];
        [lineDict setObject:[rs stringForColumn:@"TOTAL_SIZE"] forKey:@"TOTAL_SIZE"];
        [lineDict setObject:[rs stringForColumn:@"IMG_PATH"] forKey:@"IMG_PATH"];
        [lineDict setObject:[rs stringForColumn:@"FINISH_COUNT"] forKey:@"FINISH_COUNT"];
        [lineDict setObject:[rs stringForColumn:@"TOTAL"] forKey:@"TOTAL"];
        [lineDict setObject:[rs stringForColumn:@"ID"] forKey:@"ID"];
        
        if (![@"0" isEqualToString:[rs stringForColumn:@"FINISH_COUNT"]]) {
            [finishedArray addObject:lineDict];
        }

//        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@""];
//        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@""];
//        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@""];
//        [lineDict setObject:[rs stringForColumn:@"NAME"] forKey:@""];


        
    }
    self.finishedlist = finishedArray;
    

    
    //    else
    //        [[NSFileManager defaultManager]createFileAtPath:plistPath contents:nil attributes:nil];
    
}

-(void)saveFinishedFile:(FileModel *) fileInfo{
    //[_finishedList addObject:file];
    
//    if (_finishedList==nil) {
//        return;
//    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.db beginTransaction];

    NSString *updateSql = [NSString stringWithFormat:@"UPDATE CHAPTER_LIST SET DOWNLOAD_FINISH ='2',SIZE ='%@' WHERE ID = '%@'",fileInfo.fileSize ,fileInfo.chapterId];
    
    NSLog(@"完成下载后的更新语句==%@",updateSql);
    
    [appDelegate.db executeUpdate:updateSql];
    
    [appDelegate.db commit];

}
-(void)deleteFinishFile:(FileModel *)selectFile{
    
    //先删除数据库的记录:先删除小节，如果小节对应的课程下没有了小节，则将课程删除
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.db beginTransaction];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE ID = '%@'",selectFile.chapterId];
    NSLog(@"删除小节的sql == %@",deleteSql);
    [appDelegate.db executeUpdate:deleteSql];

    int chapterCount = 0;
    NSString *selectCourseCount  = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",selectFile.courseId];

    NSLog(@"查询小节所在课程下的小节数量 sql == %@",selectCourseCount);

    FMResultSet *rs =[appDelegate.db executeQuery:selectCourseCount];

    if ([rs next]) {
        chapterCount = [rs intForColumn:@"TOTAL"];
    }
    if(chapterCount == 0){
        deleteSql = [NSString stringWithFormat:@"DELETE FROM COURSE_LIST WHERE ID = '%@'",selectFile.courseId];
        NSLog(@"查询小节所在课程的 sql == %@",selectCourseCount);
        [appDelegate.db executeUpdate:deleteSql];

    }
    
    [appDelegate.db commit];

    [_finishedList removeObject:selectFile];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:selectFile.targetPath]) {
        [fm removeItemAtPath:selectFile.targetPath error:nil];
    }
    //[self saveFinishedFile];
}


-(void)deleteSingleFinishFile:(NSDictionary *)chapterInfoDict{
    
    //先删除数据库的记录:先删除小节，如果小节对应的课程下没有了小节，则将课程删除
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/DownLoad/dest/%@",documentsDirectory,appDelegate.userId,[chapterInfoDict objectForKey:@"FILE_NAME"]];
    NSLog(@"正在删除文件的filePath = %@",filePath);


    [appDelegate.db beginTransaction];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE ID = '%@'",[chapterInfoDict objectForKey:@"ID"]];
    NSLog(@"删除小节的sql == %@",deleteSql);
    [appDelegate.db executeUpdate:deleteSql];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
    
    int chapterCount = 0;
    NSString *selectCourseCount  = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",[chapterInfoDict objectForKey:@"COURSE_ID"]];
    
    NSLog(@"查询小节所在课程下的小节数量 sql == %@",selectCourseCount);
    
    FMResultSet *rs =[appDelegate.db executeQuery:selectCourseCount];
    
    if ([rs next]) {
        chapterCount = [rs intForColumn:@"TOTAL"];
    }
    if(chapterCount == 0){
        deleteSql = [NSString stringWithFormat:@"DELETE FROM COURSE_LIST WHERE ID = '%@'",[chapterInfoDict objectForKey:@"COURSE_ID"]];
        NSLog(@"查询小节所在课程的 sql == %@",selectCourseCount);
        [appDelegate.db executeUpdate:deleteSql];
        
    }
    
    [appDelegate.db commit];
    
}




-(void)deleteFinishGroup:(NSArray*) deleteArray{
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSFileManager* fm = [NSFileManager defaultManager];

    for (int i = 0 ; i <  [deleteArray  count]; i++) {
        NSMutableDictionary *lineDict = [deleteArray objectAtIndex:i];
        //先删除数据库的记录:先删除小节，如果小节对应的课程下没有了小节，则将课程删除
        NSString *querySql = [NSString stringWithFormat:@"SELECT FILE_NAME FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",[lineDict objectForKey:@"ID"]];
        
        NSLog(@"查询出所有的需要删除的chapterid的sql = %@",querySql);
        
        FMResultSet *rs =[appDelegate.db executeQuery:querySql];
        while ([rs next]) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@/DownLoad/dest/%@",documentsDirectory,appDelegate.userId,[rs stringForColumn:@"FILE_NAME"]];
            
            NSLog(@"正在删除文件的filePath = %@",filePath);
            if ([fm fileExistsAtPath:filePath]) {
                [fm removeItemAtPath:filePath error:nil];
            }

        }
        NSLog(@"文件删除结束");
        [rs close];
        
        
        NSLog(@"开始删除数据库记录");

        [appDelegate.db beginTransaction];

        
        NSString *deleteSql  = [NSString stringWithFormat:@"DELETE FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",[lineDict objectForKey:@"ID"]];
        
        NSLog(@"删除对应小节的sql =  %@",deleteSql);
        
        [appDelegate.db executeUpdate:deleteSql];
        
        
        int chapterCount = 0;
        NSString *selectCourseCount  = [NSString stringWithFormat:@"SELECT COUNT(1) TOTAL FROM CHAPTER_LIST WHERE  COURSE_ID = '%@'",[lineDict objectForKey:@"COURSE_ID"]];
        
        NSLog(@"查询小节所在课程下的小节数量 sql == %@",selectCourseCount);
        
        rs =[appDelegate.db executeQuery:selectCourseCount];
        if ([rs next]) {
            chapterCount = [rs intForColumn:@"TOTAL"];
        }
        if(chapterCount == 0){
            deleteSql = [NSString stringWithFormat:@"DELETE FROM COURSE_LIST WHERE ID = '%@'",[lineDict objectForKey:@"ID"]];
            NSLog(@"删除小节所在课程的 sql == %@",deleteSql);
            [appDelegate.db executeUpdate:deleteSql];
        }
        
        [appDelegate.db commit];
        NSLog(@"结束删除数据库记录");

        [_finishedList removeObject:lineDict];
        
        
    }
    
}
#pragma mark -

#pragma mark -- ASIHttpRequest回调委托 --

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(MidHttpRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code==4) {
        return;
    }
    if ([request isExecuting]) {
        [request cancel];
    }
    FileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    fileInfo.downloadState = StopDownload;
    fileInfo.error = YES;
    for (FileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
			file.downloadState = StopDownload;

            file.error = YES;
        }
    }
    [self.downloadDelegate updateCellProgress:request];
}

-(void)requestStarted:(MidHttpRequest *)request
{
    NSLog(@"开始了!");
    
   
}

-(void)request:(MidHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到回复了！");

 
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
	fileInfo.isFirstReceived = YES;

    NSString *len = [responseHeaders objectForKey:@"Content-Length"];//
        // NSLog(@"%@,%@,%@",fileInfo.fileSize,fileInfo.fileReceivedSize,len);
    //这个信息头，首次收到的为总大小，那么后来续传时收到的大小为肯定小于或等于首次的值，则忽略
    if ([fileInfo.fileSize longLongValue]> [len longLongValue])
    {
        return;
    }
   
        fileInfo.fileSize = [NSString stringWithFormat:@"%lld",  [len longLongValue]];
        [self saveDownloadFile:fileInfo];
    
}


-(void)request:(MidHttpRequest *)request didReceiveBytes:(long long)bytes
{
    
    

    
    if (_downloadIndex < _downloadCount) {
        
        NSDictionary *lineContentDic = [_downLoadDict objectForKey:@"lineContent"];
        
        NSString *courseId = [lineContentDic objectForKey:@"id"];
        
        NSString *courseName = [lineContentDic objectForKey:@"videoName"];
        
        NSString *teacher = [lineContentDic objectForKey:@"teacher"];
        
        NSString *imgPath = [lineContentDic objectForKey:@"videoUrl"];
        _downloadIndex++;
        for (; _downloadIndex < _downloadCount; _downloadIndex ++) {
            NSDictionary *lineDict = [_chapterList objectAtIndex:_downloadIndex];
            
            NSString *url = [lineDict objectForKey:@"path"];
            
            NSArray *tempArray = [url componentsSeparatedByString:@"/"];
            NSString *fileName = [tempArray lastObject];
            
            NSString *desDir = @"dest";
            [self downFileUrl: url filename: fileName  filetarget:desDir fileimage:nil courseId:courseId courseName:courseName teacher:teacher imgPath:imgPath chapterId:[lineDict objectForKey:@"id"] chapterName:[lineDict objectForKey:@"name"] courseDesc:[lineDict objectForKey:@"detail"]chapterDesc:[lineDict objectForKey:@"detail"] effectiveTime:[lineDict objectForKey:@"effectiveTime"]];
        }
        
    }
    
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    NSLog(@"%@,%lld",fileInfo.fileReceivedSize,bytes);
    if (fileInfo.isFirstReceived) {
        fileInfo.isFirstReceived=NO;
        fileInfo.fileReceivedSize =[NSString stringWithFormat:@"%lld",bytes];
    }
    else if(!fileInfo.isFirstReceived)
    {

        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
    {
        [self.downloadDelegate updateCellProgress:request];
    }
   
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(MidHttpRequest *)request
{
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    
    //重写文件
    //将文件拷贝到另外一个目录去
    
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@/DownLoad/dest/%@",documentsDirectory,appDelegate.userId,fileInfo.fileName];
    NSLog(@"resourcePath=%@",resourcePath);
    
    FILE * fp = fopen([ resourcePath UTF8String], "rb+");
    
    if (fp == NULL) {
        printf("fopen error");

    }
    //seek到文件头
    fseek(fp, 0, SEEK_SET);
    //定义两个字节数据
    char a[1] = {0xff};
    //修改前两个字节
    fwrite(a, 1, 1, fp);
    
    fclose(fp);
    
    
//    NSData *returnData = [NSData dataWithContentsOfFile:resourcePath];
//    NSRange range0 = NSMakeRange(0, 1);
//    NSRange range1_2 = NSMakeRange(1, 2);
//    NSRange range3 = NSMakeRange(3, 1);
//    NSRange range4 = NSMakeRange(4, [returnData length]-4);
//    NSData *data0 = [returnData  subdataWithRange:range0];
//    NSData *data1_2 = [returnData  subdataWithRange:range1_2];
//    NSData *data3 = [returnData  subdataWithRange:range3];
//    NSData *data4 = [returnData subdataWithRange:range4];
//    
//    NSMutableData *resultData = [NSMutableData dataWithData:data3];
//    [resultData appendData:data1_2];
//    [resultData appendData:data3];
//    [resultData appendData:data4];
//
//    [resultData writeToFile:resourcePath atomically:YES];
    
    

    
//    NSRange range1 = NSMakeRange(0, 2);
//    NSRange range2 = NSMakeRange(2, 2);
//    NSRange range3 = NSMakeRange(4, [returnData length]-4);
//
//    NSData *data1 = [returnData subdataWithRange:range1];
//    NSData *data2 = [returnData subdataWithRange:range2];
//    NSData *data3 = [returnData subdataWithRange:range3];
//    NSMutableData *resultData = [NSMutableData dataWithData:data2];
//    [resultData appendData:data1];
//    [resultData appendData:data3];
//    
//    [resultData writeToFile:resourcePath atomically:YES];


    [_filelist removeObject:fileInfo];
    [_downinglist removeObject:request];
    [self saveFinishedFile:fileInfo];
    [self startLoad];
  
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegate finishedDownload:request];
    }
}

#pragma mark - --UIAlertViewDelegate--

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)//确定按钮
    {
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        NSInteger delindex =-1;
        if([CommonHelper isExistFile:_fileInfo.targetPath])//已经下载过一次该音乐
        {
            if ([fileManager removeItemAtPath:_fileInfo.targetPath error:&error]!=YES) {
                
                NSLog(@"删除文件出错:%@",[error localizedDescription]);
            }
            
            
        }else{
            for(MidHttpRequest *request in self.downinglist)
            {
                FileModel *fileModel=[request.userInfo objectForKey:@"File"];
                if([fileModel.fileName isEqualToString:_fileInfo.fileName])
                {
                    //[self.downinglist removeObject:request];
                    if ([request isExecuting]) {
                        [request cancel];
                    }
                    delindex = [_downinglist indexOfObject:request];
                    //  [self deleteImage:fileModel];
                    break;
                }
            }
            [_downinglist removeObjectAtIndex:delindex];
            
            for (FileModel *file in _filelist) {
                if ([file.fileName isEqualToString:_fileInfo.fileName]) {
                    delindex = [_filelist indexOfObject:file];
                    break;
                }
            }
            [_filelist removeObjectAtIndex:delindex];
            //存在于临时文件夹里
            NSString * tempfilePath =[_fileInfo.tempPath stringByAppendingString:@".plist"];
            if([CommonHelper isExistFile:tempfilePath])
            {
                if ([fileManager removeItemAtPath:tempfilePath error:&error]!=YES) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
                
            }
            if([CommonHelper isExistFile:_fileInfo.tempPath])
            {
                if ([fileManager removeItemAtPath:_fileInfo.tempPath error:&error]!=YES) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
            
        }
        
        self.fileInfo.fileReceivedSize=@"0.00";
        [_filelist addObject:_fileInfo];
        [self startLoad];
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
        
    }
    if(self.VCdelegate!=nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)])
    {
        [self.VCdelegate allowNextRequest];
    }
}

@end
