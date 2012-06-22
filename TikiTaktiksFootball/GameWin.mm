//
//  GameWin.m
//  TTFootball
//
//  Created by Michal Thompson on 6/12/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "GameWin.h"
#import "GameLevel.h"
#import "LevelMenu.h"


@implementation GameWin

-(id) initGameWinWithLevel:(int)levelId
{
    if ((self = [super init]))
    {         
        _theLevel = levelId;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    
    
        CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You Win level: %d", _theLevel] fontName:@"Arial" fontSize:16];
        [self addChild: label];
    
        CGSize s = [[CCDirector sharedDirector] winSize];
        [label setPosition: CGPointMake(30, s.height-20)];
        
        
        
        
        CCMenuItem *levelMenuItem = [CCMenuItemImage 
                                     itemFromNormalImage:@"Button1.png" selectedImage:@"Button1.png" 
                                     target:self selector:@selector(backToLevel:)];
        levelMenuItem.tag = 1;
        levelMenuItem.position = ccp(60, 200);
        
        CCMenuItem *levelMenuItem2 = [CCMenuItemImage 
                                      itemFromNormalImage:@"Button2.png" selectedImage:@"Button2.png" 
                                      target:self selector:@selector(nextLevel:)];
        levelMenuItem2.tag = 2;
        levelMenuItem2.position = ccp(120, 200);
        
        CCMenuItem *levelMenuItem3 = [CCMenuItemImage 
                                      itemFromNormalImage:@"Button3.png" selectedImage:@"Button3.png" 
                                      target:self selector:@selector(levelMenu:)];
        levelMenuItem3.tag = 3;
        levelMenuItem3.position = ccp(180, 200);
        
        CCMenu *levelMenu = [CCMenu menuWithItems:levelMenuItem,levelMenuItem2, levelMenuItem3,nil];
        levelMenu.position = CGPointZero;
        [self addChild:levelMenu];

        
        
        
    
    }
    return self;
}


+(id)nodeGameWinWithLevel:(int) level{

return [[[self alloc] initGameWinWithLevel:level] autorelease];    
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL isTouching;
    // determine if it's a touch you want, then return the result
    return isTouching;
}


- (void)backToLevel:(CCMenuItemImage*)item{
    
    CCDirector *director = [CCDirector sharedDirector];
	CCLayer *layer = [GameLevel nodeWithGameLevel:_theLevel];
    
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	
    [director replaceScene:newScene];   
}

- (void)nextLevel:(CCMenuItemImage*)item{
    
    CCDirector *director = [CCDirector sharedDirector];
	CCLayer *layer = [GameLevel nodeWithGameLevel:_theLevel+1];
    
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	
    [director replaceScene:newScene];
    
}

- (void)levelMenu:(CCMenuItemImage*)item{
    
    CCDirector *director = [CCDirector sharedDirector];
	CCLayer *layer = [LevelMenu node];
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
    
    [director replaceScene:newScene]; 
}


@end
