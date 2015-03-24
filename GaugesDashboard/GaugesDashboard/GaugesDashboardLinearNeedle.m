//
//  GaugesDashboardLinearNeedle.m
//  GaugesDashboard
//
//  Created by Alison Clarke on 23/03/2015.
//
//  Copyright 2015 Scott Logic
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

#import "GaugesDashboardLinearNeedle.h"
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"

@interface GaugesDashboardLinearNeedle ()

@property (strong, nonatomic) UIView *needleView;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation GaugesDashboardLinearNeedle

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.layer.zPosition = 2;
    
    // Change anchor, and reposition
    self.layer.anchorPoint = CGPointMake(0.5, 1);
    self.frame = frame;
    
    // Add a label showing the temperature
    self.valueLabel = [UILabel new];
    self.valueLabel.text = @"00";
    self.valueLabel.font = [UIFont boldShinobiFontOfSize:18];
    self.valueLabel.textColor = [UIColor gaugesDashboardOrangeColor];
    [self.valueLabel sizeToFit];
    [self addSubview:self.valueLabel];
    
    // Add custom needle - a simple narrow UIView that's as tall as our frame less the label height
    CGFloat needleWidth = 4;
    self.needleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.valueLabel.frame.size.height,
                                                               needleWidth,
                                                               frame.size.height - self.valueLabel.frame.size.height)];
    self.needleView.backgroundColor = [UIColor gaugesDashboardOrangeColor];
    [self addSubview:self.needleView];
  }
  return self;
}

- (void)setNeedleValue:(CGFloat)needleValue {
  _needleValue = needleValue;
  self.valueLabel.text = [NSString stringWithFormat:@"%.f", needleValue];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Make sure the needle is in the center of the view
  self.valueLabel.center = CGPointMake(self.bounds.size.width/2,
                                       self.valueLabel.bounds.size.height/2);
  self.needleView.center = CGPointMake(self.bounds.size.width/2,
                                       self.valueLabel.bounds.size.height + self.needleView.bounds.size.height/2);
}

@end
