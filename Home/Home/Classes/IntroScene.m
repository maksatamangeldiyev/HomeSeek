//
//  IntroScene.m
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright Peak games 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "Hero.h"

@implementation IntroScene


CCTiledMap* map;
Hero* hero;
CCTiledMapLayer* walls;



+ (IntroScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    glClearColor(0.1, 0.1, 0.1, 1.0);
    
    self.userInteractionEnabled = YES;
    self.claimsUserInteraction = YES;
    
    map = [CCTiledMap tiledMapWithFile:@"HomeSeek1.tmx"];
    walls = [map layerNamed:@"Ground"];
    
    [self addChild:map];
    hero = [[Hero alloc] initWithMap:map];

    [map runAction:[CCActionFollow actionWithTarget:hero worldBoundary:map.boundingBox]];

 
    self.collisionPoints = [NSMutableArray array];
    
    for(int i=0;i<12;i++)
    {
        CCSprite* point = [CCSprite spriteWithImageNamed:@"1px.png"];
        point.scale = 16;
        point.color = [CCColor redColor];
        [self.collisionPoints addObject:point];
        [map addChild:point];
        
    }
    
    self.isTouching = NO;
    
    // done
	return self;
}

-(void) update:(CCTime)delta
{
    [self checkForAndResolveCollisions:hero];
    
    if(hero.position.x > self.contentSize.width/2.f && hero.position.x < map.contentSize.width - self.contentSize.width/2.f)
    {
        [map runAction:[CCActionFollow actionWithTarget:hero worldBoundary:map.boundingBox]];
    }
}


