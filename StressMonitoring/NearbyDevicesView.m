//
//  NearbyDevicesView.m
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "NearbyDevicesView.h"

@implementation NearbyDevicesView

NSArray *devicesFound;
NSMutableArray *recentDevices;

//initialize view with given positioning frame
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style type:(NSInteger *)type
{
    self = [super initWithFrame:frame style:style];
    
    [self registerClass:[ UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    devicesFound = [[NSArray alloc] init];
    recentDevices = [[NSMutableArray alloc] init];
    
    self.type = type;
    
    return self;
}

- (IBAction)ScanForDevicesButtonPressed:(id)sender
{
    [EmpaticaAPI discoverDevicesWithDelegate:self];
}

- (void) didDiscoverDevices:(NSArray *)devices
{
    if(devices.count > 0)
    {
        // Print names of available devices
        for (EmpaticaDeviceManager *device in devices)
            NSLog(@"Device: %@", device.name);
        
        devicesFound = devices;
    }
    else
        NSLog(@"No device found in range");
}

- (void)didReceiveGSR:(float)gsr withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    NSLog(@"GSR value received: %f at timestamp: %lf", gsr, timestamp);
}

- (void)didUpdateDeviceStatus:(DeviceStatus)status forDevice:(EmpaticaDeviceManager *)device
{
    switch (status)
    {
        case kDeviceStatusDisconnected:
            NSLog(@"Device Disconnected");
            break;
        case kDeviceStatusConnecting:
            NSLog(@"Device Connecting");
            break;
        case kDeviceStatusConnected:
            NSLog(@"Device Connected");
            break;
        case kDeviceStatusDisconnecting:
            NSLog(@"Device Disconnecting");
            break;
        default:
            break;
    }
}


- (void)didUpdateBLEStatus:(BLEStatus)status
{
    switch (status) {
        case kBLEStatusNotAvailable:
            NSLog(@"Bluetooth low energy not available");
            break;
        case kBLEStatusReady:
            NSLog(@"Bluetooth low energy ready");
            break;
        case kBLEStatusScanning:
            NSLog(@"Bluetooth low energy scanning for devices");
            break;
        default:
            break;
    }
}

//connect to device
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmpaticaDeviceManager *device = devicesFound[indexPath.row];
    [device connectWithDeviceDelegate:self];
    
    if([device deviceStatus] == kDeviceStatusConnected)
    {
        NSLog(@"Device connected");
        
        [recentDevices addObject:device];
        
    }
    else if([device deviceStatus] == kDeviceStatusFailedToConnect)
        NSLog(@"Failed to connect");
}

//sets the title for each table
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (self.type == 0) ? @"My Devices" : @"Devices";
}

//return number of devices found
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (self.type == 0) ? [recentDevices count] : [devicesFound count];
}

//Create cells with devices in range
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    EmpaticaDeviceManager *device = (self.type == 0) ? recentDevices[indexPath.row] : devicesFound[indexPath.row];
    cell.textLabel.text = [device description];
    
    return cell;
    
}

//sets editing
- (IBAction) toggleEditingMode:(id) sender
{
    // If you are currently in editing mode...
    if (self.isEditing)
    {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    }
    else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}

@end
