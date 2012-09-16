//
//  Configuracio+Create.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Configuracio.h"

@interface Configuracio (Create)

+ (Configuracio *) crearConfiguracioAmbUsuari:(NSString *) usuari
                          contrassenya:(NSString *) contrassenya
                        llocPerDefecte:(NSString *) llocPerDefecte
                                avatar:(UIImage *) avatar
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
