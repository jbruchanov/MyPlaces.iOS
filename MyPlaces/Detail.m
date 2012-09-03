//
//  Detail.m
//  MyPlaces
//
//  Created by Jiří Bruchanov on 31/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "Detail.h"

@implementation Detail
@synthesize ID;
@synthesize what;
@synthesize detail;
@synthesize time;

//-(NSString*) toJSON;
//{
//    NSData *jsonData = [self toJSONData];
//    NSString *d = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return [d autorelease];
//}
//
//-(NSData*) toJSONData;
//{
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.ID],@"id",self.what,@"what",self.detail,@"detail", nil];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    return jsonData;
//}

-(NSDictionary*) toDictionaryWithDateFormatter:(NSDateFormatter*)formatter
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%lld",self.ID],@"id",
                          self.what,@"what",
                          self.detail,@"detail",
                          [formatter stringFromDate:self.time],@"time",
                          nil];
    return [dict autorelease];
}

-(void)dealloc
{
    what = nil;
    detail = nil;
    time = nil;
    [super dealloc];
}
@end
