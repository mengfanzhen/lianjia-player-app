//
//  FinishedCell.h


#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface FinishedCell : UITableViewCell {
    FileModel *fileInfo;

}
@property(nonatomic,assign)UIViewController *delegate;
@property(nonatomic,retain) FileModel *fileInfo;
@property (retain, nonatomic) IBOutlet UILabel *fileTypeLab;
@property (retain, nonatomic) IBOutlet UIImageView *fileImage;
@property(nonatomic,retain)IBOutlet UILabel *fileName;
@property(nonatomic,retain)IBOutlet UILabel *fileSize;
@property (retain, nonatomic) IBOutlet UILabel *timelable;
@property (retain, nonatomic) IBOutlet UILabel *finishCountLabel;
@property (retain, nonatomic)  IBOutlet UIButton *checkBtn;


- (IBAction)deleteFile:(id)sender;
- (IBAction)openFile:(UIButton *)sender;

@end
