//
//  LevelMenu.m
//  TikiTakatics
//
//  Created by Michal Thompson on 2/5/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "LevelMenu.h"
#import "GameLevel.h"
#import "DataStore.h"
#import "CCMenuLevel.h"


@implementation LevelMenu

-(id) init{
    
	self = [super init];
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    int xPositioning = 60;
    int yPositioning = 60;
    
    DataStore *dataStore = [[DataStore alloc] autorelease];
    
    NSArray *arr = [dataStore getAllLevels];
    menu = [CCMenuLevel menuWithItems:nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    for (NSDictionary *co in arr) {
        
        NSString *completedString = [co valueForKey:@"Complete"];
        
        BOOL comp = false;
        comp = [completedString boolValue];
        
        NSString *buttonImage = comp ? @"Button2.png" : @"Button1.png";
        
        CCMenuItem *levelMenuItem = [CCMenuItemImage itemFromNormalImage:buttonImage selectedImage:buttonImage];
        
        NSString *num = [co valueForKey:@"LevelId"];
        
        levelMenuItem.tag = [num intValue];
        levelMenuItem.position = ccp(xPositioning, yPositioning);
        [menu addChild:levelMenuItem];
        
        if (xPositioning == 240) {
            xPositioning = 60;
            yPositioning = yPositioning + 60;
        }
        else {
            xPositioning = xPositioning + 60;
        }
        
    }
    
    CCMenuItem *starMenuItem = [CCMenuItemImage 
								itemFromNormalImage:@"Button1.png" selectedImage:@"Button1.png" 
								target:self selector:@selector(onLevelCreator:)];
    starMenuItem.position = ccp(260, 420);
    starMenuItem.tag = 0; //dev screen
    
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];

	return self;
}

- (void)onLevelCreator:(CCMenuItemImage*)item{
    
    CCDirector *director = [CCDirector sharedDirector];
    CCLayer *layer = [GameLevel nodeWithGameLevel:item.tag];
    
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    
    [director replaceScene:newScene];
}



+(id) scene
{
	CCScene *scene = [CCScene node];
	LevelMenu *layer = [LevelMenu node];
	[scene addChild: layer];
	return scene;
}

-(void)dealloc
{
    [super dealloc];
     
}

@end
