//
//  Hero.h
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

enum
{
    AnimationWalking
} Animation;

@interface Hero : CCSprite

@property (nonatomic, assign) CCSprite* innerSprite;

@property (nonatomic,assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;

@property (nonatomic, assign) BOOL isWalking;

@property (nonatomic, strong) NSDate* lastTimeOnGround;

-(instancetype) initWithMap:(CCTiledMap*) map;

-(CGRect) collisionBoundingBox;

-(void) moveForward;
-(void) moveBackwards;
-(void) jump;
-(void) stop;
-(void) landOnGround;

@end
