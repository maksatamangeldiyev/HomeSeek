//
//  Map.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Map.h"

@implementation Map

-(instancetype) initWithFile:(NSString *)tmxFile
{
    if(self = [super initWithFile:tmxFile])
    {
        self.mapInfo = [[CCTiledMapInfo alloc] initWithFile:@"HomeSeek1.tmx"];
        
        self.collisionPoints = [NSMutableArray array];
        
        for(int i=0;i<12;i++)
        {
            CCSprite* point = [CCSprite spriteWithImageNamed:@"1px.png"];
            point.scale = 16;
            point.color = [CCColor redColor];
            [self.collisionPoints addObject:point];
            [self addChild:point];
        }
    }
    return self;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    position = ccpMult(position, 2);
    float x = floor(position.x / self.tileSize.width);
    float levelHeightInPixels = self.mapSize.height * self.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / self.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float levelHeightInPixels =self.mapSize.height * self.tileSize.height;
    CGPoint origin = ccp(tileCoords.x * self.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * self.tileSize.height));
    return CGRectMake(origin.x/2, origin.y/2, self.tileSize.width, self.tileSize.height);
}

-(Tile*) tileDataForPos:(CGPoint) position forLayer:(CCTiledMapLayer*) layer withType:(PointPos) type
{
    Tile* retVal = [[Tile alloc] init];
    if(position.x < 0 || position.y < 0)
    {
        return retVal;
    }
    
    if(position.x >= self.mapSize.width || position.y >= self.mapSize.height)
    {
        return retVal;
    }
    
    int tgid = [layer tileGIDAt:position];
    
    CGRect tileRect = [self tileRectFromTileCoords:position];
    
    NSDictionary * info = [self.mapInfo.tileProperties objectForKey: [NSNumber numberWithInt: tgid] ];
    float tileSlope = [[info objectForKey:@"slope"] floatValue];
    
    retVal.tileSprite = [layer tileAt:position];
    retVal.gid = tgid;
    retVal.x = tileRect.origin.x;
    retVal.y = tileRect.origin.y;
    retVal.tilePos = position;
    retVal.tileType = type;
    retVal.slope = tileSlope;
    
    return retVal;
}

-(NSArray *)getSurroundingTilesForRect:(CGRect)rect forLayer:(CCTiledMapLayer *)layer
{
    CGPoint plPosLeftBototm = [self tileCoordForPosition:ccp(rect.origin.x, rect.origin.y)];
    CGPoint plPosLeftTop = [self tileCoordForPosition:ccp(rect.origin.x, rect.origin.y+rect.size.height)];
    CGPoint plPosRightTop = [self tileCoordForPosition:ccp(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height)];
    CGPoint plPosRightBottom = [self tileCoordForPosition:ccp(rect.origin.x+rect.size.width, rect.origin.y)];
    
    
    CGPoint lb1 = ccp(plPosLeftBototm.x, plPosLeftBototm.y-1);
    CGPoint lb2 = ccp(plPosLeftBototm.x, plPosLeftBototm.y);
    CGPoint lb3 = ccp(plPosLeftBototm.x+1, plPosLeftBototm.y);
    
    CGPoint lt1 = ccp(plPosLeftTop.x, plPosLeftTop.y+1);
    CGPoint lt2 = ccp(plPosLeftTop.x, plPosLeftTop.y);
    CGPoint lt3 = ccp(plPosLeftTop.x+1, plPosLeftTop.y);
    
    CGPoint rt1 = ccp(plPosRightTop.x, plPosRightTop.y+1);
    CGPoint rt2 = ccp(plPosRightTop.x, plPosRightTop.y);
    CGPoint rt3 = ccp(plPosRightTop.x-1, plPosRightTop.y);
    
    CGPoint rb1 = ccp(plPosRightBottom.x, plPosRightBottom.y-1);
    CGPoint rb2 = ccp(plPosRightBottom.x, plPosRightBottom.y);
    CGPoint rb3 = ccp(plPosRightBottom.x-1, plPosRightBottom.y);
    
    NSMutableArray *gids = [NSMutableArray array];
    
    [gids addObject:[self tileDataForPos:lb3 forLayer:layer withType:Bottom]];
    [gids addObject:[self tileDataForPos:lt3 forLayer:layer withType:Top]];
    
    [gids addObject:[self tileDataForPos:lb1 forLayer:layer withType:Left]];
    [gids addObject:[self tileDataForPos:rb1 forLayer:layer withType:Right]];
    
    [gids addObject:[self tileDataForPos:lt1 forLayer:layer withType:Left]];
    
    [gids addObject:[self tileDataForPos:rt1 forLayer:layer withType:Right]];
    //
    [gids addObject:[self tileDataForPos:rt3 forLayer:layer withType:Top]];
    //
    [gids addObject:[self tileDataForPos:rb3 forLayer:layer withType:Bottom]];
    
    
    
    int i=0;
    for(Tile* tileData in gids)
    {
        CGPoint p = ccp(tileData.x, tileData.y);
        CCSprite* point = [self.collisionPoints objectAtIndex:i];
        point.position = p;
        i++;
    }
    
    return (NSArray *)gids;
}

-(void) setCollisionPointColor:(CCColor*) color atIndex:(int) index
{
    CCSprite* collisionPoint = [self.collisionPoints objectAtIndex:index];
    [collisionPoint setColor:color];
    collisionPoint.zOrder = 10;

}
@end
