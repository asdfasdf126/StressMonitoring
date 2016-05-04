//
//  GraphView.m
//  StressMonitoring
//
//  Created by Group3 on 3/10/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import "GraphView.h"


@interface GraphView()

@property (nonatomic, strong) DataStatistics *dataView;
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) ChartLimitLine *ll;
@property (nonatomic, strong) NSMutableArray *xVals;
@property (nonatomic, strong) NSMutableArray *yVals;
@property (nonatomic, strong) NSMutableArray *yVals2;
@property (nonatomic, strong) NSMutableArray *yVals3;
@property (nonatomic, strong) ChartYAxis *leftAxis;
@property (nonatomic, strong) NSArray *label;
@property (nonatomic, assign) BOOL useGradient;
@property (nonatomic, assign) BOOL useBaseLine;
@property int count;
@property double avg;
@property int numSets;

@end

@implementation GraphView

const int MAXVALUES = 40;
const int AVGVALUES = 50;
static NSArray *colors;

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    colors = [[NSArray alloc] initWithObjects:[UIColor blueColor], [UIColor greenColor], [UIColor redColor], nil];
    self.useGradient = true;
    self.useBaseLine = true;
    self.numSets = 0;
    
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    self.chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.xVals = [[NSMutableArray alloc] init];
    self.yVals = [[NSMutableArray alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.chartView.descriptionText = @"";
    self.chartView.noDataTextDescription = @"Please connect a device.";
    self.chartView.infoTextColor = [UIColor blackColor];
    
    self.chartView.dragEnabled = true;
    self.chartView.pinchZoomEnabled = true;
    self.chartView.drawGridBackgroundEnabled = false;
    [self.chartView setScaleEnabled:true];
    [self.chartView setAutoScaleMinMaxEnabled:false];
    
    self.ll = [[ChartLimitLine alloc] initWithLimit:0.0 label:@"Base line"];
    self.ll.lineWidth = 4.0;
    self.ll.lineDashLengths = @[@5.f, @5.f];
    self.ll.labelPosition = ChartLimitLabelPositionRightTop;
    self.ll.valueFont = [UIFont systemFontOfSize:10.0];
    self.ll.lineColor = [UIColor blueColor];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    nf.maximumSignificantDigits = 3;
    
    self.leftAxis = self.chartView.leftAxis;
    [self.leftAxis removeAllLimitLines];
    self.leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    self.leftAxis.drawZeroLineEnabled = false;
    self.leftAxis.drawLimitLinesBehindDataEnabled = true;
    self.leftAxis.forceLabelsEnabled = true;
    self.leftAxis.valueFormatter = nf;
    
    ChartXAxis *xAxis = self.chartView._xAxis;
    xAxis.spaceBetweenLabels = 10;
    
    self.chartView.rightAxis.enabled = false;
    
    [self.chartView.viewPortHandler setMaximumScaleY:5.f];
    [self.chartView.viewPortHandler setMaximumScaleX:2.f];
    
    self.chartView.legend.form = ChartLegendFormLine;
    
    [self addSubview:self.chartView];
    
    return self;
}

- (void) addStats:(DataStatistics *) dataStats
{
    self.dataView = dataStats;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        self.chartView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-75);
    }
}

- (void)handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView
{
    
}

- (void) setChartData:(NSArray *)xVal yValue:(NSArray *)yVal
{
    int values = (int)[[[yVal objectAtIndex:0] componentsSeparatedByString:@","] count];
    
    self.chartView.data = [[LineChartData alloc] init];
    self.count = 0;
    self.avg = 0;
    
    [self updateChartData:0 yValue:0 yValue2:0 yValue3:0];
    //[self.dataView setVars:values];
    
    self.xVals = [[NSMutableArray alloc] init];
    self.yVals = [[NSMutableArray alloc] init];
    
    if(values > 1)
        self.yVals2 = [[NSMutableArray alloc] init];
    if(values > 2)
        self.yVals3 = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [yVal count]; i++)
    {
        NSArray *allValues = [[yVal objectAtIndex:i] componentsSeparatedByString:@","];
        
        double x = 0;
        double y = 0;
        double y2 = 0;
        double y3 = 0;
        
        if(xVal == nil)
            x = i;
        else
            x = [xVal[i] doubleValue];
        y = [[allValues objectAtIndex:0] doubleValue];
        if([allValues count] > 1)
            y2 = [[allValues objectAtIndex:1] doubleValue];
        if([allValues count] > 2)
            y3 = [[allValues objectAtIndex:2] doubleValue];

        
        //[self updateChartData:x yValue:y];
        [self.xVals addObject:[NSNumber numberWithDouble:x]];
        [self.yVals addObject:[NSNumber numberWithDouble:y]];
        
        if(self.yVals2 != nil)
            [self.yVals2 addObject:[NSNumber numberWithDouble:y2]];
        if(self.yVals3 != nil)
            [self.yVals3 addObject:[NSNumber numberWithDouble:y3]];
    }
}

