//
//  Map.h
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "cocos2d-ui.h"
#import "cocos2d.h"

#import "Tile.h"

@interface Map : CCTiledMap

@property (nonatomic, strong) NSMutableArray* collisionPoints;
@property (nonatomic, strong) CCTiledMapInfo* mapInfo;

-(CGPoint)tileCoordForPosition:(CGPoint)position;
-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords;
-(NSArray *)getSurroundingTilesForRect:(CGRect)rect forLayer:(CCTiledMapLayer *)layer;
-(Tile*) tileDataForPos:(CGPoint) position forLayer:(CCTiledMapLayer*) layer withType:(PointPos) type;

-(void) setCollisionPointColor:(CCColor*) color atIndex:(int) index;

@end
