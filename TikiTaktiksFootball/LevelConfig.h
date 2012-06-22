//
//  LevelConfig.h
//  TTFootball
//
//  Created by Michal Thompson on 6/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"


@interface LevelConfig  : CCLayer {
    b2World* world;
    CCNode* xnode;

}


-(void)addGoal;
-(void)addBall;
-(void)addBackground;
-(void)loadLevel:(int)level;
-(void)addPlayerAt:(CGPoint)pos;
-(void)addOppositionAt:(CGPoint)pos;

-(void)addLevelTitle:(int)level;


+(id) configWithWorld:(b2World*)world  node:(CCNode*)node;




@end
