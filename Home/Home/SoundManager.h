//
//  SoundManager.h
//  Home
//
//  Created by Maksat Aman on 1/23/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject


@property (nonatomic, strong) NSMutableDictionary* soundHandlers;

+(instancetype) sharedManager;



-(void) playSteps;
-(void) stopSteps;

-(void) playJump;
-(void) playFall;
-(void) playCoin;

-(void) playIdle;
-(void) playDie;

@end
