//
//  ImageToDataTransformer.m
//  Silvèstrë2
//
//  Created by Mine IPhone on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageToDataTransformer.h"

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (NSData *)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}

- (UIImage *)reverseTransformedValue:(id)value {
	UIImage *storedImage = [[UIImage alloc] initWithData:value];    
    
    return storedImage;
}

@end
