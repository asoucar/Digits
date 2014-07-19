//
//  ViewController.m
//  Digits
//
//  Created by Ashley Soucar on 6/20/14.
//  Copyright (c) 2014 Motion Math. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *onScreenNums;
@property (nonatomic) int numTimesTenDecMovers;
@property (nonatomic) int numDivTenDecMovers;
@property (nonatomic, strong) UIImageView *multBy10;
@property (nonatomic, strong) UIImageView *divBy10;
@property (nonatomic, strong) NSMutableArray *digitCovers;

@end

@implementation ViewController

int numDigits =0;
bool decimalUsed = false;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.xGridLines = [NSArray arrayWithObjects:[NSNumber numberWithInt:154],[NSNumber numberWithInt:214],[NSNumber numberWithInt:274],[NSNumber numberWithInt:334],[NSNumber numberWithInt:394],[NSNumber numberWithInt:454],[NSNumber numberWithInt:514],[NSNumber numberWithInt:574],[NSNumber numberWithInt:634],[NSNumber numberWithInt:694],[NSNumber numberWithInt:754],[NSNumber numberWithInt:814],[NSNumber numberWithInt:894],nil];
    self.yGridLines = [NSArray arrayWithObjects:[NSNumber numberWithInt:102],[NSNumber numberWithInt:182],[NSNumber numberWithInt:262],[NSNumber numberWithInt:342],[NSNumber numberWithInt:422],[NSNumber numberWithInt:502],[NSNumber numberWithInt:582],[NSNumber numberWithInt:662],nil];

    self.calculator.hidden=true;
    self.decimalMoverCreator.hidden = true;
    self.numTimesTenDecMovers = 0;
    self.numDivTenDecMovers = 0;
    self.digitCovers = [[NSMutableArray alloc] init];
    
    self.onScreenNums = [NSMutableArray array];
    
    UIPanGestureRecognizer *gesture1 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(multDragged:)];
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(divDragged:)];
    
    self.divBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteLeftArrow.png"]];
    self.multBy10 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteRightArrow.png"]];
    
    self.divBy10.userInteractionEnabled = YES;
    self.multBy10.userInteractionEnabled = YES;
    self.divBy10.frame = CGRectMake(350, 33, 65, 60);
    self.divBy10.backgroundColor = [UIColor clearColor];
    self.multBy10.frame = CGRectMake(570, 33, 65, 60);
    self.multBy10.backgroundColor = [UIColor clearColor];
    
    [self.multBy10 addGestureRecognizer:gesture1];
    [self.divBy10 addGestureRecognizer:gesture2];
    
    [self.view addSubview:self.divBy10];
    [self.view addSubview:self.multBy10];

    self.divBy10.hidden = YES;
    self.multBy10.hidden = YES;
    self.multCount.hidden = YES;
    self.divCount.hidden = YES;
}

