//
//  TMRadioAppDelegate.m
//  TMRadio
//
//  Created by Jimi Dini on 20.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import "TMRadioAppDelegate.h"


@implementation TMRadioAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize uiIsVisible;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    self.uiIsVisible = NO;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.uiIsVisible = NO;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.uiIsVisible = YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.uiIsVisible = YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    self.uiIsVisible = NO;
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

