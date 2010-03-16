
#import "SearchPhotosViewController.h"
#import "SearchResultsPhotoSource.h"
#import "ForwardingAdapters.h"
#import "SearchResultsModel.h"


@implementation SearchPhotosViewController

- (id)init
{
	NSLog(@"init");
    if ((self = [super init])) {
        self.title = @"精彩推荐";
        photoSource = [[SearchResultsPhotoSource alloc] initWithModel:CreateSearchModelWithCurrentSettings()];
		NSLog(@"%@",photoSource);
    }
    return self;
}

- (void)doSearch
{
       
    [queryField resignFirstResponder];
    
    // Configure the photo source with the user's search terms.
    // NOTE: I have to explicitly cast the photoSource to the SearchResultsModel
    //       protocol because otherwise the compiler will issue a warning
    //       (because the compiler doesn't know that the photoSource forwards
    //       to a SearchResultsModel at runtime)
    [(id<SearchResultsModel>)photoSource setSearchTerms:[queryField text]];
	//NSLog(@"Searching for %@", queryField.text);

    // Load the new data
    [photoSource load:TTURLRequestCachePolicyDefault more:NO];
    //	return;
    // Display the updated photoSource.
    TTThumbsViewController *thumbs = [[MyThumbsViewController alloc] initForPhotoSource:photoSource];
    [self.navigationController pushViewController:thumbs animated:YES];
    [thumbs release];
}

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.f];
    
    // Search query field.
    queryField = [[UITextField alloc] initWithFrame:CGRectMake(30.f, 30.f, 260.f, 30.f)];
    queryField.placeholder = @"图像搜索";
    queryField.autocorrectionType = YES;
    queryField.autocapitalizationType = YES;
    queryField.clearsOnBeginEditing = YES;
    queryField.borderStyle = UITextBorderStyleRoundedRect;
	queryField.hidden = YES;
    [self.view addSubview:queryField];
        
	

	
    // Search button.
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[searchButton setFrame:CGRectMake(50.f, 140.f, 200.f, 44.f)];
	//[searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  //  [searchButton setTitle:@"精彩推荐" forState:UIControlStateHighlighted];
	 [searchButton setTitle:@"精彩推荐" forState:UIControlStateNormal];
	searchButton.center = self.view.center; 

    [searchButton addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

- (void)dealloc
{
    [queryField release];
    [photoSource release];
    [super dealloc];
}


@end