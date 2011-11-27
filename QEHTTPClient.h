

#import <Foundation/Foundation.h>

@class QEHTTPClientResponse;


@interface QEHTTPClient : NSObject {
	NSString *baseURL;
}


@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *xsrf;
@property (readwrite, assign) bool isLoggedIn;
@property (readwrite, assign) int userID;

-(QEHTTPClientResponse *)doQEPostRequest:(NSString *)resource postFields:(NSDictionary *)postFields;
-(QEHTTPClientResponse *)doQEGetRequest:(NSString *)resource queryFields:(NSDictionary *)queryFields;

-(NSString *)getXSFRValue;

-(void)logout:(int *)status;
-(void)login:(NSString *)username password:(NSString *)password status:(int *)status;
-(NSMutableArray *)getMyGames:(int *)status;

-(NSMutableDictionary *)createGame:(NSMutableArray *)players width:(int)width height:(int)height 
                planetDensity:(int)planetDensity meanUranium:(int)meanU meanPlanetLifetime:(int)meanPlanetLifetime
              startingUranium:(int)startingU status:(int *)status;

@end
