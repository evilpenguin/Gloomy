//
//  AppDelegate.m
//  JustPlaying
//
//  Created by James Emrich on 7/2/18.
//  Copyright © 2018 James Emrich. All rights reserved.
//

#import "GloomyAppDelegate.h"
#import "GRootViewController.h"

@implementation GloomyAppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.rootViewController = [GRootViewController new];
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
