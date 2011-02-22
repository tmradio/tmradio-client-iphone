    //
//  PodcastsController.m
//  TMRadio
//
//  Created by Jimi Dini on 22.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import "PodcastsController.h"

#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "NSArray_JSONExtensions.h"


@implementation PodcastsController

@synthesize table;
@synthesize bufferingIndicator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    podcasts = nil;
    [self loadPodcasts: self];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void) loadPodcasts:(id)sender
{
    NSURL *url = [NSURL URLWithString: @"http://www.tmradio.net/podcast.json"];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [bufferingIndicator startAnimating];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [bufferingIndicator stopAnimating];
    // NSData *responseData = [request responseData];
    NSString *responseString = [request responseString];

    // NSLog(@"got: %@", responseString);

    NSError *error = nil;
    NSArray *theArray = [NSArray arrayWithJSONString:responseString error:&error];

    if (nil != podcasts) {
        [podcasts release];
    }
    podcasts = [theArray retain];

    [table reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [bufferingIndicator stopAnimating];
    NSError *error = [request error];
    NSLog(@"got error");
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"total row count: %d", [podcasts count]);
    return [podcasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath indexAtPosition: 1];

    NSDictionary *podcast = [podcasts objectAtIndex: index];
    NSString *user = [podcast valueForKey: @"author"];
    NSString *text = [podcast valueForKey: @"title"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"PodcastsController"];
    UILabel *mainLabel, *secondLabel;

    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"PodcastsController"] autorelease];
        // CGRect frame = cell.contentView.frame;
        // frame.size.height = 90.0;
        // cell.contentView.frame = frame;

        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
        secondLabel.tag = 102;
        secondLabel.font = [UIFont systemFontOfSize:12.0];
        secondLabel.textAlignment = UITextAlignmentRight;
        secondLabel.lineBreakMode = UILineBreakModeWordWrap;
        secondLabel.textColor = [UIColor darkGrayColor];
        secondLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview: [secondLabel autorelease]];

        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30.0, 300.0, 60.0)];
        mainLabel.tag = 101;
        mainLabel.font = [UIFont systemFontOfSize:14.0];
        mainLabel.textAlignment = UITextAlignmentLeft;
        mainLabel.lineBreakMode = UILineBreakModeWordWrap;
        mainLabel.numberOfLines = 0;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = 0;
        [cell.contentView addSubview: [mainLabel autorelease]];
    } else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:101];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:102];
    }

    mainLabel.text = text;
    secondLabel.text = user;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
	NSUInteger index = [indexPath indexAtPosition: 1];
    NSDictionary *podcast = [podcasts objectAtIndex: index];
    NSString *text = [[podcast valueForKey: @"text"] stringByReplacingOccurrencesOfString: @"&quot;" withString: @"\""];

    UIFont *cellFont = [UIFont systemFontOfSize:14.0];
    CGSize constraintSize = CGSizeMake(300.0f, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];

    return labelSize.height + 50;
}

@end