- (void)multDragged:(UIPanGestureRecognizer *)gesture
{
    UIImageView *mult = (UIImageView *)gesture.view;
    CGPoint translation = [gesture translationInView:mult];
    
	// move label
	mult.center = CGPointMake(mult.center.x + translation.x,
                               mult.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:mult];
    for (BigNumber *number in self.onScreenNums)
    {
        int decShift = 0;
        if(number.decimalNumberDigits.count > 0){
            decShift = 17;
        }
        
        NSNumber *numberDecimalLoc = [NSNumber numberWithFloat:((number.frame.origin.x)+[number.decimalPosition floatValue])+decShift];
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)mult.frame.origin.x+14));
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+60, 10);
        
        CGRect multProjectedFrame = CGRectMake(mult.frame.origin.x, mult.frame.origin.y+30, mult.frame.size.width, 10);

        if (CGRectIntersectsRect(multProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {

            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:1];
            number.value = decNum1;
            int labelLength = 60*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            mult.frame = CGRectMake(65, 190, 65, 60);
            self.numTimesTenDecMovers -= 1;
            self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
            if (self.numDivTenDecMovers <= 0) {
                self.divBy10.hidden = YES;
                self.divCount.hidden = YES;
            }
            if (self.numTimesTenDecMovers <= 0) {
                self.multBy10.hidden = YES;
                self.multCount.hidden = YES;
            }
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 80)andValue:decNum1 ];
            NSArray *objsForSelector = [NSArray arrayWithObjects:number, newNumber, nil];
            
            for (DigitView *digit in number.digitViews) {
                if ([digit.text isEqualToString:@"."]) {
                    CGPoint startLoc = digit.center;
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        digit.center = CGPointMake(startLoc.x + 35, startLoc.y+20);
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            digit.center = CGPointMake(startLoc.x + 70, startLoc.y);
                        } completion:^(BOOL finished) {
                            
                            newNumber.userInteractionEnabled = YES;
                            //
                            DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(labelDragged:)];
                            [newNumber addGestureRecognizer:gesture3];
                            
                            [self.onScreenNums removeObject:number];
                            [number removeFromSuperview];
                            
                            // add it
                            [self.view addSubview:newNumber];
                            [self.onScreenNums addObject:newNumber];
                            [newNumber wobbleAnimation];

                        }];

                    }];
                }
            }

        [self performSelector:@selector(presentNewNumFromDecimalMoverWithNumber:) withObject:objsForSelector afterDelay:1];
          break;
        }
    }

}

- (void)divDragged:(UIPanGestureRecognizer *)gesture
{
    UIImageView *div = (UIImageView *)gesture.view;
    CGPoint translation = [gesture translationInView:div];
    
	// move label
	div.center = CGPointMake(div.center.x + translation.x,
                              div.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:div];
    for (BigNumber *number in self.onScreenNums)
    {
        int decShift = 0;
        if(number.decimalNumberDigits.count > 0){
            decShift = 17;
        }
        
        NSNumber *numberDecimalLoc = [NSNumber numberWithFloat:((number.frame.origin.x)+[number.decimalPosition floatValue])+decShift];
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)div.frame.origin.x+div.frame.size.width-14));
        NSLog(@"arrow allign: %i", arrowAllign);
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+60, 10);
        
        CGRect divProjectedFrame = CGRectMake(div.frame.origin.x, div.frame.origin.y+30, div.frame.size.width, 10);
        
        if (CGRectIntersectsRect(divProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:-1];
            number.value = decNum1;
            int labelLength = 60*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            div.frame = CGRectMake(65, 125, 65, 60);
            self.numDivTenDecMovers -= 1;
            self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
            if (self.numDivTenDecMovers <= 0) {
                self.divBy10.hidden = YES;
                self.divCount.hidden = YES;
            }
            if (self.numTimesTenDecMovers <= 0) {
                self.multBy10.hidden = YES;
                self.multCount.hidden = YES;
            }
            gesture.enabled = NO;
            gesture.enabled = YES;
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 80)andValue:decNum1 ];
            
            NSArray *objsForSelector = [NSArray arrayWithObjects:number, newNumber, nil];
            
            for (DigitView *digit in number.digitViews) {
                if ([digit.text isEqualToString:@"."]) {
                    CGPoint startLoc = digit.center;
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        digit.center = CGPointMake(startLoc.x - 35, startLoc.y+20);
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            digit.center = CGPointMake(startLoc.x - 70, startLoc.y);
                        } completion:^(BOOL finished) {
                            
                            newNumber.userInteractionEnabled = YES;
                            
                            DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(labelDragged:)];
                            [newNumber addGestureRecognizer:gesture3];
                            
                            [self.onScreenNums removeObject:number];
                            [number removeFromSuperview];
                            
                            // add it
                            [self.view addSubview:newNumber];
                            [self.onScreenNums addObject:newNumber];
                            [newNumber wobbleAnimation];
                            
                        }];
                        
                    }];
                }
            }
            
            
            
            [self performSelector:@selector(presentNewNumFromDecimalMoverWithNumber:) withObject:objsForSelector afterDelay:1];

            
            break;
        }
    }

}

