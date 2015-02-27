//
//  GaugesDashboardColor.m
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

#import "UIColor+GDColor.h"

@implementation UIColor (GDColor)

+ (UIColor *)customGreyBlueColor {
  return [UIColor colorWithRed:75.0f/255 green:119.0f/255 blue:133.0f/255 alpha:1];
}

+ (UIColor *)customOrangeColor {
  return [UIColor colorWithRed:255.0f/255 green:145.0f/255 blue:0.0f/255 alpha:1];
}

+ (UIColor *)customDarkBlueColor {
  return [UIColor colorWithRed:35.0f/255 green:128.0f/255 blue:166.0f/255 alpha:1];
}

+ (UIColor *)customBlueColor {
  return [UIColor colorWithRed:44.0f/255 green:156.0f/255 blue:190.0f/255 alpha:1];
}

+ (UIColor *)customDarkGrayColor {
  return [UIColor colorWithRed:87.0f/255 green:87.0f/255 blue:87.0f/255 alpha:1];
}

+ (UIColor *)customLightGrayColor {
  return [UIColor colorWithRed:192.0f/255 green:192.0f/255 blue:192.0f/255 alpha:1];
}

@end
