

#import <Foundation/Foundation.h>

@class QEHTTPClientResponse;


@interface QEHTTPClient : NSObject {
	NSString *baseURL;
}


@property (nonatomic, retain) NSString *baseURL;


-(QEHTTPClientResponse *)doQEPostRequest:(NSString *)resource postFields:(NSDictionary *)postFields;
-(QEHTTPClientResponse *)doQEGetRequest:(NSString *)resource queryFields:(NSDictionary *)queryFields;

-(NSString *)getXSFRValue;

-(void)logout:(int *)status;
-(int)login:(NSString *)username password:(NSString *)password status:(int *)status;


@end
