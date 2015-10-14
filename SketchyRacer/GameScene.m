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
@property CGMutablePathRef pathToDraw;
@property (nonatomic) SKShapeNode* selectorLine;

@end

@implementation GameScene

static const uint32_t carCategory     =  0x1 << 0;
static const uint32_t groundCategory        =  0x1 << 1;

- (id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blueColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
        
        //create Physics for collisions
        self.physicsWorld.contactDelegate = self;

    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    BackgroundSprite *background = [BackgroundSprite spriteNodeWithImageNamed:@"LinedPaper"];
    background.size = self.frame.size;
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    if (!self.carSprite) {
        self.carSprite = [CarSpriteNode spriteNodeWithImageNamed:@"Car1"];
        self.carSprite.position = CGPointMake(100, 600);
        self.carSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.carSprite.size];
        self.carSprite.physicsBody.dynamic = YES;
        self.carSprite.physicsBody.affectedByGravity = YES;
        self.carSprite.physicsBody.categoryBitMask = carCategory;
        self.carSprite.physicsBody.collisionBitMask = groundCategory;
        self.carSprite.physicsBody.usesPreciseCollisionDetection = YES;
        self.carSprite.physicsBody.mass = 1000;
        self.carSprite.name = @"car";
        [self addChild:self.carSprite];
        
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    
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
    self.selectorLine.path = self.pathToDraw;
    self.selectorLine.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:self.pathToDraw];
    self.selectorLine.physicsBody.restitution = 0.01f;
    self.selectorLine.physicsBody.dynamic = NO;
    self.selectorLine.physicsBody.usesPreciseCollisionDetection = YES;
    self.selectorLine.physicsBody.categoryBitMask = groundCategory;
    self.selectorLine.physicsBody.collisionBitMask = carCategory;
    self.selectorLine.physicsBody.mass = 100;
    self.selectorLine.zPosition = 1;
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

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

@end
