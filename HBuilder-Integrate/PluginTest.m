//
//  PluginTest.m
//  HBuilder-Hello
//
//  Created by Mac Pro on 14-9-3.
//  Copyright (c) 2014年 DCloud. All rights reserved.
//

#import "PluginTest.h"
#import "MoviePlayerViewController.h"
#import "DownloadNav.h"
#import "DownloadListController.h"

@implementation PGPluginTest

- (void)PluginTestFunction:(PGMethod*)commands
{
	if ( commands ) {
    
//        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
//        NSString* cbId = [commands.arguments objectAtIndex:0];
//        
//        // 用户的参数会在第二个参数传回
//        NSString* pArgument1 = [commands.arguments objectAtIndex:1];
//        NSString* pArgument2 = [commands.arguments objectAtIndex:2];
//        NSString* pArgument3 = [commands.arguments objectAtIndex:3];
//        NSString* pArgument4 = [commands.arguments objectAtIndex:4];
//        
//        // 如果使用Array方式传递参数
//        NSArray* pResultString = [NSArray arrayWithObjects:pArgument1, pArgument2, pArgument3, pArgument4, nil];
//        
//        // 运行Native代码结果和预期相同，调用回调通知JS层运行成功并返回结果
//        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray: pResultString];
//
//        // 如果Native代码运行结果和预期不同，需要通过回调通知JS层出现错误，并返回错误提示
//        //PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusError messageAsString:@"惨了! 出错了！ 咋(wu)整(liao)"];
//
//        // 通知JS层Native层运行结果
//        [self toCallback:cbId withReslut:[result toJSONString]];
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
//        
//        NSData *orgFileData = [NSData dataWithContentsOfURL:url ];
//        NSData *resultData = [orgFileData subdataWithRange:NSMakeRange(16, orgFileData.length -16)];
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *filePath = [NSString stringWithFormat:@"%@/1_tmp.mp4",documentsDirectory];
//        
//        [resultData writeToFile:filePath atomically:YES];
//        
//        filePath = [NSString stringWithFormat:@"file://%@",filePath];
//        
//        url = [NSURL URLWithString:filePath];
//        MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:url movieTitle:@"电影名称1"];
//        [self presentViewController:movieVC animated:YES completion:nil];
//        [movieVC release];
        
        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
        NSString* cbId = [commands.arguments objectAtIndex:1];
  

        if (cbId == nil || [@""  isEqualToString:cbId]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"参数错误" message:@"传入参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            NSLog(@"没有传入参数");
            
            [alertView show];
        }else{
            
            NSString* playIndexStr = [commands.arguments objectAtIndex:2];
            int playIndex = playIndexStr.intValue;
            
            NSData *jsonData = [cbId dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err = nil;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            
            if (dic == nil || [dic count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"参数错误" message:@"传入参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
                return;

            }
            
            
            NSDictionary *resultDict = dic;
            
            NSArray *chapterList = [resultDict objectForKey:@"chapterList"];
            
            NSDictionary *lineContentDic = [resultDict objectForKey:@"lineContent"];
            NSString *courseName = [lineContentDic objectForKey:@"videoName"];

            
//            MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithJsonString:cbId playIndex:playIndex];
            MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithChapterList:chapterList playIndex:playIndex courseName:courseName];
            [self presentViewController:movieVC animated:YES completion:nil];
            [movieVC release];
            
        }
        

        
        
//        NSURL *jsonUrl = [NSURL URLWithString:@"http://app.ljabc.com.cn/app/classRoom/getCourseByCourseId.html?courseId=783"];
//        
//        
//        MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithJsonURL:jsonUrl];
//        [self presentViewController:movieVC animated:YES completion:nil];
//        [movieVC release];
        
    }
}

- (void)PluginTestFunctionArrayArgu:(PGMethod*)commands
{
    if ( commands ) {
        
//        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
//        NSString* cbId = [commands.arguments objectAtIndex:0];
//        
//        // 用户的参数会在第二个参数传回，可以按照Array方式传入，
//        NSArray* pArray = [commands.arguments objectAtIndex:1];
//        
//        // 如果使用Array方式传递参数
//        NSString* pResultString = [NSString stringWithFormat:@"%@ %@ %@ %@",[pArray objectAtIndex:0], [pArray objectAtIndex:1], [pArray objectAtIndex:2], [pArray objectAtIndex:3]];
//        
//        // 运行Native代码结果和预期相同，调用回调通知JS层运行成功并返回结果
//        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsString:pResultString];
//        
//        // 如果Native代码运行结果和预期不同，需要通过回调通知JS层出现错误，并返回错误提示
//        //PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusError messageAsString:@"惨了! 出错了！ 咋(wu)整(liao)"];
//        
//        // 通知JS层Native层运行结果
//        [self toCallback:cbId withReslut:[result toJSONString]];
        NSArray* array = [commands.arguments objectAtIndex:1] ;
        NSString *cbId = [array objectAtIndex:0];
        if (cbId == nil || [@""  isEqualToString:cbId]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"参数错误" message:@"传入参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            NSLog(@"没有传入参数");

            [alertView show];
            return;
        }else{
            
//            NSString* playIndexStr = [commands.arguments objectAtIndex:2];
//            int playIndex = playIndexStr.intValue;
            
            NSData *jsonData = [cbId dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err = nil;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            
            if (dic == nil || [dic count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"参数错误" message:@"传入参数错误！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alertView show];
                return;
                
            }
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];

            DownloadNav *downloadNav = [story instantiateViewControllerWithIdentifier:@"DownloadNav"];
            NSArray *controllers = downloadNav.viewControllers;
            
            DownloadListController* dlc = [controllers objectAtIndex:0];
//            [dlc initDownLoadDataWithDic:dic];
            
            
            [self presentViewController:downloadNav animated:YES completion:nil];
            

            [downloadNav release];
            
        }

        
    }
}


- (NSData*)PluginTestFunctionSync:(PGMethod*)command
{
    // 根据传入获取参数
    NSString* pArgument1 = [command.arguments objectAtIndex:0];
    NSString* pArgument2 = [command.arguments objectAtIndex:1];
    NSString* pArgument3 = [command.arguments objectAtIndex:2];
    NSString* pArgument4 = [command.arguments objectAtIndex:3];
    
    // 拼接成字符串
    NSString* pResultString = [NSString stringWithFormat:@"%@ %@ %@ %@", pArgument1, pArgument2, pArgument3, pArgument4];

    // 按照字符串方式返回结果
    return [self resultWithString: pResultString];
}


- (NSData*)PluginTestFunctionSyncArrayArgu:(PGMethod*)command
{
    // 根据传入参数获取一个Array，可以从中获取参数
    NSArray* pArray = [command.arguments objectAtIndex:0];
    
    // 创建一个作为返回值的NSDictionary
    NSDictionary* pResultDic = [NSDictionary dictionaryWithObjects:pArray forKeys:[NSArray arrayWithObjects:@"RetArgu1",@"RetArgu2",@"RetArgu3", @"RetArgu4", nil]];

    // 返回类型为JSON，JS层在取值是需要按照JSON进行获取
    return [self resultWithJSON: pResultDic];
}
- (void)playLocalMovieList{
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"mp4"];
    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"3" withExtension:@"mp4"];
    NSArray *list = @[url1,url2,url3];
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURLList:list movieTitle:@"电影名称3"];
    [self presentViewController:movieVC animated:YES completion:nil];
}
- (BOOL)isHavePreviousMovie{
    return NO;
}
- (BOOL)isHaveNextMovie{
    return NO;
}
- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie{
    return nil;
}
- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie{
    return nil;
}
@end
