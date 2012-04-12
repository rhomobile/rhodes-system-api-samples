
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NListDataCache.h"




@implementation NListDataCacheRequest

@synthesize count, prevRequest, nextRequest, start_index;

-(id) init:(int)_start_index count:(int)_count {
    self = [super init];
    actualFlags = (int*)malloc(sizeof(int)*_count);
    datas = NULL;
    int i;
    for (i = 0; i < _count; i++) actualFlags[i] = 0;
    self.start_index = _start_index;
    self.count = _count;
    self.prevRequest = nil;
    self.nextRequest = nil;
    return self;
}

-(void) enableActualRequestForIndex:(int)index {
    int arr_index = index - self.start_index;
    if ((arr_index >= 0) && (arr_index < self.count)) {
        actualFlags[arr_index] = 1;
    }
}

-(void) disableActualRequestForIndex:(int)index {
    int arr_index = index - self.start_index;
    if ((arr_index >= 0) && (arr_index < self.count)) {
        actualFlags[arr_index] = 0;
    }
}

-(NSString*) getData:(int)index {
    int arr_index = index - self.start_index;
    if ((arr_index >= 0) && (arr_index < self.count)) {
        if (datas != NULL) {
            return datas[arr_index];
        }
    }
    return nil;
}

-(void) setData:(int)index data:(NSString*)data {
    int arr_index = index - self.start_index;
    if ((arr_index >= 0) && (arr_index < self.count)) {
        if (datas == NULL) {
            datas = (NSString**)malloc(sizeof(NSString*)*self.count);
            int i;
            for (i = 0; i < self.count; i++) datas[i] = nil;
        }
        datas[arr_index] = data;
    }
}

-(BOOL) isEmptyRequest {
    int i;
    for (i = 0 ; i < self.count; i++) {
        if (actualFlags[i] != 0) {
            return NO;
        }
    }
    return YES;
}

-(void) dealloc {
    ///*
     if (datas != NULL) {
        int i;
        for (i = 0 ; i < self.count; i++) {
            [datas[i] release];
        }
        free(datas);
    }
    free(actualFlags);
    actualFlags = NULL;
   // */
     [super dealloc];
}


@end













@implementation NListDataCache

@synthesize delegate;



-(id) init:(int)cache_size portion_size:(int)portion_size url:(NSString*)url maxIndex:(int)_maxIndex{
    self = [super init];
    
    lastRequstedIndex = 0;
    xmlParsingCurrentIndex = -1;
    xmlParsedRequest = nil;
    maxIndex = _maxIndex;
    
    data_loding_thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadingDataJob) object:nil];
    
    firstRequest = nil;
    newestRecord = nil;
    //oldestRecord = nil;
    recordCount = 0;
    maxCacheSize = cache_size;
    portionSize = portion_size;
    dataRequestBaseUrl = [url retain];
    
    [data_loding_thread start];
    
    return self;
}

-(NSString*) findData:(int)index is_data_already_requested:(BOOL*)is_data_already_requested setActual:(BOOL)setActual{
    NListDataCacheRequest* rec = newestRecord;
    *is_data_already_requested = NO;
    while (rec != nil) {
        if ((rec.start_index <= index) && ( index < (rec.start_index + rec.count))) {
            return [rec getData:index];
        }
        rec = rec.nextRequest;
    }
    
    // not found - check for already requested
    rec = [self findDataRequestByIndex:index];
    if ( rec != nil) {
        if (setActual) {
            [rec enableActualRequestForIndex:index];
        }
        *is_data_already_requested = YES;
        return nil;
    }
    return nil;
}

