//
//  SilvestreEditor.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 07/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SilvestreEditor : UIView

@property (nonatomic,strong) NSNumber *orientacioOriginal;
@property (nonatomic) BOOL imatgeDeLaBDD;
@property (nonatomic) BOOL esApaisat;
@property (nonatomic,strong) NSString *maActual;
@property (nonatomic,strong) UIImage *imatgeFinal;
@property (nonatomic,strong) UIImage *imatgeInicialRedimensionada;
@property (nonatomic) UIImage *imatgeInicial;
@property (nonatomic) BOOL estaArrossegant;
@property (nonatomic) BOOL haDesfetUlimPas;


+(UIImage *)redimensionar:(UIImage *)imatge ALaMida:(CGSize)size;
+(UIImage *)ferMiniaturaQuadradaDe:(UIImage *)imatge ambMida:(CGSize) mida;
+(UIImage *)ferMiniaturaRetalladaDe:(UIImage *)imatge esApaisada:(BOOL)esApaisada ambMida:(CGSize)size;


-(void)inicialitzarMansIEsApaisat:(float)orientacio;
-(void)inicialitzar:(CGSize)frame;
-(void)guardar;
-(UIImage *)desferUltimPasDesde:(UIImage *) imatge;
-(UIImage *)comencaArrossegar:(CGPoint) p;
-(UIImage *)continuaArrossegar:(CGPoint) p;
-(UIImage *)finalitzaArrossegar:(CGPoint) p;
-(UIImage *)haFetUnToc:(CGPoint) p aLaImatge:(UIImage *) imatge;

@end