- (void)presentNewNumFromDecimalMoverWithNumber:(NSArray*)numbers
{
    BigNumber *oldNum =(BigNumber*)[numbers objectAtIndex:0];
    
    if ([self.onScreenNums containsObject:oldNum]) {
        BigNumber *newNum = (BigNumber*)[numbers objectAtIndex:1];
        newNum.userInteractionEnabled = YES;
        
        DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(labelDragged:)];
        [newNum addGestureRecognizer:gesture3];
        
        [self.onScreenNums removeObject:oldNum];
        [oldNum removeFromSuperview];
        
        // add it
        [self.view addSubview:newNum];
        [self.onScreenNums addObject:newNum];
    }

}

- (void)labelDragged:(DirectionPanGestureRecognizer *)gesture
{
	BigNumber *firstNumber = (BigNumber *)gesture.view;
    firstNumber.backgroundColor = [UIColor clearColor];
    NSLog(@"%f",firstNumber.frame.origin.y);
    int closestLineX = 0;
    int distanceFromClosestX = 1000;
    for (int i = 0; i < [self.xGridLines count]; i++) {
        float distanceFromLine = abs(firstNumber.frame.origin.x - [self.xGridLines[i] floatValue]);
        if (distanceFromLine < distanceFromClosestX) {
            distanceFromClosestX = distanceFromLine;
            closestLineX = [self.xGridLines[i] floatValue];
        }
        
    }
    
    int closestLineY = 0;
    int distanceFromClosestY = 1000;
    for (int i = 0; i < [self.yGridLines count]; i++) {
        float distanceFromLine = abs(firstNumber.frame.origin.y - [self.yGridLines[i] floatValue]);
        if (distanceFromLine < distanceFromClosestY) {
            distanceFromClosestY = distanceFromLine;
            closestLineY = [self.yGridLines[i] floatValue];
        }
        
    }
    
    CGPoint translation = [gesture translationInView:self.view];
    if (gesture.direction == DirectionPanGestureRecognizerHorizontal) {
        translation.y = 0;
    }
    else if (gesture.direction == DirectionPangestureRecognizerVertical) {
        translation.x = 0;
    }
    else
    {
        [gesture setTranslation:CGPointZero inView:firstNumber];
    }
    
    //move number
    CGPoint imageViewPosition = firstNumber.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    CGFloat checkOriginX = firstNumber.frame.origin.x + translation.x;
    CGFloat checkOriginY = firstNumber.frame.origin.y + translation.y;
    
    CGRect rectToCheckBounds = CGRectMake(checkOriginX, checkOriginY, firstNumber.frame.size.width, firstNumber.frame.size.height);
    
    CGRect draggableFrame = CGRectMake(self.gridFrame.frame.origin.x, self.gridFrame.frame.origin.y, self.gridFrame.frame.size.width, self.gridFrame.frame.size.height);
    if (CGRectContainsRect(draggableFrame, rectToCheckBounds)){
        firstNumber.center = imageViewPosition;
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    
    
    NSMutableArray *movedNums = [NSMutableArray arrayWithObject:firstNumber];
    
    BOOL hitWall = [self checkNumberCollisionWithNumber:firstNumber andTranslation:translation andMovedNums:movedNums andCanAdd:YES];
    
    if (hitWall) {
        firstNumber.center = CGPointMake(firstNumber.center.x - translation.x,
                                      firstNumber.center.y - translation.y);
    }
    
    if(gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged)
    {
        [UIView animateWithDuration:0.5 animations:^{
            firstNumber.frame = CGRectMake(closestLineX, closestLineY, firstNumber.frame.size.width, firstNumber.frame.size.height);
        }];
    }
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:firstNumber];
}

