//
//  SilvestreEditor.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 07/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define MIDAXMA 0.07
#define MIDAYMA 0.07
#define MIDAXMANS 0.14
#define MIDAYMANS 0.07
#define CORRECCIOX 0.05 /*Desviació X del toc(tap gesture) i on ha d'apareixer visualment*/
#define CORRECCIOY 0.02 /*Desviació Y del toc(tap gesture) i on ha d'apareixer visualment*/
#define MIDANUMEROS 0.0495 /*Numeros de les mans*/
#define MIDATEXTWATERMARK 0.08
#define MIDAYWATERMARK 0.07
#define COMPRESSIO 2
#define ARROSSEGAROFFSET 0.19 /*Desplaçament per arrossegar la mà i poder veurela sobre el dit*/

#import "SilvestreEditor.h"
#import "SilvestreImageEditorViewController.h"
#import "UIImage+Transformacions.h"

@interface SilvestreEditor()

@property (nonatomic,strong) NSString *maDretaArxiu;
@property (nonatomic,strong) NSString *maEsquerraArxiu;
@property (nonatomic,strong) NSString *juntesArxiu;

@property (nonatomic) NSInteger numeroActual;
@property (nonatomic) float proporcioPantalla;
@property (nonatomic,strong) UIImage *imatgeAnterior;
@property (nonatomic,strong) UIImage *imatgeInicialRotada;
@property (nonatomic,strong) NSMutableArray *puntsMarcats;
@property (nonatomic,strong) NSMutableArray *maAlPunt;
@property (nonatomic) float proporcioImatgeEdicioRealX;
@property (nonatomic) float proporcioImatgeEdicioRealY;
@property (nonatomic) float costatPetitGlobal;  //Totes les mides dels objectes dibuixats, estan en
//proporció al costat petit, d'aquesta manera ens assegurem 
//que sempre cabran a la imatge i estaran
//proporcionals a les mides de les diferents resolucions.

@end

@implementation SilvestreEditor

@synthesize maActual = _maActual;
@synthesize maDretaArxiu =_maDretaArxiu;
@synthesize maEsquerraArxiu = _maEsquerraArxiu;
@synthesize juntesArxiu = _juntesArxiu;
@synthesize numeroActual = _numeroActual;
@synthesize proporcioPantalla;
@synthesize imatgeInicial = _imatgeInicial;
@synthesize imatgeInicialRedimensionada = _imatgeInicialRedimensionada;
@synthesize imatgeAnterior = _imatgeAnterior;
@synthesize imatgeFinal = _imatgeFinal;
@synthesize imatgeInicialRotada = _imatgeInicialRotada;
@synthesize estaArrossegant = _estaArrossegant;
@synthesize haDesfetUlimPas = _haDesfetUlimPas;
@synthesize puntsMarcats = _puntsMarcats;
@synthesize maAlPunt = _maAlPunt;
@synthesize proporcioImatgeEdicioRealX = _proporcioImatgeEdicioRealX;
@synthesize proporcioImatgeEdicioRealY = _proporcioImatgeEdicioRealY;
@synthesize costatPetitGlobal = _costatPetitGlobal;
@synthesize esApaisat =_esApaisat;
@synthesize orientacioOriginal = _orientacioOriginal;
@synthesize imatgeDeLaBDD = _imatgeDeLaBDD;


+(UIImage *)ferMiniaturaRetalladaDe:(UIImage *)imatge
                         esApaisada:(BOOL)esApaisada
                            ambMida:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    if(esApaisada){
        [imatge drawAtPoint:CGPointMake(size.width-imatge.size.width, 0)];
    } else {
        [imatge drawAtPoint:CGPointMake(0, size.height-imatge.size.height)];
    }
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


//Prec: La imatge ha de ser panoràmica(o un costat més gran que l'altre)

