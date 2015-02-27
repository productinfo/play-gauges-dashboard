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
#import "UIColor+GDColor.h"
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
    self.backgroundColor = [UIColor customDarkBlueColor];
    
    self.roomNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 27, 152, 35)];
    [self createUILabel:self.roomNameLabel textColor:[UIColor whiteColor]
                   font:[UIFont fontWithName:@"Roboto-Bold" size:32] text:nil];
    
    self.lightsLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 70, 152, 31)];
    [self createUILabel:self.lightsLabel textColor:[UIColor whiteColor]
                   font:[UIFont shinobiFontOfSize:20] text:@"Lights"];
    
    self.lightsStateLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 86, 152, 70)];
    [self createUILabel:self.lightsStateLabel textColor:[UIColor customOrangeColor]
                   font:[UIFont shinobiFontOfSize:36] text:nil];
    
    self.powerUsageLabel= [[UILabel alloc] initWithFrame:CGRectMake(18, 149, 152, 25)];
    [self createUILabel:self.powerUsageLabel textColor:[UIColor whiteColor]
                   font:[UIFont shinobiFontOfSize:20] text:@"Power Usage"];
    
    self.kwhLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 177, 73, 32)];
    [self createUILabel:self.kwhLabel textColor:[UIColor customOrangeColor]
                   font:[UIFont shinobiFontOfSize:20] text:nil];
    
    self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 192, 80, 21)];
    [self createUILabel:self.rateLabel textColor:[UIColor lightGrayColor]
                   font:[UIFont boldShinobiFontOfSize:18] text:nil];;
    
    NSInteger hideView1Size = 100;
    UIView *hideView1 = [[UIView alloc] initWithFrame:CGRectMake(390 - hideView1Size, 59, hideView1Size, 233 - 59)];
    hideView1.backgroundColor = [UIColor customBlueColor];
    [self addSubview:hideView1];

  }
  return self;
}

- (void)createUILabel:(UILabel*)label textColor:(UIColor*)textColor font:(UIFont*)font text:(NSString*)text {
  label.textAlignment = NSTextAlignmentLeft;
  label.textColor = textColor;
  label.font = font;
  label.text = text;
  [self addSubview:label];
}

- (void)updateInfo:(GaugesDashboardRoomInfo*)roomInfo {
  self.roomNameLabel.text = [roomInfo.roomName capitalizedString];
  self.lightsStateLabel.text = roomInfo.lights;
  
  NSDictionary *firstAttributes = @{NSForegroundColorAttributeName: [UIColor customOrangeColor],
                                    NSFontAttributeName: [UIFont shinobiFontOfSize:35]};
  NSDictionary *secondAttributes = @{ NSForegroundColorAttributeName: [UIColor customOrangeColor],
                                      NSFontAttributeName: [UIFont shinobiFontOfSize:24]};
  
  NSString *kwhLabelString = roomInfo.totalPowerUsage;
  NSRange rangeOfkwhSubstring = [kwhLabelString rangeOfString:@"kwh"];
  NSMutableAttributedString *kwhLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:kwhLabelString];
  [kwhLabelAttributedString setAttributes:firstAttributes range:NSMakeRange(0, kwhLabelString.length - rangeOfkwhSubstring.length)];
  [kwhLabelAttributedString setAttributes:secondAttributes range:rangeOfkwhSubstring];
  self.kwhLabel.attributedText = kwhLabelAttributedString;
  [self.kwhLabel sizeToFit];
  
  self.rateLabel.text = roomInfo.powerUsageRate;
  [self.rateLabel sizeToFit];
  
  [self.rateLabel setFrame:CGRectMake(CGRectGetMaxX(self.kwhLabel.frame) + 9,
                                      CGRectGetMinY(self.rateLabel.frame),
                                      CGRectGetWidth(self.rateLabel.frame),
                                      CGRectGetHeight(self.rateLabel.frame))];
}

@end
