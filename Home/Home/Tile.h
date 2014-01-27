//
//  TileData.h
//  Home
//
//  Created by Maksat Aman on 1/21/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    Left,
    Right,
    Top,
    Bottom
}PointPos;

@interface Tile : NSObject

@property (nonatomic, assign) int gid;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) CGPoint tilePos;
@property (nonatomic, assign) CGRect tileRect;
@property (nonatomic, assign) PointPos tileType;
@property (nonatomic, assign) bool hasSlope;

@property (nonatomic, assign) float slopeYLeft;
@property (nonatomic, assign) float slopeYRight;

@property (nonatomic, assign) float slopeAngle;

@property (nonatomic, strong) CCSprite* tileSprite;

-(bool) isEmpty;
-(CGSize) getIntersectionWith:(CGRect) pRect;
-(bool) collidesWith:(CGRect) pRect;

-(bool) isBelow:(CGRect) pRect;
-(bool) isAbove:(CGRect) pRect;
-(bool) isToTheRightOf:(CGRect) pRect;
-(bool) isToTheLeftOf:(CGRect) pRect;
@end