-(bool) isRect:(CGRect) r1 rightBelowRect:(CGRect) r2
{
    if(r1.origin.y <= r2.origin.y)
    {
//        if(r1.origin.x > r2.origin.x)
        {
//            if(r1.origin.x < r2.origin.x + r2.size.width)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(bool) isRect:(CGRect) r1 rightAboveRect:(CGRect) r2
{
    if(r1.origin.y >= r2.origin.y)
    {
        if(r1.origin.x > r2.origin.x)
        {
            if(r1.origin.x < r2.origin.x + r2.size.width)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(bool) isRect:(CGRect) r1 toTheLeftOf:(CGRect) r2
{
    if(r1.origin.x < r2.origin.x)
    {
//        if(r1.origin.y > r2.origin.y)
        {
//            if(r1.origin.y < r2.origin.y + r2.size.height)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(bool) isRect:(CGRect) r1 toTheRightOf:(CGRect)r2
{
    if(r1.origin.x >= r2.origin.x)
    {
//        if(r1.origin.y > r2.origin.y)
        {
//            if(r1.origin.y < r2.origin.y + r2.size.height)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(void)checkForAndResolveCollisions:(Hero *)p {
    
    NSArray *tiles = [self getSurroundingTilesForRect:p.boundingBox forLayer:walls];
    
    p.onGround = NO; //////Here
    
    for(CCSprite* tile in walls.children)
    {
        tile.color = [CCColor whiteColor];
        tile.scale = 1;
    }
    
    //Vertical collisions
    for (NSDictionary *dic in tiles) {
        CGRect pRect = [p collisionBoundingBox]; //3

        int gid = [[dic objectForKey:@"gid"] intValue]; //4
        if (gid > 0) {
            CCSprite* tile = [walls tileAt:[[dic objectForKey:@"tilePos"] CGPointValue]];
            CGRect tileRect = tile.boundingBox; //CGRectMake([[dic objectForKey:@"x"] floatValue], [[dic objectForKey:@"y"] floatValue], map.tileSize.width/2, map.tileSize.height/2); //5
            if (CGRectIntersectsRect(pRect, tileRect)) {
                CGRect intersection = CGRectIntersection(pRect, tileRect);
                intersection.size.height /=2;
                
                [tile setColor:[CCColor redColor]];
                
                if ([self isRect:tileRect rightBelowRect:pRect])
                {
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0); //////Here
                    p.onGround = YES; //////Here
                } else if ([self isRect:tileRect rightAboveRect:pRect])
                {
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.size.height);
                    p.velocity = ccp(p.velocity.x, 0.0); //////Here
                }
                else if ([self isRect:tileRect toTheLeftOf:pRect]) {
                    p.desiredPosition = ccp(p.desiredPosition.x + intersection.size.width, p.desiredPosition.y);
                } else if ([self isRect:tileRect toTheRightOf:pRect]) {
                    p.desiredPosition = ccp(p.desiredPosition.x - intersection.size.width, p.desiredPosition.y);
                }
//                else {
//                    if (intersection.size.width > intersection.size.height) {
//                        //tile is diagonal, but resolving collision vertially
//                        p.velocity = ccp(p.velocity.x, 0.0); //////Here
//                        float resolutionHeight;
//                        if (tileIndx > 5) {
//                            resolutionHeight = intersection.size.height;
//                            p.onGround = YES; //////Here
//                        } else {
//                            resolutionHeight = -intersection.size.height;
//                        }
//                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight);
//                        
//                    } else {
//                        float resolutionWidth;
//                        if (tileIndx == 6 || tileIndx == 4) {
//                            resolutionWidth = intersection.size.width;
//                        } else {
//                            resolutionWidth = -intersection.size.width;
//                        }
//                        p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y);
//                    } 
//                }
            }
        } 
    }
    
    if(p.onGround && !self.isTouching)
    {
        [p stop];
    }
    
    p.position = p.desiredPosition; //8
}

- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    position = ccpMult(position, 2);
    float x = floor(position.x / map.tileSize.width);
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    float y = floor((levelHeightInPixels - position.y) / map.tileSize.height);
    return ccp(x, y);
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords
{
    float levelHeightInPixels = map.mapSize.height * map.tileSize.height;
    CGPoint origin = ccp(tileCoords.x * map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * map.tileSize.height));
    return CGRectMake(origin.x/2, origin.y/2, map.tileSize.width, map.tileSize.height);
}

-(NSDictionary*) tileDictForPos:(CGPoint) position forLayer:(CCTiledMapLayer*) layer
{
    if(position.x < 0 || position.y < 0)
    {
        return [NSDictionary dictionary];
    }
    
    if(position.x >= map.mapSize.width || position.y >= map.mapSize.height)
    {
        return [NSDictionary dictionary];
    }
        
    int tgid = [layer tileGIDAt:position];
    
    CGRect tileRect = [self tileRectFromTileCoords:position];
    
    NSDictionary *tileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:tgid], @"gid",
                              [NSNumber numberWithFloat:tileRect.origin.x], @"x",
                              [NSNumber numberWithFloat:tileRect.origin.y], @"y",
                              [NSValue valueWithCGPoint:position],@"tilePos",
                              nil];
    return tileDict;
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
    
    [gids addObject:[self tileDictForPos:lb1 forLayer:layer]];
    [gids addObject:[self tileDictForPos:lb2 forLayer:layer]];
    [gids addObject:[self tileDictForPos:lb3 forLayer:layer]];
    [gids addObject:[self tileDictForPos:lt1 forLayer:layer]];
    [gids addObject:[self tileDictForPos:lt2 forLayer:layer]];
    [gids addObject:[self tileDictForPos:lt3 forLayer:layer]];

    [gids addObject:[self tileDictForPos:rt1 forLayer:layer]];
    [gids addObject:[self tileDictForPos:rt2 forLayer:layer]];
    [gids addObject:[self tileDictForPos:rt3 forLayer:layer]];
    [gids addObject:[self tileDictForPos:rb1 forLayer:layer]];
    [gids addObject:[self tileDictForPos:rb2 forLayer:layer]];
    [gids addObject:[self tileDictForPos:rb3 forLayer:layer]];
    
    
    
    int i=0;
    for(NSDictionary* dict in gids)
    {
        CGPoint p = ccp([[dict objectForKey:@"x"] intValue], [[dict objectForKey:@"y"] intValue]);
        CCSprite* point = [self.collisionPoints objectAtIndex:i];
        point.position = p;
        i++;
    }
   
    return (NSArray *)gids;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [map convertToNodeSpace:touch.locationInWorld];
    self.touchDownLocation = touchLocation;
    self.touchDownTime = [NSDate date];

    if(touchLocation.x < hero.position.x)
    {
        [hero moveBackwards];
    }else
    {
        [hero moveForward];
    }
    
    self.isTouching = YES;
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}
-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    float timePassed = -[self.touchDownTime timeIntervalSinceNow];
    
    bool hasJumped = NO;
    if(timePassed < 0.5 && timePassed > 0)
    {
        CGPoint touchLocation = [map convertToNodeSpace:touch.locationInWorld];
        float distance = ccpDistance(touchLocation, self.touchDownLocation);
        if(distance > 50)
        {
            [hero jump];
            hasJumped = YES;
            
            if(touchLocation.x > self.touchDownLocation.x + 20)
            {
                [hero moveForward];
                [hero moveForward];
            }else if(touchLocation.x < self.touchDownLocation.x - 20)
            {
                [hero moveBackwards];
                [hero moveBackwards];
            }
            
        }
    }
    
    if(!hasJumped)
    {
        [hero stop];
    }
    
    self.isTouching = NO;
}

@end
