//
//  SoundManager.m
//  Home
//
//  Created by Maksat Aman on 1/23/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "SoundManager.h"
#import "cocos2d.h"

static SoundManager* _sharedManager;
@implementation SoundManager

+(instancetype) sharedManager
{
    if(_sharedManager == nil)
    {
        _sharedManager = [[SoundManager alloc] init];
    }
    return _sharedManager;
}

-(instancetype) init
{
    if(self == [super init])
    {
        [[OALSimpleAudio sharedInstance] playBg:@"Rain Forest.m4a" loop:YES];
        
        
        NSArray* soundFiles = @[@"Chest.m4a",
                                @"Coin.m4a",
                                @"Die.m4a",
                                @"Enemy.m4a",
                                @"Energy Increase.m4a",
                                @"idle1.m4a",
                                @"idle2.m4a",
                                @"idle3.m4a",
                                @"Jump.m4a",
                                @"Level Completed.m4a",
                                @"Music.m4a",
                                @"Play Button.m4a",
                                @"Rain Forest.m4a",
                                @"Rock Fall.m4a",
                                @"Rock Push.m4a",
                                @"Walking.m4a",
                                @"Wear.m4a"
                                ];
        
        for(NSString* file in soundFiles)
        {
            [[OALSimpleAudio sharedInstance] preloadEffect:file reduceToMono:YES];
        }
        
        self.soundHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void) playSound:(NSString*) sound loop:(bool) loop
{
    id handler = [[OALSimpleAudio sharedInstance] playEffect:sound loop:loop];
    [self.soundHandlers setObject:handler forKey:sound];
}

-(void) stopSound:(NSString*) sound
{
    id<ALSoundSource> handler = [self.soundHandlers objectForKey:sound];
    [handler stop];
    [self.soundHandlers removeObjectForKey:sound];
}

-(void) playIdle
{
    int rnd = random()%3 + 1;
    
    [self playSound:[NSString stringWithFormat:@"idle%d.m4a", rnd] loop:NO];
}

-(void) playSteps
{
    [self playSound:@"Walking.m4a" loop:YES];
}

-(void) stopSteps
{
    [self stopSound:@"Walking.m4a"];
}

-(void) playJump
{
    [self playSound:@"Jump.m4a" loop:NO];
}
-(void) playFall
{
    [self playSound:@"idle1.m4a" loop:NO];
}
-(void) playCoin
{
    [self playSound:@"Coin.m4a" loop:NO];
}

-(void) playDie
{
    [self playSound:@"Die.m4a" loop:NO];    
}

@end
