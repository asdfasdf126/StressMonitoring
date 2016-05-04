//
//  BlueToothViewController.h
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyDevicesView.h"

@interface BlueToothViewController : UIViewController

@property NearbyDevicesView *scanDevices;
@property NearbyDevicesView *myDevices;

@end
