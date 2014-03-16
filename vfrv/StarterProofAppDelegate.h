// iOS Dev Tutorial series on http://mobileorchard.com

#import <UIKit/UIKit.h>

@class StarterProofViewController;

@interface StarterProofAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    StarterProofViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StarterProofViewController *viewController;

@end