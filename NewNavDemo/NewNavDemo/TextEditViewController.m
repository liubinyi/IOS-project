//
//  ViewController.m
//  textViewDemo
//
//  Created by David Rowland on 10/17/14.
//  Copyright (c) 2014 David Rowland. All rights reserved.
//

#import "TextEditViewController.h"

//This unnamed category is a private interface to the class.
//These things are not in the header file and are not seen by other code.
@interface TextEditViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton* doneButton;

- (void)setupTextView;
- (void)setupDoneButton;
- (void)saveAction:(UIButton*)sender;
@end


@implementation TextEditViewController

- (void)setupTextView
{
  _textView = [[UITextView alloc] initWithFrame:self.view.frame];
  self.textView.textColor = [UIColor blackColor];
  self.textView.font = [UIFont fontWithName:@"Arial" size:12.0];
  self.textView.delegate = self;
  self.textView.backgroundColor = [UIColor whiteColor];
  
  //See if there is a file saved from a previous invocation of the app and load it.
  //If not, load this default text.
    NSError * error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",
                          documentsDirectory];
    NSString *stringFromFileAtPath = [[NSString alloc]
                                      initWithContentsOfFile:fileName
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    if (error)
    {
        NSLog(@"Error reading file at %@\n%@\n",
              fileName, [error localizedFailureReason]);
        error = nil;
    }
    if (documentsDirectory != nil) {
        self.textView.text= stringFromFileAtPath;
    } else {
  self.textView.text = @"Look, how the floor of heaven\nIs thick inlaid with patines of bright gold;\nThere's not the smallest orb which thou behold'st\nBut in his motion like an angel sings ...\nSuch harmony is in immortal souls;\nBut, whilst this muddy vesture of decay\nDoth grossly close it in,we cannot hear it.\n\n";
    }
  self.textView.returnKeyType = UIReturnKeyDefault;
  self.textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
  self.textView.scrollEnabled = YES;
  
  // note: for UITextView, if you don't like autocompletion while typing use:
  // myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
  
  [self.view addSubview: self.textView];
  
}

- (void)placeButtonInFrame:(CGRect) frame
{
  //Place it in relation to the right side and bottom. May not be right for landscape view.
  CGFloat buttonWidth = 80;
  CGFloat buttonHeight = 24;
  CGFloat pointsFromRight = 20;
  CGFloat pointsAboveBottom = 300;
  CGFloat screenWidth = frame.size.width;
  CGFloat screenHeight = frame.size.height;
  CGFloat buttonLeft = screenWidth - buttonWidth - pointsFromRight;
  CGFloat buttonTop = screenHeight - pointsAboveBottom - buttonHeight;
  self.doneButton.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
}

- (void)setupDoneButton
{
  //lazy initialization of the Done button. Do it here when first needed.
  //After that just add and remove it as a subview.
  if (_doneButton == nil)
  {
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self placeButtonInFrame:self.view.frame];
  }
  [self.view addSubview:self.doneButton];
}

- (void)saveAction:(UIButton*)sender
{
  //Resign first responder, which will remove the keypad and signal the end of editing
  //by calling textViewDidEndEditing.
  [self.textView resignFirstResponder];
  self.navigationItem.rightBarButtonItem = nil;	// this will remove the "Done" button
  [self.doneButton removeFromSuperview];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  //When under a navigation controller, this will install a "Done" button in the navigation
  //tool bar at the top.
  UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                               target:self
                               action:@selector(saveAction:)];
  self.navigationItem.rightBarButtonItem = doneItem;
  
  //When not under a nav controller, just install a crude button to end the editing.
  [self setupDoneButton];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
  //This is your opportunity to save the text into a file. In viewDidLoad you can check
  //its existence and reload it the next time the app is launched.
  //get the documents directory:
  NSArray *paths = NSSearchPathForDirectoriesInDomains
  (NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
    
  //make a file name to write the data to using the documents directory:
  NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",
                          documentsDirectory];
  NSString *content = @"textView";
  NSLog(@"%@", self.textView.text);
  [self.textView.text writeToFile:fileName
             atomically:NO
             encoding:NSUTF8StringEncoding
                error:nil];
}

#pragma mark UIViewControllerDelegate
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = NSLocalizedString(@"TextViewTitle", @"");
  [self setupTextView];
}

-(BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:transitionCoordinator
{
  CGRect frame = CGRectMake(0, 0, size.width, size.height);
  [self placeButtonInFrame:frame];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
