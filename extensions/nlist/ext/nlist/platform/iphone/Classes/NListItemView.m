
#import "NListItemView.h"

#include "ruby/ext/rho/rhoruby.h"

#import "NListViewManager.h"

@implementation NListItemView

@synthesize data_index;


-(void) prepareWebView {
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
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(int)height {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.data_index = -1;
    
    data_for_processing = nil;
    
    //[self prepareWebView];
        
    return self;
}

- (void) buttonPress:(id)sender {
    [[NListViewManager getInstance] clickItem:data_index];
}

-(void) setupNativeView {
    
    UIView* mainView = self.contentView;
    CGRect cellrect = mainView.frame;    
    cellrect.origin.x = 0;
    cellrect.origin.y = 0;
    mainView.backgroundColor = [UIColor whiteColor];
    

    CGRect rect = CGRectMake(7, 7, 50, 50);
    imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.autoresizingMask = UIViewAutoresizingNone;
    [mainView addSubview:imageView];
    
    rect = CGRectMake(66, 7, 171+(cellrect.size.width-320), 25);
    titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [mainView addSubview:titleLabel];
    
    rect = CGRectMake(68, 34, 169+(cellrect.size.width-320), 21);
    subtitleLabel = [[UILabel alloc] initWithFrame:rect];
    subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [mainView addSubview:subtitleLabel];

    rect = CGRectMake(245+(cellrect.size.width-320), 12, 65, 43);
    numberLabel = [[UILabel alloc] initWithFrame:rect];
    numberLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [mainView addSubview:numberLabel];
    
    button = [[UIButton alloc] initWithFrame:cellrect];
    button.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:[button autorelease]];
}

- (void) setupWebView:(NSString*)url {
    
    [self prepareWebView];
    
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
    if (webView != nil) {
        // WebView mode
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
    else {
        // Native mode
        NSDictionary* dict = [self veryverySimpleJSONParser:data];
        
        titleLabel.text = (NSString*)[dict objectForKey:@"title"];
        subtitleLabel.text = (NSString*)[dict objectForKey:@"subtitle"];
        numberLabel.text = (NSString*)[dict objectForKey:@"number"];
        
        UIImage* img = [UIImage imageWithContentsOfFile:(NSString*)[dict objectForKey:@"image"]];
        [imageView setImage:img];
        imageView.contentMode = UIViewContentModeCenter;
        
        [self.contentView setNeedsLayout];
        [self.contentView setNeedsDisplay];
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


- (NSDictionary*) veryverySimpleJSONParser:(NSString*)jsonData {
    
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:4];

    if (jsonData == nil) {
        return dict;
    }
    
    BOOL isContinue = YES;
    
    NSRange searchRange;
    searchRange.location = 0;
    searchRange.length = [jsonData length];

    while (isContinue) {
        
        NSRange range1 = [jsonData rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:searchRange]; 
        if (range1.length > 0) {
            searchRange.location = range1.location+1;
            searchRange.length = [jsonData length] - searchRange.location;
            NSRange range2 = [jsonData rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:searchRange]; 
            if (range2.length > 0) {
                searchRange.location = range2.location+1;
                searchRange.length = [jsonData length] - searchRange.location;
                NSRange range3 = [jsonData rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:searchRange]; 
                if (range3.length > 0) {
                    searchRange.location = range3.location+1;
                    searchRange.length = [jsonData length] - searchRange.location;
                    NSRange range4 = [jsonData rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:searchRange]; 
                    if (range4.length > 0) {
                        NSRange keyRange;
                        NSRange valueRange;
                        
                        keyRange.location = range1.location+1;
                        keyRange.length = range2.location - range1.location - 1;

                        valueRange.location = range3.location+1;
                        valueRange.length = range4.location - range3.location - 1;
                        
                        NSString* key = [jsonData substringWithRange:keyRange];
                        NSString* value = [jsonData substringWithRange:valueRange];
                        
                        [dict setObject:value forKey:key];

                        searchRange.location = range4.location+1;
                        searchRange.length = [jsonData length] - searchRange.location;
                    }
                    else {
                        isContinue = NO;
                    }
                }
                else {
                    isContinue = NO;
                }
            }
            else {
                isContinue = NO;
            }
        }
        else {
            isContinue = NO;
        }
    }
    return dict;
}



 - (void)dealloc {
     [imageView release];
     [titleLabel release];
     [subtitleLabel release];
     [numberLabel release];
    //[webView release];
    webView = nil;
    //[activityIndicator release];
    activityIndicator = nil;
    data_for_processing = nil;
    button = nil;
    [super dealloc];
}

@end