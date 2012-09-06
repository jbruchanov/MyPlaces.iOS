//
//  ViewController.m
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController ()
{
@private NSArray *mStars;
}
@end

@implementation ViewController

@synthesize Map;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadStarsAsync];
}

-(void)loadStarsAsync
{
    [NSThread detachNewThreadSelector: @selector(loadStars) toTarget:self withObject:NULL];
}


-(void)loadStars
{
    [NSThread sleepForTimeInterval:2];
    ServerConnection *sc = [self getServerConnection];
    NSArray *stars = [[sc arrayWithStars] retain];
    dispatch_async(dispatch_get_main_queue(), ^{[self didLoadStars:stars];});
}

-(void)didLoadStars:(NSArray*)stars
{
    mStars = stars;
    [self showStars:mStars];
}

-(void)showStars:(NSArray*)stars
{
    for(Star *s in stars)
    {
        [self.Map addAnnotation:s];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ServerConnection*)getServerConnection
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.serverConnection;
}

- (void)dealloc {
    [mStars release];
    [Map release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMap:nil];
    [super viewDidUnload];
}
@end
