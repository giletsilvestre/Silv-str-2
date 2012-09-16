//
//  SilvestreImatgeScrollViewController.h
//  Silvèstrë2
//
//  Created by Mine IPhone on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SilvestreImatgeScrollViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImage *imatgeInicial;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)exitButton:(UIButton *)sender;

@end
