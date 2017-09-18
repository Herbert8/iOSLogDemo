//
//  ViewController.m
//  TestiOSLog
//
//  Created by 巴宏斌 on 2017/9/18.
//  Copyright © 2017年 巴宏斌. All rights reserved.
//

#import "ViewController.h"

#import <NSLogger/NSLogger.h>
#import <Crashlytics/Crashlytics.h>
#import <PonyDebugger/PonyDebugger.h>
#import <AFNetworking/AFNetworking.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    UITableView *itemTable;
    NSArray *itemArray;
    NSString *cellId;
}

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    NSLog(@"sskk");
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//
//
//    }
//    return self;
//}

//- (instancetype)init {
//    NSLog(@"ss");
//    return nil;
//}

- (void)viewDidLoad {


    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    itemArray = @[@"NSLogger", @"Crashlytics", @"PonyDebugger", @"CocoaLumberjack"];
    cellId = @"cellId";

    CGRect frame = self.view.bounds;
    frame.origin.y = 20;
    frame.size.height -= 20;

    itemTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [itemTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];

    [self.view addSubview:itemTable];

    itemTable.delegate = self;
    itemTable.dataSource = self;

    [itemTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId
                                                            forIndexPath:indexPath];
    cell.textLabel.text = itemArray[indexPath.row];

    return cell;

}

#define ddLogLevel DDLogLevelAll

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            NSLog(@"这是 NSLogger 的日志");
            break;

        case 1:
            [[Crashlytics sharedInstance] crash];
            break;

        case 2:
            [self testPonyDebugger];
            break;

        case 3:
            [self setupCocoaLumberjack];
            DDLogVerbose(@"Verbose");
            DDLogDebug(@"Debug");
            DDLogInfo(@"Info");
            DDLogWarn(@"Warn");
            DDLogError(@"Error");
            break;

        default:
            break;
    }

}

#pragma mark - 测试 PonyDebugger
- (NSString *)genUrlStr {
    NSString *sUrl = @"https://www.sslpoc.com/t.json";
    sUrl = @"http://httpbin.org/get";
    NSString *url = [NSString stringWithFormat:@"%@?ts=%f",
                     sUrl,
                     [[NSDate date] timeIntervalSince1970]];
    return url;
}


- (void)testPonyDebugger {
    NSString *url = [self genUrlStr];

    PDLogD(@"url = %@", url);

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    [mgr GET:url
  parameters:nil progress:nil
     success:nil
     failure:nil];

}

#pragma mark - 测试 CocoaLumberjack

- (void)setupCocoaLumberjack {
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

    DDLogVerbose(@"log paths = %@", fileLogger.logFileManager.sortedLogFilePaths);

}







@end
