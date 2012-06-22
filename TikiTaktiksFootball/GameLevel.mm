//
//  GameLevel.m
//  TTFootball
//
//  Created by Michal Thompson on 4/6/12.
//  Copyright 2012 NA. All rights reserved.
//

#import "GameLevel.h"
#import "Background.h"
#import "Ball.h"
#import "Constants.h"
#import "Helper.h"
#import "Player.h"
#import "Opposition.h"
#import "Goal.h"
#import "LevelConfig.h"
#import "HUDLayer.h"
#import "GameOver.h"
#import "GameWin.h"
#import "DataStore.h"
#import "LevelMenu.h"

#define KGameLayer 1
#define KHudLayer 2


@implementation GameLevel

#pragma mark init and dealloc

-(id) initWithGameLevel:(int)levelId
{
	if ((self = [super init]))
	{         
        playerNodeArray = [[NSMutableArray alloc] initWithObjects:nil];

        _theLevel = levelId;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

        [self initBox2dWorld];
        [self enableBox2dDebugDrawing];
        
        if (_theLevel == 0) {
            [self addAddNodeMenu];
        }
        
        [self loadBodyNodes];
        
        _contactListener = new MyContactListener();
		world->SetContactListener(_contactListener);
        
        [self scheduleUpdate];
        
    }
    
    
    if ([[CCDirector sharedDirector] isPaused]) {
        [[CCDirector sharedDirector] resume];
    }
    
    return self;
}


+(id)nodeWithGameLevel:(int) level{
    
    return [[[self alloc] initWithGameLevel:level] autorelease];    
}

-(void)loadBodyNodes
{
    // load all body nodes - player, opposition etc
    LevelConfig* cfg = [LevelConfig configWithWorld:world node:self];

    [cfg loadLevel:_theLevel];
    
    //insert players into an array
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {

			BodyNode *node = (BodyNode *)b->GetUserData();
            
            if (node.sprite.tag == kPlayerNodeTag) {
                
                [playerNodeArray addObject:node];
            }
            
            if (node.sprite.tag == kBallNodeTag) {
                
                ballStartPos = CGPointMake(node.sprite.position.x, node.sprite.position.y);
            }
        }
    }

    [self addHUD];
    [self addArrow];
    
}

-(void)addArrow
{
    if (redArrow) {
        [redArrow removeFromParentAndCleanup:YES];
    }
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    redArrow = [[CCSprite spriteWithFile:@"red-up-arrow.png"] retain];
    redArrow.position = ccp(screenSize.width/2, 60);
    redArrow.anchorPoint = ccp(0.5,0);
    [self addChild:redArrow z:-1];
}


-(void) addHUD
{
    HUDLayer *hud =  [HUDLayer HUDDisplay:_theLevel];
    [self addChild:hud z:1];
}


-(void)addAddNodeMenu
{
    CCMenuItem *starMenuItem = [CCMenuItemImage 
								itemFromNormalImage:@"Button1.png" selectedImage:@"Button1.png" 
								target:self selector:@selector(addNewBodyNode:)];
    starMenuItem.position = ccp(260, 420);
    starMenuItem.tag = kPlayerNodeTag;
    CCMenuItem *starMenuItem2 = [CCMenuItemImage 
								itemFromNormalImage:@"Button1.png" selectedImage:@"Button1.png" 
								target:self selector:@selector(addNewBodyNode:)];
    starMenuItem2.position = ccp(260, 360);
    starMenuItem2.tag = kOppositionNodeTag;
    
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem,starMenuItem2, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
    
}

-(void)addNewBodyNode:(CCMenuItemImage*)item
{
    LevelConfig* cfg = [LevelConfig configWithWorld:world node:self];
    
    if (item.tag == kPlayerNodeTag) {
        [cfg addPlayerAt:CGPointMake(100, 100)];
    }
    
    if (item.tag == kOppositionNodeTag) {
        [cfg addOppositionAt:CGPointMake(200, 200)];
    }
    
    [playerNodeArray removeAllObjects];
    
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
            
			BodyNode *node = (BodyNode *)b->GetUserData();
            
            if (node.sprite.tag == kPlayerNodeTag) {
                
                [playerNodeArray addObject:node];
            }
            
        }
    }
    
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete debugDraw;
	debugDraw = NULL;
    
    [redArrow release];
    redArrow = nil;

	_contactListener = NULL;
	delete _contactListener;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