+(UIImage *)ferMiniaturaQuadradaDe:(UIImage *)imatge ambMida:(CGSize) mida
{
    UIImage *miniatura = [[UIImage alloc]init];
    BOOL esApaisada = NO;
    float proporcio = (imatge.size.height/imatge.size.width);
    if(proporcio < 1 ){//apaisada
        proporcio = (imatge.size.width/imatge.size.height);
        miniatura = [self redimensionar: imatge ALaMida:CGSizeMake(proporcio*mida.width,mida.height)];
        esApaisada = YES;
        
    } else {
        miniatura = [self redimensionar: imatge ALaMida:CGSizeMake(mida.width,proporcio*mida.height)];
        
    }
    miniatura = [self ferMiniaturaRetalladaDe:miniatura esApaisada:esApaisada ambMida:mida];
    
    return miniatura;
}

+(UIImage *)redimensionar:(UIImage *)imatge 
                  ALaMida:(CGSize)size 
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    [imatge drawInRect:rect];
    CGContextStrokeRect(context,rect);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)dibuixarRectAmbText:(NSString *)text
                  midaFont:(NSInteger)midaFont
                     color:(UIColor *)color
                 alineacio:(UITextAlignment) alineacio
                    alPunt:(CGPoint)punt
                   ambMida:(CGSize)mida
                 alContext:(CGContextRef)context

{
    if(self.esApaisat) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, punt.x-mida.height/3, punt.y);
        CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI/2);
        CGContextConcatCTM(context, rotateTransform);
        CGContextTranslateCTM(context,-punt.x-mida.height/2,-punt.y);
    }
    
    CGRect rectAmbText = CGRectMake(punt.x, punt.y, mida.width, mida.height);
    [color setFill];
    
    [text drawInRect:rectAmbText withFont:[UIFont boldSystemFontOfSize:midaFont] lineBreakMode:UILineBreakModeClip alignment:alineacio];
    CGContextStrokeRect(context, rectAmbText);
    
    if(self.esApaisat){
        CGContextRestoreGState(context);   
    }
}

-(void)dibuixarRectAmbImatge:(NSString *)nomImatge
                      alPunt:(CGPoint)punt  
                     ambMida:(CGSize)mida 
               transparencia:(NSNumber *) transparencia
                   alContext:(CGContextRef)context
{
    CGRect rectAmbImatge = CGRectMake(punt.x, punt.y, mida.width, mida.height);
    UIImage *imatge = [UIImage imageNamed:nomImatge];
    [imatge drawInRect:rectAmbImatge blendMode:kCGBlendModeNormal alpha:transparencia.floatValue];
    CGContextStrokeRect(context, rectAmbImatge);
}

-(void)refrescaNumeroAmb:(NSInteger) numero
{
    self.numeroActual = numero;
}



-(NSNumber *)costatPetitDeSize:(CGSize) mida {
    NSNumber *costatPetit = [[NSNumber alloc] initWithFloat:0.0];
    
    if(mida.width < mida.height) {
        costatPetit = [NSNumber numberWithFloat: mida.width];
    } else {
        costatPetit = [NSNumber numberWithFloat: mida.height];
    }
    return costatPetit;
}


-(CGContextRef)inicarContextAmbImatge:(UIImage *) imatge
{
    UIGraphicsBeginImageContext(imatge.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imatge drawAtPoint: CGPointMake(0.0, 0.0)];
    return context;
}

-(UIImage *)redimensionar:(UIImage *)imatge 
                  ALaMida:(CGSize)size 
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    [imatge drawInRect:rect];
    CGContextStrokeRect(context,rect);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//Mètode per dibuixar mans de forma ràpida
