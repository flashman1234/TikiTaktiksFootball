//
//  Ball.h
//  TikiTakatics
//
//  Created by Michal Thompson on 1/25/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "BodyNode.h"

@interface Goal : BodyNode
{
}

+(id) goalWithWorld:(b2World*)world;
-(void) createGoalInWorld:(b2World*)world;

@end
