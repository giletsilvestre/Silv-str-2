//
//  Configuracio.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Imatges, Llocs;

@interface Configuracio : NSManagedObject

@property (nonatomic, retain) NSString * contrassenya;
@property (nonatomic, retain) NSString * nomUsuari;
@property (nonatomic, retain) Imatges *avatar;
@property (nonatomic, retain) Llocs *llocPerDefecte;

@end
