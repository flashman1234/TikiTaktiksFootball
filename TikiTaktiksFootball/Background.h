//
//  Background.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface Background : CCNode {
    
}

//+(id) backgroundWithWorld:(b2World*)world;
+(CCSprite*) createBackgroundInWorld;

@end
