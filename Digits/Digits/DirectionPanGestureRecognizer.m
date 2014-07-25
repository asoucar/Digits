//
//  DirectionPanGestureRecognizer.m
//  Digits
//
//  Created by Ashley Soucar on 7/18/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "DirectionPanGestureRecognizer.h"


@implementation DirectionPanGestureRecognizer

@synthesize direction = _direction;

-(id) initWithTarget:(id)target action:(SEL)action threshold:(int)threshold {
    self = [super initWithTarget:target action:action];
    
    if (self) {
        self.verticalDirectionPanThreshold = 60;
        self.horizontalDirectionPanThreshold = 60;
    }
    
    return self;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > self.horizontalDirectionPanThreshold) {
            _drag = YES;
            _direction = DirectionPanGestureRecognizerHorizontal;
            self.direction = DirectionPanGestureRecognizerHorizontal;
        }else if (abs(_moveY) > self.verticalDirectionPanThreshold) {
            _direction = DirectionPangestureRecognizerVertical;
            self.direction = DirectionPangestureRecognizerVertical;
            _drag = YES;

        }
    }
    else
    {
        if (abs(_moveX) > self.horizontalDirectionPanThreshold) {
            if (_direction == DirectionPangestureRecognizerVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }else if (abs(_moveY) > self.verticalDirectionPanThreshold) {
            if (_direction == DirectionPanGestureRecognizerHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }

    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end