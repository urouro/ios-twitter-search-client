#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

extern NSString * const TwitterSearchClientErrorDomain;

typedef NS_ENUM(NSUInteger, TwitterSearchClientErrorCode) {
    TwitterSearchClientErrorCodeNotAvailableTwitter = 1,
    TwitterSearchClientErrorCodeGrantFalse = 2,
    TwitterSearchClientErrorCodeInvalidStatusCode = 3,
    TwitterSearchClientErrorCodeJSONParseError = 4,
};

/**
 *  Wrapper fetching data https://api.twitter.com/search/tweets.json
 */
@interface TwitterSearchClient : NSObject

/**
 *  fetching data Search API
 *
 *  @param accountStore
 *  @param account
 *  @param word         Search query (use. `"q=%@", word`)
 *  @param completion   
 */
+ (void)searchWithAccountStore:(ACAccountStore *)accountStore account:(ACAccount *)account word:(NSString *)word completion:(void (^)(NSDictionary *result, NSError *error))completion;

@end
