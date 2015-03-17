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
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"

@interface GaugesDashboardViewController ()

@property NSArray *roomData;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) GaugesDashboardRoomView *selectedRoom;

@property (strong, nonatomic) GaugesDashboardInformationView *informationView;
@property (strong, nonatomic) NSArray *roomArray;
@property (strong, nonatomic) SGaugeRadial *gauge;

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
  if (!self.gauge) {
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
    
    // Throw away the gauge
    [self.gauge removeFromSuperview];
    self.gauge = nil;
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
  self.informationView = [[GaugesDashboardInformationView alloc]initWithFrame:CGRectMake(90, 90, 390, 233)];
  [self.view addSubview:self.informationView];
  
  self.roomArray = @[self.loungeView, self.kitchenView, self.bathroomView, self.bed1View, self.bed2View, self.bed3View];
  for (int i = 0; i < self.roomArray.count; ++i) {
    GaugesDashboardRoomView *roomView = self.roomArray[i];
    [roomView setDataAndStyleRoomView:self.roomData[i]];
  }
  
  [self createGauge];
  
  [self updateClock];
  
  [self setRoomSelected: (self.selectedRoom) ? self.selectedRoom : self.roomArray[1]];
  
  [self.view bringSubviewToFront:self.maxLabel];
  [self.view bringSubviewToFront:self.currentValueLabel];
  [self.view bringSubviewToFront:self.currentLabel];
}

- (void)createGauge {
  // Do any additional setup after loading the view, typically from a nib.
  self.gauge = [[SGaugeRadial alloc] initWithFrame:CGRectMake(325, 123, 225, 225) fromMinimum:@0 toMaximum:@100];
  self.gauge.style = [SGaugeLightStyle new];
  [self.view addSubview:self.gauge];
  
  self.gauge.clipsToBounds = NO;
  
  // Set the angle to start at the bottom of the gauge and go round to 1 o'clock
  self.gauge.arcAngleStart = - M_PI_2 * 2;
  self.gauge.arcAngleEnd = M_PI_2 * 0.425;
  
  // Gauge style
  self.gauge.style.borderIsFullCircle = YES;
  self.gauge.style.showTickLabels = NO;
  self.gauge.style.majorTickColor = [UIColor clearColor];
  self.gauge.style.minorTickColor = [UIColor clearColor];
  self.gauge.style.showGlassEffect = NO;
  self.gauge.style.tickBaselineColor = [UIColor whiteColor];
  self.gauge.style.tickBaselineWidth = 16;
  self.gauge.style.outerBackgroundColor = [UIColor gaugesDashboardBlueColor];
  self.gauge.style.innerBackgroundColor = [UIColor gaugesDashboardBlueColor];
  self.gauge.needle.hidden = YES;
  
  // Add a clear bevel to inset the gauge so that it does not get cropped at the edges
  self.gauge.style.bevelPrimaryColor = [UIColor clearColor];
  self.gauge.style.bevelSecondaryColor = [UIColor clearColor];
  self.gauge.style.bevelWidth = 20;
  
  // Update gauge to show value
  [self updateGauge:[((GaugesDashboardRoomInfo *)self.roomData[1]) percentageTemperature]];
  self.gauge.style.qualitativeRangeOuterPosition = 0.95;
  self.gauge.style.qualitativeRangeInnerPosition = 0.90;
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
  // Create animation effect starting from 0.001 and increaing in increments of 3 every 0.01 seconds
  NSDictionary *temperatureDictionary = @{@"current": @0.001, @"max": percentageTemperature};
  [self performSelector:@selector(animateGaugeValue:)
             withObject:temperatureDictionary
             afterDelay:0];
}

- (void)animateGaugeValue:(NSDictionary *)state {
  NSNumber *current = state[@"current"];
  NSNumber *max = state[@"max"];
  
  if ([current floatValue] >= [max floatValue]) {
    // If we have overshot our max temperature then set that displayed value to be equal to
    // our max temperature and return, to end the recursion
    self.gauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                      maximum:max
                                                                        color:[UIColor gaugesDashboardOrangeColor]]];
    return;
  }
  
  // Increment the value shown on the gauge's qualitative indicator
  self.gauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                    maximum:current
                                                                      color:[UIColor gaugesDashboardOrangeColor]]];
  
  // Recursively increment the temperature upwards from 0.001 in increments of 4.
  NSDictionary *temperatureDictionary = @{@"current": @(current.doubleValue + 4), @"max": max};
  double delayInSeconds = 0.01;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self animateGaugeValue:temperatureDictionary];
  });

}

@end
