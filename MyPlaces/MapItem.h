//
//  MapItem.h
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapItem : NSObject

@property long long ID;
@property (retain, nonatomic) NSString *type;

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *country;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *street;
@property (retain, nonatomic) NSString *web;
@property (retain, nonatomic) NSString *streetViewLink;
@property (retain, nonatomic) NSString *author;
@property (retain, nonatomic) NSString *contact;

@property double x;
@property double y;

@property int rating;

@property (retain, nonatomic) NSArray *pros;
@property (retain, nonatomic) NSArray *cons;
@property (retain, nonatomic) NSArray *details;

-(NSString*) toJSON;
-(NSData*) toJSONData;

@end
