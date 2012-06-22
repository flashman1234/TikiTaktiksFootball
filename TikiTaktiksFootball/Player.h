//
//  Player.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BodyNode.h"

@interface Player : BodyNode {
    
}

+(id) playerWithWorld:(b2World*)world position:(CGPoint)pos;
-(void) createPlayerInWorld:(b2World*)world position:(CGPoint)pos;

@end
