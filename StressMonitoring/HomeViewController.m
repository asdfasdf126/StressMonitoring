//
//  HomeViewController.m
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//
@import Charts;

#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "DynamicGraphView.h"
#import "GraphView.h"
#import "DataStatistics.h"

@interface HomeViewController () <EmpaticaDelegate, EmpaticaDeviceDelegate>

@property (nonatomic, strong) GraphView *graphView;
@property (nonatomic, strong) DynamicGraphView *otherGraph;
@property (nonatomic, strong) DataStatistics *dataStats;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) NSArray *footerLabel;
@property (nonatomic, strong) NSMutableArray *allGraphs;
@property (nonatomic, strong) NSMutableArray *allStats;

@end

@implementation HomeViewController

enum DataType
{
    ACC = 0,
    BVP,
    EDA,
    HR,
    IBI
} DataType;

NSMutableArray *initialTime;
NSMutableArray *prevTime;
UIButton *prevBtn;
CGRect portraitRect;

int xVal = 0;

-(instancetype)init
{
    self = [super init];
    self.allGraphs = [[NSMutableArray alloc] init];
    self.allStats = [[NSMutableArray alloc] init];
    
    initialTime = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:-1],
                   [NSNumber numberWithInteger:-1], [NSNumber numberWithInteger:-1],
                   [NSNumber numberWithInteger:-1], [NSNumber numberWithInteger:-1], nil];
    prevTime = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:-1],
                [NSNumber numberWithInteger:-1], [NSNumber numberWithInteger:-1],
                [NSNumber numberWithInteger:-1], [NSNumber numberWithInteger:-1], nil];
    
    //create default view
    self.view.backgroundColor = [UIColor whiteColor];
    self.footerLabel = [[NSArray alloc] initWithObjects:@"ACC",@"BVP",@"EDA",@"HR",@"IBI", nil];
    
    int width = (self.view.frame.size.height > self.view.frame.size.width)?
                self.view.bounds.size.width: self.view.bounds.size.height;
    int height = (self.view.frame.size.height > self.view.frame.size.width)?
                    self.view.bounds.size.height: self.view.bounds.size.width;//self.view.bounds.size.height/3 - 30;
    
    portraitRect = CGRectMake(0, height - (height/3 - 30 + 95), width, height/3 - 30);
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, height - 75,
                                                              width, 75)];
    self.footer.backgroundColor = [UIColor grayColor];
    
    for(int x = 0; x < [self.footerLabel count]; x++)
    {
        GraphView *graph = [[GraphView alloc] initWithFrame:portraitRect];
        DataStatistics *stats = [[DataStatistics alloc] initWithFrame:CGRectMake(0, 66, width, height * 7/15)];
        
        [graph addStats:stats];
        [self createTab:[self.footerLabel objectAtIndex:x] pos:x];
        [self.allGraphs addObject:graph];
        [self.allStats addObject:stats];
    }
    
    self.graphView = [self.allGraphs objectAtIndex:0];
    self.dataStats = [self.allStats objectAtIndex:0];
    
    //add elements to view controller
    [self.view addSubview:self.graphView];
    [self.view addSubview:self.footer];
    [self.view addSubview:self.dataStats];
    
    return self;
}

- (void) createTab:(NSString *)title pos:(int) pos
{
    double width = self.view.bounds.size.width / [self.footerLabel count];
    CGRect rect = CGRectMake(width*pos, 0, width, 75);
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 75)];
    
    [btn addTarget:self action:@selector(viewSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [[btn layer] setBorderWidth:0.5f];
    [[btn layer] setBorderColor:[UIColor blackColor].CGColor];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    if(pos == 0)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        prevBtn = btn;
    }
    else
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [view addSubview:btn];
    [self.footer addSubview:view];
}

- (IBAction)viewSelected:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *text = [btn titleLabel].text;
    
    [prevBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    prevBtn = btn;
    
    [self.graphView removeFromSuperview];
    [self.dataStats removeFromSuperview];
    
    self.graphView = [self.allGraphs objectAtIndex:[self.footerLabel indexOfObject:text]];
    self.dataStats = [self.allStats objectAtIndex:[self.footerLabel indexOfObject:text]];
    
    [self.view addSubview:self.graphView];
    [self.view addSubview:self.dataStats];
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
        
        EmpaticaDeviceManager *firstDevice = [devices objectAtIndex:0];
        [firstDevice connectWithDeviceDelegate:self];
    }
    else
        NSLog(@"No device found in range");
}

- (void) didReceiveBVP:(float)bvp withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    [self fixValues:BVP x:timestamp y:bvp y2:0 y3:0];
}

- (void) didReceiveAccelerationX:(char)x y:(char)y z:(char)z withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    //double mag = sqrt(x*x + y*y + z*z);
                      
    [self fixValues:ACC x:timestamp y:x y2:y y3:z];
}

- (void) didReceiveHR:(float)hr withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    [self fixValues:HR x:timestamp y:hr y2:0 y3:0];
}

