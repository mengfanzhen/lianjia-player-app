//
//  DownloadCell.m


#import "DownloadCell.h"

#import "FilesDownManage.h"
#import "DownloadViewController.h"
#import "Reachability.h"
@implementation DownloadCell
@synthesize fileInfo;
@synthesize progress1;
@synthesize fileName;
@synthesize fileCurrentSize;
@synthesize fileSize;
@synthesize timelable;
@synthesize operateButton;
@synthesize request;
@synthesize averagebandLab;
@synthesize sizeinfoLab;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
 

- (IBAction)deleteRquest:(id)sender {
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    [filedownmanage deleteRequest:request];
       if ([self.delegate respondsToSelector:@selector(ReloadDownLoadingTable)]) 
    [((DownloadViewController*)self.delegate) ReloadDownLoadingTable];
}

-(IBAction)operateTask:(UIButton*)sender
{
	//执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    FileModel *downFile=self.fileInfo;
    FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
    if(downFile.downloadState==Downloading)//文件正在下载，点击之后暂停下载 有可能进入等待状态
    {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"download_pausing_icon.png"] forState:UIControlStateNormal];
        [filedownmanage stopRequest:request];
    }
    else
    {
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
        NetworkStatus status = [reach currentReachabilityStatus];
        
//        status = 1;
        if (status == 1) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您现在使用的是运营商网络，继续观看可能产生超额流量费" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续下载", nil];
            av.delegate = self;
            [av show];
        }
        
        
//        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloadstart.png"] forState:UIControlStateNormal];
//        
//        [filedownmanage resumeRequest:request];
    }
    //暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if ([self.delegate respondsToSelector:@selector(ReloadDownLoadingTable)]) {
           [((DownloadViewController*)self.delegate) ReloadDownLoadingTable];
    }
    sender.userInteractionEnabled = YES;
}

//删除确认
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloadstart.png"] forState:UIControlStateNormal];
        FilesDownManage *filedownmanage = [FilesDownManage sharedFilesDownManage];
        [filedownmanage resumeRequest:request];
    }

}


- (void)dealloc {
    [_courseDesc release];
    [_courseName release];
    [super dealloc];
}
@end
