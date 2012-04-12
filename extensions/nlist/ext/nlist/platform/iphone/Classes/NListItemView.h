
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NListItemView : UITableViewCell <UIWebViewDelegate>{
    UIWebView* webView;
    UIActivityIndicatorView* activityIndicator;
    NSString* data_for_processing;
    UIButton* button;
}

@property (nonatomic, assign) int data_index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int)height;

- (void) setupWebView:(NSString*)url;
- (void) setData:(NSString*)data;

- (void)dealloc;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void) buttonPress:(id)sender;

@end