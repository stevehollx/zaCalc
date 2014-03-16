// iOS Dev Tutorial series on http://mobileorchard.com

#import <UIKit/UIKit.h>

@class starterRecipeViewController;

@interface StarterRecipeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    starterRecipeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet starterRecipeViewController *viewController;

@end