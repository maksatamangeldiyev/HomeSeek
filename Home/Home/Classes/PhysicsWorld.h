//
//  PhysicsWorld.h
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "CollisionObject.h"

@interface PhysicsWorld : NSObject

+(instancetype) world;
@property (nonatomic, weak) Map* map;
@property (nonatomic, weak) CCTiledMapLayer* walls;

@property (nonatomic, strong) NSMutableArray* dynamicObjects;

@property (nonatomic, strong) NSMutableArray* objectsToRemove;

+(instancetype) physicsWorldWithMap:(Map*) map;
-(instancetype) initWithMap:(Map*) map;

-(void) addDynamicObject:(CollisionObject*) object;
-(void) removeDynamicObject:(CollisionObject*) object;

-(void) step:(CCTime)delta;

@end
