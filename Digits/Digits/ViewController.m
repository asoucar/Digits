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
@property (nonatomic, strong) NSMutableArray *targetNums;
@property (nonatomic, strong) NSDecimalNumber *targetValue;
@property (nonatomic) CGRect targetNumberFrame;
@property (nonatomic) int verticalSpawnOffset;
@property (nonatomic) int targetDecimalLoc;
@property (nonatomic) int numTimesTenDecMovers;
@property (nonatomic) int numDivTenDecMovers;
@property (nonatomic, strong) UIImageView *multBy10;
@property (nonatomic, strong) UIImageView *divBy10;
@property (nonatomic, strong) NSMutableArray *digitCovers;
@property (nonatomic, strong) NSMutableArray *outerGridViews;

@property (nonatomic) int lastLevelNum;

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
    
    //hide hide text view
    self.hideTextView.hidden = YES;
    
    //setup make problem color pallette
    self.calculator.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:171/255.0 alpha:1.0];
    self.decimalMoverCreator.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:171/255.0 alpha:1.0];
    for (UIButton *butn in self.makeProblemButtons) {
        butn.backgroundColor = [UIColor colorWithRed:5/255.0 green:83/255.0 blue:117/255.0 alpha:1.0];
    }
    self.numberDisplay.backgroundColor = [UIColor colorWithRed:144/255.0 green:209/255.0 blue:215/255.0 alpha:1.0];
    self.times10NumDisplay.backgroundColor = [UIColor colorWithRed:144/255.0 green:209/255.0 blue:215/255.0 alpha:1.0];
    self.divide10NumDisplay.backgroundColor = [UIColor colorWithRed:144/255.0 green:209/255.0 blue:215/255.0 alpha:1.0];
    
    self.lastLevelNum = 1;
    self.calculator.hidden=true;
    self.decimalMoverCreator.hidden = true;
    self.numTimesTenDecMovers = 0;
    self.verticalSpawnOffset = 102;
    self.numDivTenDecMovers = 0;
    self.digitCovers = [[NSMutableArray alloc] init];
    self.outerGridViews = [[NSMutableArray alloc] init];
    
    self.onScreenNums = [NSMutableArray array];
    self.targetNums = [NSMutableArray array];
    
    [self.gridFrame setBackgroundColor:[UIColor colorWithRed:5/255.0 green:83/255.0 blue:117/255.0 alpha:1.0]];
    for (UIView *gridBox in self.gridFrame.subviews){
        if(![self.innerGridViews containsObject:gridBox]){
            [self.outerGridViews addObject:gridBox];
            [gridBox setBackgroundColor:[UIColor colorWithRed:138/255.0 green:192/255.0 blue:225/255.0 alpha:1.0]];
        }
    }
    for (UIView *gridBox in self.innerGridViews){
        [gridBox setBackgroundColor:[UIColor colorWithRed:5/255.0 green:117/255.0 blue:165/255.0 alpha:1.0]];
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:144/255.0 green:209/255.0 blue:215/255.0 alpha:1.0]];
    [self.hideTextView setBackgroundColor:[UIColor colorWithRed:144/255.0 green:209/255.0 blue:215/255.0 alpha:1.0]];
    
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
    self.divBy10.frame = CGRectMake(55, 130, 65, 60);
    self.divBy10.backgroundColor = [UIColor clearColor];
    self.multBy10.frame = CGRectMake(55, 200, 65, 60);
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
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)mult.frame.origin.x+2));
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+58, 10);
        
        CGRect multProjectedFrame = CGRectMake(mult.frame.origin.x, mult.frame.origin.y+30, mult.frame.size.width, 10);

        if (CGRectIntersectsRect(multProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {

            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:1];
            number.value = decNum1;
            int labelLength = 58*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            mult.frame = CGRectMake(55, 200, 65, 60);
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
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 78)andValue:decNum1 ];
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
                                                                action:@selector(labelDragged:)
                                                                threshold:labelLength];
                            [newNumber addGestureRecognizer:gesture3];
                            
                            [self.onScreenNums removeObject:number];
                            [number removeFromSuperview];
                            
                            // add it
                            [self.view addSubview:newNumber];
                            [self.view bringSubviewToFront:newNumber];
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
        int arrowAllign = abs([numberDecimalLoc intValue]-((int)div.frame.origin.x+div.frame.size.width-25));
        NSLog(@"arrow allign: %i", arrowAllign);
        
        CGRect numberProjectedFrame = CGRectMake(number.frame.origin.x, number.frame.origin.y+number.frame.size.height, number.frame.size.width+58, 10);
        
        CGRect divProjectedFrame = CGRectMake(div.frame.origin.x, div.frame.origin.y+30, div.frame.size.width, 10);
        
        if (CGRectIntersectsRect(divProjectedFrame, numberProjectedFrame) && (arrowAllign <=5)) {            NSDecimalNumber *decNum1 = number.value;
            decNum1 = [decNum1 decimalNumberByMultiplyingByPowerOf10:-1];
            number.value = decNum1;
            int labelLength = 58*decNum1.stringValue.length;
            if ([decNum1.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            div.frame = CGRectMake(55, 130, 65, 60);
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
            
            BigNumber *newNumber = [[BigNumber alloc] initWithFrame:CGRectMake(number.frame.origin.x, number.frame.origin.y, labelLength, 78)andValue:decNum1 ];
            
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
                                                                action:@selector(labelDragged:)
                                                                threshold:labelLength];
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
                                            action:@selector(labelDragged:)
                                            threshold:[oldNum.digitViews count]*58];
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
    
    CGRect rectToCheckBounds = CGRectMake(checkOriginX-2, checkOriginY+2, firstNumber.frame.size.width-2, firstNumber.frame.size.height-2);
    
    CGRect draggableFrame = CGRectMake(self.gridFrame.frame.origin.x, self.gridFrame.frame.origin.y, self.gridFrame.frame.size.width, self.gridFrame.frame.size.height);
    if (CGRectContainsRect(draggableFrame, rectToCheckBounds) && (!CGRectIntersectsRect(self.targetNumberFrame, rectToCheckBounds)||[self doesTargetDecimalAndValueMatchNumber:firstNumber])){
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
        for (BigNumber *snapNumber in self.onScreenNums) {
        int closestLineX = 0;
        int distanceFromClosestX = 1000;
        for (int i = 0; i < [self.xGridLines count]; i++) {
            float distanceFromLine = abs(snapNumber.frame.origin.x - [self.xGridLines[i] floatValue]);
            if (distanceFromLine < distanceFromClosestX) {
                distanceFromClosestX = distanceFromLine;
                closestLineX = [self.xGridLines[i] floatValue];
            }
            
        }
        
        int closestLineY = 0;
        int distanceFromClosestY = 1000;
        for (int i = 0; i < [self.yGridLines count]; i++) {
            float distanceFromLine = abs(snapNumber.frame.origin.y - [self.yGridLines[i] floatValue]);
            if (distanceFromLine < distanceFromClosestY) {
                distanceFromClosestY = distanceFromLine;
                closestLineY = [self.yGridLines[i] floatValue];
            }
            
        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            snapNumber.frame = CGRectMake(closestLineX-1, closestLineY+2, snapNumber.frame.size.width, snapNumber.frame.size.height);
        } completion:^(BOOL finished) {
            if (CGRectIntersectsRect(snapNumber.frame, self.targetNumberFrame) && [self doesTargetDecimalAndValueMatchNumber:firstNumber])
            {
                [snapNumber setBackgroundColor:[UIColor clearColor]];
                NSLog(@"on target");
                [UIView animateWithDuration:1.0
                                      delay:0.0
                                    options: UIViewAnimationCurveEaseOut
                                 animations:^{
                                     self.gridFrame.alpha = 0.0;
                                     for (UILabel *v in self.targetNums) {
                                         v.alpha = 0.0;
                                     }
                                     for (UILabel *v in self.onScreenNums) {
                                         if(v.frame.origin.x != firstNumber.frame.origin.x){
                                             v.alpha = 0.0;
                                         }
                                     }
                                 }
                                 completion:^(BOOL finished){
                                     [UIView animateWithDuration:1.0
                                                           delay:1.0
                                                         options: UIViewAnimationCurveEaseOut
                                                      animations:^{
                                                          self.gridFrame.alpha = 1.0;
                                                          firstNumber.alpha = 0.0;
                                                          
                                                      }  
                                                      completion:^(BOOL finished){
                                                          [self clearNumber:nil];
                                                          [self createLevelWithLevelNum:self.lastLevelNum + 1];
                                                          NSLog(@"Done!");
                                                      }];
                                 }];
            }
        }];
        }
    }
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:firstNumber];
}

