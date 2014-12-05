//
//  MasterViewController.m
//  navDemo
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WebViewController.h"
#import "TextEditViewController.h"

//Private interface
@interface MasterViewController()
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) WebViewController * webViewController;
@property (strong, nonatomic) TextEditViewController * textEditViewController;
@end

@implementation MasterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Master", @"");
  }
  return self;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  //If you set a backBarButtonItem here, its title will show in the navigation toolbar
  //when you go to the next view.
  //If you don't set it, the button will show the title of this controller
  //("Master" in initWithNibName above). If there is no title there, the button
  //will show "Back".
  //When the button is tapped it will automatically pop the current controller
  //from the navigation stack and show the previous controller.
  
  UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
  backButton.title = @"Zurück";
  self.navigationItem.backBarButtonItem = backButton;
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

- (NSUInteger)supportedInterfaceOrientations
{
  //These should agree with those in the Info.plist file.
  return UIInterfaceOrientationPortrait
  |UIInterfaceOrientationLandscapeLeft
  |UIInterfaceOrientationLandscapeRight;
}

#pragma mark table view data source protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }
  
  // Configure the cell.
  //XXXXX put in code for each view controller you add to this table view.
  if (indexPath.row == 0)
    cell.textLabel.text = NSLocalizedString(@"Drawing view", @"");
  if (indexPath.row == 1)
    cell.textLabel.text = NSLocalizedString(@"text edit view", @"");
  if (indexPath.row == 2)
    cell.textLabel.text = NSLocalizedString(@"web view", @"");
  
  
  return cell;
}


#pragma mark table view delegate protocol
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //XXXXX add code to push the viewcontroller for this indexPath.row.
  if (indexPath.row == 0)
  {
    //Lazy initialization of this controller.
    //"initWithNibName:nil" means that there is no nib file. The method will do all initialization.
    if (!self.detailViewController)
      self.detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
  }
  if (indexPath.row == 2)
  {
    //Lazy initialization of this controller.
    //"initWithNibName:nil" means that there is no nib file. The method will do all initialization.
    if (!self.webViewController)
      self.webViewController = [[WebViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:self.webViewController animated:YES];
    }
  if (indexPath.row == 1)
  {
    //Lazy initialization of this controller.
    //"initWithNibName:nil" means that there is no nib file. The method will do all initialization.
    if (!self.textEditViewController)
        self.textEditViewController = [[TextEditViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:self.textEditViewController animated:YES];
   }

  
}


@end
