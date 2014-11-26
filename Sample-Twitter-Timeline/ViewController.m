//
//  ViewController.m
//  Sample-Twitter-Timeline
//
//  Created by Kenta Nakai on 2014/11/26.
//

#import "ViewController.h"
#import "TweetCell.h"
#import "TwitterSearchClient.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) ACAccountStore *accountStore;
@property(nonatomic,strong) NSArray *statuses;

@property(nonatomic,strong) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accountStore = [ACAccountStore new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self _fetchTimeline];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *status = self.statuses[indexPath.row];
    cell.userNameLabel.text = status[@"user"][@"name"];
    cell.tweetTextLabel.text = status[@"text"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Private Method

- (void)_reload
{
    [self.tableView reloadData];
}

- (void)_fetchTimeline
{

    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [TwitterSearchClient searchWithAccountStore:self.accountStore
                                        account:[[self.accountStore accountsWithAccountType:accountType] firstObject]
                                           word:@"%23tv"
                                     completion:^(NSDictionary *results, NSError *error) {
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                         
                                         LOG(@"results=%@", results);
                                         LOG(@"error=%@", error);
                                         
                                         if (error) {
                                             return;
                                         }
                                         
                                         self.statuses = results[@"statuses"];
                                         
                                         [self _reload];
                                     }];
}



@end
