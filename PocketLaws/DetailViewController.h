//
//  DetailViewController.h
//  PocketLaws
//
//  Created by John Jusayan on 10/15/11.
//  Copyright (c) 2011 Treeness, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Segment;

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) Segment *detailItem;
@property (strong, nonatomic) NSArray *childrenSegments;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end