- (BOOL) checkNumberCollisionWithNumber:(BigNumber *) firstNum andTranslation:(CGPoint)translation andMovedNums:(NSMutableArray*)movedNums andCanAdd:(BOOL)canAdd
{
    NSNumber *firstNumberDecimalLoc = [NSNumber numberWithFloat:((firstNum.frame.origin.x)+[firstNum.decimalPosition floatValue])];
    
    for (BigNumber *otherNumber in self.onScreenNums) {
        NSNumber *otherNumberDecimalLoc = [NSNumber numberWithFloat:((otherNumber.frame.origin.x)+[otherNumber.decimalPosition floatValue])];
        
        if (firstNum != otherNumber && CGRectIntersectsRect(firstNum.frame, otherNumber.frame) && ![movedNums containsObject:otherNumber]) {
            int decimalLocDiff = abs([firstNumberDecimalLoc intValue]-[otherNumberDecimalLoc intValue]);
            if (decimalLocDiff <= 20 && canAdd) {
                
                NSDecimalNumber *decNum1 = firstNum.value;
                NSDecimalNumber *decNum2 = otherNumber.value;
                
                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
                int labelLength = 60*sumVal.stringValue.length;
                if ([sumVal.stringValue rangeOfString:@"."].location != NSNotFound) {
                    //labelLength -= 30;
                }
                CGRect sumFrame;
                if (decNum1.floatValue > decNum2.floatValue) {
                    sumFrame = CGRectMake(firstNum.frame.origin.x, otherNumber.frame.origin.y, labelLength, 80);
                }
                else {
                    sumFrame = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, labelLength, 80);
                }
                
                BigNumber *sumNumber = [[BigNumber alloc] initWithFrame:sumFrame andValue:sumVal ];
                sumNumber.userInteractionEnabled = YES;
                
                if (sumNumber.wholeNumberDigits.count > firstNum.wholeNumberDigits.count && sumNumber.wholeNumberDigits.count > otherNumber.wholeNumberDigits.count) {
                    NSLog(@"number shift");
                    sumNumber.frame = CGRectMake(otherNumber.frame.origin.x - 60, otherNumber.frame.origin.y, labelLength, 80);
                }
                
                DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(labelDragged:)];
                [sumNumber addGestureRecognizer:gesture3];
                
                // add animation
                CGRect coverFrame1;
                coverFrame1 = CGRectMake(firstNum.frame.origin.x, firstNum.frame.origin.y, labelLength, 80);
                BigNumber *cover1 = [[BigNumber alloc] initWithFrame:firstNum.frame andValue:firstNum.value];
                
                CGRect coverFrame2;
                coverFrame2 = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, otherNumber.frame.size.width, 80);
                BigNumber *cover2 = [[BigNumber alloc] initWithFrame:otherNumber.frame andValue:otherNumber.value];
                int coverDir = 1;
                if (firstNum.frame.origin.y > otherNumber.frame.origin.y) {
                    coverDir *= -1;
                }
                
                [self.onScreenNums removeObject:firstNum];
                [self.onScreenNums removeObject:otherNumber];
                [firstNum removeFromSuperview];
                [otherNumber removeFromSuperview];

                [self.view addSubview:cover2];
                [self.view addSubview:cover1];
                
                // trying cascading addition
                double delay = 0.0;
                NSArray *reversedDigits = [[cover1.digitViews reverseObjectEnumerator] allObjects];
                NSArray *reversedCover = [[cover2.digitViews reverseObjectEnumerator] allObjects];
                for (DigitView *digit in reversedDigits){
                        [UIView animateWithDuration:.5 delay:delay options:UIViewAnimationTransitionNone animations:^{
                        [digit setTransform:CGAffineTransformMakeTranslation([otherNumberDecimalLoc intValue]-[firstNumberDecimalLoc intValue], 75*coverDir)];
                        }  completion:^(BOOL finished) {
                            if ([reversedDigits objectAtIndex:reversedDigits.count-1] == digit) {
                                [cover1 removeFromSuperview];
                                [cover2 removeFromSuperview];
                                //add it
                                [self.view addSubview:sumNumber];
                                [self.onScreenNums addObject:sumNumber];

                                for (BigNumber *digitCover in self.digitCovers ) {
                                    [digitCover removeFromSuperview];
                                }
                                [self.digitCovers removeAllObjects];
                            } else {
                                for (DigitView *digitUnder in cover2.digitViews) {
                                    if (![digitUnder.text isEqualToString:@"."] && ![digit.text isEqualToString:@"."]) {
                                        if (CGRectIntersectsRect(digit.frame, digitUnder.frame)) {
                                            NSDecimalNumber *sumVal = [digit.value decimalNumberByAdding:digitUnder.value];
                                            NSString *trimmer = @"";
                                            if (sumVal.floatValue < 1.0 && sumVal.floatValue > 0.0) {
                                                trimmer = @"0.";
                                            }
                                            NSString* finalDigit = [sumVal.stringValue stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:trimmer]];
                                            if (finalDigit.length > 1) {
                                                finalDigit = [finalDigit substringFromIndex: [finalDigit length] - 1];
                                            }
                                            
                                            NSLog(@"final: %@", finalDigit);
                                            //digit.text = finalDigit;
                                        }
                                    }
                                }
                                digit.frame = CGRectMake(digit.frame.origin.x, digit.frame.origin.y-20, 60, 120);
                                //digit.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:232.0f/255.0f blue:136.0f/255.0f alpha:1.0f];
                            }
                        }];
                        delay +=0.25;
                }

                break;
            }
            else
            {
                [movedNums addObject:otherNumber];
                //for not aligned
                BOOL wallCollisionDetected = NO;
                for (BigNumber *thirdNum in self.onScreenNums) {
                    if (otherNumber != thirdNum && thirdNum != firstNum && ![movedNums containsObject:thirdNum]){
                        if (CGRectIntersectsRect(otherNumber.frame, thirdNum.frame)) {
                            BOOL hitWall = [self checkNumberCollisionWithNumber:otherNumber andTranslation:translation andMovedNums:movedNums andCanAdd:NO];
                            if (hitWall) {
                                wallCollisionDetected = YES;
                            }
                        }
                    }
                }

                
                
                CGFloat check2ndOriginX = otherNumber.frame.origin.x + translation.x;
                CGFloat check2ndOriginY = otherNumber.frame.origin.y + translation.y;
                
                CGRect rectToCheckBounds = CGRectMake(check2ndOriginX, check2ndOriginY, otherNumber.frame.size.width, otherNumber.frame.size.height);
                
                CGRect draggableFrame = CGRectMake(0, 25, self.view.frame.size.width, self.view.frame.size.height-180);
                if (!CGRectContainsRect(draggableFrame, rectToCheckBounds)){
                    wallCollisionDetected = YES;
                }
                
                if (wallCollisionDetected) {
                    firstNum.center = CGPointMake(firstNum.center.x - translation.x,
                                                     firstNum.center.y - translation.y);
                    return YES;
                }
                else{
                    otherNumber.center = CGPointMake(otherNumber.center.x + translation.x,
                                                     otherNumber.center.y + translation.y);
                    return NO;
                }
                
            }
        }
    }
	return NO;

}

