

#import "FileModel.h"


@implementation FileModel
@synthesize fileID;
@synthesize fileName;
@synthesize fileSize;
@synthesize fileType;
@synthesize isFirstReceived;
@synthesize fileReceivedData;
@synthesize fileReceivedSize;
@synthesize fileURL;
@synthesize targetPath;
@synthesize tempPath;

@synthesize error;
@synthesize time;
@synthesize MD5,fileimage;
@synthesize courseId;
@synthesize courseName;
@synthesize teacher;
@synthesize imgPath;
@synthesize chapterId;
@synthesize chapterName;
@synthesize courseDesc;
@synthesize chapterDesc;

-(id)init{
    self = [super init];
    
    return self;
}
@end
