//
//  Ball.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "BodyNode.h"

@interface Ball : BodyNode {
    
}

+(id) ballWithWorld:(b2World*)world;
-(void) createBallInWorld:(b2World*)world;

@end
