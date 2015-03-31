//
//  GaugesDashboardViewController.m
//  GaugesDashboard
//
//  Created by Alison Clarke on 27/08/2014.
//
//  Copyright 2014 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "GaugesDashboardViewController.h"
#import "GaugesDashboardRoomInfo.h"
#import "GaugesDashboardInformationView.h"
#import "GaugesDashboardRoomView.h"
#import "GaugesDashboardLinearNeedle.h"
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"
#import <sys/utsname.h>

@interface GaugesDashboardViewController ()

@property (strong, nonatomic) NSArray *roomData;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) GaugesDashboardRoomView *selectedRoom;
@property (strong, nonatomic) NSArray *roomArray;
@property (strong, nonatomic) SGaugeRadial *insideTempGauge;
@property (strong, nonatomic) SGaugeLinear *outsideTempGauge;

@property (weak, nonatomic) IBOutlet UIView *layoutView;
@property (weak, nonatomic) IBOutlet GaugesDashboardInformationView *informationView;
@property (weak, nonatomic) IBOutlet UIView *insideTempGaugePlaceholder;
@property (weak, nonatomic) IBOutlet UIView *outsideTempGaugePlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIView *loungeView;
@property (weak, nonatomic) IBOutlet UIView *kitchenView;
@property (weak, nonatomic) IBOutlet UIView *bathroomView;
@property (weak, nonatomic) IBOutlet UIView *bed1View;
@property (weak, nonatomic) IBOutlet UIView *bed2View;
@property (weak, nonatomic) IBOutlet UIView *bed3View;

- (IBAction)pickRoom:(UITapGestureRecognizer *)sender;

@end

@implementation GaugesDashboardViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createDataFormatter];
  [self createTimer];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"GaugesDashboardRoomData" ofType:@"plist"];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSMutableArray *roomData = [NSMutableArray new];
    NSDictionary *roomDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    for (NSString *key in @[@"lounge", @"kitchen", @"bathroom", @"bed 1", @"bed 2", @"bed 3"]) {
      NSDictionary *dictionary = [roomDictionary valueForKey:key];
      GaugesDashboardRoomInfo *roomInfo = [[GaugesDashboardRoomInfo alloc] initWithKey:key andDictionary:dictionary];
      [roomData addObject:roomInfo];
    }
    self.roomData = [[NSArray arrayWithArray:roomData] copy];
  }
  
  [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (!self.insideTempGauge) {
    [self createDataFormatter];
    [self createTimer];
    
    [self setupView];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  if ([self isMovingFromParentViewController]) {
    self.dateFormatter = nil;
    
    [self.timer invalidate];
    
    self.informationView = nil;
    
    // Throw away the gauges
    [self.insideTempGauge removeFromSuperview];
    self.insideTempGauge = nil;
    
    [self.outsideTempGauge removeFromSuperview];
    self.outsideTempGauge = nil;
  }
}

- (void)createDataFormatter {
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"HH:mm"];
}

- (void)createTimer {
  // Start timer
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(updateClock)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)setupView {
  self.roomArray = @[self.loungeView, self.kitchenView, self.bathroomView, self.bed1View, self.bed2View, self.bed3View];
  for (int i = 0; i < self.roomArray.count; ++i) {
    GaugesDashboardRoomView *roomView = self.roomArray[i];
    [roomView setDataAndStyleRoomView:self.roomData[i]];
  }
  
  [self createInsideTempGauge];
  [self createOutsideTempGauge];
  
  [self updateClock];
  
  [self setRoomSelected: (self.selectedRoom) ? self.selectedRoom : self.roomArray[1]];
}

