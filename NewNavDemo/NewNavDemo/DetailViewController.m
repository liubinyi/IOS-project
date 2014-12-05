//
//  DetailViewController.m
//  navDemo
//
//

#import "DetailViewController.h"



@implementation DetailViewController
@synthesize myDrawingView;
//@synthesize webView;
//@synthesize textebView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

  //XXXXX
  //Here you will insert code to alloc/init your drawing view and install it
   myDrawingView = [[MyDrawingView alloc] initWithFrame:[self.view frame]];
   //webView = [[WebView alloc] initWithFrame:[self.view frame]];
   //textView = [[TextView alloc] initWithFrame:[self.view frame]];
  //as a subview of this view controller's view. Remember to import its header file.
  [self.view addSubview:myDrawingView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Drawing view", @"");
    }
    return self;
}
							

@end
