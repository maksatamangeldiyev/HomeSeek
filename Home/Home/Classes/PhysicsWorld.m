//
//  PhysicsWorld.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "PhysicsWorld.h"
#import "Hero.h"
#import "Coin.h"

static PhysicsWorld* _sharedWorld;
@implementation PhysicsWorld


+(instancetype) world
{
    return _sharedWorld;
}

+(instancetype) physicsWorldWithMap:(Map*) map
{
    _sharedWorld = [[PhysicsWorld alloc] initWithMap:map];
    return _sharedWorld;
}

-(instancetype) initWithMap:(Map*) map
{
    if(self = [super init])
    {
        self.map = map;
        self.walls = [self.map layerNamed:@"Ground"];
        self.walls.visible = NO;
        self.dynamicObjects = [NSMutableArray array];
        self.objectsToRemove = [NSMutableArray array];
        
    }
    return self;
}

-(void) removeDynamicObject:(CollisionObject*) object
{
    [self.objectsToRemove addObject:object];
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
        
        if(![object isKindOfClass:[Coin class]])
        {
            [self checkForAndResolveCollisions:object];
        }
    }
    for(CollisionObject* o1 in self.dynamicObjects)
    {
        if(![o1 isKindOfClass:[Hero class]])
        {
            continue;
        }
        for(CollisionObject* o2 in self.dynamicObjects)
        {
            if(o1 == o2)
            {
                continue;
            }
            if(CGRectIntersectsRect(o1.collisionBoundingBox,
                                    o2.collisionBoundingBox))
            {
                CGRect intersection = CGRectIntersection(o1.collisionBoundingBox, o2.collisionBoundingBox);
                intersection.size.height /=2;
                
                if(o1.position.x < o2.position.x)
                {
                    intersection.size.width *= -1;
                }
                
                if(o1.position.y < o2.position.y)
                {
                    intersection.size.height *= -1;
                }
                
                [o1 collisionWith:o2 size:intersection.size];
                [o2 collisionWith:o1 size:intersection.size];
            }
        }
    }
   
    
    for(CollisionObject* object in self.dynamicObjects)
    {
        object.position = object.desiredPosition; //8
    }
    
    for(CollisionObject* object in self.objectsToRemove)
    {
        [self.dynamicObjects removeObject:object];
    }
    [self.objectsToRemove removeAllObjects];
 
}

-(void)checkForAndResolveCollisions:(CollisionObject *)p {
    
    NSArray *tiles = [self.map getSurroundingTilesForRect:p.boundingBox forLayer:self.walls];
    
    p.onGround = NO;
    
    for(CCSprite* tile in self.walls.children)
    {
        tile.color = [CCColor whiteColor];
    }
    
    float objectSlope = 0;
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
                    p.slope = 0;
                }
                else if (tile.tileType == Top && [tile isAbove:pRect])
                {
                    p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y - intersection.height);
                    p.velocity = ccp(p.velocity.x, 0.0);
                }
                else if (tile.tileType == Left && [tile isToTheLeftOf:pRect])
                {
                    if(tile.slopeAngle < 0)
                    {
                        intersection.height = 1.5;
                        p.slope = -45;
                        p.desiredPosition = ccp(p.desiredPosition.x, p.desiredPosition.y + intersection.height);
                    }else
                    {
                        p.desiredPosition = ccp(p.desiredPosition.x + intersection.width, p.desiredPosition.y);
                    }
                }
                else if (tile.tileType == Right && [tile isToTheRightOf:pRect])
                {
                    if(tile.slopeAngle > 0)
                    {
                        intersection.height = 1.2;
                        p.slope = 45;
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
    
    
}


@end
