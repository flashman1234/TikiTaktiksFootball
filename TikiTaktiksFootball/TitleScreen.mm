//
//  TitleScreen.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "TitleScreen.h"
#import "LevelMenu.h"


@implementation TitleScreen

-(id) init{
	self = [super init];
    
    CCMenuItem *starMenuItem = [CCMenuItemImage 
								itemFromNormalImage:@"playGameButton.png" selectedImage:@"playGameButton.png" 
								target:self selector:@selector(start:)];
    starMenuItem.position = ccp(160, 160);
    
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
    
    return self;
}

-(void)start:(id)sender{
    
    CCDirector *director = [CCDirector sharedDirector];
	CCLayer *layer = [LevelMenu node];
	//[SceneManager go: layer];
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];

    [director replaceScene:newScene];
}

+(id) scene
{
	CCScene *scene = [CCScene node];
	TitleScreen *layer = [TitleScreen node];
	[scene addChild: layer];
	return scene;
}

@end
