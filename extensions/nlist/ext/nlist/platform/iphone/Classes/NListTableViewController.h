
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "ruby/ext/rho/rhoruby.h"
#import "NListDataCache.h"


@interface NListTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSListDataCacheDelegate> {
//    NSString* itemBaseURL;
//    int itemsCount;
//    int itemHeight;
//    NListDataCache* dataCache;
}

//@property(atomic, retain) NSString* itemBaseURL;
//@property(atomic, assign) int itemsCount;
//@property(atomic, assign) int itemHeight;

- (id)init:(UIView*)parentView vframe:(CGRect)vframe params:(NSDictionary*)params;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) onClickItem:(int)index;

@end

NSDictionary* prepareDictionary(rho_param* params_hash, const char* callback);