//
//  BigNumber.h
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitView.h"

@interface BigNumber : UIView

@property (nonatomic, strong) NSDecimalNumber *value;
@property (nonatomic, strong) NSNumber *decimalPosition;
@property (nonatomic, strong) NSMutableArray *decimalNumberDigits;

- (id)initWithFrame:(CGRect)frame andValue:(NSDecimalNumber*)value;
- (void)wobbleAnimation;

@end
