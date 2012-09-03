//
//  ServerConnection.m
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import "ServerConnection.h"
#import "Star.h"
#import "MapItem.h"
#import "Detail.h"
#import "JSONKit.h"

#define SERVER_STARS @"http://myplaces.scurab.com:8182/stars"
#define SERVER_MAPITEMS_COORDS @"http://myplaces.scurab.com:8182/mapitems/%f/%f/%f/%f"
#define SERVER_MAPITEMS @"http://myplaces.scurab.com:8182/mapitems"
#define SERVER_MAPITEM @"http://myplaces.scurab.com:8182/mapitems/%llu"

#define METHOD_POST @"POST"
#define METHOD_PUT @"PUT"
#define METHOD_DELETE @"DELETE"

@implementation ServerConnection

NSDateFormatter *dateFormatter;

-(id)init
{
    self = [super init];
    if(self)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}
-(NSArray*) getStars
{
    NSArray *result = nil;
    
    NSURL *url = [ NSURL URLWithString: SERVER_STARS];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data)
    {
#ifdef DEBUG
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", json);
        [json release];
#endif
        
        NSError *err;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        NSMutableArray *mresult = [[NSMutableArray alloc]init];
        
        for (NSDictionary *d in jsonArray) {
            NSLog(@"%@",d.description);
            
            Star *s = [[Star alloc] init];
//            s.ID = [[d valueForKey:@"id"] longLongValue];
            s.ID =  [[d valueForKey:@"id"] longLongValue];
            s.type = [d valueForKey:@"type"];
            s.note = [d valueForKey:@"note"];
            s.x = [[d valueForKey:@"x"] doubleValue];
            s.y= [[d valueForKey:@"y"] doubleValue];
            
            [mresult addObject:s];
            [s release];
        }
        result = [NSArray arrayWithArray:mresult];
        [mresult release];
    }
    return result;
}

-(NSArray*)getMapItems
{
    return [self getMapItemsWithX1:-90 AndY1:-180 AndX2:90 AndY2:180];
}

-(MapItem*)initMapItemFromJsonDictionary:(NSDictionary *)d AndIsDeepParse:(BOOL)deep
{
    MapItem *mi = [[MapItem alloc] init];
    mi.ID = [[d valueForKey:@"id"] longLongValue];
    mi.type = [d valueForKey:@"type"];
    mi.name = [d valueForKey:@"name"];
    mi.city = [d valueForKey:@"city"];
    mi.street = [d valueForKey:@"street"];
    mi.web = [d valueForKey:@"web"];
    mi.streetViewLink = [d valueForKey:@"streetViewLink"];
    mi.author = [d valueForKey:@"author"];
    mi.contact = [d valueForKey:@"contact"];
    mi.country = [d valueForKey:@"country"];
    
    mi.x = [[d valueForKey:@"x"] doubleValue];
    mi.y = [[d valueForKey:@"y"] doubleValue];
    
    if(deep)
    {
        mi.pros = [d valueForKey:@"pros"];
        mi.cons = [d valueForKey:@"cons"];
        
        NSArray *details = [d valueForKey:@"details"];
        if(details)
        {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for(NSDictionary *dd in details)
            {
                Detail *detail = [[Detail alloc] init];
                detail.ID = [[dd valueForKey:@"id"] longLongValue];
                detail.what = [dd valueForKey:@"what"];
                detail.detail = [dd valueForKey:@"detail"];
                NSString *time = [dd valueForKey:@"time"];
                //TODO detail.time = [dateFormatter dateFromString:time];
                               
                [arr addObject:detail];
                [detail release];
            }
            mi.details = [NSArray arrayWithArray:arr];
            [arr release];
        }
    }
    [mi autorelease];
    return mi;
}

-(MapItem*)getMapItemById:(long long)ID
{
    MapItem *result = nil;
    NSString *urlWithCoords = [NSString stringWithFormat:SERVER_MAPITEM, ID];
    NSLog(@"%@",urlWithCoords);
    NSURL *url = [ NSURL URLWithString: urlWithCoords];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data)
    {
#ifdef DEBUG
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", json);
        [json release];
#endif
        
        NSError *err;
        NSArray *a = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        NSDictionary *d = [a lastObject];//should have only one item
        if(d)
        {
            result = [self initMapItemFromJsonDictionary:d AndIsDeepParse:YES];
            [result autorelease];
        }
    }
    return result;
}

-(NSArray*)getMapItemsWithX1:(double)x1 AndY1:(double)y1 AndX2:(double)x2 AndY2:(double)y2
{
    NSArray *result;
    
    NSString *urlWithCoords = [NSString stringWithFormat:SERVER_MAPITEMS_COORDS, x1,y1,x2,y2];
    NSURL *url = [ NSURL URLWithString: urlWithCoords];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data)
    {
#ifdef DEBUG
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", json);
        [json release];
#endif
        
        NSError *err;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        NSMutableArray *mresult = [[NSMutableArray alloc]init];
        
        for (NSDictionary *d in jsonArray) {
            MapItem *mi = [self initMapItemFromJsonDictionary:d AndIsDeepParse:NO];
            [mresult addObject:mi];        
        }

        result = [NSArray arrayWithArray:mresult];
        [mresult release];
    }
    return result;
}

-(void)saveStar:(Star*)item
{
    NSError *err;
    
    NSData *jsonData = [item toJSONData];
    NSString *url = (item.ID == 0) ? [NSString stringWithFormat:@"%@", SERVER_STARS] : [SERVER_STARS stringByAppendingFormat:@"/%lld",item.ID];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    if(item.ID == 0)
        [req setHTTPMethod:METHOD_POST];
    else
        [req setHTTPMethod:METHOD_PUT];
    [req setHTTPBody:jsonData];
    
    NSData *returnData = [[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err] autorelease];
    NSString *responseJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&err];
    long long ID = [[responseObject valueForKey:@"id"] longLongValue];
    item.ID = ID;    
}

-(void)deleteStar:(Star*)item
{
    NSError *err;
    NSString *url = [SERVER_STARS stringByAppendingFormat:@"/%lld",item.ID];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:METHOD_DELETE];

    NSData *returnData = [[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err] autorelease];
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
}

-(void)saveMapItem:(MapItem*)item
{
    NSError *err;
    
    NSData *jsonData = [item toJSONData];
#ifdef DEBUG
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", json);
    [json release];
#endif
    NSString *url = (item.ID == 0) ? SERVER_MAPITEMS : [NSString stringWithFormat: SERVER_MAPITEM,item.ID];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    if(item.ID == 0)
        [req setHTTPMethod:METHOD_POST];
    else
        [req setHTTPMethod:METHOD_PUT];
    [req setHTTPBody:jsonData];
    
    NSData *returnData = [[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err] autorelease];
    NSString *responseJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&err];
    long long ID = [[responseObject valueForKey:@"id"] longLongValue];
    item.ID = ID;
}

-(void)deleteMapItem:(MapItem*)item
{
    NSError *err;
    NSString *url = [NSString stringWithFormat:SERVER_MAPITEM,item.ID];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:METHOD_DELETE];
    
    NSData *returnData = [[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err] autorelease];
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);

}

-(void)dealloc
{
    [dateFormatter release];
    [super dealloc];
}

@end
