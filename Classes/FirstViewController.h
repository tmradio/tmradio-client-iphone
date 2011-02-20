//
//  FirstViewController.h
//  TMRadio
//
//  Created by Jimi Dini on 20.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController
{
    UISwitch *playEnabledSwitch;
    UITextView *songInfoText;
    UIActivityIndicatorView *bufferingIndicator;
}

@property (nonatomic, retain) IBOutlet UISwitch *playEnabledSwitch;
@property (nonatomic, retain) IBOutlet UITextView *songInfoText;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *bufferingIndicator;

@end
