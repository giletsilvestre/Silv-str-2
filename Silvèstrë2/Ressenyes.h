//
//  Ressenyes.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Imatges, Llocs;

@interface Ressenyes : NSManagedObject

@property (nonatomic, retain) NSString * autor;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSDecimalNumber * dificultat;
@property (nonatomic, retain) NSNumber * encadenada;
@property (nonatomic, retain) NSNumber * esTemporal;
@property (nonatomic, retain) NSDecimalNumber * estil;
@property (nonatomic, retain) NSDecimalNumber * idRessenyaWEB;
@property (nonatomic, retain) NSNumber * projecte;
@property (nonatomic, retain) NSNumber * pujada;
@property (nonatomic, retain) NSNumber * ressenyada;
@property (nonatomic, retain) Imatges *imatge;
@property (nonatomic, retain) Llocs *lloc;
@property (nonatomic, retain) Imatges *miniatura;
@property (nonatomic, retain) Imatges *thumbnail;

@end
