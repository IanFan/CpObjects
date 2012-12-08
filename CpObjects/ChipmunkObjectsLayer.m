//
//  ChipmunkObjectsLayer.m
//  BasicCocos2D
//
//  Created by Ian Fan on 25/08/12.
//
//

#import "ChipmunkObjectsLayer.h"
#import "OCpSprite.h"
#import "OCpButton.h"

@implementation ChipmunkObjectsLayer

#define GRABABLE_MASK_BIT (1<<31)
#define NOT_GRABABLE_MASK (~GRABABLE_MASK_BIT)

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	ChipmunkObjectsLayer *layer = [ChipmunkObjectsLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark -
#pragma mark Touch Event

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [_multiGrab beginLocation:point];
  }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [_multiGrab updateLocation:point];
  }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [_multiGrab endLocation:point];
  }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
  [self ccTouchEnded:touch withEvent:event];
}

#pragma mark -
#pragma mark Update

-(void)update:(ccTime)dt {
  [_space step:dt];
  
  for (OCpSprite *cps in self.children) {
    if ([_space contains:cps] == YES) [cps updateCpSprite];
  }
}

#pragma mark -
#pragma mark Chipmunk objects

-(void)setChipmunkObjects {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  //set OCpSprite
  NSUInteger height = 5;
  float dropHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? -80:-210;
  cpFloat boxSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? 50:100;
  cpFloat spacing = boxSize + 2.0;
  
  for(int i=0; i < height; i++){
    for(int j=0; j<=i; j++){
      CGPoint position = cpv((j - i/2.0)*spacing, dropHeight + (height - i - 1)*spacing);
      position = cpvadd(cpv(winSize.width/2, winSize.height/2), position);
      
      OCpSprite *cpSprite = [OCpSprite spriteWithFile:@"square.png"];
      [cpSprite setChipmunkObjectsWithShapeStyle:ShapeStylePoly mass:10 sizeWidth:boxSize sizeHeight:boxSize positionX:position.x positionY:position.y elasticity:0.0 friction:1.0 collisionType:@"spriteType"];
      [_space add:cpSprite];
      [self addChild:cpSprite];
    }
  }
}

#pragma mark -
#pragma mark Chipmunk DebugLayer

-(void)setChipmunkDebugLayer {
  _debugLayer = [[CPDebugLayer alloc]initWithSpace:_space.space options:nil];
  [self addChild:_debugLayer z:999];
}

#pragma mark -
#pragma mark ChipmunkMultiGrab

-(void)setChipmunkMultiGrab {
  //set chipmunkMultiGrab
  //1. add [glView setMultipleTouchEnabled:YES]; in AppDelegate.m
  //2. add self.isTouchEnabled = YES in this scene
  cpFloat grabForce = 1e5;
  cpFloat smoothing = cpfpow(0.3,60);
  
  _multiGrab = [[ChipmunkMultiGrab alloc]initForSpace:_space withSmoothing:smoothing withGrabForce:grabForce];
  _multiGrab.layers = GRABABLE_MASK_BIT;
  _multiGrab.grabFriction = grabForce*0.1;
  _multiGrab.grabRotaryFriction = 1e3;
  _multiGrab.grabRadius = 20.0;
  _multiGrab.pushMass = 1.0;
  _multiGrab.pushFriction = 0.7;
  _multiGrab.pushMode = FALSE;
}

#pragma mark -
#pragma mark ChipmunkSpace

-(void)setChipmunkSpace {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  _space = [[ChipmunkSpace alloc]init];
  [_space addBounds:CGRectMake(0, 0, winSize.width, winSize.height) thickness:60 elasticity:1.0 friction:1.0 layers:NOT_GRABABLE_MASK group:nil collisionType:nil];
  _space.gravity = cpv(0, -300);
  _space.iterations = 30;
  _space.sleepTimeThreshold = 0.5f;
  _space.collisionSlop = 0.5f;
}

#pragma mark -
#pragma mark Init

/*
 Target: Set Chipmunk objects with OcpSprite.
 
 1. set ChipmunkSpace, ChipmunkMultiGrab and updateStep as usual.
 2. set Chipmunk objects with OcpSprite.
 */

-(id) init {
	if((self = [super init])) {
    
    [self setChipmunkSpace];
    
    [self setChipmunkMultiGrab];
    
//    [self setChipmunkDebugLayer];
    
    [self setChipmunkObjects];
    
    [self schedule:@selector(update:)];
    
    self.isTouchEnabled = YES;
	}
	return self;
}

- (void) dealloc {
  [_space release];
//  [_debugLayer release];
  
	[super dealloc];
}

@end
