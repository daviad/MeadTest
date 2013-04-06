//
//  NSManagedObjectContext+Extends.m
//  LooCha
//
//  Created by XiongCaixing on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+Extends.h"

@implementation NSManagedObjectContext(Extends)

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request 
                       groupedBy:(NSString *)group 
                     sortWithKey:(NSString *)key 
                       ascending:(BOOL)ascending 
                           error:(NSError **)error {
    NSArray *results = [self executeFetchRequest:request error:error];
    
//    RCLog(@"results:%@", results);
    
    NSString *groupPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", group];
    NSArray *groups = [results valueForKeyPath:groupPath];
    
    NSMutableArray *newResults = [[[NSMutableArray alloc] initWithCapacity:[groups count]] autorelease];
    for (NSString *groupValue in groups) {
        NSString *format = [NSString stringWithFormat:@"(%@ == '%@')",
                            group, groupValue];
//        RCLog(@"format:%@", format);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
        NSArray *array = [results filteredArrayUsingPredicate:predicate];
//        RCLog(@"array:%@", array);
        NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] 
                                             initWithKey:key 
                                             ascending:ascending 
                                             selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray* sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
        array = [array sortedArrayUsingDescriptors:sortDescriptors];
        [newResults addObject:array];
        [nameDescriptor release];
    }
    
    //NSLog(@"newResults: %@", newResults);
    
    return newResults;
}

@end
