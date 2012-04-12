
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol NSListDataCacheDelegate <NSObject>

- (void) onDataLoaded:(int)index;

@end




@interface NListDataCacheRequest : NSObject {
    int* actualFlags;
    NSString** datas;
}

@property (nonatomic, assign) int start_index;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) NListDataCacheRequest* prevRequest;
@property (nonatomic, assign) NListDataCacheRequest* nextRequest;

-(id) init:(int)start_index count:(int)count;

-(void) enableActualRequestForIndex:(int)index;

-(void) disableActualRequestForIndex:(int)index;

-(BOOL) isEmptyRequest;

-(NSString*) getData:(int)index;
-(void) setData:(int)index data:(NSString*)data;

-(void) dealloc;

@end



@interface NListDataCache : NSObject <NSXMLParserDelegate> {
    NSThread* data_loding_thread;
    NListDataCacheRequest* firstRequest;
    NListDataCacheRequest* newestRecord;

    NSString* dataRequestBaseUrl;
    
    int recordCount;
    int maxCacheSize;
    int portionSize;
    int maxIndex;

    int lastRequstedIndex;
    
    int xmlParsingCurrentIndex;
    NListDataCacheRequest* xmlParsedRequest;
    NSString* xmlCurrentString;
}

@property (nonatomic, assign) id<NSListDataCacheDelegate>  delegate;


-(id) init:(int)cache_size portion_size:(int)portion_size url:(NSString*)url maxIndex:(int)maxIndex;

-(NSString*) getData:(int)index; 

-(void) cancelDataRequest:(int)index;

-(NListDataCacheRequest*) findDataRequestByIndex:(int)index;

-(void) addNewRequest:(int)start_index count:(int)count;

-(void) addDataRecord:(NListDataCacheRequest*)dataRecord;

-(void) dealloc;

-(void) loadingDataJob;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end

