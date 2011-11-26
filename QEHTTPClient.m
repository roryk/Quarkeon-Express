#import "QEHTTPClient.h"
#import "QEHTTPClientResponse.h"
#import "JSON.h"
#import "MultiplayerGame.h"





@implementation QEHTTPClient
@synthesize baseURL;
@synthesize isLoggedIn;
@synthesize userID;
@synthesize xsrf;

- (id)init {
    self = [super init];
	if (!self)
		return nil;
	self.baseURL = @"http://localhost:8888";
    self.isLoggedIn = false;
    self.userID = -1;
    self.xsrf = nil;
	
    return self;
}

-(QEHTTPClientResponse *)doQEPostRequest:(NSString *)resource postFields:(NSDictionary *)postFields
{
	// XXX need to handle 302 redirects!
	
	NSHTTPURLResponse   * response;
	NSError             * error;
	NSMutableURLRequest * request;
	NSString *URLString = [[NSString alloc] initWithFormat:@"%@/api/%@", self.baseURL, resource];
	
	request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	[request setHTTPMethod:@"POST"];
	
	NSMutableString *postString = [[NSMutableString alloc] init];
	
	for (id key in postFields) {
		[postString appendFormat:@"%@=%@&", key, [postFields objectForKey:key]];
	}
	
	NSString *XSRF = [self getXSFRValue]; // XXX throw a fit if this is nil
	[postString appendFormat:@"%@=%@", @"_xsrf", XSRF];
	
		
	[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [postString length]];
	
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSString *content = [[NSString alloc]  initWithBytes:[responseData bytes]
												  length:[responseData length] encoding: NSUTF8StringEncoding];
	
	NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	NSLog(@"code: %d\n", [response statusCode]);
    
    
    if ([response statusCode] == 403) {
        self.isLoggedIn = false;
    }
    
	NSLog(@"response body: \n%@", content);
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:self.baseURL]];
	NSLog(@"How many Cookies: %d", all.count);
	// Store the cookies:
	// NSHTTPCookieStorage is a Singleton.
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:self.baseURL] mainDocumentURL:nil];
	
	// Now we can print all of the cookies we have:
	for (NSHTTPCookie *cookie in all)
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate); 
	
	QEHTTPClientResponse *qeResponse = [[QEHTTPClientResponse alloc] init];
	qeResponse.content = content;
	qeResponse.statusCode = [response statusCode];
	return qeResponse;
	
}


-(QEHTTPClientResponse *)doQEGetRequest:(NSString *)resource queryFields:(NSDictionary *)queryFields
{
	
	NSHTTPURLResponse   * response;
	NSError             * error;
	NSMutableURLRequest * request;
	NSString *URLString;	
	NSMutableString *queryString = [[NSMutableString alloc] initWithCapacity:1];
	
	int count = 1;
	for (id key in queryFields) {
		if (count == queryFields.count) {
			[queryString appendFormat:@"%@=%@", key, [queryFields objectForKey:key]];
		} else {
			[queryString appendFormat:@"%@=%@&", key, [queryFields objectForKey:key]];
		}
		count ++;
	}
	
	if (queryFields != nil) {
		
	   URLString = [[NSString alloc] initWithFormat:@"%@/api/%@?%@", self.baseURL, resource, queryString];
	
	} else {
		URLString = [[NSString alloc] initWithFormat:@"%@/api/%@",self.baseURL, resource];
	}
	
	request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	[request setHTTPMethod:@"GET"];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	NSString *content = [[NSString alloc]  initWithBytes:[responseData bytes]
												  length:[responseData length] encoding: NSUTF8StringEncoding];
	
	NSLog(@"code: %d\n", [response statusCode]);
    
    if ([response statusCode] == 403) {
        self.isLoggedIn = false;
    }

	NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	NSLog(@"response body: \n%@", content);
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:self.baseURL]];
	NSLog(@"How many Cookies: %d", all.count);
	// Store the cookies:
	// NSHTTPCookieStorage is a Singleton.
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:self.baseURL] mainDocumentURL:nil];
	
	// Now we can print all of the cookies we have:
	for (NSHTTPCookie *cookie in all)
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate); 
	QEHTTPClientResponse *qeResponse = [[QEHTTPClientResponse alloc] init];
	qeResponse.content = content;
	qeResponse.statusCode = [response statusCode];
	return qeResponse;
}

-(NSString *)getXSFRValue
{
	if (self.xsrf != nil) {
        return self.xsrf;
    }
    
    NSURL *URLString = [[NSURL alloc]  initWithString:self.baseURL];

	NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URLString];
			
	for (NSHTTPCookie *cookie in allCookies)
	{
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate);
		if ([cookie.name isEqualToString:@"_xsrf"]) {
            self.xsrf = [[NSString alloc] initWithString:cookie.value];
            return self.xsrf;
		}
	}
	return nil;
	
}




