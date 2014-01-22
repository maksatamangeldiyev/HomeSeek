//
//  Geometry.h
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Geometry : NSObject

+(bool) isRect:(CGRect) r1 rightBelowRect:(CGRect) r2;
+(bool) isRect:(CGRect) r1 rightAboveRect:(CGRect) r2;
+(bool) isRect:(CGRect) r1 toTheLeftOf:(CGRect) r2;
+(bool) isRect:(CGRect) r1 toTheRightOf:(CGRect)r2;

@end
