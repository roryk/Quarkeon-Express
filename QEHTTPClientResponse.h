

#import <Foundation/Foundation.h>


@interface QEHTTPClientResponse : NSObject {
	int statusCode;
	NSString *content;

}

@property (nonatomic, retain) NSString *content;

@property (readwrite, assign) int statusCode;

@end
