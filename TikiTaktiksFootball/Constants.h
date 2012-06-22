/*
 *  Constants.h
 *  PhysicsBox2d
 *
 *  Created by Steffen Itterheim on 20.09.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32


#define kPlayerNodeTag 1
#define kBallNodeTag 2
#define kOppositionNodeTag 3
#define kGoalNodetag 4
#define kKickOffArrowTag 5

#define kbuttonPressLength 0.25
#define kdeleteLevelButtonPressLength 1

