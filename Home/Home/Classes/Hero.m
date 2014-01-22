//
//  Hero.m
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Hero.h"
#import "CCDrawingPrimitives.h"

CCSprite* drawNode;
CGPoint center;
@implementation Hero

-(instancetype) initWithMap:(CCTiledMap*) map
{
    if(self = [super initWithFileName:@"karakterV2.png"])
    {
        CCTiledMapObjectGroup *objectGroup = [map objectGroupNamed:@"Char"];
        
        if(objectGroup == NULL){
            return nil;
        }
        
        NSDictionary *spawnPoint = [objectGroup.objects objectAtIndex:0];
        [self setPositionWithTileObject:spawnPoint];
        [map addChild:self];

        self.isJumping = NO;
       
    }
    return self;
}

-(void) startWalkAnimation
{
    if(self.isWalking)
    {
        return;
    }
    
    self.isWalking = YES;
    CCAction* walkAnimation = [CCActionRepeatForever actionWithAction:
                               [CCActionSpawn actions:
                                
                               [CCActionSequence actions:
                                
                                [CCActionEaseIn actionWithAction: [CCActionScaleTo actionWithDuration:.15f scaleX:1.03 scaleY:0.98] rate:.5f],
                                [CCActionEaseIn actionWithAction: [CCActionScaleTo actionWithDuration:.3f scaleX:0.98 scaleY:1.03] rate:.5f],
                                nil],
                               [CCActionSequence actions:
                                 [CCActionEaseIn actionWithAction: [CCActionMoveBy actionWithDuration:.15f position:ccp(0, -4)] rate:.5f],
                                 [CCActionEaseIn actionWithAction: [CCActionMoveBy actionWithDuration:.3f position:ccp(0, 4)] rate:.5f],
                                nil],
                                
                                nil]];
    walkAnimation.tag = AnimationWalking;
    [self.innerSprite runAction:walkAnimation];
}

-(void) stopWalkAnimation
{
    if(self.isWalking)
    {
        [self.innerSprite runAction:
         [CCActionSpawn actions:
            [CCActionScaleTo actionWithDuration:.1f scaleX:1.f scaleY:1.f],
            [CCActionMoveTo actionWithDuration:.1f position:center],
          nil
          ]];
    }
    self.isWalking = NO;
    [self.innerSprite stopActionByTag:AnimationWalking];
}

-(void) moveForward
{
    if(self.velocity.x <= 0)
    {
        self.velocity = ccpAdd(self.velocity, ccp(70, 0));
    }
    
    if(self.velocity.x > 0)
    {
        self.innerSprite.flipX = NO;
        
        [self startWalkAnimation];
    }else if(self.velocity.x == 0)
    {
        [self stopWalkAnimation];
    }
}

-(void) moveBackwards
{
    if(self.velocity.x >= 0)
    {
        self.velocity = ccpAdd(self.velocity, ccp(-70, 0));
    }
    
    if(self.velocity.x < 0)
    {
        [self startWalkAnimation];
        self.innerSprite.flipX = YES;
    }else if(self.velocity.x == 0)
    {
        [self stopWalkAnimation];
    }
}

-(void) setOnGround:(BOOL)b
{
    if(b)
    {
        self.isJumping = NO;
    }
    [super setOnGround:b];
}

-(void) landOnGround
{
    CCAction* landAnimation =  [CCActionSpawn actions:
                                [CCActionSequence actions:
                                 [CCActionEaseIn actionWithAction: [CCActionScaleTo actionWithDuration:.1f scaleX:1.1 scaleY:0.9] rate:.5f],
                                 [CCActionEaseIn actionWithAction: [CCActionScaleTo actionWithDuration:.1f scaleX:1 scaleY:1] rate:.5f],
                                 nil],
                                [CCActionSequence actions:
                                 [CCActionEaseIn actionWithAction: [CCActionMoveBy actionWithDuration:.1f position:ccp(0, -4)] rate:.5f],
                                 [CCActionEaseIn actionWithAction: [CCActionMoveBy actionWithDuration:.1f position:ccp(0, 4)] rate:.5f],
                                 nil],
                                nil];
    [self.innerSprite runAction:landAnimation];
}

-(void) stop
{
    [super stop];
    [self stopWalkAnimation];
}

-(void) jump
{
    if(self.isJumping)
    {
        return;
    }
    self.isJumping = YES;
    self.velocity = ccpAdd(self.velocity, ccp(0, 300));
}

@end
