//
//  Llocs+Create.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Llocs.h"

@interface Llocs (Create)

+ (Llocs *) crearLlocAmbNom:(NSString *) nom
                coordenades:(NSString *) coordenades
                     adreca:(NSString *) adreca
                     avatar:(UIImage *) avatar
     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
