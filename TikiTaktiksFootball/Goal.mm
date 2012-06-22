//
//  Goal.mm
//  TikiTakatics
//
//  Created by Michal Thompson on 1/30/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "Goal.h"



@implementation Goal
-(id) initWithWorld:(b2World*)world
{
	if ((self = [super init]))
	{
		[self createGoalInWorld:world];
	}
	return self;
}

+(id) goalWithWorld:(b2World*)world
{
	return [[[self alloc] initWithWorld:world] autorelease];
}

-(void) dealloc
{
	[super dealloc];
}


-(void) createGoalInWorld:(b2World*)world
{

	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGPoint pos = CGPointMake(screenSize.width /2,  screenSize.height - 20);

	b2BodyDef goalBodyDef;
	goalBodyDef.type = b2_staticBody;
	goalBodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	
	CCSprite* tempSprite = [CCSprite spriteWithFile:@"goal.png"];
    tempSprite.tag = kGoalNodetag;
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
					bodyDef:&goalBodyDef 
					fixtureDef:&fixtureDef 
					bodySprite:tempSprite
     ];
	
	


}



@end
