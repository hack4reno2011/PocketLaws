//
//  MasterViewController.m
//  PocketLaws
//
//  Created by John Jusayan on 10/15/11.
//  Copyright (c) 2011 Treeness, LLC. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Segment.h"

@interface MasterViewController ()
- (void)configureTableView:(UITableView*)aTableView cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize segments = _segments;
@synthesize filteredList = _filteredList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Set up the edit and add buttons.
    self.navigationController.navigationBar.tintColor = PLTintColor;
    
    self.title = @"Sources";
    /*
    
    // Insert code here to initialize your application
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"testRAC" withExtension:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:fileURL];
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *segments = [(NSDictionary*)jsonObject objectForKey:@"segments"];
    self.segments = segments;
    
    [self.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self segmentForDictionary:(NSDictionary*)obj];
        NSLog(@"segments");
    }];
    
    [self.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self associateChildrenWithParents:obj];
        NSLog(@"associating");
    }];
    
    [self.managedObjectContext save:NULL];
    
     */
    
    
//    NSFetchRequest *testForLoadedDataFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
//    
//    if ([self.managedObjectContext countForFetchRequest:testForLoadedDataFetchRequest error:NULL]) {
////        NSArray *segments = [self.managedObjectContext executeFetchRequest:testForLoadedDataFetchRequest error:NULL];
////        [segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
////            NSLog(@"%@ %@", [obj title], [obj content]);
////        }];
//        return;
//    }
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Laws" withExtension:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfURL:fileURL];
//    
//    NSError *error;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//    NSMutableArray *segments = [(NSDictionary*)jsonObject objectForKey:@"segments"];
//    self.segments = segments;
//        
//    [self.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [self segmentForDictionary:(NSDictionary*)obj];
//    }];
//    
//    [self.segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [self associateChildrenWithParents:obj];
//    }];
//    
//    [self.managedObjectContext save:NULL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return [[self.fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredList count];
    }
    else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    [self configureTableView:tableView cell:cell atIndexPath:indexPath];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Segment *selectedObject = (Segment*)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    detailViewController.detailItem = selectedObject;    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Segment" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *hasParentPredicate = [NSPredicate predicateWithFormat:@"parent == nil"];
    [fetchRequest setPredicate:hasParentPredicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureTableView:tableView cell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureTableView:(UITableView*)aTableView cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
{
    Segment *segment;
    
    if (aTableView == self.searchDisplayController.searchResultsTableView) {
        segment = (Segment*)[self.filteredList objectAtIndex:indexPath.row];
    }
    else {
        segment = (Segment*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.textLabel.text = segment.title;
    cell.detailTextLabel.text = segment.subtitle;    
}

- (void)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"identifier"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (Segment*)segmentForDictionary:(NSDictionary*)aDictionary
{
    Segment *newSegment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:self.managedObjectContext];
    id identifier = [aDictionary objectForKey:@"identifier"];
    if (identifier != [NSNull null]) {
    newSegment.identifier = identifier;
    }
    id title = [aDictionary objectForKey:@"title"];
    if (title != [NSNull null]) {
        newSegment.title = title;
    }
    id subtitle =  [aDictionary objectForKey:@"subtitle"];
    if (subtitle != [NSNull null]) {
        newSegment.subtitle = subtitle;
    }
    id content = [aDictionary objectForKey:@"content"];
    if (content != [NSNull null]) {
        newSegment.content = content;
    }
    
    return newSegment;
}

#pragma mark - UITableViewDataSource section title

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    if (tableView == self.tableView) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? [self.fetchedResultsController sectionIndexTitles] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return tableView == self.tableView ? [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index] : 0;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (void)associateChildrenWithParents:(NSDictionary*)segmentDictionary
{
    NSFetchRequest *parentFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    [parentFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", [segmentDictionary objectForKey:@"identifier"]]];
    
    NSError *error;
    NSArray *arrayContainingParent = [self.managedObjectContext executeFetchRequest:parentFetchRequest error:&error];
    
    if ([arrayContainingParent count] != 1) {
        NSLog(@"There are %i parent segments found. This should not happen", [arrayContainingParent count]);
        [arrayContainingParent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"%@, %@", [obj identifier], [obj title]);
        }];
        return;
    }
    
    Segment *parentSegment = [arrayContainingParent lastObject];
    
    NSArray *childrenIdentifiers = (NSArray*)[segmentDictionary objectForKey:@"children"];
    [childrenIdentifiers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSError *error;
        
        NSString *childIdentifier = (NSString*)obj;
        NSFetchRequest *childFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
        [childFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", childIdentifier]];
        NSArray *arrayContainingChild = [self.managedObjectContext executeFetchRequest:childFetchRequest error:&error];
        
        if ([arrayContainingChild count] != 1) {
            NSLog(@"There are %i child segments found. This should not happen", [arrayContainingChild count]);
            [arrayContainingParent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@, %@", [obj identifier], [obj title]);
            }];
        }
        Segment *childSegment = [arrayContainingChild lastObject];
        childSegment.parent = parentSegment;
    }];
    
}


@end
