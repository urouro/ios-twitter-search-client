#import "TwitterSearchClient.h"
#import <Social/Social.h>

NSString * const TwitterSearchClientErrorDomain = @"TwitterSearchClientErrorDomain";

@implementation TwitterSearchClient

+ (void)searchWithAccountStore:(ACAccountStore *)accountStore account:(ACAccount *)account word:(NSString *)word completion:(void (^)(NSDictionary *result, NSError *error))completion;
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSError *error = [[NSError alloc] initWithDomain:TwitterSearchClientErrorDomain
                                                    code:TwitterSearchClientErrorCodeNotAvailableTwitter
                                                userInfo:@{NSLocalizedDescriptionKey: @"Twitter not available"}];
        completion(nil, error);
        return;
    }
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:NULL
                                       completion:^(BOOL granted, NSError *error) {
                                           if (!granted) {
                                               NSError *error;
                                               error = [[NSError alloc] initWithDomain:TwitterSearchClientErrorDomain
                                                                                  code:TwitterSearchClientErrorCodeGrantFalse
                                                                              userInfo:@{NSLocalizedDescriptionKey: @"granted is false"}];
                                               completion(nil, error);
                                               return;
                                           }
                                           
                                           NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                                           NSDictionary *params = @{
                                                                    @"q": word,
                                                                    };
                                           SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                                   requestMethod:SLRequestMethodGET
                                                                                             URL:url
                                                                                      parameters:params];
                                           [request setAccount:account];
                                           
                                           [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                               if (urlResponse.statusCode < 200 || urlResponse.statusCode >= 300) {
                                                   NSError *error;
                                                   error = [[NSError alloc] initWithDomain:TwitterSearchClientErrorDomain
                                                                                      code:TwitterSearchClientErrorCodeInvalidStatusCode
                                                                                  userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"statusCode is %@, error=%@", @(urlResponse.statusCode), error]}];
                                                   completion(nil, error);
                                                   return;
                                               }
                                               
                                               NSError *jsonError = nil;
                                               NSDictionary *timeline = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                   options:NSJSONReadingAllowFragments
                                                                                                     error:&jsonError];
                                               
                                               if (jsonError) {
                                                   NSError *error;
                                                   error = [[NSError alloc] initWithDomain:TwitterSearchClientErrorDomain
                                                                                      code:TwitterSearchClientErrorCodeJSONParseError
                                                                                  userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"jsonError=%@", jsonError]}];
                                                   completion(nil, error);
                                                   return;
                                               }
                                               
                                               completion(timeline, nil);
                                           }];
                                       }];
}

@end
