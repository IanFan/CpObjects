//
//  OCpButton.m
//  Space
//
//  Created by Fan Tsai Ming on 8/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OCpButton.h"

@implementation OCpButton

#define SIZE 100.0f 

@synthesize menu;
@synthesize button;
@synthesize chipmunkObjects;
@synthesize touchedShapes;

-(void)dealloc
{
  [button release],button=nil;
  [body release],body=nil;
  [chipmunkObjects release],chipmunkObjects=nil;
  
  [super dealloc];
}

-(id)init
{
  if (self = [super init]) {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"ball.png"] forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, SIZE, SIZE);
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    menuItemImage = [CCMenuItemImage itemWithNormalImage:@"ball.png" selectedImage:@"ball.png" target:self selector:@selector(menuTapped:)];
    menuItemImage.position = ccp(screenSize.width/2, screenSize.height/2);
    menu = [CCMenu menuWithItems:menuItemImage, nil];
    menu.position = ccp(0, 0);
    
    cpFloat mass = 1.0f;
    cpFloat moment = cpMomentForCircle(mass, SIZE, SIZE, cpv(0.0f, 0.0f));
//    cpFloat moment = cpMomentForBox(mass, SIZE, SIZE);
    
    body = [[ChipmunkBody alloc]initWithMass:mass andMoment:moment];
    [body setPos:cpv(screenSize.width/2, screenSize.height/2)];
    
    ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:(0.5*SIZE) offset:CGPointMake(0, 0)];
//    ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:SIZE height:SIZE];
    [shape setElasticity:1.0f];
    [shape setFriction:0.0f];
    [shape setCollisionType:[OCpButton class]];
//    [shape setCollisionType:[CCMenu class]];
    [shape setData:self];
    
    chipmunkObjects = [[NSArray alloc]initWithObjects:body,shape, nil];
  }
  
  return self;
}

-(void)updateUIButtonPostion {
  button.transform = body.affineTransform;
}

-(void)updateCCMenuPostion {
  
  menuItemImage.position = body.pos;
  menuItemImage.rotation = CC_RADIANS_TO_DEGREES(body.angle);
}

static cpFloat frand_unit() {return 2.0f*((cpFloat)rand()/(cpFloat)RAND_MAX) - 1.0f;}

-(void)buttonTapped:(UIButton*)sender {
  cpVect v = cpvmult(cpv(frand_unit(), frand_unit()), 500.0f);
  body.vel = cpvadd(body.vel, v);
  body.angVel += 5.0f * frand_unit();
}

-(void)menuTapped:(CCMenuItemImage*)sender {
  cpVect v = cpvmult(cpv(frand_unit(), frand_unit()), 500.0f);
  body.vel = cpvadd(body.vel, v);
  body.angVel += 5.0f * frand_unit();
}

@end
