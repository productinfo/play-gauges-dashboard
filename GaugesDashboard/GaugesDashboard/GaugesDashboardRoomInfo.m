//
//  GaugesDashboardRoomInfo.m
//  GaugesDashboard
//
//  Created by Daniel Allsop on 25/02/2015.
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

#import "GaugesDashboardRoomInfo.h"
#import "UIColor+GaugesDashboardColor.h"
#import "ShinobiPlayUtils/UIFont+SPUFont.h"

@implementation GaugesDashboardRoomInfo

- (instancetype)initWithKey:(NSString *)roomName andDictionary:(NSDictionary *)roomData {
  self = [super init];
  if (self) {
    self.roomName = roomName;
    self.temperature = [roomData[@"temperature"] integerValue];
    self.maxTemperature = [roomData[@"maxTemperature"] integerValue];
    self.lights = [roomData[@"lights"] boolValue];
    
    self.totalPowerUsage = [roomData[@"totalPowerUsage"] floatValue];
    self.powerUsageRate = [roomData[@"totalPowerUsage"] floatValue] * 0.0425;
  }
  return self;
}

- (NSString *)temperatureFormattedAsString {
  return [NSString stringWithFormat:@"%zd", self.temperature];
}

- (NSString *)maxTemperatureFormattedAsString {
  return [NSString stringWithFormat:@"max %zd", self.maxTemperature];
}

- (NSString *)lightsFormattedAsString {
  return (self.lights) ? @"On" : @"Off";
}

- (NSString *)totalPowerUsageFormattedAsString {
  return [NSString stringWithFormat:@"%ld", lroundf(self.totalPowerUsage)];
}

- (NSString *)powerUsageRateFormattedAsString {
  return [NSString stringWithFormat:@"$%0.2f/h", self.powerUsageRate];
}

- (NSNumber *)percentageTemperature {
  return @(((CGFloat)self.temperature / (CGFloat)self.maxTemperature) * 100);
}

@end
