//
//  GameMenu.m
//  TTFootball
//
//  Created by Michal Thompson on 6/11/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "GameMenu.h"
#import "LevelMenu.h"
#import "GameLevel.h"

@implementation GameMenu
@synthesize gameLevel;


- (id)initWithLevelId:(int)levelId {
    
    if ((self = [super init])) {
        
        CCMenu *gameMenu = [CCMenu menuWithItems: nil];
        gameMenu.position = CGPointZero;
        [self addChild:gameMenu]; 
        
        
        
        CCMenuItem *pausePlay = [CCMenuItemImage 
                                    itemFromNormalImage:@"PausePlay.png" selectedImage:@"PausePlay.png" 
                                    target:self selector:@selector(resumeGame)];
        pausePlay.position = ccp(50, 50);
        
        CCMenuItem *levelMenu = [CCMenuItemImage 
                                    itemFromNormalImage:@"LevelMenu.png" selectedImage:@"LevelMenu.png" 
                                    target:self selector:@selector(goMenu)];
        levelMenu.position = ccp(50, 120);
        
//        CCMenuItem *starMenuItem3 = [CCMenuItemImage 
//                                     itemFromNormalImage:@"ResetLevel.png" selectedImage:@"ResetLevel.png" 
//                                     target:self selector:@selector(resetLevel)];
//        starMenuItem3.position = ccp(50, 190);
        
        CCMenuItem *resetBall = [CCMenuItemImage 
                                     itemFromNormalImage:@"ResetPositions.png" selectedImage:@"ResetPositions.png" 
                                     target:self selector:@selector(resetPositions)];
        resetBall.position = ccp(50, 190);
        
        CCMenuItem *savePositions = [CCMenuItemImage 
                                     itemFromNormalImage:@"Save.png" selectedImage:@"Save.png" 
                                     target:self selector:@selector(savePositions)];
        savePositions.position = ccp(50, 250);

        [gameMenu addChild:pausePlay];
        [gameMenu addChild:levelMenu];
        [gameMenu addChild:resetBall];
        
        if (levelId == 0) {
            [gameMenu addChild:savePositions];
        }
    }
    return self;
}

+ (id) GameMenuDisplay:(int)levelId
{
	return [[[self alloc] initWithLevelId:levelId] autorelease];
}


-(void)resumeGame
{
    [[CCDirector sharedDirector] resume];
    [self.parent removeChild:self cleanup:YES];
}

-(void)goMenu
{
    [[CCDirector sharedDirector] resume];
    CCDirector *director = [CCDirector sharedDirector];
	CCLayer *layer = [LevelMenu node];
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
    
    [director replaceScene:newScene];
}

//-(void)resetLevel
//{
//    [[CCDirector sharedDirector] resume];
//    id par = [self parent];
//    [par removeChild:self cleanup:YES];
//    
//    GameLevel * par2 = (GameLevel*)[par parent];
//    [par2 removeChild:par cleanup:YES];
//    
//    [par2 resetGame];
//}

-(void)resetPositions
{
    [[CCDirector sharedDirector] resume];
    id par = [self parent];
    [par removeChild:self cleanup:YES];
    
    GameLevel * par2 = (GameLevel*)[par parent];
    
    [par2 resetPositions];
}

-(void)savePositions
{
    id par = [self parent];
    [par removeChild:self cleanup:YES];
    GameLevel * par2 = (GameLevel*)[par parent];
    
    [par2 savePositions];
}


-(void)dealloc
{
	[super dealloc];
}

@end
