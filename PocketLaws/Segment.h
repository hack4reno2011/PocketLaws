//
//  Segment.h
//  PocketLaws
//
//  Created by John Jusayan on 10/15/11.
//  Copyright (c) 2011 Treeness, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment;

@interface Segment : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Segment *parent;
@property (nonatomic, retain) NSSet *children;
@end

@interface Segment (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Segment *)value;
- (void)removeChildrenObject:(Segment *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
