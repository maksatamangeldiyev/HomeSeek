//
//  PhysicsWorld.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "PhysicsWorld.h"

@implementation PhysicsWorld

+(instancetype) physicsWorldWithMap:(Map*) map
{
    return [[PhysicsWorld alloc] initWithMap:map];
}

-(instancetype) initWithMap:(Map*) map
{
    if(self = [super init])
    {
        self.map = map;
        self.walls = [self.map layerNamed:@"Ground"];
        
        self.dynamicObjects = [NSMutableArray array];
        
    }
    return self;
}

-(void) addDynamicObject:(CollisionObject*) object
{
    [self.dynamicObjects addObject:object];
}

-(void) step:(CCTime)delta
{
    for(CollisionObject* object in self.dynamicObjects)
    {
        [object step:delta];
        [self checkForAndResolveCollisions:object];
    }
}

-(void)checkForAndResolveCollisions:(CollisionObject *)p {
    
    NSArray *tiles = [self.map getSurroundingTilesForRect:p.boundingBox forLayer:self.walls];
    
    p.onGround = NO;
    
    for(CCSprite* tile in self.walls.children)
    {
        tile.color = [CCColor whiteColor];
    }
    
    int i=0;
    //Vertical collisions
    for (Tile *tile in tiles) {
        [self.map setCollisionPointColor:[CCColor greenColor] atIndex:i];
        
        CGRect pRect = [p collisionBoundingBox]; //3
        
        if (!tile.isEmpty) {
            if ([tile collidesWith:pRect])
            {
                CGSize intersection = [tile getIntersectionWith:pRect];
                [self.map setCollisionPointColor:[CCColor purpleColor] atIndex:i];
                
                if (tile.tileType == Bottom && [tile isBelow:pRect])
                {
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                    p.onGround = YES;
                }
                else if (tile.tileType == Top && [tile isAbove:pRect])
                {
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                }
                else if (tile.tileType == Left && [tile isToTheLeftOf:pRect])
                {
                    if(tile.slope < 0)
                    {
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.height);
                    }else
                    {
                        p.desiredPosition = ccp(p.desiredPosition.x + intersection.width, p.desiredPosition.y);
                    }
                }
                else if (tile.tileType == Right && [tile isToTheRightOf:pRect])
                {
                    if(tile.slope > 0)
                    {
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.height);
                    }else
                    {
                        p.desiredPosition = ccp(p.desiredPosition.x - intersection.width, p.desiredPosition.y);
                    }
                    
                }
                else {
                    if (intersection.width > intersection.height) {
                        //tile is diagonal, but resolving collision vertially
                        p.velocity = ccp(p.velocity.x, 0.0);
                        float resolutionHeight;
                        if (tile.tileType == Bottom) {
                            resolutionHeight = intersection.height;
                            p.onGround = YES;
                        } else {
                            resolutionHeight = -intersection.height;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + resolutionHeight);
                        
                    } else {
                        float resolutionWidth;
                        if (tile.tileType == Right) {
                            resolutionWidth = intersection.width;
                        } else {
                            resolutionWidth = -intersection.width;
                        }
                        p.desiredPosition = ccp(p.desiredPosition.x + resolutionWidth, p.desiredPosition.y);
                    }
                }
            }
        }
        i++;
    }
    p.position = p.desiredPosition; //8
}


@end