- (void)createInsideTempGauge {
  // Do any additional setup after loading the view, typically from a nib.
  self.insideTempGauge = [[SGaugeRadial alloc] initWithFrame:self.insideTempGaugePlaceholder.bounds fromMinimum:@0 toMaximum:@100];
  self.insideTempGauge.style = [SGaugeLightStyle new];
  [self.insideTempGaugePlaceholder addSubview:self.insideTempGauge];
  
  [self.insideTempGaugePlaceholder bringSubviewToFront:self.maxLabel];
  [self.insideTempGaugePlaceholder bringSubviewToFront:self.currentValueLabel];
  [self.insideTempGaugePlaceholder bringSubviewToFront:self.currentLabel];
  
  self.insideTempGauge.clipsToBounds = NO;
  
  // Set the angle to start at the bottom of the gauge and go round to 1 o'clock
  self.insideTempGauge.arcAngleStart = - M_PI_2 * 2;
  self.insideTempGauge.arcAngleEnd = M_PI_2 * 0.425;
  
  // Gauge style
  self.insideTempGauge.style.borderIsFullCircle = YES;
  self.insideTempGauge.style.showTickLabels = NO;
  self.insideTempGauge.style.majorTickColor = [UIColor clearColor];
  self.insideTempGauge.style.minorTickColor = [UIColor clearColor];
  self.insideTempGauge.style.showGlassEffect = NO;
  self.insideTempGauge.style.tickBaselineColor = [UIColor whiteColor];
  self.insideTempGauge.style.tickBaselineWidth = 16;
  self.insideTempGauge.style.outerBackgroundColor = [UIColor gaugesDashboardBlueColor];
  self.insideTempGauge.style.innerBackgroundColor = [UIColor gaugesDashboardBlueColor];
  self.insideTempGauge.needle.hidden = YES;
  
  // Add a clear bevel to inset the gauge so that it does not get cropped at the edges
  self.insideTempGauge.style.bevelPrimaryColor = [UIColor clearColor];
  self.insideTempGauge.style.bevelSecondaryColor = [UIColor clearColor];
  self.insideTempGauge.style.bevelWidth = 20;
  
  // Update gauge to show value
  [self updateGauge:[((GaugesDashboardRoomInfo *)self.roomData[1]) percentageTemperature]];
  self.insideTempGauge.style.qualitativeRangeOuterPosition = 0.95;
  self.insideTempGauge.style.qualitativeRangeInnerPosition = 0.90;
}

- (void)createOutsideTempGauge {
  // Create gauge and set its default style and value
  self.outsideTempGauge = [[SGaugeLinear alloc] initWithFrame:self.outsideTempGaugePlaceholder.bounds];
  self.outsideTempGauge.style = [SGaugeLightStyle new];
  self.outsideTempGauge.value = 14;
  [self.outsideTempGaugePlaceholder addSubview:self.outsideTempGauge];
  
  // Set delegate
  self.outsideTempGauge.delegate = self;
  
  // Set min/max
  self.outsideTempGauge.minimumValue = @-10;
  self.outsideTempGauge.maximumValue = @41;
  
  // Set tick frequency
  self.outsideTempGauge.axis.majorTickFrequency = 1;
  
  // Add qualitative ranges
  self.outsideTempGauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:self.outsideTempGauge.minimumValue
                                                                               maximum:@3
                                                                                 color:[UIColor gaugesDashboardLightBlueColor]],
                                              [SGaugeQualitativeRange rangeWithMinimum:@28
                                                                               maximum:self.outsideTempGauge.maximumValue
                                                                                 color:[UIColor gaugesDashboardRedColor]]];
  
  // Use a custom needle
  GaugesDashboardLinearNeedle *needle = [[GaugesDashboardLinearNeedle alloc]
                                         initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  4,
                                                                  self.outsideTempGauge.bounds.size.height)];
  needle.needleValue = self.outsideTempGauge.value;
  self.outsideTempGauge.needle = needle;
  
  // Style gauge
  self.outsideTempGauge.style.outerBackgroundColor = [UIColor clearColor];
  self.outsideTempGauge.style.innerBackgroundColor = [UIColor clearColor];
  self.outsideTempGauge.style.showGlassEffect = NO;
  self.outsideTempGauge.style.tickBaselineColor = [UIColor whiteColor];
  self.outsideTempGauge.style.tickBaselineWidth = 4;
  self.outsideTempGauge.style.tickBaselinePosition = 0.65;
  self.outsideTempGauge.style.tickLabelOffsetFromBaseline = -14;
  self.outsideTempGauge.style.tickLabelColor = [UIColor whiteColor];
  self.outsideTempGauge.style.tickLabelFont = [UIFont shinobiFontOfSize:18];
  self.outsideTempGauge.style.majorTickSize = CGSizeZero;
  self.outsideTempGauge.style.needleColor = [UIColor gaugesDashboardOrangeColor];
  self.outsideTempGauge.style.needleWidth = 4;
  self.outsideTempGauge.style.qualitativeRangeInnerPosition = self.outsideTempGauge.style.tickBaselinePosition;
  self.outsideTempGauge.style.qualitativeRangeOuterPosition = 1;
}

