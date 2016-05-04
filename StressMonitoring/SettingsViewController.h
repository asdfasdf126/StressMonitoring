//
//  SettingsViewController.h
//  StressMonitoring
//
//  Created by Group3 on 4/4/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Empalink-ios-0.7-full/EmpaticaAPI-0.7.h>
#import "HomeViewController.h"

@interface SettingsViewController : UITableViewController

- (instancetype) initWithStyle:(UITableViewStyle)style homeView:(HomeViewController *)homeView;

@end
