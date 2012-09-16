//
//  SilvestreTraductorNumerosBDD.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 28/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SilvestreTraductorNumerosBDD : NSObject

+(NSString *)traduirGrau:(NSDecimalNumber *)grau;
+(UIColor *)traduirColorGrau:(NSDecimalNumber *)grau;
+(NSString *)traduirEstil:(NSDecimalNumber *)estil;


@end
