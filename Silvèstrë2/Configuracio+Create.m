//
//  Configuracio+Create.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Configuracio+Create.h"
#import "Imatges+Create.h"
#import "Llocs+Create.h"

@implementation Configuracio (Create)

+ (Configuracio *) crearConfiguracioAmbUsuari:(NSString *) usuari
                          contrassenya:(NSString *) contrassenya
                        llocPerDefecte:(NSString *) llocPerDefecte
                                avatar:(UIImage *) avatar
                inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Configuracio *configuracioUsuari = nil;
    NSLog(@"crear configuracio");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Configuracio"];
    request.predicate = [NSPredicate predicateWithFormat:@"nomUsuari = %@", usuari];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"error query");
    } else if ([matches count] == 0) {
        NSLog(@"crear per primer cop");
        configuracioUsuari = [NSEntityDescription insertNewObjectForEntityForName:@"Configuracio" inManagedObjectContext:context];
        configuracioUsuari.nomUsuari = usuari;
        configuracioUsuari.contrassenya = contrassenya;
        configuracioUsuari.llocPerDefecte = [Llocs crearLlocAmbNom:llocPerDefecte coordenades:NULL adreca:NULL avatar:NULL inManagedObjectContext:context];
        configuracioUsuari.avatar = [Imatges crearImatgeAmb:avatar orientacio: 10.0 inManagedObjectContext:context];
    } else {
        NSLog(@"actualitzar");
        configuracioUsuari = [matches lastObject];
        configuracioUsuari.llocPerDefecte = [Llocs crearLlocAmbNom:llocPerDefecte coordenades:NULL adreca:NULL avatar:NULL inManagedObjectContext:context];
    
    }
    
    return configuracioUsuari;
}

@end
