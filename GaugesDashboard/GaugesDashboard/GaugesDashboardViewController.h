//
//  GaugesDashboardViewController.h
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

@import UIKit;
#import "ShinobiPlayUtils/SPUGalleryManagedViewController.h"
#import <ShinobiGauges/ShinobiGauges.h>

@interface GaugesDashboardViewController : SPUGalleryManagedViewController

@property IBOutlet UILabel *timeLabel;
@property IBOutlet UILabel *maxLabel;
@property IBOutlet UILabel *currentValueLabel;
@property IBOutlet UILabel *currentLabel;
@property IBOutlet UIView *roomView;
@property IBOutlet UIView *loungeView;
@property IBOutlet UIView *kitchenView;
@property IBOutlet UIView *bathroomView;
@property IBOutlet UIView *bed1View;
@property IBOutlet UIView *bed2View;
@property IBOutlet UIView *bed3View;

@end
