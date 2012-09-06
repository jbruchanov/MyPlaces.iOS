//
//  Star.m
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "Star.h"

@implementation Star

    @synthesize ID;
    @synthesize note;
    @synthesize type;
    @synthesize x;
    @synthesize y;
    
//MKAnnotation
-(NSString*)title
{
    return [note copy];
}

-(NSString*)subtitle
{
    return @"Subtitle";
}

-(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D loc;
    loc.longitude = self.x;
    loc.latitude = self.y;
    return loc;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.x = newCoordinate.longitude;
    self.y = newCoordinate.latitude;
}

//MKAnnotation end


-(NSString*) toJSON;
{
    NSData *jsonData = [self toJSONData];
    NSString *d = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [d autorelease];
}

-(NSData*) toJSONData;
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.ID],@"id",self.note,@"note",self.type,@"type",[NSString stringWithFormat:@"%f",self.x],@"x",[NSString stringWithFormat:@"%f",self.y],@"y", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return jsonData;
}

- (void)dealloc
{
    self.note = nil;
    self.type = nil;
    [super dealloc];
}
@end
