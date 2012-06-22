//
//  GameOver.h
//  TTFootball
//
//  Created by Michal Thompson on 6/12/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOver : CCLayer {
    int _theLevel;
    
}

+(id)nodeGameOverWithLevel:(int) level;

@end
