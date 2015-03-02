//
//  GaugesDashboardRoomView.m
//  GaugesDashboard
//
//  Created by Daniel Allsop on 24/02/2015.
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

#import "GaugesDashboardRoomView.h"
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"

@interface GaugesDashboardRoomView ()

@property (strong, nonatomic) UILabel *roomNameLabel;
@property (strong, nonatomic) UILabel *temperatureLabel;

@end

@implementation GaugesDashboardRoomView

- (instancetype)initWithFrame:(CGRect)frame roomData:(GaugesDashboardRoomInfo *)roomData {
  self = [super initWithFrame:frame];
  if (self) {
    self.roomData = roomData;
    
    self.backgroundColor = [UIColor gaugesDashboardGrayBlueColor];
    self.layer.borderColor = [UIColor gaugesDashboardOrangeColor].CGColor;
    
    BOOL isBigView = (CGRectGetHeight(frame) > 90);
    CGFloat roomNameLabelFontSize = isBigView ? 20 : 16;
    CGFloat temperatureLabelFontSize = isBigView ? 47 : 40;
    
    // Position and size roomNameLabel to fill top ~20% of uiview
    self.roomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetHeight(frame) * 0.08,
                                                                   CGRectGetWidth(frame),
                                                                   CGRectGetHeight(frame) * 0.2)];
    [self styleUILabel:self.roomNameLabel textColor:[UIColor whiteColor]
                  font:[UIFont shinobiFontOfSize:roomNameLabelFontSize]
                  text:self.roomData.roomName];
    [self addSubview:self.roomNameLabel];
    
    // Position and size temperatureLabel to fill bottom 80% of uiview
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetHeight(frame) * 0.2,
                                                                      CGRectGetWidth(frame),
                                                                      CGRectGetHeight(frame) * 0.8)];
    [self styleUILabel:self.temperatureLabel textColor:[UIColor gaugesDashboardOrangeColor]
                  font:[UIFont lightShinobiFontOfSize:temperatureLabelFontSize]
                  text:[NSString stringWithFormat:@"%zd", self.roomData.temperature]];
    [self addSubview:self.temperatureLabel];
  }
  return self;
}

- (void)styleUILabel:(UILabel *)label textColor:(UIColor *)textColor
                 font:(UIFont *)font text:(NSString *)text {
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = textColor;
  label.font = font;  
  label.text = text;
  [self addSubview:label];
}

- (void)setSelected {
  self.layer.borderWidth = 1;
}

- (void)clearSelected {
  self.layer.borderWidth = 0;
}

@end
