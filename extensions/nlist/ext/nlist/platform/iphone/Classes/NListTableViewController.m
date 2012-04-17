
#import "NListTableViewController.h"



#import "Nlist.h"

#import "NListItemView.h"



#import "NListViewManager.h"

#include "RhodesApp.h"



static NSString* itemBaseURL;
static NSString* dataBaseURL;
static int itemsCount;
static int itemHeight;
static NListDataCache* dataCache;
static NSString* callbackURL; 



@implementation NListTableViewController

//@synthesize itemBaseURL, itemsCount, itemHeight;

- (id)init:(UIView*)parentView vframe:(CGRect)vframe params:(NSDictionary*)params {
    self = [super initWithStyle:UITableViewStylePlain];

    
    NSString* par_url = (NSString*)[params objectForKey:NLIST_ITEM_REQUEST_URL];
    NSString* par_data_url = (NSString*)[params objectForKey:NLIST_DATA_REQUEST_URL];
    NSString* par_count = (NSString*)[params objectForKey:NLIST_ITEMS_COUNT];
    NSString* par_height = (NSString*)[params objectForKey:NLIST_ITEM_HEIGHT];
    NSString* par_cache_size = (NSString*)[params objectForKey:NLIST_DATA_CACHE_SIZE];
    NSString* par_portion_size = (NSString*)[params objectForKey:NLIST_DATA_PORTION_SIZE];
    callbackURL = (NSString*)[params objectForKey:NLIST_LIST_CALLBACK];
    
    //const char* c_data_url = [par_data_url UTF8String];
    //const char* c_url = [par_url UTF8String];
    //const char* c_count = [par_count UTF8String];
    //const char* c_height = [par_height UTF8String];
    
    
    itemBaseURL = par_url;
    dataBaseURL = par_data_url;
    itemsCount = [par_count intValue];
    itemHeight = [par_height intValue];    
    
    int cache_size = 1024;
    int portion_size = 32;
    
    if (par_cache_size != nil) {
        cache_size = [par_cache_size intValue];
    }
    if (par_portion_size != nil) {
        portion_size = [par_portion_size intValue];
    }

    dataCache = [[NListDataCache alloc] init:cache_size portion_size:portion_size url:dataBaseURL maxIndex:(itemsCount-1)];   
    dataCache.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = itemHeight;
    
    [self.tableView setFrame:vframe];
    [parentView addSubview:self.tableView];
   
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsCount;
}


- (NSString*) getDataByIndex:(int)index {

    NSString* sdata = nil;
    
    NSString* url = [NSString stringWithFormat:@"%@?&item=%d", dataBaseURL, index];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]							  
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:150.0];	
    @try {
        NSHTTPURLResponse *response = NULL;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        sdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        
    }
    @catch (NSException *exception) {
        //NSLog(@"Geocoding failed");
    }
    @finally {
        //NSLog(@"finally");
    }
    
    return sdata;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    
    // 1
    static NSString* cellID = @"cellID";
    NListItemView* cell = nil;
    cell = (NListItemView*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if ( !cell ) {
        cell = [[NListItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID height:itemHeight];
        if (itemBaseURL != nil) {
            // use cell with WebView inside
            NSString* url = [NSString stringWithFormat:@"%@?&item=%d", itemBaseURL, index];
            [cell setupWebView:url];
        }
        else {
            // use pure native cell
            [cell setupNativeView];
        }
    }
    else {
        [dataCache cancelDataRequest:cell.data_index];
    }
    NSString* data = [dataCache getData:index];//[self getDataByIndex:index];//[NSString stringWithFormat:@"(%d)", index];
    cell.data_index = index;
    if (data != nil) {
        [cell setData:data];
    }
    return cell;    
}

- (void) onDataLoaded:(int)index {
    unsigned int indexes[2] = {0, index};
    NSIndexPath* path = [NSIndexPath indexPathWithIndexes:indexes length:2];
    NListItemView* cell = (NListItemView*)[self.tableView cellForRowAtIndexPath:path];
    if (cell != nil) {
        NSString* data = [dataCache getData:index];
        if (data != nil) {
            [cell setData:data];
        }
    }
}



-(void) onClickItem:(int)index {
    
    NSString* body = [NSString stringWithFormat:@"&rho_callback=1&selected_item=%d", index];
    
    rho_net_request_with_data(rho_http_normalizeurl([callbackURL UTF8String]), [body UTF8String]);
    
    //[[NListViewManager getInstance] closeView];
}




@end






NSDictionary* prepareDictionary(rho_param* params_hash, const char* callback) {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    for (int i = 0, lim = params_hash->v.hash->size; i < lim; ++i) {
        const char *name = params_hash->v.hash->name[i];
        rho_param *value = params_hash->v.hash->value[i];
        
        NSString* nsname = [NSString stringWithUTF8String:name];
        NSString* nsvalue = [NSString stringWithUTF8String:value->v.string];
        
        [dict setObject:nsvalue forKey:nsname]; 
        
    }
    
    [dict setObject:[NSString stringWithUTF8String:callback] forKey:NLIST_LIST_CALLBACK]; 
    
    return dict;
}



