//
//  AppDelegate.h
//  StressMonitoring
//
//  Created by Group3 on 3/3/16.
//  Copyright © 2016 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Empalink-ios-0.7-full/EmpaticaAPI-0.7.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) applicationDidEnterBackground:(UIApplication *)application;
- (void) applicationDidBecomeActive:(UIApplication *)application;

@end

