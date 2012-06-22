//
//  Ball.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "Ball.h"
#import "Helper.h"


@implementation Ball

-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
		[self createBallInWorld:world];
	}
	return self;
}

+(id) ballWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) dealloc
{
	[super dealloc];
}

-(void) createBallInWorld:(b2World*)world
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CGPoint startPos = CGPointMake(screenSize.width/2, 50);
    
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:startPos];
	
	CCSprite* ballSprite = [CCSprite spriteWithFile:@"soccer_ball.png"];
    ballSprite.scaleX = 0.5f;
    ballSprite.scaleY = 0.5f;
	ballSprite.position = startPos;
    ballSprite.tag = kBallNodeTag;
	
	b2CircleShape shape;
	float radiusInMeters = (ballSprite.contentSize.width / PTM_RATIO) * 0.25f;
	shape.m_radius = radiusInMeters;
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 0.8f;
	fixtureDef.friction = 0.7f;
	fixtureDef.restitution = 0.3f;
	
	
	[super createBody:world 
                    bodyDef:&bodyDef 
                    fixtureDef:&fixtureDef 
                    bodySprite:ballSprite
     ];
    
}

@end
