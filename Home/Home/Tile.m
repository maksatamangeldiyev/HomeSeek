//
//  TileData.m
//  Home
//
//  Created by Maksat Aman on 1/21/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Tile.h"
#import "Geometry.h"

@implementation Tile


-(instancetype) init
{
    if(self = [super init])
    {
        
    }
    return self;
}
-(CGSize) getIntersectionWith:(CGRect) pRect
{
    CGRect intersection = CGRectIntersection(pRect, self.tileRect);
    intersection.size.height /=2;
    return intersection.size;
}

-(void) setTileSprite:(CCSprite *)tileSprite
{
    _tileSprite = tileSprite;
    self.tileRect = self.tileSprite.boundingBox;
}

-(bool) isEmpty
{
    return self.gid == 0;
}

-(bool) collidesWith:(CGRect)pRect
{
    return CGRectIntersectsRect(pRect, self.tileRect);
}

-(bool) isBelow:(CGRect) pRect
{
    return [Geometry isRect:self.tileRect rightBelowRect:pRect];
}
-(bool) isAbove:(CGRect) pRect
{
    return [Geometry isRect:self.tileRect rightAboveRect:pRect];
}
-(bool) isToTheRightOf:(CGRect) pRect
{
    return [Geometry isRect:self.tileRect toTheRightOf:pRect];
}
-(bool) isToTheLeftOf:(CGRect) pRect
{
    return [Geometry isRect:self.tileRect toTheLeftOf:pRect];
}
@end
