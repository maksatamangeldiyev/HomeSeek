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
//    self.tileRect = self.tileSprite.boundingBox;
}

-(bool) isEmpty
{
    return self.gid == 0;
}

-(bool) isPoint: (CGPoint) p onLeftOfLineBegin: (CGPoint) l1 andEnd:(CGPoint) l2
{
    return ((l2.x - l1.x)*(p.y - l1.y) - (l2.y - l1.y)*(p.x - l1.x)) > 0;
}

//-(bool) isPointInTile: (CGPoint) p
//{
//    CGPoint tileL = ccp(self.tileRect.origin.x, self.tileRect.origin.y + self.slopeYLeft);
//    CGPoint tileR = ccp(self.tileRect.origin.x + self.tileRect.size.width, self.tileRect.origin.y + self.slopeYLeft);
//    
//    if(CGRectContainsPoint(self.tileRect, p))
//    {
//        if(self.slopeYLeft > self.slopeYRight)
//        {
//            return [self isPoint:p onLeftOfLineBegin:tileL andEnd:tileR];
//        }else
//        {
//            return ![self isPoint:p onLeftOfLineBegin:tileL andEnd:tileR];
//        }
//    }
//    return NO;
//}

-(bool) collidesWith:(CGRect)pRect
{
    return CGRectIntersectsRect(pRect, self.tileRect);
//    bool rectIntersects = CGRectIntersectsRect(pRect, self.tileRect);
//    
//    if(!self.hasSlope)
//    {
//        return rectIntersects;
//    }else if(rectIntersects)
//    {
//        //any point of rectangle is in tile
//        
//        CGPoint lb = pRect.origin;
//        CGPoint lt = ccpAdd(pRect.origin, ccp(0, pRect.size.height));
//        CGPoint rt = ccpAdd(pRect.origin, ccp(pRect.size.width, pRect.size.height));
//        CGPoint rb = ccpAdd(pRect.origin, ccp(pRect.size.width, 0));
//        
//        if( [self isPointInTile:lb] ||
//                [self isPointInTile:lt]||
//                [self isPointInTile:rt] ||
//                [self isPointInTile:rb])
//        {
//            return YES;
//        }
//        
//        CGPoint tileL = ccp(self.tileRect.origin.x, self.tileRect.origin.y + self.slopeYLeft);
//        CGPoint tileR = ccp(self.tileRect.origin.x + self.tileRect.size.width, self.tileRect.origin.y + self.slopeYLeft);
//        
//        if(CGRectContainsPoint(pRect, tileL) || CGRectContainsPoint(pRect, tileR))
//        {
//            return YES;
//        }
//    }
//    return NO;
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
