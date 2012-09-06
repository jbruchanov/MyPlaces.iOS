//
//  Star.h
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Star : NSObject <MKAnnotation>

    @property long long ID;
    @property (retain, nonatomic) NSString *note;
    @property (retain, nonatomic) NSString *type;
    @property double x;
    @property double y;


//MKAnnotation
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
//MKAnnotation end

-(NSString*) toJSON;
-(NSData*) toJSONData;

@end
