

#import "NListViewManager.h"
#import "RhoNativeViewManager.h"
#import "NListTableViewController.h"
#import "Nlist.h"
#import "RhodesApp.h"

@implementation NListViewManager

static NListViewManager *instance = NULL;
static NListTableViewController *viewController = NULL;

+ (NListViewManager*)getInstance {
	if (instance == NULL) {
		instance = [[NListViewManager alloc] init];
	}
	return instance;
}

- (void) animationCompleted:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
    [viewController.view removeFromSuperview];
    [viewController release];
    viewController = nil;
}

- (void)closeViewCommand:(NSObject*)args {
	if (viewController != nil) {
        if (viewController.tableView != nil) {
            
            
            UIWebView* wv = (UIWebView*)RhoNativeViewManager::getWebViewObject(-1);
            CGRect rect = wv.frame;
            
            [UIView beginAnimations:@"return" context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.35];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationCompleted:finished:context:)];
            
            rect.origin.x = rect.origin.x + rect.size.width;
            [wv setFrame:rect];

            rect = viewController.tableView.frame;
            rect.origin.x = rect.origin.x + rect.size.width;

            [viewController.tableView setFrame:rect];
            
            [UIView commitAnimations];
            
            
        }
	}
}


- (void)openViewCommand:(NSObject*)args {
	if (viewController != nil) {
		[self closeViewCommand:nil];
	}
    NSDictionary* params = (NSDictionary*)args;
	UIWebView* wv = (UIWebView*)RhoNativeViewManager::getWebViewObject(-1);
    CGRect fr = wv.frame;
    UIView* mainView = wv.superview;
    viewController = [[NListTableViewController alloc] init:mainView vframe:fr params:params];
    
    CGRect rect = fr;
    rect.origin.x = rect.origin.x + rect.size.width;
    
    [viewController.tableView setFrame:rect];
    
    [UIView beginAnimations:@"entrance" context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    rect.origin.x = rect.origin.x - rect.size.width;
    
    [viewController.tableView setFrame:rect];
    rect = wv.frame;
    rect.origin.x = rect.origin.x - rect.size.width;
    [wv setFrame:rect];
    
    [UIView commitAnimations];
    
    
	[mainView setNeedsDisplay];
}

- (void)openView:(NSDictionary*)params {
	[self performSelectorOnMainThread:@selector(openViewCommand:) withObject:params waitUntilDone:NO];	
}

- (void)closeView {
	[self performSelectorOnMainThread:@selector(closeViewCommand:) withObject:nil waitUntilDone:NO];	
}

- (void)clickItem:(int)index {
	[viewController onClickItem:index];
}


@end




