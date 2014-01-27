//
//  Plant.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Plant.h"
#import "Hero.h"

@implementation Plant

-(instancetype) init
{
    if(self = [super initWithFileName:@"enemy_plantV2.png"])
    {
        self.innerSprite.anchorPoint = ccp(0,0);
        self.innerSprite.position = ccpSub(self.innerSprite.position, ccp(self.innerSprite.boundingBox.size.width/2.f, self.innerSprite.boundingBox.size.height/2.f));
        [self.innerSprite runAction:[CCActionRepeatForever actionWithAction:
                                     [CCActionSequence actions:
                                     [CCActionScaleTo actionWithDuration:.2f scaleX:1 scaleY:.95],
                                      [CCActionScaleTo actionWithDuration:.2f scaleX:1 scaleY:1],
                                      nil]
                                     ]];
    }
    return self;
}


-(void) collisionWith:(CollisionObject*) collided size:(CGSize) collisionSize
{
    if([collided isKindOfClass:[Hero class]])
    {
        if(collided.position.y < self.position.y + self.boundingBox.size.height - 15)
        {
            self.desiredPosition  = ccpAdd(self.desiredPosition, ccp(-collisionSize.width, 0));
        }
    }
}
@end
