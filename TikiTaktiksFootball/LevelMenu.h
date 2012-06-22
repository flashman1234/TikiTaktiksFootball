//
//  LevelMenu.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CCMenuLevel.h"

@interface LevelMenu : CCLayer {
    
    NSTimeInterval lastTouch;
    CCMenuLevel *menu;
    
}

+(id) scene;


@end
