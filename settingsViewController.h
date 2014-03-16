//
//  settingsViewController.h
//  zaCalc
//
//  Created by sholl on 2/9/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate> {

    IBOutlet UIPickerView *weightPicker;
    IBOutlet UIPickerView *tempPicker;
    IBOutlet UIPickerView *distancePicker;
    
    NSArray *weights;
    NSArray *distances;
    NSArray *temps;
}
@end
