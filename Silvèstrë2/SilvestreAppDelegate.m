//
//  SilvestreAppDelegate.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreAppDelegate.h"

@implementation SilvestreAppDelegate

@synthesize window = _window;

- (void)customizeAppearance
{
       
    UIImage *titleBarBackgroundImage = [[UIImage alloc]init];
    titleBarBackgroundImage=[[UIImage imageNamed:@"titleBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      
    [[UINavigationBar appearance] setBackgroundImage:titleBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.0 green:0.44 blue:0.0 alpha:1.0]];
    
    UIImage *tabBarBackgroundImage = [[UIImage alloc]init];

    tabBarBackgroundImage=[[UIImage imageNamed:@"tabbarBack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    
    [[UITabBar appearance] setBackgroundImage: tabBarBackgroundImage];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
