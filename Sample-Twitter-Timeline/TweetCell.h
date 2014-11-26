//
//  TweetCell.h
//  Sample-Twitter-Timeline
//
//  Created by Kenta Nakai on 2014/11/26.
//
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *userNameLabel;
@property(nonatomic,weak) IBOutlet UILabel *tweetTextLabel;

@end
