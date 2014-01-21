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
    if(self = [super init])
    {
        self.innerSprite = [CCSprite spriteWithImageNamed:@"karakterV2.png"];
        [self addChild:self.innerSprite];
        self.contentSize = self.innerSprite.contentSize;
        center = ccp(self.contentSize.width/2.f, self.contentSize.height/2.f);
        
        self.innerSprite.position = center;
        CCTiledMapObjectGroup *objectGroup = [map objectGroupNamed:@"Char"];
        
        if(objectGroup == NULL){
            return nil;
        }
        
        NSDictionary *spawnPoint = [objectGroup.objects objectAtIndex:0];
        
        int x = [[spawnPoint valueForKey:@"x"] intValue]/2;
        int y = [[spawnPoint valueForKey:@"y"] intValue]/2;
        
        self.position = ccp(x,y);
        [map addChild:self];

        self.velocity = ccp(0,0);
        
        drawNode = [CCSprite spriteWithImageNamed:@"1px.png"];
        drawNode.color = [CCColor blueColor];
//        [self addChild:drawNode];
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
    if(!self.onGround && b)
    {
        float timeSinceLastOnGround = -[self.lastTimeOnGround timeIntervalSinceNow];
        
        if(timeSinceLastOnGround > 1)
        {
            [self landOnGround];
        }
    }else if(self.onGround && !b)
    {
        self.lastTimeOnGround = [NSDate date];
    }
    _onGround = b;
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
    self.velocity = ccp(0, self.velocity.y);
    [self stopWalkAnimation];
}

-(void) jump
{
    self.velocity = ccpAdd(self.velocity, ccp(0, 300));
}

-(void) update:(CCTime)delta
{   
    CGPoint gravity = ccp(0, -450);
    CGPoint gravityStep = ccpMult(gravity, delta);
    self.velocity = ccpAdd(self.velocity, gravityStep);
    CGPoint stepVelocity = ccpMult(self.velocity, delta);
    self.desiredPosition = ccpAdd(self.position, stepVelocity);
    self.desiredPosition = ccp(roundf(self.desiredPosition.x), roundf(self.desiredPosition.y));
}


-(CGRect)collisionBoundingBox {
    CGRect collisionBox = CGRectInset(self.boundingBox, 3, 0);
    CGPoint diff = ccpSub(self.desiredPosition, self.position);
    CGRect returnBoundingBox = CGRectOffset(collisionBox, diff.x, diff.y);
    
    
    drawNode.position = ccp(0, 0);
    drawNode.anchorPoint = ccp(0,0);
    drawNode.scaleX = returnBoundingBox.size.width;
    drawNode.scaleY = returnBoundingBox.size.height;
    
    
    return returnBoundingBox;
}
@end
