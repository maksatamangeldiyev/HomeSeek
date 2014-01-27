//
//  CollisionObject.h
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface CollisionObject : CCSprite

@property (nonatomic, strong) CCSprite* innerSprite;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, strong) NSDate* lastTimeOnGround;
@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) float slope;


-(instancetype) initWithFileName:(NSString*) imgFileName;

-(CGRect)collisionBoundingBox;
-(void) step:(CCTime)delta;
-(void) stop;

-(void) landOnGround;

-(void) setPositionWithTileObject:(NSDictionary*) tileObject;


-(void) collisionWith:(CollisionObject*) collided size:(CGSize) collisionSize;

@end
