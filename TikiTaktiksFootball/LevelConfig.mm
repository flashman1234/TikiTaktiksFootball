//
//  LevelConfig.m
//  TTFootball
//
//  Created by Michal Thompson on 6/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "LevelConfig.h"
#import "Goal.h"
#import "Ball.h"
#import "Background.h"
#import "Player.h"
#import "Opposition.h"
#import "KickOffArrow.h"
#import <UIKit/UIKit.h>
#import "DataStore.h"




@implementation LevelConfig

-(void) dealloc
{
  	[super dealloc];
}


-(id) initWithWorld:(b2World*)xworld node:(CCNode*)node
{
	if ((self = [super init]))
	{
        world = xworld;
        xnode = node;
	}
	return self;
}


+(id) configWithWorld:(b2World*)world node:(CCNode*)node
{
	return [[[self alloc] initWithWorld:world node:node] autorelease];
}

-(void)loadLevel:(int)level
{
    [self addBackground];
    [self addGoal];
    [self addBall];
    [self addLevelTitle:level];
    
    
    

    DataStore *dataStore = [[DataStore alloc] init];
    
    NSMutableArray *lev = [dataStore getLevel:level];
    
    for (NSDictionary *co in lev) {
        
        NSString *value = (NSString *)[co valueForKey:@"SpriteType"];
        
        CGPoint spritePosition = CGPointFromString((NSString *)[co valueForKey:@"Coordinates"]);
        
        if([value isEqualToString:@"Player"]){

            [self addPlayerAt:spritePosition];
        }
        
        if([value isEqualToString:@"Opposition"]){

            [self addOppositionAt:spritePosition];
        }
    }
    
    
   
    
    
//    [self addPlayerAt:CGPointMake(255, 224)];
//    [self addPlayerAt:CGPointMake(56, 338)];
//    [self addPlayerAt:CGPointMake(218, 346)];
//    [self addPlayerAt:CGPointMake(56, 199)];
    
    
    
//    [self addOppositionAt:CGPointMake(236, 396)];
//    [self addOppositionAt:CGPointMake(157, 287)];
//    [self addOppositionAt:CGPointMake(88, 395)];
//    [self addOppositionAt:CGPointMake(106, 125)];



    
    //[self addKickOffArrow];
}

//-(void)loadLevel2
//{
//    [self addBackground];
//    [self addGoal];
//    [self addBall];
//    [self addLevelTitle:2];
//    
//    [self addPlayerAt:CGPointMake(260, 180)];
//    [self addOppositionAt:CGPointMake(160, 380)];
//}

-(void)addLevelTitle:(int) level
{
    CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %d", level] fontName:@"Arial" fontSize:16];
    [xnode addChild: label];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    [label setPosition: CGPointMake(30, s.height-20)];
    
}



-(void)addGoal
{
    Goal* goal = [Goal goalWithWorld:world];
    [xnode addChild:goal z:-1];
}

-(void)addBall
{
    Ball* ball = [Ball ballWithWorld:world];
	[xnode addChild:ball z:0];	
}

-(void)addBackground
{
    CCSprite* background = [Background createBackgroundInWorld];
    background.position = ccp(160, 240);
	[xnode addChild:background z:-2];
}

-(void) addPlayerAt:(CGPoint)pos
{
	Player* player = [Player playerWithWorld:world position:pos];
	[xnode addChild:player z:-2];
}

-(void) addOppositionAt:(CGPoint)pos
{
	Opposition* opposition = [Opposition oppositionWithWorld:world position:pos];
	[xnode addChild:opposition z:-2];
}

-(void)addKickOffArrow
{
    
    //CCSprite *player = [CCSprite spriteWithFile:@"red-up-arrow.jpg"];
//    KickOffArrow* kickOffArrow = [KickOffArrow kickOffArrowWithWorld:world];
//    [xnode addChild:kickOffArrow z:-1];
}



@end
