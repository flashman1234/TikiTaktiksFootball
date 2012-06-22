//
//  Opposition.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "Opposition.h"


@implementation Opposition

-(id) initWithWorld:(b2World*)world position:(CGPoint)pos
{
	if ((self = [super init]))
	{
		[self createOppositionInWorld:world  position:pos];
	}
	return self;
}

+(id) oppositionWithWorld:(b2World*)world position:(CGPoint)pos
{
	return [[[self alloc] initWithWorld:world position:pos] autorelease];
}

-(void) dealloc
{
	[super dealloc];
}

-(void) createOppositionInWorld:(b2World*)world position:(CGPoint)pos
{
	b2BodyDef spriteBodyDef;
	spriteBodyDef.type = b2_staticBody;
	spriteBodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	
	CCSprite* tempSprite = [CCSprite spriteWithFile:@"opposition1.png"];
    tempSprite.tag = kOppositionNodeTag;
	tempSprite.position = pos;
	
	b2PolygonShape spriteShape;
	spriteShape.SetAsBox(tempSprite.contentSize.width/PTM_RATIO/2, tempSprite.contentSize.height/PTM_RATIO/2);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &spriteShape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.8f;
	
	// restitution > 1 makes objects bounce off faster than they hit
	fixtureDef.restitution = 0.0f;
	
	[super createBody:world 
              bodyDef:&spriteBodyDef 
           fixtureDef:&fixtureDef 
           bodySprite:tempSprite
     ];
}


@end
