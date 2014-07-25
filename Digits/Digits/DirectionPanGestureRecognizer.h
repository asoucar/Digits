//
//  DirectionPanGestureRecognizer.h
//  Digits
//
//  Created by Ashley Soucar on 7/18/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionPangestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal
} DirectionPangestureRecognizerDirection;

@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
    DirectionPangestureRecognizerDirection _direction;
}

@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;
@property (nonatomic) int verticalDirectionPanThreshold;
@property (nonatomic) int horizontalDirectionPanThreshold;

-(id) initWithTarget:(id)target action:(SEL)action threshold:(int)threshold;

@end