//
//  Ressenyes+Create.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ressenyes.h"

@interface Ressenyes (Create)

+ (Ressenyes *)ressenyaAlLloc:(NSString *)lloc
                        autor:(NSString *) autor
                   dificultat:(NSDecimalNumber *) dificultat
                        estil:(NSDecimalNumber *) estil
                       imatge:(UIImage *) imatge
                    miniatura:(UIImage *) miniatura
                    thumbnail:(UIImage *) thumbnail
                   orientacio:(float) orientacio
                         data:(NSDate *) data
                idRessenyaWEB:(NSString *) idRessenyaWEB
                       pujada:(BOOL) pujada
                   ressenyada:(BOOL) ressenyada
                   encadenada:(BOOL) encadenada
                     projecte:(BOOL) projecte
                   esTemporal:(BOOL) esTemporal
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
