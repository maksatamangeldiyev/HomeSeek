//
//  Hero.m
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Hero.h"
#import "Plant.h"
#import "CCDrawingPrimitives.h"
#import "SoundManager.h"
#import "IntroScene.h"

CCSprite* drawNode;
CGPoint center;
@implementation Hero

-(instancetype) initWithMap:(CCTiledMap*) map
{
    if(self = [super initWithFileName:@"hero.png"])
    {
        CCTiledMapObjectGroup *objectGroup = [map objectGroupNamed:@"Char"];
        
        if(objectGroup == NULL){
            return nil;
        }
        
        NSDictionary *spawnPoint = [objectGroup.objects objectAtIndex:0];
        [self setPositionWithTileObject:spawnPoint];
        self.zOrder = 10000;
        [map addChild:self];

        self.isJumping = NO;
        self.isDead = NO;
        
        [self performSelector:@selector(playIdleSound) withObject:nil afterDelay:rand()%15];
        
    }
    return self;
}

-(void) playIdleSound
{
    
    [[SoundManager sharedManager] playIdle];
    [self performSelector:@selector(playIdleSound) withObject:nil afterDelay:rand()%15];
}

-(void) startWalkAnimation
{
    if(self.isWalking)
    {
        return;
    }
    
    [[SoundManager sharedManager] playSteps];
    
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
    [[SoundManager sharedManager] stopSteps];
    if(self.isWalking)
    {
        [self.innerSprite runAction:
         [CCActionSpawn actions:
            [CCActionScaleTo actionWithDuration:.1f scaleX:1.f scaleY:1.f],
            [CCActionMoveTo actionWithDuration:.1f position:self.center],
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
        self.velocity = ccpAdd(self.velocity, ccp(140, 0));
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
        self.velocity = ccpAdd(self.velocity, ccp(-140, 0));
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
    
    [[SoundManager sharedManager] playJump];
    self.isJumping = YES;
    self.velocity = ccpAdd(self.velocity, ccp(0, 350));
}

-(void) setSlope:(float)slope
{
    if(slope != self.slope)
    {
        if(slope > 0)
        {
            slope = -20;
        }else if(slope < 0)
        {
            slope = 20;
        }
        [self.innerSprite runAction:[CCActionRotateTo actionWithDuration:.1f angle:slope]];
    }
    [super setSlope:slope];
}

-(void) collisionWith:(CollisionObject*) collided size:(CGSize) collisionSize
{
//    if([collided isKindOfClass:[Plant class]])
//    {
//        float shiftX = 2*collisionSize.width;
//        float shiftY = 2*collisionSize.height;
//        
//        float xVel = self.velocity.x;
//        float yVel = self.velocity.y;
//        if(!self.isWalking)
//        {
//            xVel = 0;
//        }
//        if(!self.isJumping)
//        {
//            yVel = 0;
//        }
//        
//        self.velocity = ccp(xVel, yVel);
//        self.onGround = YES;
//       
//        
//        if(shiftY < 0)
//        {
//            shiftY = 0;
//        }
//        
//        self.desiredPosition  = ccpAdd(self.desiredPosition, ccp(0, shiftY));
//    }
    
    if([collided isKindOfClass:[Plant class]])
    {
        [self die];
    }
}

-(void) die
{
    if(self.isDead)
    {
        return;
    }
    self.isDead = YES;
    [[SoundManager sharedManager] playDie];
    [self runAction:[CCActionSequence actions:
                     [CCActionScaleTo actionWithDuration:1.1f scaleX:0 scaleY:0],
                     [CCActionCallBlock actionWithBlock:^{
                            [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                                                       withTransition:[CCTransition transitionFadeWithColor:[CCColor yellowColor] duration:.4f]];
                    }],nil]];
}

@end
