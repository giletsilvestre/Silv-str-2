//
//  Llocs+Create.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Llocs+Create.h"
#import "Imatges+Create.h"

@implementation Llocs (Create)

+ (Llocs *) crearLlocAmbNom:(NSString *) nom
                coordenades:(NSString *) coordenades
                     adreca:(NSString *) adreca
                     avatar:(UIImage *) avatar
     inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Llocs *lloc = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Llocs"];
    request.predicate = [NSPredicate predicateWithFormat:@"nom like[c] %@", nom];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"error");

    } else if ([matches count] == 0) {
        NSLog(@"crea LLoc");
        lloc = [NSEntityDescription insertNewObjectForEntityForName:@"Llocs" inManagedObjectContext:context];
        lloc.nom = nom;
        lloc.coord = coordenades;
        lloc.adreca = adreca;
        lloc.llocUsuari = NULL;
        lloc.ressenyes = NULL;
        lloc.avatar = [Imatges crearImatgeAmb:avatar orientacio: 10.0 inManagedObjectContext:context];
    } else {
        lloc = [matches lastObject];
        NSLog(@"ja existeix");

    }
    
    return lloc;
}

@end
