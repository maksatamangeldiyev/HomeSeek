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
#import "Tile.h"
#import "Geometry.h"

@implementation IntroScene

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
    
    self.map = [Map tiledMapWithFile:@"HomeSeek1.tmx"];
    self.world = [PhysicsWorld physicsWorldWithMap:self.map];
    
    [self addChild:self.map];
    self.hero = [[Hero alloc] initWithMap:self.map];
    [self.map runAction:[CCActionFollow actionWithTarget:self.hero worldBoundary:self.map.boundingBox]];
    [self.world addDynamicObject:self.hero];

    self.isTouching = NO;
    
    // done
	return self;
}

-(bool) shouldMoveMap
{
    return self.hero.position.x > self.contentSize.width/2.f && self.hero.position.x < self.map.contentSize.width - self.contentSize.width/2.f;
}

-(void) update:(CCTime)delta
{
    [self.world step:delta];
    
    if([self shouldMoveMap])
    {
        [self.map runAction:[CCActionFollow actionWithTarget:self.hero worldBoundary:self.map.boundingBox]];
    }
    
    if(self.hero.onGround && !self.isTouching)
    {
        [self.hero stop];
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self.map convertToNodeSpace:touch.locationInWorld];
    self.touchDownLocation = touchLocation;
    self.touchDownTime = [NSDate date];

    if(touchLocation.x < self.hero.position.x)
    {
        [self.hero moveBackwards];
    }else
    {
        [self.hero moveForward];
    }
    
    self.isTouching = YES;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    float timePassed = -[self.touchDownTime timeIntervalSinceNow];
    
    bool hasJumped = NO;
    if(timePassed < 0.5 && timePassed > 0)
    {
        CGPoint touchLocation = [self.map convertToNodeSpace:touch.locationInWorld];
        float distance = ccpDistance(touchLocation, self.touchDownLocation);
        if(distance > 50)
        {
            [self.hero jump];
            hasJumped = YES;
            
            if(touchLocation.x > self.touchDownLocation.x + 20)
            {
                [self.hero moveForward];
                [self.hero moveForward];
            }else if(touchLocation.x < self.touchDownLocation.x - 20)
            {
                [self.hero moveBackwards];
                [self.hero moveBackwards];
            }
        }
    }
    
    if(!hasJumped)
    {
        [self.hero stop];
    }
    
    self.isTouching = NO;
}

@end
