//
//  Star.h
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Star : NSObject

    @property long long ID;
    @property (retain, nonatomic) NSString *note;
    @property (retain, nonatomic) NSString *type;
    @property double x;
    @property double y;

-(NSString*) toJSON;
-(NSData*) toJSONData;

@end
