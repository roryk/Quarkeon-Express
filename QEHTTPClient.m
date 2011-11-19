#import "QEHTTPClient.h"
#import "QEHTTPClientResponse.h"
#import "JSON.h"





@implementation QEHTTPClient
@synthesize baseURL;

- (id)init {
    self = [super init];
	if (!self)
		return nil;
	self.baseURL = @"http://localhost:8888";
	
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
	NSURL *URLString = [[NSURL alloc]  initWithString:self.baseURL];

	NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URLString];
			
	for (NSHTTPCookie *cookie in allCookies)
	{
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate);
		if ([cookie.name isEqualToString:@"_xsrf"]) {
			return cookie.value;
		}
	}
	return nil;
	
}


-(int)login:(NSString *)username password:(NSString *)password status:(int *)status
{
	QEHTTPClientResponse *qeResponse = [self doQEPostRequest:@"login" postFields:[NSDictionary dictionaryWithObjectsAndKeys:username, @"user_name", password, @"password", nil]];
	NSString *content = qeResponse.content;
	*status = qeResponse.statusCode;
	
	NSDictionary *results = [content JSONValue];
	
	if (results.count == 0) {
		return -1;
	} 
	
	return [[results objectForKey:@"userID"] intValue];

}

-(void)logout:(int *)status
{
    QEHTTPClientResponse *qeResponse = [self doQEGetRequest:@"logout" queryFields:nil];
	*status = qeResponse.statusCode;
	
}


-(NSMutableArray *)getMap:(NSNumber *)userID status:(int *)status
{
	QEHTTPClientResponse *qeResponse = [self doQEGetRequest:@"getmap" queryFields:[NSDictionary dictionaryWithObjectsAndKeys:[userID stringValue], @"user_id", nil]];
    NSString *content = qeResponse.content;
	*status = qeResponse.statusCode;
	NSDictionary *results = [content JSONValue];
     	
}

@end
