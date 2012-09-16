//
//  Llocs.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Configuracio, Imatges, Ressenyes;

@interface Llocs : NSManagedObject

@property (nonatomic, retain) NSString * adreca;
@property (nonatomic, retain) NSString * coord;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) Imatges *avatar;
@property (nonatomic, retain) Configuracio *llocUsuari;
@property (nonatomic, retain) NSSet *ressenyes;
@end

@interface Llocs (CoreDataGeneratedAccessors)

- (void)addRessenyesObject:(Ressenyes *)value;
- (void)removeRessenyesObject:(Ressenyes *)value;
- (void)addRessenyes:(NSSet *)values;
- (void)removeRessenyes:(NSSet *)values;

@end
