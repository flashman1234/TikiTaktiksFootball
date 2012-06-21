//
//  AppDelegate.h
//  TikiTaktiksFootball
//
//  Created by Michal Thompson on 6/21/12.
//  Copyright NA 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
