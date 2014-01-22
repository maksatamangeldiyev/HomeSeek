//
//  Geometry.m
//  Home
//
//  Created by Maksat Aman on 1/22/14.
//  Copyright (c) 2014 Peak games. All rights reserved.
//

#import "Geometry.h"

@implementation Geometry

+(bool) isRect:(CGRect) r1 rightBelowRect:(CGRect) r2
{
    if(r1.origin.y <= r2.origin.y)
    {
        //        if(r1.origin.x > r2.origin.x)
        {
            //            if(r1.origin.x < r2.origin.x + r2.size.width)
            {
                return YES;
            }
        }
    }
    return NO;
}

+(bool) isRect:(CGRect) r1 rightAboveRect:(CGRect) r2
{
    if(r1.origin.y > r2.origin.y)
    {
        if(r1.origin.x > r2.origin.x)
        {
            if(r1.origin.x < r2.origin.x + r2.size.width)
            {
                return YES;
            }
        }
    }
    return NO;
}

+(bool) isRect:(CGRect) r1 toTheLeftOf:(CGRect) r2
{
    if(r1.origin.x < r2.origin.x)
    {
        //        if(r1.origin.y > r2.origin.y)
        {
            //            if(r1.origin.y < r2.origin.y + r2.size.height)
            {
                return YES;
            }
        }
    }
    return NO;
}

+(bool) isRect:(CGRect) r1 toTheRightOf:(CGRect)r2
{
    if(r1.origin.x >= r2.origin.x)
    {
        //        if(r1.origin.y > r2.origin.y)
        {
            //            if(r1.origin.y < r2.origin.y + r2.size.height)
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
