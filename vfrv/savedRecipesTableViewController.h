//
//  savedRecipesTableViewController.h
//  zaCalc
//
//  Created by sholl on 3/31/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface savedRecipesTableViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate> {

@interface savedRecipesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    //IBOutlet UIPickerView *recipePicker;

}
@property (strong) NSMutableArray *recipeArray;

@end