- (void) numberSwiped:(UIPanGestureRecognizer *)gesture
{
    BigNumber *firstNumber = (BigNumber *)gesture.view;
    [firstNumber numberSwiped:gesture];
}


- (void)decomposeBigNumberWithNewValue:(NSDecimalNumber *)val andOrigNum:(BigNumber *)prevNum andDir:(NSString *)dir andOffset:(int)offest andDigit:(NSString *)digit
{
    CGRect spawnArea = CGRectMake(154, 102, 540, 80);
    BigNumber *blocker;
    CGRect bottomArea = CGRectMake(self.gridFrame.frame.origin.x, self.gridFrame.frame.size.height-60, self.gridFrame.frame.size.width, self.gridFrame.frame.size.height);
    CGRect swipeDownArea = CGRectMake(prevNum.frame.origin.x, prevNum.frame.origin.y+80, prevNum.frame.size.width, 80);
    BOOL isANumInSpawnSpot = NO;
    for (BigNumber *oldNum in self.onScreenNums) {
        if (CGRectIntersectsRect(oldNum.frame, swipeDownArea)) {
            isANumInSpawnSpot = YES;
            blocker = oldNum;
        }
    }
    if (!(CGRectIntersectsRect(prevNum.frame, spawnArea)) && !(CGRectIntersectsRect(prevNum.frame, bottomArea))) {
        BOOL hitWall = NO;
        if (isANumInSpawnSpot) {
            blocker.center = CGPointMake(blocker.center.x, blocker.center.y+100);
            NSMutableArray *moveNums = [NSMutableArray arrayWithObjects:blocker, prevNum, nil];
            hitWall = [self checkNumberCollisionWithNumber:blocker andTranslation:CGPointMake(0, 100) andMovedNums:moveNums andCanAdd:NO];
        }
        if (!hitWall) {
            NSDecimalNumber *decNum1 = prevNum.value;
            NSDecimalNumber *decNum2 = [NSDecimalNumber decimalNumberWithDecimal:val.decimalValue];
            
            NSDecimalNumber *subVal = [decNum1 decimalNumberBySubtracting:decNum2];
            int labelLength = 60*subVal.stringValue.length;
            if ([subVal.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            int oldXOffsett = 0;
            if (prevNum.value.stringValue.length > subVal.stringValue.length && val.floatValue > 1) {
                oldXOffsett = 60*(prevNum.value.stringValue.length - subVal.stringValue.length);
            }
            
            BigNumber *subNumber = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x+oldXOffsett, prevNum.frame.origin.y, labelLength, 80) andValue:subVal];
            subNumber.userInteractionEnabled = YES;
            subNumber.backgroundColor = [UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:177.0f/255.0f alpha:1];
            
            DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)];
            [subNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:prevNum];
            [prevNum removeFromSuperview];
            
            // add it
            if ([subVal compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
                [self.view addSubview:subNumber];
                [self.onScreenNums addObject:subNumber];
            }
            
            int addX = 0;
            int addY = 0;
            if ([dir isEqualToString:@"up"]) {
                addY = -80;
            }
            else if ([dir isEqualToString:@"down"]) {
                addY = 0;
            }
            else if ([dir isEqualToString:@"right"]) {
                addX = labelLength + 75;
            }
            
            labelLength = 60*decNum2.stringValue.length;
            if ([decNum2.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            BigNumber *newNum = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x + addX +offest, subNumber.frame.origin.y + addY, labelLength, 80) andValue:decNum2];
            newNum.userInteractionEnabled = YES;
            newNum.backgroundColor = [UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:177.0f/255.0f alpha:1];
            
            DirectionPanGestureRecognizer *gesture4 = [[DirectionPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)];
            [newNum addGestureRecognizer:gesture4];
            
            // add it
            if ([newNum.value compare:[NSNumber numberWithInt:0]] != NSOrderedSame && newNum.value != subNumber.value) {
                UILabel *cover = [[UILabel alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x + addX +offest, subNumber.frame.origin.y, 60, 80)];
                cover.backgroundColor = [UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:177.0f/255.0f alpha:1];
                cover.textColor = [UIColor whiteColor];
                cover.font = [UIFont fontWithName:@"Futura" size:100];
                [self.view addSubview:cover];
                if(newNum.value.floatValue < 1){
                    cover.text = @"0";
                    [self.view sendSubviewToBack:cover];
                } else {
                    cover.text = digit;
                }
                [self.view addSubview:newNum];
                [self.onScreenNums addObject:newNum];
                
                
                [UIView animateWithDuration:0.75
                                 animations:^{
                                     [cover setTransform:CGAffineTransformMakeTranslation(0, 80)];
                                     [newNum setTransform:CGAffineTransformMakeTranslation(0, 80)];
                                 } completion:^(BOOL finished) {
                                     [cover removeFromSuperview];
                                     [UIView animateWithDuration:0.5
                                                       animations:^{
                                                           [newNum setBackgroundColor:[UIColor clearColor]];
                                                           [subNumber setBackgroundColor:[UIColor clearColor]];
                                                       } completion:^(BOOL finished) {
                        
                                                           
                                                       }];
                                     
                                 }];
                
            }

        }
    }
    
}