#pragma mark ccTouch

- (BOOL)ccTouchBegan:(UITouch *)myTouch withEvent:(UIEvent *)event 
{ 
    
    if (![[CCDirector sharedDirector] isPaused]) {
        CGPoint touchLocation = [self convertTouchToNodeSpace:myTouch];
        [self selectBodyForTouch:touchLocation];      
        
        if (!selectededBody) 
        {
            [self selectSpriteForTouch:touchLocation]; 
        }
        
        lastTouch = [event timestamp];
    }
    
    
    
    
    return TRUE;    
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{   
    if (selectededBody) 
    {
        if (_theLevel == 0) {
            NSTimeInterval touchBeginEndInterval = [event timestamp] - lastTouch;
            
            if (touchBeginEndInterval > kbuttonPressLength) 
            {
                CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
                [self moveBody:touchLocation];
            }
        }
    }
    else if (selSprite) 
    {
        CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
        [self rotateArrow:touchLocation];
    } 
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    NSTimeInterval touchBeginEndInterval = [event timestamp] - lastTouch;
    
    // if the sprite is a bodynode
    if (selectededBody) {
        
        if (touchBeginEndInterval < kbuttonPressLength) {
            BodyNode* actorA = (BodyNode*) selectededBody->GetUserData();
            
            if([actorA isKindOfClass:[Ball class]])
            {               
                CGPoint ball = actorA.sprite.position;
                CGPoint player = CGPointMake(nearestPlayer.position.x, nearestPlayer.position.y);
                
                b2Vec2 vect;
                if (player.x == 0.0 and player.y == 0.0) {
                     vect = b2Vec2(0, 2);
                }
                else {
                     vect = b2Vec2(player.x/PTM_RATIO - ball.x/PTM_RATIO, player.y/PTM_RATIO - ball.y/PTM_RATIO);
                    
                    while (vect.x > 4 or vect.y > 4) {
                        vect.x = vect.x * 0.75;
                        vect.y = vect.y * 0.75;
                    }
                }

                selectededBody->ApplyLinearImpulse( vect, selectededBody->GetPosition() );
                ballStartPos = CGPointMake(NAN, NAN);
                
                if (selSprite) {
                    [selSprite removeFromParentAndCleanup:YES];
                }
                else if(redArrow){
                    [redArrow removeFromParentAndCleanup:YES];
                }
            }
            
            if([actorA isKindOfClass:[Player class]])
            {               
                float angle = selectededBody->GetAngle() - 90.0;
                b2Vec2 pos = selectededBody->GetPosition();
                selectededBody->SetTransform(pos, angle);
                
            } 
        }
        
        selectededBody = nil;
    }
}

#pragma mark select sprite/body for touch

- (void)selectBodyForTouch:(CGPoint)touchLocation { 
    
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) 
    {
        b2Fixture *bf1 = b->GetFixtureList();
        if (bf1->TestPoint(locationWorld))
        {
            selectededBody = b;
            break;
        }
    }
}


- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    
        if (CGRectContainsPoint(redArrow.boundingBox, touchLocation)) {            
            newSprite = redArrow;
        }
        
    if (newSprite != selSprite) {
      
        selSprite = newSprite;
    }
}


#pragma mark move body or sprite

-(void)moveBody:(CGPoint)translation
{
   // if (_theLevel == 0) {
        if (selectededBody) {
            
            selectededBody->SetTransform(b2Vec2(translation.x/PTM_RATIO, translation.y/PTM_RATIO), selectededBody->GetAngle());
            
            BodyNode* actorA = (BodyNode*) selectededBody->GetUserData();
            
            if([actorA isKindOfClass:[Ball class]])
            {     
                ballStartPos = CGPointMake(actorA.sprite.position.x, actorA.sprite.position.y);
            }
        }
    //}
}


-(void)moveSprite:(CGPoint)translation
{
    //if (_theLevel == 0) {
        if (selectededBody) {
            
            selectededBody->SetTransform(b2Vec2(translation.x/PTM_RATIO, translation.y/PTM_RATIO), selectededBody->GetAngle());
            
            BodyNode* actorA = (BodyNode*) selectededBody->GetUserData();
            
            if([actorA isKindOfClass:[Ball class]])
            {     
                ballStartPos = CGPointMake(actorA.sprite.position.x, actorA.sprite.position.y);
            }
        }
    //}
}


