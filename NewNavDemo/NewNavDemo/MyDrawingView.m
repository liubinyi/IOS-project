//
//  MyDrawingView.m
//  navAndViews
//
//  Created by David Rowland on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDrawingView.h"

@implementation MyDrawingView

@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor lightGrayColor]];
    //The button will be a plain colored rectangle with a title.
    //No shading, no shape, no image.
    button = [[UIButton alloc]initWithFrame:CGRectMake(220, 360, 80, 44)];
    [button setTitle:@"Rotate" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [button setShowsTouchWhenHighlighted:YES];
    
    [self addSubview:button];
    
    //For the more elaborate animations we must deal with a CAShapeLayer which we add to this UIView.
    shapeLayer = [CAShapeLayer layer];
    [[self layer] addSublayer:shapeLayer];
    
    
  }
  return self;
}

-(void)setPen:(CGContextRef) context
{
  //Stroke color is white
  CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
  //Fill color is blue
  CGContextSetRGBFillColor(context, 0.5, 0.5, 1.0, 1.0);
  // Draw them with a 2.0 stroke width so they are a bit more visible.
  CGContextSetLineWidth(context, 2.0);
}

-(CGGradientRef)setGradient
{
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGFloat colors[] =
  {
    1.0, 1.0, 1.0, 1.0,   //RGBA
    0.1, 0.5, 0.8, 1.0
  };
  CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
  CGColorSpaceRelease(rgb);
  return gradient;
}

-(void) drawCircleInContext:(CGContextRef) context
{
  CGContextSaveGState(context);
  
  [self setPen:context];
  CGContextStrokeEllipseInRect(context, CGRectMake(30.0, 120.0, 60.0, 60.0));
  
  CGContextRestoreGState(context);
}

-(void)fillEllipseInContext:(CGContextRef) context
{
  CGContextSaveGState(context);
  
  [self setPen:context];
  CGContextFillEllipseInRect(context, CGRectMake(100, 240, 80, 90));
  
  CGContextRestoreGState(context);
}

-(void)drawTextInContext:(CGContextRef) context
{
  CGContextSaveGState(context);
  
  //define the string, its font and size and location.
  NSString *hello   = @"Hello, World!";
  CGPoint  location = CGPointMake(10, 20);
  UIFont   *font    = [UIFont systemFontOfSize:24];
  //Set the fill and stroke colors.
  [[UIColor whiteColor] set];
  
  //Do something fancy. Set up the matrix to rotate and then translate it.
  CGAffineTransform t = CGAffineTransformMakeTranslation(100, 0);
  CGContextConcatCTM(context,t);
  CGAffineTransform r = CGAffineTransformMakeRotation(1.0);
  CGContextConcatCTM(context,r);
  //Now draw it.
  [hello drawAtPoint:location withFont:font];
  
  CGContextRestoreGState(context);
}

-(CGMutablePathRef)makeAPath
{
  const int arraySize = 6;
  // A path is a series of line segments. The
  // line segments are specified by points, an array of CGPoints.
  //Create path object.
  CGMutablePathRef path = CGPathCreateMutable();
  //Define the points as an array.
  CGPoint s[arraySize] = {170, 200, 220, 150, 270, 150, 320, 200,245, 250, 170, 200};
  
  //Move to the first point
  CGPathMoveToPoint(path, NULL, s[0].x, s[0].y);
  //Build the path by adding lines to successive points.
  for (int k = 1; k < arraySize; k += 1) {
    CGPathAddLineToPoint(path, NULL, s[k].x, s[k].y);
  }
  return path;
}

