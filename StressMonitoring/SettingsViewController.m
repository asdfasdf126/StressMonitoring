//
//  SettingsViewController.m
//  StressMonitoring
//
//  Created by Group3 on 4/4/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoadGraphTable.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

HomeViewController *home;
NSMutableArray *btDevices;
NSArray *files;

- (instancetype) initWithStyle:(UITableViewStyle)style homeView:(HomeViewController *)homeView;
{
    self = [super initWithStyle:style];
    
    home = homeView;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    btDevices = [[NSMutableArray alloc] initWithObjects:@"Connect to device", nil];
    files = [[NSArray alloc] initWithObjects:@"Save", @"Save As", @"Delete", @"Load", nil];
    
    self.title = @"Settings";
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Bluetooth Devices", @"Bluetooth Devices");
            break;
        case 1:
            sectionName = NSLocalizedString(@"File Management", @"File Management");
            break;
        default:
            sectionName = @"";
            break;
    }
    
    return sectionName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [btDevices count];
    else
        return[files count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    
    if(indexPath.section == 0)
        cell.textLabel.text = [btDevices objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [files objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        switch(indexPath.row)
        {
            case 0: [EmpaticaAPI discoverDevicesWithDelegate:home];
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch(indexPath.row)
        {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            case 3: [self.navigationController pushViewController:[[LoadGraphTable alloc]
                                                                   initWithStyle:UITableViewStyleGrouped] animated:true];
                break;
        }
    }
}

@end