- (void)rotateArrow:(CGPoint)touchLocation {    
    if (selSprite) {
        
        float angleTouchAndArrowInRadians = atan2f((touchLocation.y - selSprite.position.y) , (touchLocation.x - selSprite.position.x));
        
        float angleTouchAndArrowInDegrees = CC_RADIANS_TO_DEGREES(angleTouchAndArrowInRadians);
        float cocosTouchAngle = -1 * angleTouchAndArrowInDegrees;
        
        int lowestDiff = 200;
        
        for(int i = 0; i < [playerNodeArray count]; i++)
        {
            BodyNode *node = [playerNodeArray objectAtIndex:i] ; 
            CGPoint playerPosition = node.sprite.position;
        
            float anglePlayerAndArrowInRadians = atan2f((playerPosition.y - selSprite.position.y) , (playerPosition.x - selSprite.position.x));
            float anglePlayerAndArrowInDegrees = CC_RADIANS_TO_DEGREES(anglePlayerAndArrowInRadians);
            float cocosPlayerAngle = -1 * anglePlayerAndArrowInDegrees;

            int diff = std::abs((int)cocosTouchAngle - (int)cocosPlayerAngle);
            if (diff < lowestDiff) {
                nearestPlayer = node.sprite;
                lowestDiff = diff;
            }
        }

        float angleFinalInRadians = atan2f((nearestPlayer.position.y - selSprite.position.y) , (nearestPlayer.position.x - selSprite.position.x));
        
        float angleFinalDegrees = CC_RADIANS_TO_DEGREES(angleFinalInRadians);
        float cocosFinalAngle = -1 * angleFinalDegrees;
        
        redArrow.rotation = cocosFinalAngle + 90.0;
       
       }
}


#pragma mark win/lose/reset

-(void)goToWinScreen
{
    if (_theLevel != 0) {
        
        [self setLevelComplete];
        
        CCDirector *director = [CCDirector sharedDirector];
        CCLayer *layer = [GameWin nodeGameWinWithLevel:_theLevel];
        
        CCScene *newScene = [CCScene node];
        [newScene addChild: layer];
        
        [director replaceScene:newScene];

    }
    
}

-(void)setLevelComplete
{
    if (_theLevel != 0) {
        DataStore *dataStore = [DataStore alloc];
        
        [dataStore setLevelComplete:_theLevel]; 
    }
}



-(void)goToLoseScreen
{
    if (_theLevel != 0) {
        CCDirector *director = [CCDirector sharedDirector];
        CCLayer *layer = [GameOver nodeGameOverWithLevel:_theLevel];
        
        CCScene *newScene = [CCScene node];
        [newScene addChild: layer];
        
        [director replaceScene:newScene];
    }
}


-(void)resetPositions
{
    [self addArrow];
    
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
            
			BodyNode *node = (BodyNode *)b->GetUserData();

            if (node.sprite.tag == kBallNodeTag) {
                
                b->SetLinearVelocity(b2Vec2(0,0));
                b->SetAngularVelocity(0);
                
                CGSize screenSize = [[CCDirector sharedDirector] winSize];
                CGPoint startPos = CGPointMake(screenSize.width/2, 50);
                
                b->SetTransform([Helper toMeters:startPos], 0);
           
                ballStartPos = CGPointMake(node.sprite.position.x, node.sprite.position.y);
                nearestPlayer = nil;
            }
        }
    }
}




