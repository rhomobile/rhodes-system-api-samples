
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NListViewManager : NSObject {

}

+ (NListViewManager*)getInstance;

- (void)openView:(NSDictionary*)params;
- (void)closeView;
- (void)clickItem:(int)index;

@end