-(void)dibuixarMa:(NSString *)ma 
        ambNumero:(NSInteger)numeroADibuixar 
           alPunt:(CGPoint) punt
        alContext:(CGContextRef) context
      queEsDeMida:(CGSize) mida
{        
    
    CGContextSetLineWidth(context, 0.0);
    
    float costatPetit = [[self costatPetitDeSize:mida] floatValue];
    NSString *numero = [NSString stringWithFormat:@"%d",numeroADibuixar];
    
    if([ma isEqualToString:@"Juntes"]) {
        
        
        CGPoint dibuixar = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGSize mida = CGSizeMake(MIDAXMANS*costatPetit, MIDAYMANS*costatPetit);
        if(self.esApaisat){
            mida = CGSizeMake(MIDAYMANS*costatPetit, MIDAXMANS*costatPetit);
        }
        [self dibuixarRectAmbImatge:self.juntesArxiu alPunt:dibuixar ambMida:mida transparencia: [NSNumber numberWithFloat:0.6] alContext:context];
        mida.width = costatPetit;
        dibuixar.x += 0.077*costatPetit;
        [self dibuixarRectAmbText:numero midaFont:MIDANUMEROS*costatPetit color:[UIColor greenColor] alineacio: UITextAlignmentLeft alPunt:dibuixar ambMida:mida alContext:context];
        
    } else { //maActual és "Dreta" o "Esquerra"
        
        CGPoint dibuixar = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGPoint dibuixarText = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGSize mida = CGSizeMake(MIDAXMA*costatPetit, MIDAYMA*costatPetit);
        NSString *nom;
        UIColor *color;
        if([ma isEqualToString:@"Dreta"]) {
            nom = self.maDretaArxiu;
            color = [UIColor cyanColor];
            dibuixarText.x += costatPetit*0.026; //Desviació per centrar el numero
            
        } else { // maActual és "Esquerra"
            nom = self.maEsquerraArxiu;
            color = [UIColor magentaColor];
            dibuixarText.x += costatPetit*0.016; //Desviació per centrar el numero
        }
        
        NSNumber *n =[[NSNumber alloc ]initWithFloat:0.6];
        [self dibuixarRectAmbImatge:nom alPunt:dibuixar ambMida:mida transparencia:n alContext:context];
        mida.width = costatPetit;
        [self dibuixarRectAmbText:numero midaFont:costatPetit*MIDANUMEROS color:color alineacio: UITextAlignmentLeft alPunt:dibuixarText ambMida:mida alContext:context];
        
    }
    
}

//Mètode per dibuixar mans al editor
-(UIImage *)dibuixarMaALaImatge:(UIImage *)imatge 
                         alPunt:(CGPoint) punt
{    
    self.imatgeAnterior = imatge;
    CGContextRef context = [self inicarContextAmbImatge:imatge];
    
    
    CGContextSetLineWidth(context, 0.0);
    
    //float proporcioX = imatge.size.width/self.imatgeView.frame.size.width;
    //float proporcioY = imatge.size.height/self.imatgeView.frame.size.height;
    float costatPetit = [[self costatPetitDeSize:imatge.size] floatValue];
    NSString *numero = [NSString stringWithFormat:@"%d",self.numeroActual];
    
    if([self.maActual isEqualToString:@"Juntes"]) {
        
        
        CGPoint dibuixar = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGSize mida = CGSizeMake(MIDAXMANS*costatPetit, MIDAYMANS*costatPetit);
        if(self.esApaisat){
            mida = CGSizeMake(MIDAYMANS*costatPetit, MIDAXMANS*costatPetit);
        }
        [self dibuixarRectAmbImatge:self.juntesArxiu alPunt:dibuixar ambMida:mida transparencia:[NSNumber numberWithFloat:0.6] alContext:context];
        mida.width = costatPetit;
        dibuixar.x += 0.077*costatPetit;
        [self dibuixarRectAmbText:numero midaFont:MIDANUMEROS*costatPetit color:[UIColor greenColor] alineacio: UITextAlignmentLeft alPunt:dibuixar ambMida:mida alContext:context];
        
    } else { //maActual és "Dreta" o "Esquerra"
        
        CGPoint dibuixar = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGPoint dibuixarText = CGPointMake(punt.x-(CORRECCIOX*costatPetit), punt.y-(CORRECCIOY*costatPetit));
        CGSize mida = CGSizeMake(MIDAXMA*costatPetit, MIDAYMA*costatPetit);
        NSString *nom;
        UIColor *color;
        if([self.maActual isEqualToString:@"Dreta"]) {
            nom = self.maDretaArxiu;
            color = [UIColor cyanColor];
            dibuixarText.x += costatPetit*0.026; //Desviació per centrar el numero
            
        } else { // maActual és "Esquerra"
            nom = self.maEsquerraArxiu;
            color = [UIColor magentaColor];
            dibuixarText.x += costatPetit*0.016; //Desviació per centrar el numero
        }
        
        NSNumber *n =[[NSNumber alloc ]initWithFloat:0.6];
        [self dibuixarRectAmbImatge:nom alPunt:dibuixar ambMida:mida transparencia:n alContext:context];
        mida.width = costatPetit;
        [self dibuixarRectAmbText:numero midaFont:costatPetit*MIDANUMEROS color:color alineacio: UITextAlignmentLeft alPunt:dibuixarText ambMida:mida alContext:context];
    }
    
    UIImage *imatgeAmbMa = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imatgeAmbMa;
}

