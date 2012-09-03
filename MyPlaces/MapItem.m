//
//  MapItem.m
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "MapItem.h"
#import "Detail.h"

@implementation MapItem

@synthesize ID;
@synthesize  type;

@synthesize  name;
@synthesize  country;
@synthesize  city;
@synthesize  street;
@synthesize  web;
@synthesize  streetViewLink;
@synthesize  author;
@synthesize  contact;

@synthesize x;
@synthesize y;

@synthesize rating;

@synthesize pros;
@synthesize cons;
@synthesize details;

-(NSString*) toJSON;
{
    NSData *jsonData = [self toJSONData];
    NSString *d = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [d autorelease];
}

-(id)valueOrNull:(id)value
{
    return (value) ? value : [NSNull null];
}

-(NSData*) toJSONData
{
    NSDateFormatter *nsd = [[NSDateFormatter alloc]init];
    [nsd setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSMutableArray *arrDetails = nil;
    if(self.details)
    {
        arrDetails = [[NSMutableArray alloc] init];
        for (Detail *d in self.details) {
            [arrDetails addObject:[d toDictionaryWithDateFormatter:nsd]];
        }
    }
    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          [NSString stringWithFormat:@"%lld",self.ID],@"id",
//                          self.type,@"type",
//                          self.name,@"name",
//                          self.country,@"country",
//                          self.city,@"city",
//                          self.street,@"street",
//                          self.web,@"web",
//                          self.streetViewLink,@"streetViewLink",
//                          self.author,@"author",
//                          self.contact,@"contact",
//                          [NSString stringWithFormat:@"%f",self.x],@"x",
//                          [NSString stringWithFormat:@"%f",self.y],@"y",
//                          self.rating,@"rating",
//                          self.pros,@"pros",
//                          self.cons,@"cons",
//                          arrDetails, @"details",
//                          nil];
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    [result setObject:[self valueOrNull:[NSString stringWithFormat:@"%lld",self.ID]] forKey:@"id"];
    [result setObject:[self valueOrNull:self.type] forKey:@"type"];
    [result setObject:[self valueOrNull:self.name] forKey:@"name"];
    [result setObject:[self valueOrNull:self.country] forKey:@"country"];
    [result setObject:[self valueOrNull:self.city] forKey:@"city"];
    [result setObject:[self valueOrNull:self.street] forKey:@"street"];
    [result setObject:[self valueOrNull:self.web] forKey:@"web"];
    [result setObject:[self valueOrNull:self.streetViewLink] forKey:@"streetViewLink"];
    [result setObject:[self valueOrNull:self.author] forKey:@"author"];
    [result setObject:[self valueOrNull:self.contact] forKey:@"contact"];
    [result setObject:[NSString stringWithFormat:@"%f",self.x] forKey:@"x"];
    [result setObject:[NSString stringWithFormat:@"%f",self.y] forKey:@"y"];
    [result setObject:[NSString stringWithFormat:@"%d",self.rating] forKey:@"rating"];
    [result setObject:[self valueOrNull:self.pros] forKey:@"pros"];
    [result setObject:[self valueOrNull:self.cons] forKey:@"cons"];
    [result setObject:[self valueOrNull:arrDetails] forKey:@"details"];
    
    [nsd release];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    [result release];
    return jsonData;
}

-(void) dealloc
{
    type = nil;
    name = nil;
    country = nil;
    city = nil;
    street = nil;
    web = nil;
    streetViewLink = nil;
    author = nil;
    contact = nil;
    pros = nil;
    cons = nil;
    details = nil;
    [super dealloc];
}
@end