- (void)updateClock {
  NSDate *now = [NSDate date];
  self.timeLabel.text = [self.dateFormatter stringFromDate:now];
}

- (IBAction)pickRoom:(UITapGestureRecognizer *)sender {
  GaugesDashboardRoomView *tappedRoomView = ((GaugesDashboardRoomView *)sender.view);
  for (GaugesDashboardRoomView *roomView in self.roomArray) {
    if ([tappedRoomView isEqual:roomView]) {
      self.selectedRoom = roomView;
      [self setRoomSelected:roomView];
    } else {
      [roomView clearSelected];
    }
  }
}

- (void)setRoomSelected:(GaugesDashboardRoomView*)selectedRoom {
  [selectedRoom setSelected];
  [self.informationView updateInfo:selectedRoom.roomData];
  self.currentValueLabel.text = [selectedRoom.roomData temperatureFormattedAsString];
  self.maxLabel.text = [selectedRoom.roomData maxTemperatureFormattedAsString];
  [self updateGauge:[selectedRoom.roomData percentageTemperature]];
}

- (void)updateGauge:(NSNumber*)percentageTemperature {
  // Check whether the device is OK to animate the qualitative range change
  if ([self deviceCanCopeWithQualitativeRangeAnimations]) {
    // Animate the value from 0.001 to the percentageTemperature
    NSDictionary *temperatureDictionary = @{@"current": @0.001, @"max": percentageTemperature};
    [self performSelector:@selector(animateGaugeValue:)
               withObject:temperatureDictionary
               afterDelay:0];
  } else {
    self.insideTempGauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                                maximum:percentageTemperature
                                                                                  color:[UIColor gaugesDashboardOrangeColor]]];
  }
}

- (void)animateGaugeValue:(NSDictionary *)state {
  NSNumber *current = state[@"current"];
  NSNumber *max = state[@"max"];
  
  if ([current floatValue] >= [max floatValue]) {
    // If we have overshot our max temperature then set that displayed value to be equal to
    // our max temperature and return, to end the recursion
    self.insideTempGauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                                maximum:max
                                                                                  color:[UIColor gaugesDashboardOrangeColor]]];
    return;
  }
  
  // Increment the value shown on the gauge's qualitative indicator
  self.insideTempGauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                              maximum:current
                                                                                color:[UIColor gaugesDashboardOrangeColor]]];
  
  // Recursively increment the temperature upwards in increments of 4.
  NSDictionary *temperatureDictionary = @{@"current": @(current.doubleValue + 4), @"max": max};
  double delayInSeconds = 0.01;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self animateGaugeValue:temperatureDictionary];
  });
}

- (BOOL)deviceCanCopeWithQualitativeRangeAnimations {
  struct utsname systemInfo;
  uname(&systemInfo);
  
  NSString *platform = [NSString stringWithCString:systemInfo.machine
                                          encoding:NSUTF8StringEncoding];
  
  return ![platform hasPrefix:@"iPad3"];
}

#pragma mark - SGaugeDelegate methods

- (void)gauge:(SGauge *)gauge alterTickLabel:(UILabel *)tickLabel atValue:(CGFloat)value {
  // Round the value before comparing against specific values. (Our tick frequency is 1 so
  // the values we're expecting are integers)
  NSInteger roundedValue = lroundf(value);
  
  if (roundedValue == [gauge.maximumValue integerValue] - 1) {
    // We're at the end of the gauge, so show the axis unit rather than the value, and
    // make it bigger
    tickLabel.text = @"°C";
    tickLabel.font = [tickLabel.font fontWithSize:22];
  } else if (roundedValue != 3 && roundedValue != 28) {
    // Hide all tick labels but the ones at 3 and 28 (either end of our qualitative ranges)
    tickLabel.text = @"";
  }
  
  [tickLabel sizeToFit];
}

- (void)gauge:(SGauge *)gauge alterNeedle:(UIView *)needle onChangeFromValue:(CGFloat)oldValue {
  // Update the needle's value
  ((GaugesDashboardLinearNeedle *)needle).needleValue = gauge.value;
}

@end
