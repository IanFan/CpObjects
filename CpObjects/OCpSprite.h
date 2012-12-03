//
//  OCpSprite.h
//  BasicCocos2D
//
//  Created by Ian Fan on 13/08/12.
//
//

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

/*
 1. add ChipmunkObject delegate
 2. add "chipmunkObjects" in parent ChipmunkSpace
 3. add update method in parent scene update:
 */

typedef enum {
  ShapeStyleCircle,
  ShapeStylePoly,
} CpShapeStyle;

@interface OCpSprite : CCSprite <ChipmunkObject>
{
  float chipmunkBodyWidth;
  float chipmunkBodyHeight;
}

@property (nonatomic, retain) ChipmunkBody *chipmunkBody;
@property (nonatomic, retain) ChipmunkShape *chipmunkShape;
@property (nonatomic, retain) NSArray *chipmunkObjects;
@property int touchedShapes;

-(void)setChipmunkObjectsWithShapeStyle:(CpShapeStyle)shapeSty mass:(float)mas sizeWidth:(int)sizeW sizeHeight:(int)sizeH positionX:(float)posX positionY:(float)posY elasticity:(float)elas friction:(float)fric collisionType:(NSString*)colliType;
-(void)updateCpSprite;

@end

