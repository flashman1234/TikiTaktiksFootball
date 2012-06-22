//
//  CCMenuLevel.m
//  TTFootball
//
// Overrides CCMenu to allow for long touch of a menu item
//
//  Created by Michal Thompson on 6/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "CCMenuLevel.h"
#import "Constants.h"
#import "GameLevel.h"
#import "DataStore.h"
#import "LevelMenu.h"
#import <mach/mach.h>
#import <mach/mach_time.h>

@implementation CCMenuLevel


- (NSTimeInterval)gettimestamp
{
    // get the timebase info -- different on phone and OSX
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // get the time
    uint64_t absTime = mach_absolute_time();
    
    // apply the timebase info
    absTime *= info.numer;
    absTime /= info.denom;
    
    // convert nanoseconds into seconds and return
    return (NSTimeInterval) ((double) absTime / 1000000000.0);
}


#pragma mark ccTouch

- (BOOL)ccTouchBegan:(UITouch *)myTouch withEvent:(UIEvent *)event 
{ 
    lastTouch = [event timestamp];
   
    curSelection = [self itemForTouch:myTouch];

    //touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(touchHasBeenHeld) userInfo:nil repeats:YES];
    
    del = true;

    return TRUE;    
}


-(void)touchHasBeenHeld
{
    NSTimeInterval touchBeginEndInterval = [self gettimestamp] - lastTouch;
    
    if (touchBeginEndInterval > kdeleteLevelButtonPressLength)
    {
        if (del) {
             NSLog(@"do fadeout now");
            
            
//            
//            
//            CCFadeOut *fadeToAlpha = [CCFadeOut actionWithDuration:0.5];
//            id Seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.5],fadeToAlpha,nil];
//            CCMenuItemImage *image = (CCMenuItemImage *)curSelection;
//            [image runAction:Seq];
//            
            
//            CCFadeOut *fadeToAlpha = [CCFadeOut actionWithDuration:0.5];
//            CCSequence *seq = [CCSequence actions:[CCRotateTo actionWithDuration:0.9 angle:4.8], [CCRotateTo actionWithDuration:0.9 angle:-4.8], nil];
//            seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.1],fadeToAlpha,nil];
//            CCMenuItemSprite *image = (CCMenuItemSprite *)curSelection;
//            [image runAction:[CCRepeatForever actionWithAction:seq]];
//            
//            id skewX = [CCSkewBy actionWithDuration:2 skewX:45 skewY:0];
//			id skewX_back = [skewX reverse];
//			id skewY = [CCSkewBy actionWithDuration:2 skewX:0 skewY:45];
//			id skewY_back = [skewY reverse];
//            
//            id seq_skew = [CCSequence actions:skewX, skewX_back, skewY, skewY_back, nil];
//            
//            CCMenuItemSprite *image = (CCMenuItemSprite *)curSelection;
//            [image runAction:[CCRepeatForever actionWithAction:seq_skew]];
//            
//            [curSelection setSkewY:17.7f];
//            [curSelection skewY];
            
            del = false;
           
        }
       
        


    }
}



-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    
    if ([touchTimer isValid]) [touchTimer invalidate];

    NSTimeInterval touchBeginEndInterval = [event timestamp] - lastTouch;
    
    if (touchBeginEndInterval < kdeleteLevelButtonPressLength) {
        
        if (curSelection) {
            CCDirector *director = [CCDirector sharedDirector];
            CCLayer *layer = [GameLevel nodeWithGameLevel:curSelection.tag];
            
            CCScene *newScene = [CCScene node];
            [newScene addChild: layer];
            
            [director replaceScene:newScene];
        }
        
    }
    else {
        [self deleteAndReload];
//        NSLog(@"%@", curSelection);
//        CCFadeOut *fadeToAlpha = [CCFadeOut actionWithDuration:0.5];
//        id Seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.5],fadeToAlpha,nil];
//        CCMenuItemImage *image = (CCMenuItemImage *)curSelection;
//        [image runAction:Seq];
//        NSLog(@"ranaction");
//        
//        double time = 1.0;
//        id delay = [CCDelayTime actionWithDuration: time];
//        id callbackAction = [CCCallFunc actionWithTarget: self selector: @selector(deleteAndReload)];
//        id sequence = [CCSequence actions: delay, callbackAction, nil];
//        [self runAction: sequence];
//        
//        NSLog(@"ransequence");
        
        
           }
}

-(void)deleteAndReload
{
    DataStore *dataStore = [[DataStore alloc] autorelease];
    [dataStore deleteLevel:curSelection.tag]; 
    
    //reload level menu
    CCDirector *director = [CCDirector sharedDirector];
    CCLayer *layer = [LevelMenu node];
    //[SceneManager go: layer];
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    
    [director replaceScene:newScene];

    
}


-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
			
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{   
}



@end
