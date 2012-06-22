//
//  GameOver.m
//  TTFootball
//
//  Created by Michal Thompson on 6/12/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "GameOver.h"


@implementation GameOver

-(id) initGameOverWithLevel:(int)levelId
{
	if ((self = [super init]))
	{         
             
        _theLevel = levelId;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You lose level: %d", _theLevel] fontName:@"Arial" fontSize:16];
        [self addChild: label];
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        [label setPosition: CGPointMake(30, s.height-20)];
        
    }
    return self;
}


+(id)nodeGameOverWithLevel:(int) level{
    
    return [[[self alloc] initGameOverWithLevel:level] autorelease];    
}









@end
