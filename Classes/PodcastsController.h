//
//  PodcastsController.h
//  TMRadio
//
//  Created by Jimi Dini on 22.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PodcastsController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *table;
    NSArray *podcasts;

    UIActivityIndicatorView *bufferingIndicator;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *bufferingIndicator;

- (IBAction) loadPodcasts:(id)sender;

@end
