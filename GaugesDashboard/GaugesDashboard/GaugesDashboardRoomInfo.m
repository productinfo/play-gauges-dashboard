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

@interface GaugesDashboardRoomInfo ()

@end

@implementation GaugesDashboardRoomInfo

- (instancetype)initWithKey:(NSString*)roomName andDictionary:(NSDictionary*)roomData {
  self = [super init];
  if (self) {
    self.roomName = roomName;
    self.temperature = [roomData[@"temperature"] integerValue];
    self.maxTemperature = [roomData[@"maxTemperature"] integerValue];
    self.lights = ([roomData[@"lights"] boolValue]) ? @"On" : @"Off";
    
    NSInteger totalPowerUsage = [roomData[@"totalPowerUsage"] floatValue];
    self.totalPowerUsage = [NSString stringWithFormat:@"%zdkwh", totalPowerUsage];
    
    double powerUsageRate = [roomData[@"totalPowerUsage"] floatValue] * 0.0425;
    self.powerUsageRate  =[NSString stringWithFormat:@"$%0.2f/h", powerUsageRate];
  }
  return self;
}

- (NSNumber*)percentageTemperature {
  return [NSNumber numberWithFloat:([[NSNumber numberWithInteger:self.temperature] floatValue] /
                                    [[NSNumber numberWithInteger:self.maxTemperature] floatValue]) * 100];
}

@end
