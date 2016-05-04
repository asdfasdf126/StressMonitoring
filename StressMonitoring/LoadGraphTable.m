//
//  LoadGraphTable.m
//  StressMonitoring
//
//  Created by Group3 on 4/20/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "LoadGraphTable.h"
#import "HomeViewController.h"

@interface LoadGraphTable ()

@property (nonatomic, strong) NSMutableArray *sampleFiles;
@property (nonatomic, strong) NSMutableArray *savedFiles;
@property (nonatomic, strong) NSArray *sections;

@end

@implementation LoadGraphTable

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    self.sampleFiles = [[NSMutableArray alloc] init];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle bundlePath];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:@"csv"])
        {
            NSString *fileName = [filePath stringByDeletingPathExtension];
            NSString *groupName = [[fileName componentsSeparatedByString:@"|"] objectAtIndex:0];
            
            if([self.sampleFiles containsObject:groupName])
                continue;
            
            [self.sampleFiles addObject:groupName];
        }
    }
    
    self.savedFiles = [[NSMutableArray alloc] init];
    
    self.sections = [[NSArray alloc] initWithObjects:@"Samples", @"Saved", nil];
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [self.sampleFiles count];
    else if(section == 1)
        return [self.savedFiles count];
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return @"Sample Files";
            break;
        case 1: return @"All Files";
            break;
    }
    
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
        cell.textLabel.text = [self.sampleFiles objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [self.savedFiles objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = (indexPath.section == 0)?
                            [self.sampleFiles objectAtIndex:indexPath.row]:
                            [self.savedFiles objectAtIndex:indexPath.row];
    
    HomeViewController *home = [self.navigationController.viewControllers objectAtIndex:0];
    [home setData: fileName];
    
    [self.navigationController popToRootViewControllerAnimated:true];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
