//
//  GaugesDashboardRoomInfo.h
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

@import Foundation;

@interface GaugesDashboardRoomInfo : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (assign, nonatomic) NSInteger temperature;
@property (assign, nonatomic) NSInteger maxTemperature;
@property (assign, nonatomic) BOOL lights;
@property (assign, nonatomic) CGFloat totalPowerUsage;
@property (assign, nonatomic) CGFloat powerUsageRate;

- (instancetype)initWithKey:(NSString *)roomName andDictionary:(NSDictionary *)roomData;
- (NSString *)temperatureFormattedAsString;
- (NSString *)maxTemperatureFormattedAsString;
- (NSString *)lightsFormattedAsString;
- (NSString *)totalPowerUsageFormattedAsString;
- (NSString *)powerUsageRateFormattedAsString;
- (NSNumber *)percentageTemperature;

@end
