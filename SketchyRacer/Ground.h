//
//  Ground.h
//  SketchyRacer
//
//  Created by Derik Flanary on 10/14/15.
//  Copyright © 2015 Derik Flanary. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ground : SKSpriteNode

- (void)addPointToMove:(CGPoint)point;
- (CGPathRef)createPathToMove;

@end
