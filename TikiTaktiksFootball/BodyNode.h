//
//  BodyNode.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@interface BodyNode : CCNode {
    
    b2Body* body;
    CCSprite* sprite;
    b2Fixture* fixture;
    
}

@property (readonly, nonatomic) b2Body* body;
@property (readonly, nonatomic) CCSprite* sprite;

-(void)createBody:(b2World*)world 
          bodyDef:(b2BodyDef*)bodyDef 
       fixtureDef:(b2FixtureDef*)fixtureDef
       bodySprite:(CCSprite*)bodySprite;

-(void) removeSprite;
-(void) removeBody;

@end
