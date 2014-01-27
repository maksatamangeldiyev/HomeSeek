//
//  Coin.m
//  Home
//
//  Created by Maksat Aman on 1/23/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Coin.h"
#import "Hero.h"
#import "PhysicsWorld.h"
#import "SoundManager.h"

@implementation Coin

-(instancetype) init
{
    if(self = [super initWithImageNamed:@"coin.png"])
    {
//        [self runAction:[CCActionRepeatForever actionWithAction:
//                                     [CCActionSequence actions:
//                                      [CCActionScaleTo actionWithDuration:.6f scaleX:-1 scaleY:1],
//                                      [CCActionScaleTo actionWithDuration:.6f scaleX:1 scaleY:1],
//                                      nil]
//                                     ]];

    }
    return self;
}

-(void) step:(CCTime)delta
{
    self.desiredPosition = self.position;
}


-(void) collisionWith:(CollisionObject*) collided size:(CGSize) collisionSize
{
    if([collided isKindOfClass:[Hero class]])
    {
        [[SoundManager sharedManager] playCoin];
        [self removeFromParent];
        [[PhysicsWorld world] removeDynamicObject:self];
    }
}

@end
