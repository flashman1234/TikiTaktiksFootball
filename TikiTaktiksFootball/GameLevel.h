//
//  GameLevel.h
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "HUDLayer.h"
#import "MyContactListener.h"


@interface GameLevel : CCLayer {
    
    b2World* world;
    GLESDebugDraw* debugDraw;
    CCDirector *sharedDirector;
    
    @public int _theLevel;
    
    NSMutableArray* playerNodeArray;
    CGPoint ballStartPos;
    
    MyContactListener *_contactListener;
    
    b2Body* containerBody;
    
    b2Body* selectededBody;
    
    CCTimer* buttonTime;
    
    NSTimeInterval lastTouch;
    
    CCSprite *redArrow;
    CCSprite * selSprite;
    
    CCSprite* nearestPlayer;

}


-(void) initBox2dWorld;
-(void) enableBox2dDebugDrawing;
+(id)nodeWithGameLevel:(int) level;
-(void)resetPositions;
-(void)savePositions;



@end
