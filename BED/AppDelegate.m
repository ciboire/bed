//
//  AppDelegate.m
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

static NSMutableArray* history = nil;

+(NSMutableArray*) getHistory
{
    return history;
}

+(void) setHistory:(NSMutableArray*) h
{
    history = h;
}

+(void)loadHistory
{
    NSString* applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dataFilename = [applicationDocumentsDir stringByAppendingPathComponent:@"history"];
    NSData* data = [NSData dataWithContentsOfFile:dataFilename];
    if (data != nil) 
    {
        NSLog(@"App Delegate loading data from file.");
        history = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+(void)saveHistory
{
    if (history != nil)
    {
        NSLog(@"App Delegate saving data to file.");
        NSString* applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* dataFilename = [applicationDocumentsDir stringByAppendingPathComponent:@"history"];
        [[NSKeyedArchiver archivedDataWithRootObject:history] writeToFile:dataFilename atomically:YES];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Load the data file if it exists; or just initialize an empty data array if not.
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
