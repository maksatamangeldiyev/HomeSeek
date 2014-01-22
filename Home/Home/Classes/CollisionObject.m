//
//  CollisionObject.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "CollisionObject.h"

@implementation CollisionObject

CCSprite* drawNode;
CGPoint center;

-(instancetype) initWithFileName:(NSString*) imgFileName
{
    if(self = [super init])
    {
        self.innerSprite = [CCSprite spriteWithImageNamed:imgFileName];
        [self addChild:self.innerSprite];
        self.contentSize = self.innerSprite.contentSize;
        center = ccp(self.contentSize.width/2.f, self.contentSize.height/2.f);
        
        self.innerSprite.position = center;
        
        self.velocity = ccp(0,0);
        
        drawNode = [CCSprite spriteWithImageNamed:@"1px.png"];
        drawNode.color = [CCColor blueColor];
//        [self addChild:drawNode];
    }
    return self;
}


-(void) step:(CCTime)delta
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

-(void) stop
{
    self.velocity = ccp(0, self.velocity.y);
}

-(void) landOnGround
{

}

-(void) setPositionWithTileObject:(NSDictionary*) tileObject
{
    int x = [[tileObject valueForKey:@"x"] intValue]/2;
    int y = [[tileObject valueForKey:@"y"] intValue]/2;
    self.position = ccp(x,y);
}

@end