- (void) didReceiveGSR:(float)gsr withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    [self fixValues:EDA x:timestamp y:gsr y2:0 y3:0];
}

- (void) didReceiveIBI:(float)ibi withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    [self fixValues:IBI x:timestamp y:ibi y2:0 y3:0];
}

/*- (void) didReceiveTemperature:(float)temp withTimestamp:(double)timestamp fromDevice:(EmpaticaDeviceManager *)device
{
    [self fixValues:TEMP x:timestamp y:temp];
}*/

- (void) fixValues:(int)type x:(double)xVal y:(double)yVal y2:(double)yVal2 y3:(double)yVal3
{
    GraphView *curGraph = [self.allGraphs objectAtIndex:type];
    
    if([[initialTime objectAtIndex:type] doubleValue] == -1)
    {
        [initialTime setObject:[NSNumber numberWithDouble:xVal] atIndexedSubscript:type];
        [prevTime setObject:[NSNumber numberWithDouble:0] atIndexedSubscript:type];
    }
    
    double currentTime = xVal - [[initialTime objectAtIndex:type] doubleValue];
    
    [prevTime setObject:[NSNumber numberWithDouble:currentTime] atIndexedSubscript:type];
    
    [curGraph updateChartData:[NSNumber numberWithDouble:currentTime] yValue:[NSNumber numberWithDouble:yVal]
                      yValue2:[NSNumber numberWithDouble:yVal2] yValue3:[NSNumber numberWithDouble:yVal3]];
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
            [self.navigationController popViewControllerAnimated:true];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
         style:UIBarButtonItemStylePlain target:self action:@selector(pushSettings:)];
    
    [self.navigationItem setTitle:@"Monitoring"];
    self.navigationItem.rightBarButtonItem = settings;
}

- (IBAction) pushSettings:(id)sender
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped homeView:self];
    [self.navigationController pushViewController:settings animated:YES];
}

// handle rotation within the application
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //portrait
    if(size.height > size.width)
    {
        self.graphView.frame = portraitRect;
        [self.view addSubview:self.footer];
        [self.view addSubview:self.dataStats];
    }
    else //landscape
    {
        self.graphView.frame = CGRectMake(0, 66, size.width, size.height);
        [self.footer removeFromSuperview];
        [self.dataStats removeFromSuperview];
    }
    
    [self.graphView sizeToFit];
}

- (void) setData:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    for(int x = 0; x < [self.allGraphs count]; x++)
    {
        NSString *curFile = [[NSString alloc] initWithString:[@"|" stringByAppendingString:[self.footerLabel objectAtIndex:x]]];
        GraphView *curGraph = [self.allGraphs objectAtIndex:x];
        DataStatistics *stats = [self.allStats objectAtIndex:x];
        
        NSString *path = [bundle pathForResource:[fileName stringByAppendingString:curFile] ofType:@"csv"];
        NSStringEncoding usedEncoding = NSASCIIStringEncoding;
        NSError *csvError = nil;

        NSString *file = [[NSString alloc] initWithContentsOfFile:path encoding:usedEncoding error:&csvError];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

        [curGraph setDataLabel:[[NSArray alloc] initWithObjects:[self.footerLabel objectAtIndex:x], nil]];
        
        //if(x != ACC)
        //    return;
        
        if(x == ACC)
        {
            [curGraph setUseGradient:false];
            [curGraph setUseBaseLine:false];
            [curGraph setDataLabel:[[NSArray alloc] initWithObjects:@"x",@"y",@"z", nil]];
        }
        if(x == IBI)
        {
            [curGraph setDataLabel:[[NSArray alloc] initWithObjects:@"IBI 1", @"IBI 2", nil]];
            [curGraph setUseBaseLine:false];
            [curGraph setUseGradient:false];
        }

        [curGraph setChartData:nil yValue:[allLines subarrayWithRange:NSMakeRange(2, [allLines count]-3)]];
        [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(addPoint:) userInfo:nil repeats:true];
    }
}

- (IBAction)addPoint:(id)sender
{
    for(int x = 0; x < [self.allGraphs count]; x++)
    {
        GraphView *curGraph = [self.allGraphs objectAtIndex:x];
        
        [curGraph updateChartData];
        [curGraph setNeedsDisplay];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//self.otherGraph = [[DynamicGraphView alloc] initWithFrame:graphRect];

/*[self.otherGraph setBackgroundColor:[UIColor whiteColor]];
 [self.otherGraph setSpacing:10];
 [self.otherGraph setFill:true];
 [self.otherGraph setStrokeColor:[UIColor blackColor]];
 [self.otherGraph setZeroLineStrokeColor:[UIColor blueColor]];
 [self.otherGraph setFillColor:[UIColor blueColor]];
 [self.otherGraph setLineWidth:2];
 [self.otherGraph setCurvedLines:true];
 [self.otherGraph setNumberOfPointsInGraph:100];*/

@end
