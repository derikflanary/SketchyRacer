//
//  Ground.m
//  SketchyRacer
//
//  Created by Derik Flanary on 10/14/15.
//  Copyright © 2015 Derik Flanary. All rights reserved.
//

#import "Ground.h"

@implementation Ground

NSMutableArray *_wayPoints;
CGPoint _velocity;

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size{
    if(self = [super initWithColor:color size:size]) {
        _wayPoints = [NSMutableArray array];
    }
    
    return self;
}

- (void)addPointToMove:(CGPoint)point {
    [_wayPoints addObject:[NSValue valueWithCGPoint:point]];
}

- (CGPathRef)createPathToMove {
    //1
    CGMutablePathRef ref = CGPathCreateMutable();
    
    //2
    for(int i = 0; i < [_wayPoints count]; ++i) {
        CGPoint p = [_wayPoints[i] CGPointValue];
        p = [self.scene convertPointToView:p];
        //3
        if(i == 0) {
            CGPathMoveToPoint(ref, NULL, p.x, p.y);
        } else {
            CGPathAddLineToPoint(ref, NULL, p.x, p.y);
        }
    }
    
    return ref;
}
@end