- (BOOL) doesTargetDecimalAndValueMatchNumber:(BigNumber*) movedNum{
    NSNumber *numberDecimalLoc = [NSNumber numberWithFloat:((movedNum.frame.origin.x)+[movedNum.decimalPosition floatValue])];
    NSLog(@"number decimal loc: %@", numberDecimalLoc);
    NSLog(@"target decimal loc: %d", self.targetDecimalLoc);
    int decimalLocDiff = abs([numberDecimalLoc intValue]-self.targetDecimalLoc);
    NSLog(@"decimal diff: %i", decimalLocDiff);
    return ([movedNum.value isEqualToNumber:self.targetValue] && decimalLocDiff < 20);
}

- (BOOL) checkNumberCollisionWithNumber:(BigNumber *) firstNum andTranslation:(CGPoint)translation andMovedNums:(NSMutableArray*)movedNums andCanAdd:(BOOL)canAdd
{
    NSNumber *firstNumberDecimalLoc = [NSNumber numberWithFloat:((firstNum.frame.origin.x)+[firstNum.decimalPosition floatValue])];
    
    for (BigNumber *otherNumber in self.onScreenNums) {
        NSNumber *otherNumberDecimalLoc = [NSNumber numberWithFloat:((otherNumber.frame.origin.x)+[otherNumber.decimalPosition floatValue])];
        CGRect addSpace = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y+37, otherNumber.frame.size.width, 4);
        
        if (firstNum != otherNumber && CGRectIntersectsRect(firstNum.frame, otherNumber.frame) && ![movedNums containsObject:otherNumber]) {
            int decimalLocDiff = abs([firstNumberDecimalLoc intValue]-[otherNumberDecimalLoc intValue]);
            if (decimalLocDiff <= 20 && canAdd) {
                
                if (CGRectIntersectsRect(firstNum.frame, addSpace)) {

                NSDecimalNumber *decNum1 = firstNum.value;
                NSDecimalNumber *decNum2 = otherNumber.value;
                
                NSDecimalNumber *sumVal = [decNum2 decimalNumberByAdding:decNum1];
                int labelLength = 58*sumVal.stringValue.length;
                if ([sumVal.stringValue rangeOfString:@"."].location != NSNotFound) {
                    //labelLength -= 30;
                }
                CGRect sumFrame;
                if (decNum1.floatValue > decNum2.floatValue) {
                    sumFrame = CGRectMake(firstNum.frame.origin.x, otherNumber.frame.origin.y, labelLength, 78);
                }
                else {
                    sumFrame = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, labelLength, 78);
                }
                
                BigNumber *sumNumber = [[BigNumber alloc] initWithFrame:sumFrame andValue:sumVal ];
                sumNumber.userInteractionEnabled = YES;
                BOOL needRightShift = NO;
                if (sumNumber.wholeNumberDigits.count > firstNum.wholeNumberDigits.count && sumNumber.wholeNumberDigits.count > otherNumber.wholeNumberDigits.count) {
                    NSLog(@"number shift");
                    sumNumber.frame = CGRectMake(otherNumber.frame.origin.x - 58, otherNumber.frame.origin.y, labelLength, 78);
                    if (sumNumber.frame.origin.x < self.gridFrame.frame.origin.x) {
                        needRightShift = YES;
                    }
                }
                
                DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(labelDragged:)
                                                    threshold:labelLength];
                [sumNumber addGestureRecognizer:gesture3];
                
                // add animation
                CGRect coverFrame1;
                coverFrame1 = CGRectMake(firstNum.frame.origin.x, firstNum.frame.origin.y, labelLength, 78);
                BigNumber *cover1 = [[BigNumber alloc] initWithFrame:firstNum.frame andValue:firstNum.value];
                
                CGRect coverFrame2;
                coverFrame2 = CGRectMake(otherNumber.frame.origin.x, otherNumber.frame.origin.y, otherNumber.frame.size.width, 78);
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
                                    
                if (needRightShift) {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         [cover1 setTransform:CGAffineTransformMakeTranslation(58, 0)];
                                         [cover2 setTransform:CGAffineTransformMakeTranslation(58, 0)];
                                     } completion:^(BOOL finished) {
                                         // trying cascading addition
                                         double delay = 0.0;
                                         NSArray *reversedDigits = [[cover1.digitViews reverseObjectEnumerator] allObjects];
                                         NSArray *reversedCover = [[cover2.digitViews reverseObjectEnumerator] allObjects];
                                         for (DigitView *digit in reversedDigits){
                                             [UIView animateWithDuration:.5 delay:delay options:UIViewAnimationTransitionNone animations:^{
                                                 [digit setTransform:CGAffineTransformMakeTranslation([otherNumberDecimalLoc intValue]-[firstNumberDecimalLoc intValue], 48*coverDir)];
                                             }  completion:^(BOOL finished) {
                                                 if ([reversedDigits objectAtIndex:reversedDigits.count-1] == digit) {
                                                     //add it
                                                     if (sumNumber.digitViews.count > cover1.digitViews.count && sumNumber.digitViews.count > cover2.digitViews.count) {
                                                         UILabel *carryOne = [[UILabel alloc] initWithFrame:CGRectMake(cover1.frame.origin.x, cover1.frame.origin.y+39, 58, cover1.frame.size.height)];
                                                         carryOne.font = digit.font;
                                                         carryOne.textColor = digit.textColor;
                                                         carryOne.backgroundColor = digit.backgroundColor;
                                                         carryOne.text = @"1";
                                                         [UIView animateWithDuration:0.5
                                                                          animations:^{
                                                                              [self.view addSubview:carryOne];
                                                                              [carryOne setTransform:CGAffineTransformMakeTranslation(-60, 0)];
                                                                              
                                                                          } completion:^(BOOL finished) {
                                                                              [self.view addSubview:sumNumber];
                                                                              [self.onScreenNums addObject:sumNumber];
                                                                              
                                                                              for (BigNumber *digitCover in self.digitCovers ) {
                                                                                  [digitCover removeFromSuperview];
                                                                              }
                                                                              [self.digitCovers removeAllObjects];
                                                                              [carryOne removeFromSuperview];
                                                                              [cover1 removeFromSuperview];
                                                                              [cover2 removeFromSuperview];
                                                                          }];
                                                     }
                                                     else
                                                     {
                                                         [self.view addSubview:sumNumber];
                                                         [self.onScreenNums addObject:sumNumber];
                                                         
                                                         for (BigNumber *digitCover in self.digitCovers ) {
                                                             [digitCover removeFromSuperview];
                                                         }
                                                         [self.digitCovers removeAllObjects];
                                                         [cover1 removeFromSuperview];
                                                         [cover2 removeFromSuperview];
                                                         
                                                     }
                                                     
                                                 }
                                                 else {
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
                                                 }
                                             }];
                                             delay +=0.25;
                                         }

                                     }];
                }
                else
                {
                    // trying cascading addition
                    double delay = 0.0;
                    NSArray *reversedDigits = [[cover1.digitViews reverseObjectEnumerator] allObjects];
                    NSArray *reversedCover = [[cover2.digitViews reverseObjectEnumerator] allObjects];
                    for (DigitView *digit in reversedDigits){
                        [UIView animateWithDuration:.5 delay:delay options:UIViewAnimationTransitionNone animations:^{
                            [digit setTransform:CGAffineTransformMakeTranslation([otherNumberDecimalLoc intValue]-[firstNumberDecimalLoc intValue], 48*coverDir)];
                        }  completion:^(BOOL finished) {
                            if ([reversedDigits objectAtIndex:reversedDigits.count-1] == digit) {
                                //add it
                                if (sumNumber.digitViews.count > cover1.digitViews.count && sumNumber.digitViews.count > cover2.digitViews.count) {
                                    UILabel *carryOne = [[UILabel alloc] initWithFrame:CGRectMake(cover1.frame.origin.x, cover1.frame.origin.y+39, 58, cover1.frame.size.height)];
                                    carryOne.font = digit.font;
                                    carryOne.textColor = digit.textColor;
                                    carryOne.backgroundColor = digit.backgroundColor;
                                    carryOne.text = @"1";
                                    [UIView animateWithDuration:0.5
                                                     animations:^{
                                                         [self.view addSubview:carryOne];
                                                         [carryOne setTransform:CGAffineTransformMakeTranslation(-60, 0)];
                                                         
                                                     } completion:^(BOOL finished) {
                                                         [self.view addSubview:sumNumber];
                                                         [self.onScreenNums addObject:sumNumber];
                                                         
                                                         for (BigNumber *digitCover in self.digitCovers ) {
                                                             [digitCover removeFromSuperview];
                                                         }
                                                         [self.digitCovers removeAllObjects];
                                                         [carryOne removeFromSuperview];
                                                         [cover1 removeFromSuperview];
                                                         [cover2 removeFromSuperview];
                                                     }];
                                }
                                else
                                {
                                    [self.view addSubview:sumNumber];
                                    [self.onScreenNums addObject:sumNumber];
                                    
                                    for (BigNumber *digitCover in self.digitCovers ) {
                                        [digitCover removeFromSuperview];
                                    }
                                    [self.digitCovers removeAllObjects];
                                    [cover1 removeFromSuperview];
                                    [cover2 removeFromSuperview];
                                    
                                }
                                
                            }
                            else {
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
                            }
                        }];
                        delay +=0.25;
                    }

                }
                    
                int closestLineX = 0;
                int distanceFromClosestX = 1000;
                for (int i = 0; i < [self.xGridLines count]; i++) {
                    float distanceFromLine = abs(sumNumber.frame.origin.x - [self.xGridLines[i] floatValue]);
                    if (distanceFromLine < distanceFromClosestX) {
                        distanceFromClosestX = distanceFromLine;
                        closestLineX = [self.xGridLines[i] floatValue];
                    }
                    
                }
                
                int closestLineY = 0;
                int distanceFromClosestY = 1000;
                for (int i = 0; i < [self.yGridLines count]; i++) {
                    float distanceFromLine = abs(sumNumber.frame.origin.y - [self.yGridLines[i] floatValue]);
                    if (distanceFromLine < distanceFromClosestY) {
                        distanceFromClosestY = distanceFromLine;
                        closestLineY = [self.yGridLines[i] floatValue];
                    }
                    
                }
                [UIView animateWithDuration:0.5 animations:^{
                    sumNumber.frame = CGRectMake(closestLineX-1, closestLineY+2, sumNumber.frame.size.width, sumNumber.frame.size.height);
                }];
                break;
                }
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
                
                CGRect draggableFrame = CGRectMake(self.gridFrame.frame.origin.x, self.gridFrame.frame.origin.y, self.gridFrame.frame.size.width, self.gridFrame.frame.size.height);
                if ((!CGRectContainsRect(draggableFrame, rectToCheckBounds)) || (CGRectIntersectsRect(rectToCheckBounds, self.targetNumberFrame) && ![self doesTargetDecimalAndValueMatchNumber:otherNumber]) ){
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
    BigNumber *blocker;
    CGRect bottomArea = CGRectMake(self.gridFrame.frame.origin.x, self.gridFrame.frame.size.height-10, self.gridFrame.frame.size.width, self.gridFrame.frame.size.height);
    CGRect swipeDownArea = CGRectMake(prevNum.frame.origin.x, prevNum.frame.origin.y+78, prevNum.frame.size.width, 78);
    BOOL isTargetBelow = CGRectIntersectsRect(swipeDownArea, self.targetNumberFrame);
    
    BOOL isANumInSpawnSpot = NO;
    for (BigNumber *oldNum in self.onScreenNums) {
        if (CGRectIntersectsRect(oldNum.frame, swipeDownArea)) {
            isANumInSpawnSpot = YES;
            blocker = oldNum;
        }
    }
    if (!(CGRectIntersectsRect(prevNum.frame, bottomArea))) {
        BOOL hitWall = NO;
        if (isANumInSpawnSpot) {
            blocker.center = CGPointMake(blocker.center.x, blocker.center.y+80);
            NSMutableArray *moveNums = [NSMutableArray arrayWithObjects:blocker, prevNum, nil];
            hitWall = [self checkNumberCollisionWithNumber:blocker andTranslation:CGPointMake(0, 80) andMovedNums:moveNums andCanAdd:NO];
        }
        if (!hitWall && !isTargetBelow) {
            NSDecimalNumber *decNum1 = prevNum.value;
            NSDecimalNumber *decNum2 = val;
            
            NSDecimalNumber *subVal = [decNum1 decimalNumberBySubtracting:decNum2];
            int labelLength = 58*subVal.stringValue.length;
            if ([subVal.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            int oldXOffsett = 0;
            if(val.floatValue > 1.0){
                if (prevNum.value.stringValue.length > subVal.stringValue.length && val.floatValue > 1) {
                    oldXOffsett = 60*(prevNum.value.stringValue.length - subVal.stringValue.length);
                }
            }
            else{
                NSLog(@"pulling decimal part");
                offest = prevNum.decimalPosition.doubleValue - 58;
                NSLog(@"%d", offest);
            }
            
            BigNumber *subNumber = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x+oldXOffsett, prevNum.frame.origin.y, labelLength, 78) andValue:subVal];
            subNumber.userInteractionEnabled = YES;
            
            DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)
                                                threshold:labelLength];
            [subNumber addGestureRecognizer:gesture3];
            
            [self.onScreenNums removeObject:prevNum];
            [prevNum removeFromSuperview];
            
            // add it
            if ([subVal compare:[NSNumber numberWithInt:0]] != NSOrderedSame) {
                [self.view addSubview:subNumber];
                [self.onScreenNums addObject:subNumber];
            }
            
            labelLength = 58*decNum2.stringValue.length;
            if ([decNum2.stringValue rangeOfString:@"."].location != NSNotFound) {
                //labelLength -= 30;
            }
            BigNumber *newNum = [[BigNumber alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x + offest+1, subNumber.frame.origin.y, labelLength, 78) andValue:decNum2];
            newNum.userInteractionEnabled = YES;
            
            DirectionPanGestureRecognizer *gesture4 = [[DirectionPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(labelDragged:)
                                                threshold:labelLength];
            [newNum addGestureRecognizer:gesture4];
            
            // add it
            if ([newNum.value compare:[NSNumber numberWithInt:0]] != NSOrderedSame && newNum.value != subNumber.value) {
                [self.view insertSubview:newNum belowSubview:subNumber];
                [self.onScreenNums addObject:newNum];
                
                UILabel *cover = [[UILabel alloc] initWithFrame:CGRectMake(prevNum.frame.origin.x +offest+1, subNumber.frame.origin.y, 58, 78)];
                cover.textColor = [UIColor whiteColor];
                cover.font = [UIFont fontWithName:@"Futura" size:95];
                [self.view addSubview:cover];
                if(newNum.value.floatValue < 1){
                    cover.text = @"0";
                    [self.view sendSubviewToBack:cover];
                } else {
                    cover.text = digit;
                    [self.view bringSubviewToFront:cover];
                }
                
                
                
                [UIView animateWithDuration:0.75
                                 animations:^{
                                     [cover setTransform:CGAffineTransformMakeTranslation(0, 80)];
                                     [newNum setTransform:CGAffineTransformMakeTranslation(0, 80)];
                                 } completion:^(BOOL finished) {
                                     [cover removeFromSuperview];
                                     [UIView animateWithDuration:0.5
                                                       animations:^{
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
    
    for (UILabel *v in self.targetNums) {
        [v removeFromSuperview];
    }
    [self.targetNums removeAllObjects];
    
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

- (IBAction)targetPressed:(UIButton *)sender{
    
    for (UILabel *v in self.targetNums) {
        [v removeFromSuperview];
    }
    [self.targetNums removeAllObjects];

    if ([self.numberDisplay.text hasPrefix:@"."]) {
        NSString *withZero = [@"0" stringByAppendingString:self.numberDisplay.text];
        self.numberDisplay.text = withZero;
    }
    
    if ([self.numberDisplay.text rangeOfString:@"."].location == NSNotFound){
        self.targetDecimalLoc = 813;
    }
    
    NSMutableArray *targetNumberArray = [[NSMutableArray alloc] init];
    for (int i =0; i < self.numberDisplay.text.length; i++){
        NSString *charNum = [NSString stringWithFormat:@"%c",[self.numberDisplay.text characterAtIndex:i]];
        targetNumberArray[i] = charNum;
    }
    float targetStartingX = 813 - 60*[targetNumberArray count];
    self.targetValue = [NSDecimalNumber decimalNumberWithString:self.numberDisplay.text];
    self.targetNumberFrame = CGRectMake(targetStartingX, 584, 60*[targetNumberArray count], 78);

    for (NSString *digit in targetNumberArray) {
        if ([digit isEqualToString:@"."]){
            self.targetDecimalLoc = targetStartingX;
        }
        UILabel *newDigit = [[UILabel alloc] init];
        if ([targetNumberArray indexOfObject:digit] != 0 && [targetNumberArray indexOfObject:digit] != [targetNumberArray count]-1) {
            newDigit.frame = CGRectMake(targetStartingX-1, 584, 60, 78);
        } else if ([targetNumberArray indexOfObject:digit] == 0) {
            newDigit.frame = CGRectMake(targetStartingX, 584, 60, 78);
        } else {
            newDigit.frame = CGRectMake(targetStartingX-1, 584, 58, 78);
        }
        if ([targetNumberArray count] == 1) {
            newDigit.frame = CGRectMake(targetStartingX, 584, 58, 78);
        }
        newDigit.text = digit;
        newDigit.textAlignment = UITextAlignmentCenter;
        newDigit.font = [UIFont fontWithName:@"Futura" size:95];
        [newDigit setBackgroundColor:[UIColor colorWithRed:5/255.0 green:83/255.0 blue:117/255.0 alpha:1.0]];
        newDigit.textColor = [UIColor colorWithRed:254/255.0 green:203/255.0 blue:73/255.0 alpha:1.0];
        [self.view addSubview:newDigit];
        targetStartingX +=60;
        [self.targetNums addObject:newDigit];
        
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

- (IBAction)submitPressed:(UIButton *)sender {
    self.verticalSpawnOffset = 104;
    
    int labelLength = (58*(self.numberDisplay.text.length));
    if ([self.numberDisplay.text hasSuffix:@"."]) {
        labelLength -= 58;
    }
    if([self.numberDisplay.text hasPrefix:@"."]){
        labelLength += 58;
    }

    CGRect potentialFrame = CGRectMake(154, self.verticalSpawnOffset, labelLength, 78);
    for (int i = 0; i<=8; i++) {
        for (BigNumber *oldNum in self.onScreenNums) {
            if (CGRectIntersectsRect(oldNum.frame, potentialFrame)) {
                self.verticalSpawnOffset += 160;
                potentialFrame = CGRectMake(154, self.verticalSpawnOffset, labelLength, 78);
            }
        }
    }
    
    
    BOOL hitWall = NO;
    
    if (!hitWall && ![self.numberDisplay.text isEqualToString:@""] && (self.verticalSpawnOffset < 700)) {
        BigNumber *newNumber = [[BigNumber alloc] initWithFrame:potentialFrame
                                                       andValue:[NSDecimalNumber decimalNumberWithString:self.numberDisplay.text]];
        [self.view addSubview:newNumber];
        //newNumber.center = CGPointMake(self.view.center.y, 73);
        [self.onScreenNums addObject:newNumber];
        DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(labelDragged:)
                                            threshold:labelLength];
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
            [self.view bringSubviewToFront:self.divBy10];
        }
        if (self.numTimesTenDecMovers > 0) {
            self.multBy10.hidden = NO;
            self.multCount.hidden = NO;
            [self.view bringSubviewToFront:self.multBy10];
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

- (IBAction)restartButtonPressed:(UIButton *)sender {
    [self createLevelWithLevelNum:self.lastLevelNum];
}

- (IBAction)hideTextButtonPressed:(id)sender {
    self.hideTextView.hidden = !self.hideTextView.hidden;
    self.menuButton.enabled = !self.menuButton.enabled;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


//using menu to create level
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    self.menuPopover = [(UIStoryboardPopoverSegue*)segue popoverController];
    [segue.destinationViewController setDelegate:self];
}

- (void)createLevelWithLevelNum:(int)levNum;
{
    NSDictionary *levelDict = [self returnDictionaryForLevel:levNum];
    NSDecimalNumber *targetNum = [levelDict objectForKey:@"targetNumber"];
    NSArray *componentNums = [levelDict objectForKey:@"componentNumbers"];
    
    self.lastLevelNum = levNum;
    [self clearNumber:nil];
    [self createTargetWithNum:targetNum];
    for (NSDecimalNumber *compNum in componentNums) {
        [self createComponentNumWithNum:compNum];
    }
    
}

- (void)createTargetWithNum:(NSDecimalNumber*)num
{
    for (UILabel *v in self.targetNums) {
        [v removeFromSuperview];
    }
    [self.targetNums removeAllObjects];
    
    if ([num.stringValue hasPrefix:@"."]) {
        NSString *withZero = [@"0" stringByAppendingString:num.stringValue];
        self.numberDisplay.text = withZero;
    }
    
    if ([num.stringValue rangeOfString:@"."].location == NSNotFound){
        self.targetDecimalLoc = 813;
    }
    
    NSMutableArray *targetNumberArray = [[NSMutableArray alloc] init];
    for (int i =0; i < num.stringValue.length; i++){
        NSString *charNum = [NSString stringWithFormat:@"%c",[num.stringValue characterAtIndex:i]];
        targetNumberArray[i] = charNum;
    }
    float targetStartingX = 813 - 60*[targetNumberArray count];
    self.targetValue = [NSDecimalNumber decimalNumberWithString:num.stringValue];
    self.targetNumberFrame = CGRectMake(targetStartingX, 584, 60*[targetNumberArray count], 78);
    
    for (NSString *digit in targetNumberArray) {
        if ([digit isEqualToString:@"."]){
            self.targetDecimalLoc = targetStartingX;
        }
        UILabel *newDigit = [[UILabel alloc] init];
        if ([targetNumberArray indexOfObject:digit] != 0 && [targetNumberArray indexOfObject:digit] !=[targetNumberArray count]-1) {
            newDigit.frame = CGRectMake(targetStartingX-1, 584, 60, 78);
        } else if ([targetNumberArray indexOfObject:digit] == 0) {
            newDigit.frame = CGRectMake(targetStartingX, 584, 60, 78);
        } else {
            newDigit.frame = CGRectMake(targetStartingX-1, 584, 58, 78);
        }
        if ([targetNumberArray count] == 1) {
            newDigit.frame = CGRectMake(targetStartingX, 584, 58, 78);
        }
        newDigit.text = digit;
        newDigit.textAlignment = UITextAlignmentCenter;
        newDigit.font = [UIFont fontWithName:@"Futura" size:95];
        [newDigit setBackgroundColor:[UIColor colorWithRed:5/255.0 green:83/255.0 blue:117/255.0 alpha:1.0]];
        newDigit.textColor = [UIColor colorWithRed:254/255.0 green:203/255.0 blue:73/255.0 alpha:1.0];
        [self.view addSubview:newDigit];
        targetStartingX +=60;
        [self.targetNums addObject:newDigit];
        
    }

}

- (void)createComponentNumWithNum:(NSDecimalNumber*)num
{
    self.verticalSpawnOffset = 104;
    
    int labelLength = (58*num.stringValue.length);
    if ([num.stringValue hasSuffix:@"."]) {
        labelLength -= 58;
    }
    if([num.stringValue hasPrefix:@"."]){
        labelLength += 58;
    }
    
    CGRect potentialFrame = CGRectMake(153, self.verticalSpawnOffset, labelLength, 78);
    for (int i = 0; i<=8; i++) {
        for (BigNumber *oldNum in self.onScreenNums) {
            if (CGRectIntersectsRect(oldNum.frame, potentialFrame)) {
                self.verticalSpawnOffset += 160;
                potentialFrame = CGRectMake(154, self.verticalSpawnOffset, labelLength, 78);
            }
        }
    }
 
    BOOL hitWall = NO;
    
    if (!hitWall && ![num.stringValue isEqualToString:@""] && (self.verticalSpawnOffset < 700)) {
        BigNumber *newNumber = [[BigNumber alloc] initWithFrame:potentialFrame
                                                       andValue:[NSDecimalNumber decimalNumberWithString:num.stringValue]];
        [self.view addSubview:newNumber];
        //newNumber.center = CGPointMake(self.view.center.y, 73);
        [self.onScreenNums addObject:newNumber];
        DirectionPanGestureRecognizer *gesture3 = [[DirectionPanGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(labelDragged:)
                                                   threshold:labelLength];
        [newNumber addGestureRecognizer:gesture3];
        [newNumber wobbleAnimation];
    }

}

-(NSDictionary *)returnDictionaryForLevel:(int)levelNum {
    
    switch (levelNum) {
            
            // move
        case 1:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"8"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"8"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // add
        case 2:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"5"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"2"],
                      [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // line up, add
        case 3:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"15"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"11"],
                      [NSDecimalNumber decimalNumberWithString:@"4"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decompose
        case 4:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"40"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"42"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decompose with distractors
        case 5:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"137"],
                      [NSDecimalNumber decimalNumberWithString:@"3041"],
                      [NSDecimalNumber decimalNumberWithString:@"302"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            
            // add, decompose
        case 6:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"3"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"9"],
                      [NSDecimalNumber decimalNumberWithString:@"4"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decompose, add
        case 7:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"15"],
                      [NSDecimalNumber decimalNumberWithString:@"26"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // add, decompose, with distractor
        case 8:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"15"],
                      [NSDecimalNumber decimalNumberWithString:@"9"],
                      [NSDecimalNumber decimalNumberWithString:@"26"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // add, decompose, with distractors
        case 9:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"8"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"3"],
                      [NSDecimalNumber decimalNumberWithString:@"9"],
                      [NSDecimalNumber decimalNumberWithString:@"2"],
                      [NSDecimalNumber decimalNumberWithString:@"7"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decompose with distractors
        case 10:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"7"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"737"],
                      [NSDecimalNumber decimalNumberWithString:@"7373"],
                      [NSDecimalNumber decimalNumberWithString:@"3.7"],
                      [NSDecimalNumber decimalNumberWithString:@"773"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            
            // add, decompose, with distractors
        case 11:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"2"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"18"],
                      [NSDecimalNumber decimalNumberWithString:@"21"],
                      [NSDecimalNumber decimalNumberWithString:@"24"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // add, decompose, with distractors
        case 12:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"3"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"19"],
                      [NSDecimalNumber decimalNumberWithString:@"51"],
                      [NSDecimalNumber decimalNumberWithString:@"85"],
                      [NSDecimalNumber decimalNumberWithString:@"34"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decimals
        case 13:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"0.3"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"41.3"],
                      [NSDecimalNumber decimalNumberWithString:@"0.03"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decimals
        case 14:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"0.6"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"26.2"],
                      [NSDecimalNumber decimalNumberWithString:@"22.6"],
                      [NSDecimalNumber decimalNumberWithString:@"0.06"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decimals
        case 15:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"0.5"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"6.2"],
                      [NSDecimalNumber decimalNumberWithString:@"2.3"],
                      [NSDecimalNumber decimalNumberWithString:@"0.6"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            
            // add, decompose, with distractors
        case 16:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@".8"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@".3"],
                      [NSDecimalNumber decimalNumberWithString:@".9"],
                      [NSDecimalNumber decimalNumberWithString:@".2"],
                      [NSDecimalNumber decimalNumberWithString:@".7"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            // decimals
        case 17:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@"0.02"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@"1.42"],
                      [NSDecimalNumber decimalNumberWithString:@"6.28"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
            
            // decompose, add
        case 18:
            return  [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSDecimalNumber decimalNumberWithString:@".30"], @"targetNumber",
                     [NSArray arrayWithObjects:
                      [NSDecimalNumber decimalNumberWithString:@".15"],
                      [NSDecimalNumber decimalNumberWithString:@".26"], nil ], @"componentNumbers",
                     [NSNumber numberWithInt:0], @"numRightArrows",
                     [NSNumber numberWithInt:0], @"numLeftArrows", nil];
            
    }
    
    
    
    // default returns level 1
    return  [NSDictionary dictionaryWithObjectsAndKeys:
             [NSDecimalNumber decimalNumberWithString:@"25"], @"targetNumber",
             [NSArray arrayWithObjects:
              [NSDecimalNumber decimalNumberWithString:@"25"],
              [NSDecimalNumber decimalNumberWithString:@"3"], nil ], @"componentNumbers",
             [NSNumber numberWithInt:0], @"numRightArrows",
             [NSNumber numberWithInt:0], @"numLeftArrows", nil];
}


@end
