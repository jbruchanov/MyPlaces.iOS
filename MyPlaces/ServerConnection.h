//
//  ServerConnection.h
//  MyPlaces
//
//  Created by Jiří Bruchanov on 30/08/2012.
//  Copyright (c) 2012 Jiri Bruchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Star.h"
#import "MapItem.h"

@interface ServerConnection : NSObject

-(NSArray*)getStars;
-(NSArray*)getMapItems;
-(MapItem*)getMapItemById:(long long)id;
-(NSArray*)getMapItemsWithX1:(double)x1 AndY1:(double)y1 AndX2:(double)x2 AndY2:(double)y2;

-(void)saveStar:(Star*)item;
-(void)deleteStar:(Star*)item;
-(void)saveMapItem:(MapItem*)item;
-(void)deleteMapItem:(MapItem*)item;
@end
