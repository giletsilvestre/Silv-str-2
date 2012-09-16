//
//  Ressenyes+Create.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ressenyes+Create.h"
#import "Llocs+Create.h"
#import "Imatges+Create.h"

@implementation Ressenyes (Create)

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
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    Ressenyes *ressenya = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ressenyes"];
    request.predicate = [NSPredicate predicateWithFormat:@"data = %@", data];//compte amb la @ perque es de tipus date i no estic segur que això pugui funcionar així
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Query ha fallat a crear ressenya");
    } else if ([matches count] == 0) {

        ressenya = [NSEntityDescription insertNewObjectForEntityForName:@"Ressenyes"
                                                 inManagedObjectContext:context];
        ressenya.dificultat = dificultat;
        ressenya.estil = estil;
        ressenya.pujada = [NSNumber numberWithBool: pujada];
        ressenya.data = data;
        ressenya.esTemporal = [NSNumber numberWithBool: esTemporal];
        ressenya.ressenyada = [NSNumber numberWithBool: ressenyada];
        ressenya.encadenada = [NSNumber numberWithBool: encadenada];
        ressenya.projecte = [NSNumber numberWithBool: projecte];
        ressenya.autor = autor;
        ressenya.imatge = [Imatges crearImatgeAmb:imatge orientacio:orientacio inManagedObjectContext:context];
        ressenya.miniatura = [Imatges crearImatgeAmb:miniatura orientacio: orientacio inManagedObjectContext:context];
        ressenya.thumbnail = [Imatges crearImatgeAmb:thumbnail orientacio: orientacio inManagedObjectContext:context];
        UIImage *avatarLloc = [[UIImage alloc]init];
        avatarLloc = [UIImage imageNamed:@"defaultllocavatar.png"];
        ressenya.lloc = [Llocs crearLlocAmbNom:lloc coordenades:NULL adreca:NULL avatar:avatarLloc inManagedObjectContext:context];
    } else {
        ressenya = [matches lastObject];
    }
    
    
    return ressenya;
}

@end
