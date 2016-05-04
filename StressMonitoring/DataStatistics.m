//
//  DataStatistics.m
//  StressMonitoring
//
//  Created by Group3 on 4/22/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "DataStatistics.h"
#import "DataView.h"

@interface DataStatistics()

@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation DataStatistics

int vars;

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.views = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) createDataViews
{
    int width = self.frame.size.width;
    int height = self.frame.size.height/3;
    
    for(int x = 0; x < vars; x++)
    {
        CGRect frame = CGRectMake(0, height*x, width, height);
        DataView *data = [[DataView alloc] initWithFrame:frame];
        
        [self addSubview:data];
        [self.views addObject:data];
    }
    
    NSLog(@"Added %d views", vars);
}

- (void) setVars:(int) numVars
{
    vars = numVars;
    
    [self createDataViews];
}

- (void) addVars:(NSArray *)varArray
{
    for(int x = 0; x < vars; x++)
        [((DataView *)[self.views objectAtIndex:x]) addVar:[[varArray objectAtIndex:x] doubleValue]];
}

@end
