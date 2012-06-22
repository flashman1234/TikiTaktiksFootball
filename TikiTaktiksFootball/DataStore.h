//
//  DataStore.h
//  TTFootball
//
//  Created by Michal Thompson on 6/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
{
}

-(NSMutableArray *) getLevel:(int)levelId;
-(NSArray *) getAllLevels;
-(void)updatePositions:(int)levelId spritePositions:(NSArray*)spritePositions;
-(void)deleteLevel:(int)levelId;
-(void)setLevelComplete:(int)levelId;

@end