-(NSString*) getData:(int)index {
    // find in cached data
    NSString* res = nil;
    
    lastRequstedIndex = index;

    
    @synchronized(self) {
        
        BOOL is_data_already_requested = NO;
        res = [self findData:index is_data_already_requested:&is_data_already_requested setActual:YES];
        if (res != nil) {
            return res;
        }
        if (is_data_already_requested) {
            // increase priority
            NListDataCacheRequest* rec = [self findDataRequestByIndex:index];
            if (rec != firstRequest) {
                // move to first
                // remove from requests
                if (firstRequest == rec) {
                    firstRequest = rec.nextRequest;
                }
                else {
                    if (rec.prevRequest != nil) {
                        rec.prevRequest.nextRequest = rec.nextRequest;
                    }
                    if (rec.nextRequest != nil) {
                        rec.nextRequest.prevRequest = rec.prevRequest;
                    }
                }
                // add to first
                rec.nextRequest = firstRequest;
                if (firstRequest != nil) {
                    firstRequest.prevRequest = rec;
                }
                firstRequest = rec;
            }
            return nil;
        }
        // not found and not requested - add new request
        int sti = (index / portionSize) * portionSize;
        [self addNewRequest:sti count:portionSize];
        [firstRequest enableActualRequestForIndex:index];
        return nil;
        
    }
    return res;
}

-(void) cancelDataRequest:(int)index {
    @synchronized(self) {
        NListDataCacheRequest* rec = [self findDataRequestByIndex:index];
        if (rec != nil) {
            [rec disableActualRequestForIndex:index];
        }
    }    
}

-(NListDataCacheRequest*) findDataRequestByIndex:(int)index {
    //@synchronized(self) {
        NListDataCacheRequest* rec = firstRequest;
        while (rec != nil) {
            if ((rec.start_index <= index) && ( index < (rec.start_index + rec.count))) {
                return rec;
            }
            rec = rec.nextRequest;
        }
    //}    
    return nil;
}

-(void) addNewRequest:(int)start_index count:(int)count {
    NListDataCacheRequest* request = [[NListDataCacheRequest alloc] init:start_index count:count];
    request.nextRequest = firstRequest;
    if (firstRequest != nil) {
        firstRequest.prevRequest = request;
    }
    firstRequest = request;
}

-(void) addDataRecord:(NListDataCacheRequest*)dataRecord {
    //@synchronized(self) {
    dataRecord.nextRequest = newestRecord;
    newestRecord = dataRecord;
    dataRecord.prevRequest = nil;
    recordCount++;
    if ((recordCount*portionSize) > maxCacheSize) {
        NListDataCacheRequest* rec = newestRecord;
        while (rec != nil) {
            NListDataCacheRequest* cur_rec = rec;
            rec = rec.nextRequest;
            if (rec.nextRequest == nil) {
                [rec release];
                cur_rec.nextRequest = nil;
                recordCount--;
                return;
            }
        }
    }
    //}
}

-(void) dealloc {
    [dataRequestBaseUrl release];
    [data_loding_thread cancel];
    data_loding_thread = nil;
    NListDataCacheRequest* rec = newestRecord;
    while (rec != nil) {
        NListDataCacheRequest* cur_rec = rec;
        rec = cur_rec.nextRequest;
        [cur_rec release];
    }
    [super dealloc];
}

