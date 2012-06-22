//
//  CCMenuLevel.h
//  TTFootball
//
//  Created by Michal Thompson on 6/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCMenuLevel : CCMenu
{

 NSTimeInterval lastTouch;
    CCMenuItem *curSelection;
    NSTimer *touchTimer;
    BOOL del;
}


@end
