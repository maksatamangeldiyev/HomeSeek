//
//  IntroScene.h
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright Peak games 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------

#import "CollisionObject.h"
#import "Map.h"
#import "PhysicsWorld.h"
#import "Hero.h"

@interface IntroScene : CCScene

// -----------------------------------------------------------------------

+ (IntroScene *)scene;
- (id)init;

@property (nonatomic, strong) Hero* hero;
@property (nonatomic, strong) PhysicsWorld* world;
@property (nonatomic, strong) Map* map;

@property (nonatomic, assign) CGPoint touchDownLocation;
@property (nonatomic, strong) NSDate* touchDownTime;
@property (nonatomic, assign) bool isTouching;

@end