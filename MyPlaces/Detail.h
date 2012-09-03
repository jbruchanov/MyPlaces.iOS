//
//  Detail.h
//  MyPlaces
//
//  Created by Jiří Bruchanov on 31/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Detail : NSObject
@property long long ID;
@property (retain, nonatomic) NSString *what;
@property (retain, nonatomic) NSString *detail;
@property (retain, nonatomic) NSDate *time;

//-(NSString*) toJSON;
//-(NSData*) toJSONData;
-(NSDictionary*) toDictionaryWithDateFormatter:(NSDateFormatter*)formatter;

@end