-(void)drawPathInContext:(CGContextRef) context
{
  CGContextSaveGState(context);
  
  [self setPen:context];
  
  CGAffineTransform t = CGAffineTransformMakeTranslation(120, -120);
  CGContextConcatCTM(context,t);
  
  //Make a path and add it to the context.
  CGContextAddPath(context, [self makeAPath]);
  
  //Fill the path. Filling is complicated if the path does not close on itself or if it
  //intersects itself. Core Graphics does pretty well at figuring out what is to be done.
  if (true)  //Change to false to make it fill with a solid color.
  {
    //Fill with a gradient
    //Create the gradient.
    CGGradientRef gradient = [self setGradient];
    //Clip to limit drawing to the area within the path.
    CGContextClip(context);
    //Define the points between which the gradient runs, and draw the fill.
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(20, 200),
                                CGPointMake(20, 480),
                                0);
    CGGradientRelease(gradient);
  }
  else
  {
    //Filling with solid color is simpler.
    CGContextFillPath(context);
  }
  
  //Draw (stroke) the path. Paths are discarded after a use. You must rebuild the
  //path and add it to the context to use it again.
  
  CGContextAddPath(context, [self makeAPath]);
  
  CGContextStrokePath(context);
  
  CGContextRestoreGState(context);
}


//This is a kind of animation done to a CAShapeLayer which is an underlying
//part of a UIView. Layers allow more control than the UIView itself.
-(void)drawPathAnimated
{
  //strokeEnd is a property of CAShapeLayer which will be animated.
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  pathAnimation.duration = 4.0;
  pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
  pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
  //Give this animation a name, strokeEndAnimation, which can be used if we need to change it.
  [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
  
  //fillColor is an animatable property of CHShapeLayer.
  CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"fillColor"];
  pathAnimation2.duration = 4.0;
  pathAnimation2.fromValue = (id) ([UIColor greenColor].CGColor);
  //The next line may cause a warning about assigning to 'id'. That can be avoided by
  //forcing a type conversion as in the line above.
  pathAnimation2.toValue = (id)[UIColor redColor].CGColor;
  [shapeLayer addAnimation:pathAnimation2 forKey:@"fillColor"];
  
  //shapeLayer has its own context.
  [shapeLayer setFillColor:[[UIColor redColor] CGColor]];
  [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
  [shapeLayer setLineWidth:2.0f];
  
  CGMutablePathRef path = [self makeAPath];
  //This starts the animation.
  [shapeLayer setPath:path];
}

-(void)drawImageInContext:(CGContextRef) context
{
  NSString* name = @"testImage.png";
  UIImage* theImage = [UIImage imageNamed:name];  //find the image in the app bundle
  
  CGContextSaveGState(context);
  CGAffineTransform t = CGAffineTransformMakeTranslation(20, 0);
  CGContextConcatCTM(context,t);
  
  //Can draw using UIImage methods.
  //Image will be natural size.
  //Image will be 50% transparent and will show whatever has already been drawn behind it.
  [theImage drawAtPoint:CGPointMake(88, 300) blendMode:kCGBlendModeNormal alpha:0.5];
  
  //or you can draw using the plain C Core Graphics routines
  CGImageRef imageRef = theImage.CGImage;
  //Image will be scaled to fill an 80x80 square.
  //The coordinate system is y positive down, and the image will appear flipped vertically.
  CGRect rect = CGRectMake(120, 50, 80, 80);
  CGContextDrawImage(context, rect, imageRef);
  
  CGContextRestoreGState(context);
}

// Override drawRect to perform custom drawing.
- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self drawCircleInContext:context];
  [self fillEllipseInContext:context];
  [self drawPathInContext:context];
  [self drawTextInContext:context];
  [self drawImageInContext:context];
  [self drawPathAnimated];
}




#pragma mark - Show animation
//This is a simple kind of animation which is part of UIView
-(void)buttonHit:(id)sender
{
  //Start with an identity transform, i.e. no change and an alpha of 1.0
  self.transform = CGAffineTransformIdentity;
  self.alpha = 1.0;
  //Over a time of 2 seconds change the transform and alpha to rotate by 1 radian and to be transparent.
  [UIView animateWithDuration:2.0
                   animations:^{
                     self.transform = CGAffineTransformMakeRotation(1.0);
                     self.alpha = 0.0;
                   }
                   completion:^(BOOL finished)
   {
     //When animation is complete, set the transform back to identity and alpha to 1.0.
     //If you don't do this, it will remain invisible and rotated.
     if (finished)
     {
       self.transform = CGAffineTransformIdentity;
       self.alpha = 1.0;
     }
   }
   ];
  
}

@end
