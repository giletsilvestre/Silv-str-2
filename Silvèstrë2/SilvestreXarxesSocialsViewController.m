//
//  SilvestreXarxesSocialsViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  ICONES posar linkback http://www.designbolts.com
//

#import "SilvestreXarxesSocialsViewController.h"


@interface SilvestreXarxesSocialsViewController()<NSURLConnectionDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImage *imatgeComprimida;
@property (nonatomic,strong) NSDecimalNumber *compressioImatge;

@end

@implementation SilvestreXarxesSocialsViewController

@synthesize ressenya = _ressenya;
@synthesize xarxaSocialEscollida = _xarxaSocialEscollida;
@synthesize progressBar = _progressBar;
@synthesize imatgeView=_imatgeView;
@synthesize imatgeXarxaSocial=_imatgeXarxaSocial;
@synthesize xarxaSocial = _xarxaSocial;
@synthesize imatgeComprimida = _imatgeComprimida;
@synthesize compressioImatge =_compressioImatge;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imatgeView.image = self.ressenya.imatge.imatge;
    
    UIImage *imatge = [[UIImage alloc]init];

    if([self.xarxaSocialEscollida isEqualToString:@"tumblr"]){
        imatge = [UIImage imageNamed:@"tumblricon.png"];
        self.imatgeXarxaSocial.image = imatge;
    } else if([self.xarxaSocialEscollida isEqualToString:@"twitter"]){
        imatge = [UIImage imageNamed:@"twittericon.png"];
        self.imatgeXarxaSocial.image = imatge;
        
    } else if([self.xarxaSocialEscollida isEqualToString:@"facebook"]){
        imatge = [UIImage imageNamed:@"facebookicon.png"];
        self.imatgeXarxaSocial.image = imatge;
        
    }
}


-(void)viewDidAppear:(BOOL)animated 
{    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Qualitat"
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel·la" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Original",@"Alta",@"Mitjana",@"Baixa",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.compressioImatge =[[NSDecimalNumber alloc]initWithFloat:1.0];
            break;
        case 1:
            self.compressioImatge =[[NSDecimalNumber alloc]initWithFloat:1.5];
            break;
        case 2:
            self.compressioImatge =[[NSDecimalNumber alloc]initWithFloat:2.0];
            break;
        case 3:
            self.compressioImatge =[[NSDecimalNumber alloc]initWithFloat:4.0];
            break;
        default:
            break;
    }
    if(buttonIndex>=0 || buttonIndex <= 2) {
        UIImage *imatgePujar = [[UIImage alloc]init];
        imatgePujar = self.ressenya.imatge.imatge;
        self.imatgeComprimida = [self redimensionar:imatgePujar 
                                            ALaMida:CGSizeMake(imatgePujar.size.width/self.compressioImatge.floatValue, imatgePujar.size.height/self.compressioImatge.floatValue)];
        if([self.xarxaSocialEscollida isEqualToString:@"tumblr"]){
            //Començar a pujar
            [self pujarAmbImatge:self.imatgeComprimida
                            text:@"proves" 
                           email:@"silvestreapp@gmail.com" 
                    contrassenya:@"EstranjisSonetMarbre"];
            
        }
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self dismissModalViewControllerAnimated:YES];
}

//-----------------TUMBLR UPLOAD-------------------DEPRECATED

- (BOOL)sendPhotoToTumblr:(NSData *)photo usingEmail:(NSString *)tumblrEmail andPassword:(NSString *)tumblrPassword withCaption:(NSString *)caption;
{
    //get image data from file
    NSData *imageData = photo;  
    //stop on error
    //Create dictionary of post arguments
    NSArray *keys = [NSArray arrayWithObjects:@"email",@"password",@"type",@"caption",nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        tumblrEmail,
                        tumblrPassword,
                        @"photo", caption, nil];
    NSDictionary *keysDict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    //create tumblr photo post
    NSURLRequest *tumblrPost = [self createTumblrRequest:keysDict withData:imageData];
    
    //send request, return YES if successful
    NSURLConnection *tumblrConnection = [[NSURLConnection alloc] initWithRequest:tumblrPost delegate:self];
    
    if(tumblrConnection){
        NSLog(@"peticio envada");
        return YES;
    } else {
        NSLog(@"error peticio");
        return NO;
    }
}



- (NSURLRequest *)createTumblrRequest:(NSDictionary *)postKeys withData:(NSData *)data
{
    //create the URL POST Request to tumblr
    NSURL *tumblrURL = [NSURL URLWithString:@"http://www.tumblr.com/api/write"];
    NSMutableURLRequest *tumblrPost = [NSMutableURLRequest requestWithURL:tumblrURL];
    [tumblrPost setHTTPMethod:@"POST"];
    
    //Add the header info
    NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [tumblrPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //add key values from the NSDictionary object
    NSEnumerator *keys = [postKeys keyEnumerator];
    int i;
    for (i = 0; i < [postKeys count]; i++) {
        NSString *tempKey = [keys nextObject];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",tempKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"%@",[postKeys objectForKey:tempKey]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //add data field and file data
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"data\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[NSData dataWithData:data]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //add the body to the post
    [tumblrPost setHTTPBody:postBody];
    
    return tumblrPost;
}

-(BOOL) pujarAmbImatge:(UIImage *)imatge text:(NSString *)text email:(NSString *)email contrassenya:(NSString *)contrassenya
{
    [self sendPhotoToTumblr:UIImageJPEGRepresentation(imatge, 1.0) usingEmail:email andPassword:contrassenya withCaption:text];
    
    return YES;
    
}

//---------------------------------------------


-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
    float total =[[NSNumber numberWithInteger:totalBytesExpectedToWrite] floatValue];
    self.progressBar.progress = progress/total;
    if(progress == total) {
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (IBAction)cancelButton:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setImatgeView:nil];
    [self setImatgeXarxaSocial:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
}

@end