-(UIImage *)dibuixarPerGuardarMansDelArray:(NSMutableArray *) mans
                                  alsPunts:(NSMutableArray *) punts
               proporcionsImatgeEdicioReal:(CGSize) proporcio
                                 aLaImatge:(UIImage *)imatge
{
    UIImage *imatgeAmbMans = [[UIImage alloc] init];
    CGContextRef context = [self inicarContextAmbImatge:imatge];
    for(int i = punts.count; i > 0;i--) {
        NSString *ma = [mans lastObject];
        [mans removeLastObject];
        CGPoint puntProporcional = [[punts lastObject] CGPointValue];
        [punts removeLastObject];
        puntProporcional.x *= proporcio.width;
        puntProporcional.y *= proporcio.height;
        [self dibuixarMa:ma ambNumero:i alPunt:puntProporcional alContext:context queEsDeMida:imatge.size];
    }
    imatgeAmbMans = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imatgeAmbMans;
}

-(UIImage *)dibuixarPerGuardarMansDelArray:(NSMutableArray *) mans
                                  alsPunts:(NSMutableArray *) punts
                                 aLaImatge:(UIImage *)imatge
{
    UIImage *imatgeAmbMans = [[UIImage alloc] init];
    CGContextRef context = [self inicarContextAmbImatge:imatge];
    for(int i = punts.count; i > 0;i--) {
        NSString *ma = [mans lastObject];
        [mans removeLastObject];
        CGPoint puntProporcional = [[punts lastObject] CGPointValue];
        [punts removeLastObject];
        puntProporcional.x *= self.proporcioImatgeEdicioRealX;
        puntProporcional.y *= self.proporcioImatgeEdicioRealY;
        [self dibuixarMa:ma ambNumero:i alPunt:puntProporcional alContext:context queEsDeMida:imatge.size];
    }
    imatgeAmbMans = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imatgeAmbMans;
}

-(UIImage *)dibuixarMansDelArray:(NSMutableArray *) mans
                        alsPunts:(NSMutableArray *) punts
                       aLaImatge:(UIImage *)imatge
{
    
    UIImage *imatgeAmbMans = [[UIImage alloc] init];
    CGContextRef context = [self inicarContextAmbImatge:imatge];
    for(int i = punts.count; i > 0;i--) {
        NSString *ma = [mans lastObject];
        [mans removeLastObject];
        CGPoint punt = [[punts lastObject] CGPointValue];
        [punts removeLastObject];
        [self dibuixarMa:ma ambNumero:i alPunt:punt alContext:context queEsDeMida:imatge.size];
    }
    imatgeAmbMans = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imatgeAmbMans;
}

-(UIImage *)aplicarWatermarkALaImatge:(UIImage *)imatge 
{
    CGContextRef context = [self inicarContextAmbImatge:imatge];
    float costatPetit = [[self costatPetitDeSize:imatge.size] floatValue];
    CGPoint punt = CGPointMake(0, imatge.size.height-imatge.size.height*MIDAYWATERMARK);
    CGSize mida = CGSizeMake(imatge.size.width, imatge.size.height*MIDAYWATERMARK);
    NSNumber *n =[[NSNumber alloc ]initWithFloat:0.7];
    [self dibuixarRectAmbImatge:@"texture22.png" alPunt:punt ambMida:mida transparencia:n alContext:context];
    CGContextSetLineWidth(context, 0.0);
    punt.x -= costatPetit*0.06;
    self.esApaisat = NO;
    [self dibuixarRectAmbText:@"Silvèstrë" midaFont: costatPetit*MIDATEXTWATERMARK color:[UIColor whiteColor] alineacio: UITextAlignmentRight alPunt:punt ambMida:mida alContext:context];
    UIImage *imatgeAmbWatermark = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imatgeAmbWatermark;
}

