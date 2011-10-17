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

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *segments;
@property (strong, nonatomic) NSMutableArray *filteredList;

- (Segment*)segmentForDictionary:(NSDictionary*)aDictionary;
- (void)associateChildrenWithParents:(NSDictionary*)segmentDictionary;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
