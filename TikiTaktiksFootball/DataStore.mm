//
//  DataStore.m
//  TTFootball
//
//  Created by Michal Thompson on 6/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "DataStore.h"
#import "SQLiteManager.h"

@implementation DataStore

-(SQLiteManager*)dataManager
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *targetPath = [libraryPath stringByAppendingPathComponent:@"TTFootball.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        // database doesn't exist in your library path... copy it from the bundle
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"TTFootball" ofType:@"sqlite"];
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
    
    SQLiteManager *manager = [[SQLiteManager alloc] initWithDatabaseNamed:targetPath];
    
    return manager;
}


-(NSArray *) getAllLevels
{
    NSArray *levelArray = [[NSArray alloc] init];
    
    SQLiteManager *manager = [self dataManager];
    
    NSError *error = manager.openDatabase;
    
    if (!error) {
        
        NSString* sqlQuery = [NSString stringWithFormat:@"SELECT DISTINCT l.levelid, COALESCE(lc.Complete, 'FALSE') AS 'Complete' FROM Level l LEFT JOIN LevelCompleted lc ON l.LevelId = lc.LevelId"];
        
        levelArray = [manager getRowsForQuery:sqlQuery];
    }
    
    error = manager.closeDatabase;
    return levelArray;
}



-(void)setLevelComplete:(int)levelId
{
    SQLiteManager *manager = [self dataManager];
    
    NSError *error = manager.openDatabase;
    
    if (!error) {
                
        NSString* removeCurrentCompletedEntriesQuery = [NSString stringWithFormat:@"DELETE FROM LevelCompleted WHERE levelid =%d", levelId];
        
        error = [manager doQuery:removeCurrentCompletedEntriesQuery];
        
              
        NSString* insertCompletedEntriesQuery = [NSString stringWithFormat:@"INSERT INTO LevelCompleted (LevelId, Complete) VALUES('%d','TRUE')", levelId];
        
        error = [manager doQuery:insertCompletedEntriesQuery];
         NSLog(@"%@", error);
          }
    
    if (error) {
        NSLog(@"%@", error);
    }
}



-(NSMutableArray *) getLevel:(int)levelId
{
    NSMutableArray *levelArray = [[NSMutableArray alloc] init];
    
    SQLiteManager *manager = [self dataManager];
    
    NSError *error = manager.openDatabase;
    
    if (!error) {

        NSString* sqlQuery = [NSString stringWithFormat:@"SELECT levelid, SpriteType, Coordinates FROM Level WHERE levelid = %d ORDER BY levelid", levelId];
        
        levelArray = [[manager getRowsForQuery:sqlQuery] mutableCopy];
    }
    
    error = manager.closeDatabase;
    return levelArray;     
}

-(int)getMaxCurrentLevel
{
    SQLiteManager *manager = [self dataManager];
    
    NSError *error = manager.openDatabase;

    NSNumber *maxLevel = 0;
    
    
    if (!error) {

        NSString* sqlQuery = @"SELECT COALESCE(MAX (levelid), 0) AS 'levelid' FROM Level";
        
        NSArray *levelArray = [manager getRowsForQuery:sqlQuery];
        
        for (NSDictionary *co in levelArray) {
            
            maxLevel = [co valueForKey:@"levelid"];
        }
                
    }
    int intMaxLevel = [maxLevel intValue] + 1;
    return intMaxLevel;
}




-(void)updatePositions:(int)levelId spritePositions:(NSArray *)spritePositions
{ 
    SQLiteManager *manager = [self dataManager];    
    NSError *error = manager.openDatabase;
    
    if (!error) {

        if (levelId == 0) {
            levelId =[self getMaxCurrentLevel];
        }

        
        NSString* removeCurrentEntriesQuery = [NSString stringWithFormat:@"DELETE FROM Level WHERE levelid =%d", levelId];

        [manager doQuery:removeCurrentEntriesQuery];
        
        for (NSDictionary *co in spritePositions) {
        
            NSString *value = (NSString *)[co valueForKey:@"SpriteType"];
            
            NSString *spritePosition = (NSString *)[co valueForKey:@"Coordinates"];

            NSString* insertQuery = [NSString stringWithFormat:@"INSERT INTO level(levelId, SpriteType, Coordinates) VALUES (%d, '%@', '%@')", levelId, value, spritePosition];
                
            [manager doQuery:insertQuery];
        }
    }
}


-(void)deleteLevel:(int)levelId
{
    SQLiteManager *manager = [self dataManager];
    
    NSError *error = manager.openDatabase;
    
    if (!error) {
        NSString* removeCurrentEntriesQuery = [NSString stringWithFormat:@"DELETE FROM Level WHERE levelid =%d", levelId];
        [manager doQuery:removeCurrentEntriesQuery];
    }
    
}




@end
