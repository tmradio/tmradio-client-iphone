//
//  TwitterController.h
//  TMRadio
//
//  Created by Jimi Dini on 20.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *table;
    NSArray *twits;

    UIActivityIndicatorView *bufferingIndicator;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *bufferingIndicator;

- (IBAction) loadTwits:(id)sender;

@end
