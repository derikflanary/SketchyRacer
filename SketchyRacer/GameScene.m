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
#import "Ground.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) CarSpriteNode *carSprite;
@property (nonatomic, strong) Ground *ground;

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
//        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        

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
        self.carSprite.position = CGPointMake(100, 400);
        self.carSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.carSprite.size];
        self.carSprite.physicsBody.dynamic = YES;
        self.carSprite.physicsBody.affectedByGravity = YES;
        self.carSprite.physicsBody.categoryBitMask = carCategory;
        self.carSprite.physicsBody.collisionBitMask = groundCategory;
        self.carSprite.name = @"car";
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [self addChild:self.carSprite];
        
        self.ground = [Ground spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
        self.ground.name = @"ground";
        [self addChild:self.ground];

        
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    
    [self.ground addPointToMove:touchPoint];
    

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    
    if (self.ground) {
        [self.ground addPointToMove:touchPoint];
        
    }
}

- (void)drawLines {
    //1
    NSMutableArray *temp = [NSMutableArray array];
    for(CALayer *layer in self.view.layer.sublayers) {
        if([layer.name isEqualToString:@"line"]) {
            [temp addObject:layer];
        }
    }
    [temp makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //2
    [self enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        //3
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.name = @"line";
        lineLayer.strokeColor = [UIColor grayColor].CGColor;
        lineLayer.fillColor = nil;
        
        //4
        CGPathRef path = [(Ground *)node createPathToMove];
        lineLayer.path = path;
        CGPathRelease(path);
        [self.view.layer addSublayer:lineLayer];
        
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self drawLines];
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