-(void)savePositions
{
    if (_theLevel == 0) {
    
        NSMutableArray *spritePositions = [[NSMutableArray alloc]initWithCapacity:10];
        
        for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
            if (b->GetUserData() != NULL) {
                
                BodyNode *node = (BodyNode *)b->GetUserData();
                
                if (node.sprite.tag == kPlayerNodeTag) {
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:1];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"levelId"];  
                    [dict setObject:@"Player" forKey:@"SpriteType"];
                    [dict setObject:NSStringFromCGPoint(node.sprite.position) forKey:@"Coordinates"];
                    
                    [spritePositions addObject:dict];
                }
                
                if (node.sprite.tag == kOppositionNodeTag) {
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:1];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"levelId"];  
                    [dict setObject:@"Opposition" forKey:@"SpriteType"];
                    [dict setObject:NSStringFromCGPoint(node.sprite.position) forKey:@"Coordinates"];
                    
                    [spritePositions addObject:dict];
                }
            }
        }
        
        DataStore *dataStore = [DataStore alloc];
        
        [dataStore updatePositions:_theLevel spritePositions:spritePositions];
        
        CCDirector *director = [CCDirector sharedDirector];
        CCLayer *layer = [LevelMenu node];
        //[SceneManager go: layer];
        CCScene *newScene = [CCScene node];
        [newScene addChild: layer];
        
        [director replaceScene:newScene];  
    }

}



#pragma mark box2d, tick, update etc

- (void)tick:(ccTime) dt {
	
	for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
		if (b->GetUserData() != NULL) {
			
			CCSprite *sprite = (CCSprite *)b->GetUserData();
			
			b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
									   sprite.position.y/PTM_RATIO);
			float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
			
			b->SetTransform(b2Position, b2Angle);
		}
	}
}

- (void) enableBox2dDebugDrawing {
	// Debug Draw functions
	debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags |= b2DebugDraw::e_shapeBit;
	flags |= b2DebugDraw::e_jointBit;
	flags |= b2DebugDraw::e_aabbBit;
	flags |= b2DebugDraw::e_pairBit;
	flags |= b2DebugDraw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);		
}

- (void)draw {
	
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    //world->DrawDebugData();  // comment this out to get rid of Box2D debug drawing
	
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

- (void) initBox2dWorld {
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, -0.0f);
	bool allowBodiesToSleep = true;
	world = new b2World(gravity, allowBodiesToSleep);
	
	// Define the static container body, which will provide the collisions at screen borders.
	b2BodyDef containerBodyDef;
	containerBody = world->CreateBody(&containerBodyDef);
	
	// for the ground body we'll need these values
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	float widthInMeters = screenSize.width / PTM_RATIO;
	float heightInMeters = screenSize.height / PTM_RATIO;
	b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
	b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
	b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
	b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
	
	// Create the screen box' sides by using a polygon assigning each side individually.
	b2PolygonShape screenBoxShape;
	int density = 0;
	
	//left side
	screenBoxShape.SetAsEdge(upperLeftCorner, lowerLeftCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	//top side
	screenBoxShape.SetAsEdge(upperLeftCorner, upperRightCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	// right side
	screenBoxShape.SetAsEdge(upperRightCorner, lowerRightCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
	
	// bottom side
	screenBoxShape.SetAsEdge(lowerRightCorner, lowerLeftCorner);
	containerBody->CreateFixture(&screenBoxShape, density);
}

- (void) update:(ccTime)delta {
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		BodyNode* bodyNode = (BodyNode*)body->GetUserData();
		
        if (bodyNode != NULL && bodyNode.sprite != nil)
		{
            // update the sprite's position to where their physics bodies are
            bodyNode.sprite.position = [Helper toPixels:body->GetPosition()];
            float angle = body->GetAngle();
            bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));      
        }	
	}
    
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); 
        pos != _contactListener->_contacts.end(); ++pos) 
    {
        MyContact contact = *pos;
        
        BodyNode* actorA = (BodyNode*) contact.fixtureA->GetBody()->GetUserData();
        BodyNode* actorB = (BodyNode*) contact.fixtureB->GetBody()->GetUserData();
        
        
        if (actorA.sprite.tag == kBallNodeTag && actorB.sprite.tag == kOppositionNodeTag) {
            
            //[self goToLoseScreen];
            [self resetPositions];
        }
        
        else if (actorA.sprite.tag == kOppositionNodeTag && actorB.sprite.tag == kBallNodeTag) {
            
            [self resetPositions];
            //[self goToLoseScreen];
        }    
        
        else if (actorA.sprite.tag == kBallNodeTag && actorB.sprite.tag == kGoalNodetag) {                   
            
            [self goToWinScreen];
        }   
        
        else if (actorA.sprite.tag == kGoalNodetag && actorB.sprite.tag == kBallNodeTag) {
            
            [self goToWinScreen];
        }   
    } 
}








@end
