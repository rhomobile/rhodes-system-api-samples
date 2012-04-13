
#import "NListItemView.h"

#include "ruby/ext/rho/rhoruby.h"

#import "NListViewManager.h"

@implementation NListItemView

@synthesize data_index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int)height {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.data_index = -1;
    
    data_for_processing = nil;
    
    UIView* mainView = self.contentView;
    CGRect rect = mainView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    //rect.size.height = height;
    webView = [[UIWebView alloc] initWithFrame:rect];

    for (id subview in webView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
            [((UIScrollView *)subview) setScrollEnabled:NO];    
    
    webView.delegate = self;
	webView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	activityIndicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]
     autorelease];
	[mainView addSubview:[activityIndicator autorelease]];
	activityIndicator.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicator startAnimating];    

	CGRect activityIndicatorRect = activityIndicator.frame;
	activityIndicatorRect.origin.x =
    0.5 * (rect.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
    0.5 * (rect.size.height - activityIndicatorRect.size.height);
	activityIndicator.frame = activityIndicatorRect;
    
    [mainView addSubview:[webView autorelease]];
    webView.hidden = YES;
    
    button = [[UIButton alloc] initWithFrame:rect];
    button.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:[button autorelease]];
    
    return self;
}

- (void) buttonPress:(id)sender {
    [[NListViewManager getInstance] clickItem:data_index];
}

- (void) setupWebView:(NSString*)url {
    
    webView.hidden = YES;
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    [self.contentView setNeedsLayout];
    [self.contentView setNeedsDisplay];
    
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    [webView stopLoading];
    [webView loadRequest:request];
    [request release];
}

-(void) runJSData:(NSString*)data {
    NSString* js_code = [NSString stringWithFormat:@"nlist_set_data('%@');", data];
    [webView stringByEvaluatingJavaScriptFromString:js_code];
    [webView setNeedsDisplay];
    [data release];
}

-(void) setData:(NSString*)data {
    if (!webView.hidden) {
        [self runJSData:[data retain]];
    }
    else {
        if (data_for_processing != nil) {
            [data_for_processing release];
        }
        data_for_processing = [data retain];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    webView.hidden = NO;
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    if (data_for_processing != nil) {
        NSString* d = data_for_processing;
        data_for_processing = nil;
        [self performSelectorOnMainThread:@selector(runJSData:) withObject:d waitUntilDone:NO];
    }
    //[activityIndicator removeFromSuperview];
    [self.contentView setNeedsLayout];
    [self.contentView setNeedsDisplay];
    //NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
	//[NSURLCache setSharedURLCache:sharedCache];
	//[sharedCache release];    
}


 - (void)dealloc {
    //[webView release];
    webView = nil;
    //[activityIndicator release];
    activityIndicator = nil;
    data_for_processing = nil;
    button = nil;
    [super dealloc];
}

@end