-(void)login:(NSString *)username password:(NSString *)password status:(int *)status
{
	QEHTTPClientResponse *qeResponse = [self doQEPostRequest:@"login" postFields:[NSDictionary dictionaryWithObjectsAndKeys:username, @"email_address", password, @"password", nil]];
	NSString *content = qeResponse.content;
	*status = qeResponse.statusCode;
	
    if (*status != 200) {
        self.isLoggedIn = false;
        self.userID = -1;
        return;
    }
    
	NSDictionary *results = [content JSONValue];
	
    self.isLoggedIn = true;
    self.userID = [[results objectForKey:@"userID"] intValue];

}

-(void)logout:(int *)status
{
    QEHTTPClientResponse *qeResponse = [self doQEGetRequest:@"logout" queryFields:nil];
	*status = qeResponse.statusCode;
	
}

-(NSMutableArray *)getMyGames:(int *)status
{
	QEHTTPClientResponse *qeResponse = [self doQEGetRequest:@"getmygames" queryFields:nil];
    NSString *content = qeResponse.content;
	*status = qeResponse.statusCode;
    // XXX - find a better way to check this all the time
    // I wonder if objective C has decorators? 
    // 403 means we need to log in. 
    if (*status == 403) {
        return nil;
    }
    
	NSDictionary *results = [content JSONValue];
    
    NSMutableArray *gamesArray = [[NSMutableArray alloc] init];
    
    // /api/getmygames JSON example: {"status": "ok", "games": [{"name": "307f46c2", "players_in_game": 4, "id": 1}]}
    
    NSArray *games = [results objectForKey:@"games"];
    for (NSDictionary *game in games) {
        NSString *gameName = [game objectForKey:@"name"];
		int gameID = [[game objectForKey:@"id"] intValue];
        int playerCount = [[game objectForKey:@"players_in_game"] intValue];
        MultiplayerGame *newGame = [[MultiplayerGame alloc] init];
        newGame.name = [[NSString alloc] initWithString:gameName];
        newGame.gameID = gameID;
        newGame.numPlayers = playerCount;
        [gamesArray addObject:newGame];
        
    }
    
    return gamesArray;
    
}

/* create game & load game return the same JSON:
 
 load game json:
   {"status": "ok", 
    "map": {"width": 5, "game": 1, "id": 1, "height": 5}, 
    "players": [{"name": "adam", "xLocation": 2, "uranium": 4000, "yLocation": 1, 
                    "player": 1, "game": 1, "emailAddress": "adamf@csh.rit.edu", "id": 1, "round": 0}, 
                {"emailAddress": "roryk@mit.edu", "id": 2, "name": "rory"}, 
                {"emailAddress": "seanth@gmail.com", "id": 3, "name": "sean"}, 
                {"emailAddress": "jessica.mckellar@gmail.com", "id": 4, "name": "jessica"}], 
    "game": [{"map": 1, "num_planets": 6, "name": "307f46c2", "game_over": 0, "whose_turn": 3, "players_in_game": 4, 
                "last_turn": 0, "owner": 1, "id": 1}], 
    "planets": [{"map": 1, "name": "Ertria", "earn_rate": 2, "picture": "Ice Planet.jpg", "xLocation": 0, "id": 1, 
                    "total_uranium": 117, "game": 1, "cost": 200, "owner": null, "yLocation": 4}, 
                {"map": 1, "name": "Ceti III", "earn_rate": 2, "picture": "Ice Planet.jpg", "xLocation": 2, "id": 2, 
                    "total_uranium": 105, "game": 1, "cost": 200, "owner": null, "yLocation": 0}, 
                {"map": 1, "name": "Galli III", "earn_rate": 2, "picture": "Dead World.jpg", "xLocation": 2, "id": 3, 
                    "total_uranium": 120, "game": 1, "cost": 200, "owner": null, "yLocation": 2}, 
                {"map": 1, "name": "Germany", "earn_rate": 1, "picture": "Pyrobora.jpg", "xLocation": 2, "id": 4, 
                    "total_uranium": 138, "game": 1, "cost": 100, "owner": null, "yLocation": 3}, 
                {"map": 1, "name": "New Mars", "earn_rate": 2, "picture": "High Winds.jpg", "xLocation": 3, "id": 5, 
                    "total_uranium": 120, "game": 1, "cost": 200, "owner": null, "yLocation": 0}, 
                {"map": 1, "name": "Goulton", "earn_rate": 1, "picture": "Waterless World.jpg", "xLocation": 3, "id": 6, 
                    "total_uranium": 89, "game": 1, "cost": 100, "owner": null, "yLocation": 2}], 
    "id": 1}
 
 */

-(NSMutableArray *)createGame:(NSNumber *)userID status:(int *)status
{
	QEHTTPClientResponse *qeResponse = [self doQEGetRequest:@"createGame" queryFields:[NSDictionary dictionaryWithObjectsAndKeys:[userID stringValue], @"user_id", nil]];
    NSString *content = qeResponse.content;
	*status = qeResponse.statusCode;
    if (*status == 403) {
        return nil;
    }
	NSDictionary *results = [content JSONValue];
     	
}

@end
