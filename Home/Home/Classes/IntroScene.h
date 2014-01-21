//
//  IntroScene.h
//  Home
//
//  Created by Maksat Aman on 1/20/14.
//  Copyright Peak games 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface IntroScene : CCScene

// -----------------------------------------------------------------------

+ (IntroScene *)scene;
- (id)init;

@property (nonatomic, strong) NSMutableArray* collisionPoints;

@property (nonatomic, assign) CGPoint touchDownLocation;
@property (nonatomic, strong) NSDate* touchDownTime;
@property (nonatomic, assign) bool isTouching;

@end