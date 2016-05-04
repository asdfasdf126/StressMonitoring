//
//  BlueToothViewController.m
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "BlueToothViewController.h"

@interface BlueToothViewController ()

@end

@implementation BlueToothViewController

- (instancetype) init
{
    //dimensions of table views
    int offset = self.navigationController.navigationBar.frame.size.height;
    int height = (self.view.bounds.size.height - offset)/2;
    int width = self.view.bounds.size.width;
    
    //create default view
    UIView *view = [[UIView alloc] init];
    view.bounds = self.view.bounds;
    view.backgroundColor = [UIColor yellowColor];
    self.view = view;
    
    //set table views
    self.myDevices = [[NearbyDevicesView alloc] initWithFrame:CGRectMake(0, offset, width, height) style:UITableViewStylePlain type: 0];
    self.scanDevices = [[NearbyDevicesView alloc] initWithFrame:CGRectMake(0, height, width, height) style:UITableViewStylePlain type: 1];
    
    self.myDevices.delegate = self.myDevices;
    self.myDevices.dataSource = self.myDevices;
     
    self.scanDevices.delegate = self.scanDevices;
    self.scanDevices.dataSource = self.scanDevices;
     
    [self.view addSubview:self.myDevices];
    [self.view addSubview:self.scanDevices];
     
    //create scan for bluetooth button
    UIBarButtonItem *btnScan = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.scanDevices action:@selector(ScanForDevicesButtonPressed:)];
    
    //initialize navigation controller items
    self.navigationItem.title = @"Bluetooth Menu";
    self.navigationItem.rightBarButtonItem = btnScan;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
