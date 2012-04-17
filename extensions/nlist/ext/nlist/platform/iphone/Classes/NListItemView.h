
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NListItemView : UITableViewCell <UIWebViewDelegate>{
    UIWebView* webView;
    UIActivityIndicatorView* activityIndicator;
    NSString* data_for_processing;
    UIButton* button;
    
    UIImageView* imageView;
    UILabel* titleLabel;
    UILabel* subtitleLabel;
    UILabel* numberLabel;
}

@property (nonatomic, assign) int data_index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int)height;

- (void) setupNativeView;
- (void) setupWebView:(NSString*)url;
- (void) setData:(NSString*)data;

- (void)dealloc;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void) buttonPress:(id)sender;

- (NSDictionary*) veryverySimpleJSONParser:(NSString*)jsonData;

@end