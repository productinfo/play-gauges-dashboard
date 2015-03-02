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
@property (assign, nonatomic) NSUInteger selectedRoom;

@property (strong, nonatomic) GaugesDashboardInformationView *informationView;
@property (strong, nonatomic) GaugesDashboardRoomView *loungeView;
@property (strong, nonatomic) GaugesDashboardRoomView *kitchenView;
@property (strong, nonatomic) GaugesDashboardRoomView *bathroomView;
@property (strong, nonatomic) GaugesDashboardRoomView *bed1View;
@property (strong, nonatomic) GaugesDashboardRoomView *bed2View;
@property (strong, nonatomic) GaugesDashboardRoomView *bed3View;
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
  
  self.dateFormatter = nil;
  
  [self.timer invalidate];
  
  for (GaugesDashboardRoomView *roomView in self.roomArray) {
    [roomView removeFromSuperview];
  }
  self.informationView = nil;
  self.loungeView = nil;
  self.kitchenView = nil;
  self.bathroomView = nil;
  self.bed1View = nil;
  self.bed2View = nil;;
  self.bed3View = nil;
  self.roomArray = nil;
  
  // Throw away the gauge
  [self.gauge removeFromSuperview];
  self.gauge = nil;
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
  
  CGFloat padding = 20;
  
  BOOL isBigView = (CGRectGetHeight(self.view.frame) > 700);
  CGFloat size = isBigView ? 110 : 80;
  
  CGFloat column1 = CGRectGetMaxX(self.timeLabel.frame) - (size * 3) - (padding * 2);
  CGFloat column2 = column1 + size + padding;
  CGFloat column3 = column2 + size + padding;
  
  CGFloat row1 = isBigView ? 0.40 : 0.43;
  row1 = (self.view.frame.size.height * row1) - (size + (padding / 2));
  CGFloat row2 = row1 + size + padding;
  
  self.loungeView = [[GaugesDashboardRoomView alloc] initWithFrame:CGRectMake(column1, row1, size, size)
                                                          roomData:self.roomData[0]];
  [self.view addSubview:self.loungeView];
  [self addTapGestureRecogniserToRoomView:self.loungeView];
  
  self.kitchenView = [[GaugesDashboardRoomView alloc] initWithFrame:CGRectMake(column2, row1, size, size)
                                                           roomData:self.roomData[1]];
  [self.view addSubview:self.kitchenView];
  [self addTapGestureRecogniserToRoomView:self.kitchenView];
  
  self.bathroomView = [[GaugesDashboardRoomView  alloc]initWithFrame:CGRectMake(column3, row1, size, size)
                                                            roomData:self.roomData[2]];
  [self.view addSubview:self.bathroomView];
  [self addTapGestureRecogniserToRoomView:self.bathroomView];
    
  self.bed1View = [[GaugesDashboardRoomView alloc] initWithFrame:CGRectMake(column1, row2, size, size)
                                                        roomData:self.roomData[3]];
  [self.view addSubview:self.bed1View];
  [self addTapGestureRecogniserToRoomView:self.bed1View];

  self.bed2View = [[GaugesDashboardRoomView  alloc]initWithFrame:CGRectMake(column2, row2, size, size)
                                                        roomData:self.roomData[4]];
  [self.view addSubview:self.bed2View];
  [self addTapGestureRecogniserToRoomView:self.bed2View];
  
  self.bed3View = [[GaugesDashboardRoomView alloc] initWithFrame:CGRectMake(column3, row2, size, size)
                                                        roomData:self.roomData[5]];
  [self.view addSubview:self.bed3View];
  [self addTapGestureRecogniserToRoomView:self.bed3View];
  
  self.roomArray = [NSArray arrayWithObjects:self.loungeView, self.kitchenView,
                        self.bathroomView, self.bed1View, self.bed2View, self.bed3View, nil];
  
  [self createGauge];
  
  [self updateClock];
  
  [self setRoomSelected: (self.selectedRoom) ? self.roomArray[self.selectedRoom] : self.kitchenView];
  
  [self.view bringSubviewToFront:self.maxLabel];
  [self.view bringSubviewToFront:self.currentValueLabel];
  [self.view bringSubviewToFront:self.currentLabel];
}

- (void)addTapGestureRecogniserToRoomView:(GaugesDashboardRoomView *)roomView {
  UITapGestureRecognizer *roomTapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(pickRoom:)];
  roomTapGestureRecogniser.numberOfTapsRequired = 1;
  [roomView addGestureRecognizer:roomTapGestureRecogniser];
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
  
  // Set a bevel of width 20 to inset the gague so that it doesnot get cropped at the edges
  self.gauge.style.bevelPrimaryColor = [UIColor clearColor];
  self.gauge.style.bevelSecondaryColor = [UIColor clearColor];
  self.gauge.style.bevelWidth = 20;
  
  // Set up some qualitative ranges
  [self updateGauge:[((GaugesDashboardRoomInfo *)self.roomData[1]) percentageTemperature]];
  self.gauge.style.qualitativeRangeOuterPosition = 0.95;
  self.gauge.style.qualitativeRangeInnerPosition = 0.90;
}

- (void)updateClock {
  NSDate *now = [NSDate date];
  self.timeLabel.text = [self.dateFormatter stringFromDate:now];
}

- (void)pickRoom:(UITapGestureRecognizer *)sender {
  CGPoint location = [sender locationInView:self.view];
  for (GaugesDashboardRoomView *roomView in self.roomArray) {
    if (CGRectContainsPoint(roomView.frame, location)) {
      self.selectedRoom = [self.roomArray indexOfObject:roomView];
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
  [self performSelector:@selector(animateGaugevalue:)
             withObject:temperatureDictionary
             afterDelay:0];
}

- (void)animateGaugevalue:(NSDictionary *)state {
  NSNumber *current = state[@"current"];
  NSNumber *max = state[@"max"];
  
  if ([current floatValue] >= [max floatValue]) {
    // Check that we haven't undershot our target temperature since we increment the
    // temperature upwards from 0.001 in increments of 4.
    self.gauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                      maximum:max
                                                                        color:[UIColor gaugesDashboardOrangeColor]]];
    return;
  }
  
  // Increment the value shown by the gauge in increments of 4 every 0.01 second
  self.gauge.qualitativeRanges = @[[SGaugeQualitativeRange rangeWithMinimum:@0
                                                                    maximum:current
                                                                      color:[UIColor gaugesDashboardOrangeColor]]];
  // Temporarily persist our current progress animating the gague value
  NSDictionary *temperatureDictionary = @{@"current": @(current.doubleValue + 4), @"max": max};
  
  // Call the current method we are in recursively untill we get to our target temperature
  [self performSelector:_cmd withObject:temperatureDictionary afterDelay:0.01];
}

@end
