//
//  HomeViewController.h
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Empalink-ios-0.7-full/EmpaticaAPI-0.7.h>

@interface HomeViewController :UIViewController <EmpaticaDelegate, EmpaticaDeviceDelegate>

- (void) setData:(NSString *) fileName;

@end
