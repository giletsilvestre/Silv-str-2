//
//  SilvestreTraductorNumerosBDD.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 28/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreTraductorNumerosBDD.h"

@implementation SilvestreTraductorNumerosBDD

+(NSString *)traduirGrau:(NSDecimalNumber *)grau
{
    NSString *grauTraduit=[[NSString alloc]initWithString:@"Facil"];
    NSLog(@"entra");
    switch (grau.integerValue) {
        case 0:
            grauTraduit = @"Facil";
            break;
        case 1:
            grauTraduit = @"Moderat";
            break;
        case 2:
            grauTraduit = @"Dificil";
            break;
        case 10:
            grauTraduit = @"Nd";
            break;
        default:
            break;
    }
    return grauTraduit;
}

+(UIColor *)traduirColorGrau:(NSDecimalNumber *)grau    
{
    UIColor *colorGrau = [[UIColor alloc]init];
    switch (grau.integerValue) {
        case 0:
            colorGrau = [UIColor greenColor];
            break;
        case 1:
            colorGrau = [UIColor blueColor];
            break;
        case 2:
            colorGrau = [UIColor redColor];
            break;
        case 10:
            colorGrau = [UIColor grayColor];
            break;
        default:
            colorGrau = [UIColor greenColor];
            break;
    }
    return colorGrau;
}

+(NSString *)traduirEstil:(NSDecimalNumber *)estil
{
    NSString *estilTraduit=[[NSString alloc]initWithString:@"Lliure"];

    switch (estil.integerValue) {
        case 0:
            estilTraduit = @"Lliure";
            break;
        case 1:
            estilTraduit = @"Ma peu";
            break;
        case 2:
            estilTraduit = @"Sense peus";
            break;
        case 10:
            estilTraduit = @"Nd";
            break;
        default:
            break;
    }
    return estilTraduit;
}

@end
