//
//  MyPlacesTests.m
//  MyPlacesTests
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "MyPlacesTests.h"
#import "Star.h"
#import "MapItem.h"
#import "Detail.h"
#import "ServerConnection.h"

@implementation MyPlacesTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testGetStars
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    NSArray *stars = [[sc getStars] retain];
    STAssertTrue([stars count] > 0, @"Size of arr");
    
    for (Star *s in stars) {
        NSLog(@"%@",s.description);
    }
    STAssertNotNil(stars, @"");
    [sc release];
}

- (void)testGetMapItems
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    NSArray *mapItems = [[sc getMapItems] retain];
    STAssertTrue([mapItems count] > 0, @"Size of arr");
    
    for (MapItem *mi in mapItems) {
        NSLog(@"%@",mi.name);
    }
    STAssertNotNil(mapItems, @"");
    [sc release];
}


- (void)testGetMapItem
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    MapItem *mi = [sc getMapItemById:9973128346314856];
    STAssertTrue([mi.pros count] == 2, @"Should have 2");
    STAssertTrue([mi.cons count] == 0, @"Should have 0");
    STAssertTrue([mi.details count] == 1, @"Should have 1");
    Detail *d = [mi.details lastObject];
    STAssertTrue(d.ID > 0,@"ID of detail should has some value");
    [sc release];
}

-(void)testSaveStar
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    Star *s = [[Star alloc] init];
    s.ID = 0;
    s.x = 3;
    s.y = 50;
    s.type = @"10";
    s.note = @"TestNote";
    [sc saveStar:s];
    STAssertTrue(s.ID != 0,@"s.ID != 0");
    [s release];
}

-(void)testUpdateStar
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    Star *s = [[Star alloc] init];
    s.ID = 0;
    s.x = 3;
    s.y = 50;
    s.type = @"10";
    s.note = @"TestNote";
    [sc saveStar:s];
    STAssertTrue(s.ID != 0,@"s.ID != 0");
    long long last = s.ID;
    s.note = @"TestNote 2";
    s.type = @"21";
    [sc saveStar:s];
    STAssertFalse(s.ID == last,@"Should be same"); //the oldone is deleted
    [s release];
}

-(void)testDeleteStar
{
    ServerConnection *sc = [[ServerConnection alloc] init];
    Star *s = [[Star alloc] init];
    s.ID = 0;
    s.x = 3;
    s.y = 50;
    s.type = @"10";
    s.note = @"TestNote";
    [sc saveStar:s];
    STAssertTrue(s.ID != 0,@"s.ID != 0");
    long long last = s.ID;
    s.note = @"TestNote 2";
    s.type = @"21";
    [sc deleteStar:s];
    [s release];
}

-(void) testSaveMapItem
{
    MapItem *mi = [[MapItem alloc] init];
    mi.type = @"Hospoda";
    mi.name = @"TESET";
    mi.street = @"Street Test";
    mi.country = @"TSTCountry";
    mi.city = @"London";
    mi.pros = [NSArray arrayWithObjects:@"pro1",@"pro2",nil];
    mi.cons = [NSArray arrayWithObjects:@"con1",@"con2",@"con3",nil];
    mi.x = 3;
    mi.y = 50;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    Detail *d = [[Detail alloc] init];
    d.what = @"WhatTest";
    d.detail = @"no detail";
    d.time = [NSDate dateWithTimeIntervalSince1970:[NSDate timeIntervalSinceReferenceDate]];
    [arr addObject:d];
    [d release];
    //mi.details = arr;
    
    [arr release];
    
    NSString *q = [mi toJSON];
    NSLog(@"%@",q);
    ServerConnection *sc = [[ServerConnection alloc] init];
    [sc saveMapItem:mi];
    
    STAssertTrue(mi.ID > 0, @"mi.ID > 0");
    
    [mi release];
}

-(void) testUpdateMapItem
{
    MapItem *mi = [[MapItem alloc] init];
    mi.type = @"Hospoda";
    mi.name = @"TESET";
    mi.street = @"Street Test";
    mi.country = @"TSTCountry";
    mi.city = @"London";
    mi.pros = [NSArray arrayWithObjects:@"pro1",@"pro2",nil];
    mi.cons = [NSArray arrayWithObjects:@"con1",@"con2",@"con3",nil];
    mi.x = 3.25;
    mi.y = 50;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    Detail *d = [[Detail alloc] init];
    d.what = @"WhatTest";
    d.detail = @"no detail";
    d.time = [NSDate dateWithTimeIntervalSince1970:[NSDate timeIntervalSinceReferenceDate]];
    [arr addObject:d];
    [d release];
    //mi.details = arr;
    
    [arr release];
    
    NSString *q = [mi toJSON];
    NSLog(@"%@",q);
    ServerConnection *sc = [[ServerConnection alloc] init];
    [sc saveMapItem:mi];
    
    STAssertTrue(mi.ID > 0, @"mi.ID > 0");
    
    mi.type = @"Restaurace";
    mi.x = 3.5;
    mi.y = 51;
    
    [sc saveMapItem:mi];
    
    [mi release];
}

-(void) testDeleteMapItem
{
    MapItem *mi = [[MapItem alloc] init];
    mi.type = @"Hospoda";
    mi.name = @"TESET";
    mi.street = @"Street Test";
    mi.country = @"TSTCountry";
    mi.city = @"London";
    mi.pros = [NSArray arrayWithObjects:@"pro1",@"pro2",nil];
    mi.cons = [NSArray arrayWithObjects:@"con1",@"con2",@"con3",nil];
    mi.x = 3.25;
    mi.y = 50;
       
    NSString *q = [mi toJSON];
    NSLog(@"%@",q);
    ServerConnection *sc = [[ServerConnection alloc] init];
    [sc saveMapItem:mi];
    STAssertTrue(mi.ID > 0, @"mi.ID > 0");
    [sc deleteMapItem:mi];
    [mi release];
}

@end
