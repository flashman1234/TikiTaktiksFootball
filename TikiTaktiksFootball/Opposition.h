//
//  Opposition.h
//  TTFootball
//
//  Created by Michal Thompson on 4/8/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BodyNode.h"

@interface Opposition : BodyNode {
    
}

+(id) oppositionWithWorld:(b2World*)world position:(CGPoint)pos;
-(void) createOppositionInWorld:(b2World*)world position:(CGPoint)pos;

@end
