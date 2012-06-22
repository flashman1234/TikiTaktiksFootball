//
//  HUD.m
//  TTFootball
//
//  Created by Michal Thompson on 6/7/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "HUDLayer.h"
#import "GameMenu.h"


@implementation HUDLayer

- (id)initWithLevelId:(int)levelId{
    
    if ((self = [super init])) {
            CCMenuItem *starMenuItem = [CCMenuItemImage 
        								itemFromNormalImage:@"PausePlay.png" selectedImage:@"PausePlay.png" 
        								target:self selector:@selector(pauseGameAndShowmenu:)];
            starMenuItem.position = ccp(50, 50);
            starMenuItem.tag = levelId;
            
            CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];    
    }
    return self;
}

+ (id) HUDDisplay:(int)levelId;
{
	return [[[self alloc] initWithLevelId:levelId] autorelease];
}


-(void)pauseGameAndShowmenu:(CCMenuItemImage*)item
{
    [[CCDirector sharedDirector] pause];
    
    GameMenu *gm =  [GameMenu GameMenuDisplay:item.tag];
    [self addChild:gm z:2]; 
}


-(void)dealloc
{
	[super dealloc];
}


@end
