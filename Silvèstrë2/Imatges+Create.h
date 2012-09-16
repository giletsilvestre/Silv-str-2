//
//  Imatges+Create.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Imatges.h"

@interface Imatges (Create)


+ (Imatges *)     crearImatgeAmb:(UIImage *)imatge
                      orientacio:(float) orientacio
          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