-(void)colorizeLabelForAWhile:(BigNumber *)label withUIColor:(UIColor *)tempColor animated:(BOOL)animated
{
    // We will:
    //      1) Duplicate the given label as a temporary UILabel with a new color.
    //      2) Add the temp label to the super view with alpha 0.0
    //      3) Animate the alpha to 1.0
    //      4) Wait for awhile.
    //      5) Animate back and remove the temporary label when we are done.
    
    // Duplicate the label and add it to the superview
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = tempColor;
    tempLabel.font = [UIFont fontWithName:@"Futura" size:95];
    tempLabel.alpha = 0;
    tempLabel.text = label.value.stringValue;
    NSLog(@"temp text: %@", label.value.stringValue);
    tempLabel.frame = label.frame;
    //tempLabel.backgroundColor = [UIColor blackColor];
    [label.superview addSubview:tempLabel];
    
    // Reveal the temp label and hide the current label.
    if (animated) [UIView beginAnimations:nil context:nil];
    tempLabel.alpha = 1;
    label.alpha = 0;
    if (animated) [UIView commitAnimations];
    
    // Wait for while and change it back.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (animated) {
            // Change it back animated
            [UIView animateWithDuration:1 animations:^{
                // Animate it back.
                label.alpha = 1;
                tempLabel.alpha = 0;
            } completion:^(BOOL finished){
                // Remove the tempLabel view when we are done.
                [tempLabel removeFromSuperview];
            }];
        } else {
            // Change it back at once and remove the tempLabel view.
            label.alpha = 1.0;
            [tempLabel removeFromSuperview];
        }
    });
}

