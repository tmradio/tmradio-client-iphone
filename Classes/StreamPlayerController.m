//
//  FirstViewController.m
//  TMRadio
//
//  Created by Jimi Dini on 20.02.11.
//  Copyright 2011 Milk Farm Software, ltd. All rights reserved.
//

#import "StreamPlayerController.h"
#import "AudioStreamer.h"
#import "TMRadioAppDelegate.h"

@implementation StreamPlayerController

@synthesize playEnabledSwitch;
@synthesize songInfoText;
@synthesize bufferingIndicator;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // NSLog(@"init");
        // Custom initialization
        [self initStreamer];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder: decoder];

    if (self) {
        // NSLog(@"init");
        // Custom initialization
        [self initStreamer];
    }

    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    // NSLog(@"viewDidLoad");
    [super viewDidLoad];

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [playEnabledSwitch setOn: [d boolForKey: @"auto_play"] animated: NO];

    [self playSwitchChanged: self];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self deInitStreamer];
    [super dealloc];
}



- (void) initStreamer
{
    streamer = [[AudioStreamer alloc] initWithURL: [NSURL URLWithString: @"http://stream.tmradio.net:8180/live.mp3"]];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(playbackStateChanged:)
               name: ASStatusChangedNotification
             object: streamer];

    // Enable shoutcast metadata retrieval.
    [streamer setRetrieveShoutcastMetaData:YES];
    [nc addObserver: self
           selector: @selector(metadataChanged:)
               name: ASUpdateMetadataNotification
             object: streamer];
}

- (void) deInitStreamer
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver: self name: ASStatusChangedNotification object: streamer];
    [nc removeObserver: self name: ASUpdateMetadataNotification object: streamer];

    [streamer release];

    [self setInfoText: @""];
}

- (void) reInitStreamer
{
    [self deInitStreamer];
    [self initStreamer];
}

- (void) playSwitchChanged:(id)sender
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];

    [d setBool: playEnabledSwitch.on forKey: @"auto_play"];
    [d synchronize];

    if (playEnabledSwitch.on) {
        [streamer start];
    } else {
        [streamer stop];
    }
}


//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if ([streamer isWaiting]) {
        // NSLog(@"waiting");
        [bufferingIndicator startAnimating];
        // [self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
    } else if ([streamer isPlaying]) {
        // NSLog(@"Playing");
        [bufferingIndicator stopAnimating];
        // [self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
    } else if ([streamer isIdle]) {
        // NSLog(@"Idle");
        [bufferingIndicator stopAnimating];
        [playEnabledSwitch setOn: NO animated: YES];

        [self reInitStreamer];
    }
}

/** Example metadata
 * 
 StreamTitle='Kim Sozzi / Amuka / Livvi Franc - Secret Love / It's Over / Automatik',
 StreamUrl='&artist=Kim%20Sozzi%20%2F%20Amuka%20%2F%20Livvi%20Franc&title=Secret%20Love%20%2F%20It%27s%20Over%20%2F%20Automatik&album=&duration=1133453&songtype=S&overlay=no&buycd=&website=&picture=',

 Format is generally "Artist hypen Title" although servers may deliver only one. This code assumes 1 field is artist.
 */
- (void)metadataChanged:(NSNotification *)aNotification
{
    NSString *rawMeta = [[aNotification userInfo] objectForKey:@"metadata"];
    NSArray *metaParts = [rawMeta componentsSeparatedByString:@";"];

    NSString *item;
    NSMutableDictionary *hash = [[NSMutableDictionary alloc] init];
    for (item in metaParts) {
        // split the key/value pair
        NSArray *pair = [item componentsSeparatedByString:@"="];
        // don't bother with bad metadata
        if ([pair count] == 2)
            [hash setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }

    // do something with the StreamTitle
    NSString *streamString = [[hash objectForKey:@"StreamTitle"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSArray *streamParts = [streamString componentsSeparatedByString:@" - "];

    NSString *streamArtist;
    if ([streamParts count] > 0) {
        streamArtist = [streamParts objectAtIndex:0];
    } else {
        streamArtist = @"";
    }

    // this looks odd but not every server will have all artist hyphen title
    NSString *streamTitle;
    if ([streamParts count] >= 2) {
        streamTitle = [streamParts objectAtIndex:1];
    } else {
        streamTitle = @"";
    }

    // NSLog(@"%@ by %@", streamTitle, streamArtist);
    // NSLog(@"%@", rawMeta);

    // only update the UI if in foreground
    TMRadioAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.uiIsVisible) {
        [self performSelectorOnMainThread:@selector(setInfoText:) withObject:streamString waitUntilDone:YES];
    }
}

- (void) setInfoText: (NSString *)new_text
{
    songInfoText.text = new_text;
}

@end
