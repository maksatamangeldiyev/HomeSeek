//
//  Hero.h
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "CollisionObject.h"

enum
{
    AnimationWalking
} Animation;

@interface Hero : CollisionObject

@property (nonatomic, assign) BOOL isWalking;
@property (nonatomic, assign) BOOL isJumping;
@property (nonatomic, assign) BOOL isDead;


-(instancetype) initWithMap:(CCTiledMap*) map;

-(void) moveForward;
-(void) moveBackwards;
-(void) jump;

-(void) landOnGround;

-(void) die;

@end