- (IBAction)clearNumber:(UIButton *)sender {
    for (UILabel *v in self.onScreenNums) {
        [v removeFromSuperview];
    }
    [self.onScreenNums removeAllObjects];
    
    self.numTimesTenDecMovers = 0;
    self.numDivTenDecMovers = 0;
    self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
    self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
    self.divCount.hidden = YES;
    self.multCount.hidden = true;
    self.divBy10.hidden = YES;
    self.multBy10.hidden = true;
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = sender.currentTitle;
    if (!decimalUsed) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:decimal];
        decimalUsed = true;
    }
    
}

- (IBAction)numberPressed:(UIButton *)sender {
    NSString *number = sender.currentTitle;
    if (numDigits < 8) {
        self.numberDisplay.text = [self.numberDisplay.text stringByAppendingString:number];
        numDigits++;
    }
}

- (IBAction)submitPressed:(UIButton *)sender {
    
    int labelLength = (60*self.numberDisplay.text.length);
    if ([self.numberDisplay.text rangeOfString:@"."].location != NSNotFound) {
        //labelLength -= 30;
    }
    if([self.numberDisplay.text hasPrefix:@"."]){
        labelLength += 60;
    }

    CGRect potentialFrame = CGRectMake(155, 102, labelLength, 80);
    
    BOOL hitWall = NO;
    for (BigNumber *oldNum in self.onScreenNums) {
        if (CGRectIntersectsRect(oldNum.frame, potentialFrame)) {
            
            NSMutableArray *moveNums = [NSMutableArray arrayWithObject:oldNum];
            hitWall = [self checkNumberCollisionWithNumber:oldNum andTranslation:CGPointMake(0,79) andMovedNums:moveNums andCanAdd:NO];
            if (!hitWall) {
                oldNum.center = CGPointMake(oldNum.center.x, oldNum.center.y+79);
            }
        }
    }
    
    if (!hitWall && ![self.numberDisplay.text isEqualToString:@""]) {
        BigNumber *newNumber = [[BigNumber alloc] initWithFrame:potentialFrame
                                                       andValue:[NSDecimalNumber decimalNumberWithString:self.numberDisplay.text]];
        [self.view addSubview:newNumber];
        //newNumber.center = CGPointMake(self.view.center.y, 73);
        [self.onScreenNums addObject:newNumber];
        DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(labelDragged:)];
        [newNumber addGestureRecognizer:gesture3];
        [newNumber wobbleAnimation];
    }
        self.numberDisplay.text = @"";
        decimalUsed = false;
        numDigits = 0;
        [self.makeNumber setTitle:@"Make" forState:UIControlStateNormal];
        self.calculator.hidden = true;
        
        //for decimal mover creator
        self.numTimesTenDecMovers = [NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue;
        self.numDivTenDecMovers = [NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue;
        self.times10NumDisplay.text = @"";
        self.divide10NumDisplay.text = @"";
        
        self.divCount.text = [NSString stringWithFormat:@"%d", self.numDivTenDecMovers];
        self.multCount.text = [NSString stringWithFormat:@"%d", self.numTimesTenDecMovers];
        self.divCount.hidden = YES;
        self.multCount.hidden = true;
        self.divBy10.hidden = YES;
        self.multBy10.hidden = true;
        
        if (self.numDivTenDecMovers > 0) {
            self.divBy10.hidden = NO;
            self.divCount.hidden = NO;
        }
        if (self.numTimesTenDecMovers > 0) {
            self.multBy10.hidden = NO;
            self.multCount.hidden = NO;
        }
        self.decimalMoverCreator.hidden = YES;
    
}

- (IBAction)clearPresssed:(UIButton *)sender {
    numDigits = 0;
    decimalUsed = false;
    self.numberDisplay.text = @"";
}

- (IBAction)showCalc:(UIButton *)sender {
    if (self.calculator.hidden == true) {
        [sender setTitle:@"Close" forState:UIControlStateNormal];
        self.calculator.hidden=false;
        [self.view bringSubviewToFront:self.calculator];
        
        self.decimalMoverCreator.hidden = false;
        [self.view bringSubviewToFront:self.decimalMoverCreator];
        if ([self.times10NumDisplay.text isEqualToString:@""]) {
            self.times10NumDisplay.text = @"0";
        }
        if ([self.divide10NumDisplay.text isEqualToString:@""]) {
            self.divide10NumDisplay.text = @"0";
        }
    }
    else{
        [sender setTitle:@"Make" forState:UIControlStateNormal];
        self.calculator.hidden=true;
        self.decimalMoverCreator.hidden = true;
    }
}

- (IBAction)addTimesTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue + 1;
    self.times10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)subtractTimesTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.times10NumDisplay.text].intValue - 1;
    if (newNum < 0) {
        newNum = 0;
    }
    self.times10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)addDivTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue + 1;
    self.divide10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (IBAction)subtractDivTen:(id)sender {
    int newNum =[NSDecimalNumber decimalNumberWithString:self.divide10NumDisplay.text].intValue - 1;
    if (newNum < 0) {
        newNum = 0;
    }
    self.divide10NumDisplay.text = [NSString stringWithFormat:@"%d",newNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
