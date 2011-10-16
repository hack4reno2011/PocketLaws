//
//  MasterViewController.h
//  PocketLaws
//
//  Created by John Jusayan on 10/15/11.
//  Copyright (c) 2011 Treeness, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class Segment;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *segments;

- (Segment*)segmentForDictionary:(NSDictionary*)aDictionary;
- (void)associateChildrenWithParents:(NSDictionary*)segmentDictionary;

@end
