//
//  AppDelegate.h
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(NSMutableArray*) getHistory;
+(void) setHistory:(NSMutableArray*) h;
+(void) loadHistory;
+(void) saveHistory;

@end
