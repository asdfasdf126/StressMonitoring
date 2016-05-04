//
//  GraphView.h
//  StressMonitoring
//
//  Created by Group3 on 3/10/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>
#import "DataStatistics.h"

@interface GraphView : UIView

@property (nonatomic, assign) BOOL shouldHideData;

-(instancetype) initWithFrame:(CGRect)frame;

- (void) handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView;
- (void) updateChartData:(NSNumber *)xVal yValue:(NSNumber *)yVal yValue2:(NSNumber *)yVal2 yValue3:(NSNumber *)yVal3;
- (void) updateChartData;
- (void) setChartData:(NSArray *)xVal yValue:(NSArray *)yVal;
- (void) setDataLabel:(NSArray *)label;
- (void) setUseGradient:(Boolean)useGradient;
- (void) setUseBaseLine:(Boolean)useBaseLine;
- (void) addStats:(DataStatistics *) dataStats;

@end