-(UIImage *)corregirOrientacioPerEditar:(UIImage *)imatge orientacio:(float)orientacio
{
    UIImage *imatgeCorregida = imatge;
    if (self.imatgeDeLaBDD) {
        if(orientacio == 0.0){//Left
            imatgeCorregida = [imatge imageRotatedByRadians:3*(M_PI/2)];
        } else if(orientacio == 1.0) {//Right
            imatgeCorregida = [imatge imageRotatedByRadians:3*(M_PI/2)];
        }
    } else{
        if(orientacio == 0.0){//Left
            imatgeCorregida = [imatge imageRotatedByRadians:3*(M_PI/2)];
        } else if(orientacio == 1.0) {//Right
            imatgeCorregida = [imatge imageRotatedByRadians:3*(M_PI/2)];
        } else if (orientacio == 2.0) {//Down
            imatgeCorregida = [imatge imageRotatedByRadians:3*(M_PI/2)];
        }
    }
    return imatgeCorregida;
}

-(UIImage *)corregirOrientacioPerGuardar:(UIImage *)imatge 
                      orientacioOriginal:(float) orientacio
{
    UIImage *imatgeCorregida = imatge;
    if(orientacio == 0.0){//Left
        imatgeCorregida = [imatge imageRotatedByRadians:M_PI/2];
    } else if(orientacio == 1.0) {//Right
        imatgeCorregida = [imatge imageRotatedByRadians:M_PI/2];
    } //Si es Down volem mantenir-la reorientada(no la volem cap per avall)
    return imatgeCorregida;
}


-(void)inicialitzarMansIEsApaisat:(float)orientacio
{
    if(orientacio == 0.0 || orientacio == 1.0) {
        self.maDretaArxiu = [[NSString alloc]initWithString: @"maDretaHDapaisat.png"];
        self.maEsquerraArxiu = [[NSString alloc]initWithString:@"maEsquerraHDapaisat.png"];
        self.juntesArxiu = [[NSString alloc]initWithString:@"juntesHDapaisat.png"];
        self.esApaisat = YES;
    } else {
        self.maDretaArxiu = [[NSString alloc]initWithString:@"maDretaHD.png"];
        self.maEsquerraArxiu = [[NSString alloc]initWithString:@"maEsquerraHD.png"];
        self.juntesArxiu = [[NSString alloc]initWithString:@"juntesHD.png"];
        self.esApaisat = NO;
    }
}

-(UIImage *)desferUltimPasDesde:(UIImage *)imatge
{
    if(self.numeroActual > 0) {
        self.estaArrossegant = NO;
        self.haDesfetUlimPas = YES;
        [self.puntsMarcats removeLastObject];
        [self.maAlPunt removeLastObject];
        [self refrescaNumeroAmb:self.numeroActual-=1];
        NSMutableArray *auxMans =[[NSMutableArray alloc] initWithArray:self.maAlPunt];
        NSMutableArray *auxPunts = [[NSMutableArray alloc] initWithArray:self.puntsMarcats];
        imatge = [self dibuixarMansDelArray:auxMans alsPunts:auxPunts aLaImatge:self.imatgeInicialRedimensionada];
    }
    return imatge;
}

-(UIImage *)comencaArrossegar:(CGPoint) p
{
    if(self.numeroActual == 0) {
        [self refrescaNumeroAmb:1];
    }
    CGPoint posicio = p;
    posicio.y -= self.costatPetitGlobal*ARROSSEGAROFFSET;
    self.estaArrossegant = YES;
    return [self dibuixarMaALaImatge:self.imatgeAnterior alPunt:posicio];
}

-(UIImage *)continuaArrossegar:(CGPoint) p
{
    p.y -= self.costatPetitGlobal*ARROSSEGAROFFSET;
    return [self dibuixarMaALaImatge:self.imatgeAnterior alPunt:p];

}

