//
//  BodyNode.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "BodyNode.h"


@implementation BodyNode

@synthesize body;
@synthesize sprite;

-(void)createBody:(b2World*)world 
            bodyDef:(b2BodyDef*)bodyDef 
            fixtureDef:(b2FixtureDef*)fixtureDef
            bodySprite:(CCSprite*)bodySprite;
{
    
    //[self removeSprite];
	[self removeBody];
	
	sprite = bodySprite;
	[self addChild:sprite];
    
    body = world->CreateBody(bodyDef);
	body->SetUserData(self);
    
    fixture = body->CreateFixture(fixtureDef);
    
    
}


-(void) removeBody
{
	if (body != NULL)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}

-(void) removeSprite
{
//	CCSpriteBatchNode* batch = [[Pitch sharedPitch] getSpriteBatch];
//	if (sprite != nil && [batch.children containsObject:sprite])
//	{
//		[batch.children removeObject:sprite];
		sprite = nil;
//	}
}

-(void) dealloc
{
	//[self removeSprite];
	[self removeBody];
	
	[super dealloc];
}


@end
