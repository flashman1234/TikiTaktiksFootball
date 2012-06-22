//
//  KickOffArrow.h
//  TTFootball
//
//  Created by Michal Thompson on 6/14/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "BodyNode.h"

@interface KickOffArrow : BodyNode
{
    
}

+(id)kickOffArrowWithWorld:(b2World*)world;
-(void) createKickOffArrowInWorld:(b2World*)world;

@end