- (void) updateChartData
{
    @try
    {
        if([self.xVals count]+1 < self.count)
            return;
        
        NSArray *vars = [[NSArray alloc] initWithObjects:[self.yVals objectAtIndex:self.count],
                         (self.yVals2 == nil)?nil:[self.yVals2 objectAtIndex:self.count],
                         (self.yVals2 == nil)?nil:[self.yVals3 objectAtIndex:self.count], nil];
        
        [self updateChartData:[self.xVals objectAtIndex:self.count]
                       yValue:[self.yVals objectAtIndex:self.count]
                       yValue2:(self.yVals2 == nil)?nil:[self.yVals2 objectAtIndex:self.count]
                       yValue3:(self.yVals2 == nil)?nil:[self.yVals3 objectAtIndex:self.count]
         ];
        
        [self.dataView addVars:vars];
    } @catch (NSException *exception)
    {
    }
    
}

- (void) updateChartData:(NSNumber *)xVal yValue:(NSNumber *)yVal yValue2:(NSNumber *)yVal2 yValue3:(NSNumber *)yVal3
{
    if (self.shouldHideData)
    {
        self.chartView.data = nil;
        return;
    }
    
    LineChartData *data = self.chartView.data;
    
    if(data != nil)
    {
        LineChartDataSet *set = [data getDataSetByIndex:0];
        LineChartDataSet *set2;
        LineChartDataSet *set3;
        
        if(self.yVals2 != nil)
            set2 = [data getDataSetByIndex:1];
        if(self.yVals3 != nil)
            set3 = [data getDataSetByIndex:2];
        
        if(self.count < AVGVALUES)
            self.avg += [yVal doubleValue];
        else if(self.count == AVGVALUES)
        {
            self.avg /= self.count;
            
            if(self.useBaseLine)
            {
                [self.ll setLimit:self.avg];
                [self.chartView.leftAxis addLimitLine:self.ll];
            }
        }
        
        self.count++;
        
        if(set == nil)
            [self createSet:set data:data];
        if(set2 == nil && self.yVals2 != nil)
            [self createSet:set2 data:data];
        if(set3 == nil && self.yVals3 != nil)
            [self createSet:set3 data:data];
        
        [self.chartView setVisibleXRangeMaximum:MAXVALUES];
        [self.chartView setVisibleXRangeMinimum:MAXVALUES];
        
        [data addXValue:[NSString stringWithFormat:@"%.1f", [xVal doubleValue]]];
        [data addEntry:[[ChartDataEntry alloc] initWithValue:[yVal doubleValue] xIndex:[xVal doubleValue]] dataSetIndex:0];
        
        if(set2 != nil)
            [data addEntry:[[ChartDataEntry alloc] initWithValue:[yVal2 doubleValue] xIndex:[xVal doubleValue]] dataSetIndex:1];
        if(set3 != nil)
            [data addEntry:[[ChartDataEntry alloc] initWithValue:[yVal3 doubleValue] xIndex:[xVal doubleValue]] dataSetIndex:2];
        
        int move = [[set entryForIndex:[set entryCount] - 1] xIndex];
        
        [self.chartView notifyDataSetChanged];
        [self.chartView moveViewToX:(move - MAXVALUES < 0)?0:move - MAXVALUES];
    }
    else
    {
        self.chartView.data = [[LineChartData alloc] init];
        self.numSets = 0;
    }
}

- (void) createSet:(LineChartDataSet *)set data:(LineChartData *)data
{
    set = [[LineChartDataSet alloc] init];
    
    set.drawCirclesEnabled = false;
    set.drawValuesEnabled = false;
    [set setColor:[colors objectAtIndex:self.numSets]];
    set.lineWidth = 1.0;
    set.valueFont = [UIFont systemFontOfSize:9.f];
    set.drawCubicEnabled = true;
    set.label = [self.label objectAtIndex:self.numSets];
    
    if(self.useGradient)
    {
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set.fillAlpha = 1.f;
        set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set.drawFilledEnabled = true;
    
        CGGradientRelease(gradient);
    }
    
    self.numSets++;
    [data addDataSet:set];
}

- (void) setDataLabel:(NSArray *)label
{
    self.label = label;
}
@end
