//
//  KickOffArrow.m
//  TTFootball
//
//  Created by Michal Thompson on 6/14/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "KickOffArrow.h"


@implementation KickOffArrow

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
		[self createKickOffArrowInWorld:world];
	}
	return self;
}

+(id) kickOffArrowWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) dealloc
{
	[super dealloc];
}


-(void) createKickOffArrowInWorld:(b2World*)world
{
    
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGPoint pos = CGPointMake(screenSize.width /2, 80);
    
	b2BodyDef kickOffArrowBodyDef;
	kickOffArrowBodyDef.type = b2_staticBody;
	kickOffArrowBodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	
	CCSprite* tempSprite = [CCSprite spriteWithFile:@"red-up-arrow.png"];
    tempSprite.tag = kKickOffArrowTag;
	tempSprite.position = pos;
	
	b2PolygonShape spriteShape;
	spriteShape.SetAsBox(tempSprite.contentSize.width/PTM_RATIO/2, tempSprite.contentSize.height/PTM_RATIO/2);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &spriteShape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.8f;
    
	// restitution > 1 makes objects bounce off faster than they hit
	fixtureDef.restitution = 1.5f;
	
	
	[super createBody:world 
              bodyDef:&kickOffArrowBodyDef 
           fixtureDef:&fixtureDef 
           bodySprite:tempSprite
     ];
	
	
    
    
}




@end
