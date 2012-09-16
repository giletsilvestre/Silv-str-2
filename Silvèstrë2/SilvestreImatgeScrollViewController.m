//
//  SilvestreImatgeScrollViewController.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SilvestreImatgeScrollViewController.h"

@interface SilvestreImatgeScrollViewController()  <UIScrollViewDelegate>

@end

@implementation SilvestreImatgeScrollViewController

@synthesize scrollView = _scrollView;
@synthesize imatgeInicial = _imatgeInicial;
@synthesize imageView = _image;

-(NSNumber *)costatPetitDeSize:(CGSize) mida {
    NSNumber *costatPetit = [[NSNumber alloc] initWithFloat:0.0];
    
    if(mida.width < mida.height) {
        costatPetit = [NSNumber numberWithFloat: mida.width];
    } else {
        costatPetit = [NSNumber numberWithFloat: mida.height];
    }
    return costatPetit;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
    //NSNumber *costatPetit = [self costatPetitDeSize:self.imatgeInicial.size];
    self.scrollView.maximumZoomScale = 1;
    self.scrollView.minimumZoomScale = self.view.frame.size.width/self.imatgeInicial.size.width;
    float puntZeroInicial = (self.imageView.frame.size.height/2)-((self.imatgeInicial.size.height*(self.view.frame.size.width/self.imatgeInicial.size.width))/2);
    //self.scrollView.contentSize = CGSizeMake(self.imatgeInicial.size.width, self.imatgeInicial.size.height);
    
    self.imageView.frame = CGRectMake(0.0, puntZeroInicial, self.imatgeInicial.size.width, self.imatgeInicial.size.height); 
    self.imageView.image = self.imatgeInicial;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView setZoomScale:self.view.frame.size.width/self.imatgeInicial.size.width animated:YES];

}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
- (IBAction)exitButton:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
