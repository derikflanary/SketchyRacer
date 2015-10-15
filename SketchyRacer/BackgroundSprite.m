//
//  BackgroundSprite.m
//  SketchyRacer
//
//  Created by Derik Flanary on 10/14/15.
//  Copyright © 2015 Derik Flanary. All rights reserved.
//

#import "BackgroundSprite.h"

@implementation BackgroundSprite

static const int POINTS_PER_SEC = 1;

- (void)move{
    self.position = CGPointMake(self.position.x - POINTS_PER_SEC, self.position.y);
//    for (SKShapeNode *line in self.children) {
//        line.position = CGPointMake(line.position.x - POINTS_PER_SEC, line.position.y);
//    }
}
@end