-(UIImage *)finalitzaArrossegar:(CGPoint) p
{
    p.y -= self.costatPetitGlobal*ARROSSEGAROFFSET;
    [self.puntsMarcats removeLastObject];
    [self.maAlPunt removeLastObject];
    [self.puntsMarcats addObject:[NSValue valueWithCGPoint:p]];
    [self.maAlPunt addObject:self.maActual];
    
    return [self dibuixarMaALaImatge:self.imatgeAnterior alPunt:p];
}

-(UIImage *)haFetUnToc:(CGPoint)p aLaImatge:(UIImage *)imatge
{
    [self refrescaNumeroAmb:self.numeroActual+=1];
    [self.puntsMarcats addObject:[NSValue valueWithCGPoint:p]];
    [self.maAlPunt addObject:self.maActual];
    //if(self.haArrossegatUnCop && !self.haDesfetUltimPas) {
    //    [self refrescaNumeroAmb:self.numeroActual+=1];
    //}
    self.estaArrossegant = NO;
    self.haDesfetUlimPas = NO;
    return [self dibuixarMaALaImatge:imatge alPunt:p];
}


-(void)guardar
{
    if(self.orientacioOriginal.floatValue == 2.0 && !self.imatgeDeLaBDD) {
        self.imatgeInicialRotada = [self redimensionar:self.imatgeInicialRotada ALaMida:CGSizeMake(self.imatgeInicialRotada.size.height, self.imatgeInicialRotada.size.width)];
        self.imatgeFinal = [self dibuixarPerGuardarMansDelArray:self.maAlPunt alsPunts:self.puntsMarcats aLaImatge:self.imatgeInicialRotada];
    } else {
        self.imatgeFinal = [self dibuixarPerGuardarMansDelArray:self.maAlPunt alsPunts:self.puntsMarcats aLaImatge:self.imatgeInicialRotada];
        self.imatgeFinal =[self corregirOrientacioPerGuardar:self.imatgeFinal orientacioOriginal:self.orientacioOriginal.floatValue];//retornar la imatge a la seva orientacio original
    }
    self.imatgeFinal = [self aplicarWatermarkALaImatge:self.imatgeFinal];
}

-(void)inicialitzar:(CGSize)frame
{
    //Començem redimensionant la imatge per a poder agilitzar la edició.
    //La imatge es redimensionara a la mida de la pantalla, així depenent
    //del dispositiu serà una mida diferent i adequada a la resolució d'aquest
    //UIImage *imatgeInicialRedimensionada = [[UIImage alloc] init ];    
    
    //Aquest cas serveix per al simulador del xcode ja que no pot simular la càmera
    if(self.imatgeInicial == Nil) { 
        UIImage *imatgeDefecte = [[UIImage alloc]init];
        imatgeDefecte = [UIImage imageNamed:@"Default.png"];
        self.imatgeInicialRotada = imatgeDefecte;
        self.imatgeInicial = imatgeDefecte;
        self.orientacioOriginal = [NSNumber numberWithFloat: 3.0];
    }
    self.imatgeInicialRotada = [self corregirOrientacioPerEditar:self.imatgeInicial orientacio:self.orientacioOriginal.floatValue];
    
    [self inicialitzarMansIEsApaisat:self.orientacioOriginal.floatValue];
    self.imatgeInicialRedimensionada = [self redimensionar:self.imatgeInicialRotada ALaMida:frame];
    self.proporcioImatgeEdicioRealX = self.imatgeInicialRotada.size.width/self.imatgeInicialRedimensionada.size.width;
    self.proporcioImatgeEdicioRealY = self.imatgeInicialRotada.size.height/self.imatgeInicialRedimensionada.size.height;
    self.imatgeAnterior = self.imatgeInicialRedimensionada;
    self.estaArrossegant = NO;
    self.haDesfetUlimPas = NO;
    self.numeroActual = 0;
    self.maActual = @"Dreta";
    self.puntsMarcats = [[NSMutableArray alloc] initWithCapacity:1000];
    self.maAlPunt = [[NSMutableArray alloc] initWithCapacity:1000];
    self.costatPetitGlobal = [[self costatPetitDeSize:frame] floatValue];
}

@end
