//
//  GaugesDashboardInformationView.m
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

#import "GaugesDashboardInformationView.h"
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"

@interface GaugesDashboardInformationView ()

@property (strong, nonatomic) UILabel *roomNameLabel;
@property (strong, nonatomic) UILabel *lightsLabel;
@property (strong, nonatomic) UILabel *lightsStateLabel;
@property (strong, nonatomic) UILabel *powerUsageLabel;
@property (strong, nonatomic) UILabel *kwhLabel;
@property (strong, nonatomic) UILabel *rateLabel;

@end

@implementation GaugesDashboardInformationView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor gaugesDashboardDarkBlueColor];
    
    self.roomNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 27, 152, 35)];
    [self styleUILabel:self.roomNameLabel textColor:[UIColor whiteColor]
                   font:[UIFont extraBoldShinobiFontOfSize:32] text:nil];
    
    self.lightsLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 70, 152, 31)];
    [self styleUILabel:self.lightsLabel textColor:[UIColor whiteColor]
                   font:[UIFont shinobiFontOfSize:20] text:@"Lights"];
    
    self.lightsStateLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 86, 152, 70)];
    [self styleUILabel:self.lightsStateLabel textColor:[UIColor gaugesDashboardOrangeColor]
                   font:[UIFont shinobiFontOfSize:36] text:nil];
    
    self.powerUsageLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 149, 152, 25)];
    [self styleUILabel:self.powerUsageLabel textColor:[UIColor whiteColor]
                   font:[UIFont shinobiFontOfSize:20] text:@"Power Usage"];
    
    self.kwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 177, 73, 32)];
    [self styleUILabel:self.kwhLabel textColor:[UIColor gaugesDashboardOrangeColor]
                   font:[UIFont shinobiFontOfSize:20] text:nil];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 192, 80, 21)];
    [self styleUILabel:self.rateLabel textColor:[UIColor lightGrayColor]
                   font:[UIFont extraBoldShinobiFontOfSize:18] text:nil];;
    
    // Create a UIView to set the background color to be the same as that of the app background
    // color in places where we don't want to see the information view background color
    NSInteger alteranteBackgroundColorViewSize = 100;
    UIView *alteranteBackgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(390 - alteranteBackgroundColorViewSize,
                                                                                    59,
                                                                                    alteranteBackgroundColorViewSize,
                                                                                    233 - 59)];
    alteranteBackgroundColorView.backgroundColor = [UIColor gaugesDashboardBlueColor];
    [self addSubview:alteranteBackgroundColorView];

  }
  return self;
}

- (void)styleUILabel:(UILabel *)label textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
  label.textAlignment = NSTextAlignmentLeft;
  label.textColor = textColor;
  label.font = font;
  label.text = text;
  [self addSubview:label];
}

- (void)updateInfo:(GaugesDashboardRoomInfo *)roomInfo {
  self.roomNameLabel.text = [roomInfo.roomName capitalizedString];
  self.lightsStateLabel.text = [roomInfo lightsFormattedAsString];
  
  NSMutableAttributedString *kwhLabelValueAttributedString =
    [[NSMutableAttributedString alloc] initWithString:[roomInfo totalPowerUsageFormattedAsString]];
  NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor gaugesDashboardOrangeColor],
                                          NSFontAttributeName: [UIFont shinobiFontOfSize:35]};
  [kwhLabelValueAttributedString setAttributes:attributes range:NSMakeRange(0, kwhLabelValueAttributedString.length)];
    
  NSMutableAttributedString *kwhLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@"kWh"];
    attributes = @{ NSForegroundColorAttributeName: [UIColor gaugesDashboardOrangeColor],
                               NSFontAttributeName: [UIFont shinobiFontOfSize:24]};
  [kwhLabelAttributedString setAttributes:attributes range:NSMakeRange(0, kwhLabelAttributedString.length)];
  [kwhLabelValueAttributedString appendAttributedString:kwhLabelAttributedString];
  self.kwhLabel.attributedText = kwhLabelValueAttributedString;
  
  [self.kwhLabel sizeToFit];
  
  self.rateLabel.text = [roomInfo powerUsageRateFormattedAsString];
  [self.rateLabel sizeToFit];
  
  [self.rateLabel setFrame:CGRectMake(CGRectGetMaxX(self.kwhLabel.frame) + 9,
                                      CGRectGetMinY(self.rateLabel.frame),
                                      CGRectGetWidth(self.rateLabel.frame),
                                      CGRectGetHeight(self.rateLabel.frame))];
}

@end