-(void) callDelegateCommand:(NListDataCacheRequest*)record {
    if (self.delegate == nil) {
        return;
    }
    int i;
    for (i = 0; i < record.count; i++) {
        [self.delegate onDataLoaded:(i + record.start_index)];
    }
    [record release];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([@"item" compare:elementName options: NSCaseInsensitiveSearch] == NSOrderedSame) {
        NSString* sindex = (NSString*)[attributeDict objectForKey:@"index"];
        if (sindex != nil) {
            xmlParsingCurrentIndex = [sindex intValue];
            xmlCurrentString = nil;
        }
    }
    else {
        xmlParsingCurrentIndex = -1;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    const char* cstr = [string UTF8String];
    if (xmlParsingCurrentIndex >= 0) {
        if (xmlCurrentString == nil) {
            xmlCurrentString = [string retain];
        }
        else {
            xmlCurrentString = [xmlCurrentString stringByAppendingString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([@"item" compare:elementName options: NSCaseInsensitiveSearch] == NSOrderedSame) {
        if ((xmlCurrentString != nil) && (xmlParsedRequest)) {
            [xmlParsedRequest setData:xmlParsingCurrentIndex data:xmlCurrentString];
            xmlCurrentString = nil;
        }
    }
    xmlParsingCurrentIndex = -1;
}

-(void) loadingDataJob {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
    while (![[NSThread currentThread] isCancelled]) {
        NListDataCacheRequest* cur_request = nil;
        @synchronized(self) {
            while ((firstRequest != nil) && ([firstRequest isEmptyRequest])) {
                // remove request
                NListDataCacheRequest* n = firstRequest.nextRequest;
                [firstRequest release];
                firstRequest = n;
                firstRequest.prevRequest = nil;
            }
            cur_request = firstRequest;
        }
        
        
        if (cur_request != nil) {
            
            int count = cur_request.count;
            if ((cur_request.start_index + count - 1) > maxIndex) {
                count = maxIndex - (cur_request.start_index + count - 1);
            }
            NSString* url = [NSString stringWithFormat:@"%@?&start_item=%d&items_count=%d", dataRequestBaseUrl, cur_request.start_index, count];
            
            //NSLog(@"$$$$$$$$$$$$$$$$$$$$$$");
            //NSLog(url);
            //NSLog(@"$$$$$$$$$$$$$$$$$$$$$$");
            
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]							  
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:150.0];	
            NSData* data = nil;
            
            @try {
                NSHTTPURLResponse *response = NULL;
                data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                
                //sdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
                
            }
            @catch (NSException *exception) {
            }
            @finally {
                //NSLog(@"finally");
            }
            
            if (data != nil) {
                @synchronized(self) {
                    
                    // parse XML data
                    //const char* csdata = [sdata UTF8String];
                    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
                    
                    [parser setDelegate:self];
                    
                    xmlParsingCurrentIndex = -1;
                    xmlParsedRequest = cur_request;
                    [parser parse];
                     
                    [parser release];
                    parser = nil;
                    
                    //int i;
                    //for (i = 0 ; i < cur_request.count; i++) {
                    //    [cur_request setData:(cur_request.start_index + i) data:[sdata retain]];
                    //}
                    
                    // remove from requests
                    if (firstRequest == cur_request) {
                        firstRequest = cur_request.nextRequest;
                        if (firstRequest != nil) {
                            firstRequest.prevRequest = nil;
                        }
                    }
                    else {
                        if (cur_request.prevRequest != nil) {
                            cur_request.prevRequest.nextRequest = cur_request.nextRequest;
                        }
                        if (cur_request.nextRequest != nil) {
                            cur_request.nextRequest.prevRequest = cur_request.prevRequest;
                        }
                    }
                    // add to records
                    [self addDataRecord:cur_request];
                }
                [self performSelectorOnMainThread:@selector(callDelegateCommand:) withObject:[cur_request retain] waitUntilDone:NO];
            }
        }
        else {
            // we have free time - do prefetch !
            int steps = (maxCacheSize/portionSize)/4;
            // check the last requested index
            @synchronized(self) {
                if (lastRequstedIndex >= 0) {
                    int i;
                    for (i = steps; i >= 1; i--) {
                        int beforeIndex = lastRequstedIndex - i*portionSize;
                        int afterIndex = lastRequstedIndex + i*portionSize;
                        
                        if (beforeIndex < 0) {
                            beforeIndex = 0;
                        }
                        if (afterIndex > maxIndex) {
                            afterIndex = maxIndex;
                        }
                        
                        BOOL before_is_already = NO;
                        BOOL after_is_already = NO;
                        NSString* beforeData = [self findData:beforeIndex is_data_already_requested:&before_is_already setActual:NO];
                        NSString* afterData = [self findData:afterIndex is_data_already_requested:&after_is_already setActual:NO];

                        if ((beforeData == nil) && (!before_is_already)) {
                            // add before request
                            [self addNewRequest:beforeIndex count:portionSize];
                            [firstRequest enableActualRequestForIndex:beforeIndex];
                        }
                        if ((afterData == nil) && (!after_is_already)) {
                            // add before request
                            [self addNewRequest:afterIndex count:portionSize];
                            [firstRequest enableActualRequestForIndex:afterIndex];
                        }
                    }
                }
            }
        }
        [NSThread sleepForTimeInterval:0.01]; 
    }
    [pool release]; 
}

@end





















