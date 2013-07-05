//
//  ViewController.m
//  CustomAlert
//
//  Created by Mariya Kholod on 4/23/13.
//  Copyright (c) 2013 Mariya Kholod. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)customAlertView:(CustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Gray
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    else if (buttonIndex == 1)
    {
        //White
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

//  see :: http://iosdevtricks.blogspot.kr/2013/04/creating-custom-alert-view-for-iphone.html
//  copy from :: https://github.com/marichka/Custom-Alert-View
- (void)onAlertBtnPressed
{
    CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Warning" message:@"Set background color:" delegate:self cancelButtonTitle:@"Gray" otherButtonTitle:@"White"];
    [alert showInView:self.view];
}


#if 1
- (void) didSelectedButtonIndex:(NSInteger)btnIdx withSelectedTableRowIndexArray:(NSArray *)array;
{
    NSLog(@"didSelectedButtonIndex %d, %@", btnIdx, array);
}

// title and buttons
- (void)onCustomAlertTableBtnPressed
{
    NSArray *array_btn = @[@"ok", @"cancel", @"etc"];
    
    MPAlertTableView *alert = [[MPAlertTableView alloc] initWithCaller:self title:@"title(like alert)"
                                                       message:@"this is a message !!!\nbase source is below ~~~ https://github.com/marichka/Custom-Alert-View"
                                                          buttonTitles:array_btn];
    
    [alert showInView:self.view];
}

- (void)onCustomAlertTableBtnPressed0
{
    NSArray *table_data_array = @[@"table item 1", @"table item 2", @"table item 3"];
    NSArray *table_sel_idx = @[@"1"];
    NSArray *array_btn = @[@"cancel"];
    
    MPAlertTableView *alert = [[MPAlertTableView alloc] initWithCaller:self title:@"title(with table)" tableDataSource:table_data_array
                                                tableSelectedRowIndexs:table_sel_idx buttonTitles:array_btn];
    
    alert.selectionType = ATV_SELECTION_TYPE_NORMAL;
    [alert showInView:self.view];
}

- (void)onCustomAlertTableBtnPressed1
{
    NSArray *table_data_array = @[@"table item 1", @"table item 2", @"table item 3"];
    NSArray *table_sel_idx = @[@"1"];
    NSArray *array_btn = @[@"ok", @"cancel"];
    
    MPAlertTableView *alert = [[MPAlertTableView alloc] initWithCaller:self title:@"title(with table, single selection)" tableDataSource:table_data_array
                                                tableSelectedRowIndexs:table_sel_idx buttonTitles:array_btn];
    alert.selectionType = ATV_SELECTION_TYPE_SINGLE;
    [alert showInView:self.view];
}

- (void)onCustomAlertTableBtnPressed2
{
    NSArray *table_data_array = @[@"table item 1", @"table item 2", @"table item 3", @"table item 4"];
    NSArray *table_sel_idx = @[@"1", @"3"];
    NSArray *array_btn = @[@"ok", @"cancel", @"etc"];
    
    MPAlertTableView *alert = [[MPAlertTableView alloc] initWithCaller:self title:@"title(with table, multi selection)" tableDataSource:table_data_array
                                                tableSelectedRowIndexs:table_sel_idx buttonTitles:array_btn];
    alert.selectionType = ATV_SELECTION_TYPE_MULTI;
    [alert showInView:self.view];
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *AlertBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    AlertBtn.frame = CGRectMake((int)((self.view.frame.size.width-200.0)/2.0), 50.0, 200.0, 40.0);
    [AlertBtn setTitle:@"Show Orgin Alert" forState:UIControlStateNormal];
    [AlertBtn addTarget:self action:@selector(onAlertBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AlertBtn];
    AlertBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;


#if 1
    UIButton *cAlertBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cAlertBtn.frame = CGRectMake((int)((self.view.frame.size.width-200.0)/2.0), 50.0 + 50.0, 200.0, 40.0);
    [cAlertBtn setTitle:@"Show custom(alert)" forState:UIControlStateNormal];
    [cAlertBtn addTarget:self action:@selector(onCustomAlertTableBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cAlertBtn];
    cAlertBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;


    UIButton *cAlertBtn0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cAlertBtn0.frame = CGRectMake((int)((self.view.frame.size.width-200.0)/2.0), 50.0 + 100.0, 200.0, 40.0);
    [cAlertBtn0 setTitle:@"Show custom(normal)" forState:UIControlStateNormal];
    [cAlertBtn0 addTarget:self action:@selector(onCustomAlertTableBtnPressed0) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cAlertBtn0];
    cAlertBtn0.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UIButton *cAlertBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cAlertBtn1.frame = CGRectMake((int)((self.view.frame.size.width-200.0)/2.0), 50.0 + 150.0, 200.0, 40.0);
    [cAlertBtn1 setTitle:@"Show custom(single)" forState:UIControlStateNormal];
    [cAlertBtn1 addTarget:self action:@selector(onCustomAlertTableBtnPressed1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cAlertBtn1];
    cAlertBtn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UIButton *cAlertBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cAlertBtn2.frame = CGRectMake((int)((self.view.frame.size.width-200.0)/2.0), 50.0 + 200.0, 200.0, 40.0);
    [cAlertBtn2 setTitle:@"Show custom(multi)" forState:UIControlStateNormal];
    [cAlertBtn2 addTarget:self action:@selector(onCustomAlertTableBtnPressed2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cAlertBtn2];
    cAlertBtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
