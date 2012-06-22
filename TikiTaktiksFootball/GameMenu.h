//
//  GameMenu.h
//  TTFootball
//
//  Created by Michal Thompson on 6/11/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLevel.h"

@interface GameMenu : CCLayer {

}

@property (readwrite,retain) GameLevel* gameLevel;

+ (id) GameMenuDisplay:(int)levelId;

@end
