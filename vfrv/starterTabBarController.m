//
//  starterTabBarController.m
//  zaCalc
//
//  Created by sholl on 3/30/14.
//  Copyright (c) 2014 phade2grey. All rights reserved.
//

#import "starterTabBarController.h"

@interface starterTabBarController ()

@end

@implementation starterTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)starterTabBarController didSelectViewController:(UIViewController *)starterRecipeViewController {
    
    //not working- need to define delegates?
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults synchronize];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
