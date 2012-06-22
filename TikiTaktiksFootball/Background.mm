//
//  Background.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "Background.h"


@implementation Background


+(CCSprite*) createBackgroundInWorld
{	
    
    CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"grass.png" 
                                           rect:CGRectMake(0, 0, 320, 480)];
    return backgroundSprite;
}














@end
