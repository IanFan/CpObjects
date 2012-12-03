//
//  OCpButton.h
//  Space
//
//  Created by Fan Tsai Ming on 8/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface OCpButton : NSObject <ChipmunkObject> {
  UIButton *button;
  CCMenu *menu;
  CCMenuItemImage *menuItemImage;
  ChipmunkBody *body;
  NSArray *chipmunkObjects;
  int touchedShapes;
}

@property (readonly) CCMenu *menu;
@property (readonly) UIButton *button;
@property (readonly) NSArray *chipmunkObjects;
@property int touchedShapes;

-(void)updateCCMenuPostion;
-(void)updateUIButtonPostion;

@end
