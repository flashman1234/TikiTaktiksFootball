//
//  Helper.m
//  PhysicsBox2d
//
//  Created by Steffen Itterheim on 20.09.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "Helper.h"


@implementation Helper


// convenience method to convert a CGPoint to a b2Vec2
+(b2Vec2) toMeters:(CGPoint)point
{
	return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}

// convenience method to convert a b2Vec2 to a CGPoint
+(CGPoint) toPixels:(b2Vec2)vec
{
	return ccpMult(CGPointMake(vec.x, vec.y), PTM_RATIO);
}

+(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

+(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}

+(CGPoint) screenCenter
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	return CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
}

void QuietLog (NSString *format, ...) {
    if (format == nil) {
        printf("nil\n");
        return;
    }
    // Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
    // Perform format string argument substitution, reinstate %% escapes, then print
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    [s release];
    va_end(argList);
}

@end
