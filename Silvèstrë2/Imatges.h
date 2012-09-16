//
//  Imatges.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Configuracio, Llocs, Ressenyes;

@interface Imatges : NSManagedObject

@property (nonatomic, retain) id imatge;
@property (nonatomic, retain) NSNumber * orientacio;
@property (nonatomic, retain) Llocs *avatarLloc;
@property (nonatomic, retain) Configuracio *avatarUsuari;
@property (nonatomic, retain) Ressenyes *miniaturaRessenya;
@property (nonatomic, retain) Ressenyes *ressenya;
@property (nonatomic, retain) Ressenyes *thumbnailRessenya;

@end
