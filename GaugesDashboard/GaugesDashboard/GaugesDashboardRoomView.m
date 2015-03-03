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

@implementation GaugesDashboardRoomView

- (void)setData:(GaugesDashboardRoomInfo *)roomData {
  self.backgroundColor = [UIColor gaugesDashboardGrayBlueColor];
  self.layer.borderColor = [UIColor gaugesDashboardOrangeColor].CGColor;
  
  self.roomData = roomData;
  self.roomNameLabel.text = self.roomData.roomName;
  self.temperatureLabel.text = [NSString stringWithFormat:@"%zd", self.roomData.temperature];
}

- (void)styleUILabel:(UILabel *)label textColor:(UIColor *)textColor
                 font:(UIFont *)font{
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = textColor;
  label.font = font;
  [self addSubview:label];
}

- (void)setSelected {
  self.layer.borderWidth = 1;
}

- (void)clearSelected {
  self.layer.borderWidth = 0;
}

@end
