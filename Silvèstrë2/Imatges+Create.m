//
//  Imatges+Create.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Imatges+Create.h"

@implementation Imatges (Create)

+ (Imatges *)     crearImatgeAmb:(UIImage *)imatge
                      orientacio:(float)orientacio
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    Imatges *imatgeObj = nil;
    imatgeObj = [NSEntityDescription insertNewObjectForEntityForName:@"Imatges" inManagedObjectContext:context];
    imatgeObj.imatge = imatge;
    imatgeObj.orientacio = [NSNumber numberWithFloat:orientacio];

    return imatgeObj;
}

@end
