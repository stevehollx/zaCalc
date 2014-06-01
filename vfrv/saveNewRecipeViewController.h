//
//  saveNewRecipeViewController.h
//  zaCalc
//
//  Created by sholl on 3/31/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface saveNewRecipeViewController : UIViewController {
    IBOutlet UITextField *quantity;
    IBOutlet UITextField *diameter;
    IBOutlet UITextField *thickness;
    IBOutlet UITextField *hydration;
    IBOutlet UITextField *prefermentHydration;
    IBOutlet UITextField *salt;
    IBOutlet UITextField *oil;
    IBOutlet UITextField *sugar;
    IBOutlet UITextField *waste;
    IBOutlet UILabel *lDistance;
    IBOutlet UITextField *recipeName;
}

@end
