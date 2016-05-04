//
//  DataView.m
//  StressMonitoring
//
//  Created by Group3 on 4/22/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "DataView.h"

@interface DataView()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSArray *labelNames;
@property float sum;
@property int count;

@end

@implementation DataView

enum Name
{
    MAX = 0,
    MIN,
    AVG,
    MED
} Name;

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.labelNames = [[NSArray alloc] initWithObjects:@"Max", @"Min", @"Avg", @"Med", nil];
    self.labels = [[NSMutableArray alloc] init];
    
    self.sum = 0;
    self.count = 0;
    
    [self createView];
    
    return self;
}

- (void) createLabels
{
    int xPos = 0;
    int yPos = 0;
    
    for(int x = 0; x < [self.labelNames count]; x++)
    {
        yPos = x%2;
        
        CGRect frame = CGRectMake(50 + (120 * xPos), 10 + (yPos * 50), 40, 30);
        CGRect frameVal = CGRectMake(100 + (120 * xPos), 10 + (yPos * 50), 60, 30);
        UILabel *lbl  = [[UILabel alloc] initWithFrame:frame];
        UILabel *lblVal = [[UILabel alloc] initWithFrame:frameVal];
        
        lbl.textColor = [UIColor blackColor];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.text = [[self.labelNames objectAtIndex:x] stringByAppendingString:@":"];
        lbl.backgroundColor = [UIColor whiteColor];
        
        lblVal.textColor = [UIColor blackColor];
        lblVal.textAlignment = NSTextAlignmentLeft;
        lblVal.text = @"0.00";
        lblVal.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:lbl];
        [self addSubview:lblVal];
        
        [self.labels addObject:lblVal];
        
        xPos += x%2;
    }
}

- (void) addVar:(double) var
{
    for(int x = 0; x < [self.labels count]; x++)
    {
        UILabel *lbl = [self.labels objectAtIndex:x];
        double val = [lbl.text doubleValue];
     
        [lbl removeFromSuperview];
        
        switch(x)
        {
            case MAX:
                if(var > val)
                    lbl.text = [NSString stringWithFormat:@"%.2f", val];
                break;
            case MIN:
                if(var < val)
                    lbl.text = [NSString stringWithFormat:@"%.2f", val];
                break;
            case AVG: self.sum += var;
                lbl.text = [NSString stringWithFormat:@"%.2f", self.sum / ++self.count];
                break;
        }
        
        [self addSubview:lbl];
    }
}

- (void) createView
{
    [self createLabels];
}

@end
