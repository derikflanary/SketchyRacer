//
//  GameScene.m
//  SketchyRacer
//
//  Created by Derik Flanary on 10/14/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

#import "GameScene.h"
#import "CarSpriteNode.h"
#import "BackgroundSprite.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) CarSpriteNode *carSprite;
@property (nonatomic, strong) BackgroundSprite *background;
@property CGMutablePathRef pathToDraw;
@property (nonatomic) SKShapeNode *selectorLine;
@property CGPoint touchLocation;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (nonatomic, strong) SKCameraNode* theCamera;
@property (nonatomic, assign) BOOL touched;

@end

@implementation GameScene

static const uint32_t carCategory     =  0x1 << 0;
static const uint32_t groundCategory        =  0x1 << 1;

- (id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blueColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
//        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 50) toPoint:CGPointMake(10000, 50)];
        
        //create Physics for collisions
        self.physicsWorld.contactDelegate = self;
        self.anchorPoint = CGPointMake (0.0,0.0);
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.background = [BackgroundSprite spriteNodeWithImageNamed:@"LinedPaper"];
    self.background.size = self.frame.size;
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.background];
    
    if (!self.carSprite) {
        self.carSprite = [CarSpriteNode spriteNodeWithImageNamed:@"Car1"];
        self.carSprite.position = CGPointMake(-200, 100);
        self.carSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.carSprite.size];
//        self.carSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.carSprite.size.width/2];
        self.carSprite.physicsBody.dynamic = YES;
        self.carSprite.physicsBody.affectedByGravity = YES;
        self.carSprite.physicsBody.categoryBitMask = carCategory;
        self.carSprite.physicsBody.collisionBitMask = groundCategory;
        self.carSprite.physicsBody.usesPreciseCollisionDetection = YES;
        self.carSprite.physicsBody.mass = .02;
        self.carSprite.name = @"car";
        [self.background addChild:self.carSprite];
        
    }
    self.theCamera = [SKCameraNode new];
    self.theCamera.position = CGPointMake(self.carSprite.position.x + 100, self.background.position.y + self.background.frame.size.height);
    [self addChild:self.theCamera];
    self.camera = self.theCamera;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    self.touched = YES;
    
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    self.touchLocation = touchPoint;
    
    self.pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(self.pathToDraw, NULL, touchPoint.x, touchPoint.y);
    
    self.selectorLine = [SKShapeNode shapeNodeWithPath:self.pathToDraw];
    [self addChild:self.selectorLine];
    self.selectorLine.strokeColor = [SKColor darkGrayColor];
    self.selectorLine.lineWidth = 10;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    CGPathAddLineToPoint(self.pathToDraw, NULL, touchPoint.x, touchPoint.y);
    [self drawRoad];
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    NSTimeInterval delta = currentTime - self.previousUpdateTime;
    //3
    if (delta > 0.02) {
        delta = 0.02;
    }
    //4
    self.previousUpdateTime = currentTime;
    
    float rotation = self.carSprite.zRotation;
    CGFloat r = 30;
    
    // Create a vector in the direction the sprite is facing
    CGFloat dx = r * delta * cos (rotation);
    CGFloat dy = r * delta * sin (rotation);
    
    
    // Apply impulse to physics body
    [self.carSprite.physicsBody applyImpulse:CGVectorMake(dx,dy)];
    
    if (self.carSprite.physicsBody.velocity.dx > 1000) {
        self.carSprite.physicsBody.velocity = CGVectorMake(1000, self.carSprite.physicsBody.velocity.dy);
    }
    
//    if (self.touched) {
//        CGPathAddLineToPoint(self.pathToDraw, NULL, self.touchLocation.x, self.touchLocation.y);
//        [self drawRoad];
//    }
    
//    NSLog(@"%f, %f", dx, dy);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.touched = NO;
}

- (void)drawRoad{
    self.selectorLine.path = self.pathToDraw;
    self.selectorLine.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:self.pathToDraw];
    self.selectorLine.physicsBody.restitution = 0.00f;
    self.selectorLine.physicsBody.dynamic = NO;
    self.selectorLine.physicsBody.usesPreciseCollisionDetection = YES;
    self.selectorLine.physicsBody.categoryBitMask = groundCategory;
    self.selectorLine.physicsBody.collisionBitMask = carCategory;
    self.selectorLine.physicsBody.mass = 100;
    self.selectorLine.zPosition = 1;

}

- (void)didSimulatePhysics{

    self.theCamera.position = CGPointMake(self.carSprite.position.x + 400, self.position.y + self.background.frame.size.height/2);
//    [self centerOnNode:[self childNodeWithName:@"camera"]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & groundCategory) != 0)
    {
       
    }
    
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y - cameraPositionInScene.y);
}

@end
