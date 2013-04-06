//
//  NSManagedObjectContext+Extends.h
//  LooCha
//
//  Created by XiongCaixing on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(Extends)
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request 
                       groupedBy:(NSString *)group 
                     sortWithKey:(NSString *)key 
                       ascending:(BOOL)ascending 
                           error:(NSError **)error;
@end
