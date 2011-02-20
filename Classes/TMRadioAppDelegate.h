//
//  TMRadioAppDelegate.h
//  TMRadio
//
//  Created by Jimi Dini on 20.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMRadioAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
