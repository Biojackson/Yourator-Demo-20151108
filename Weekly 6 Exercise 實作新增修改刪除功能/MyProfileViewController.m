//
//  MyProfileViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/22.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileTableViewCell.h"
#import "MyProfileEditTableViewController.h"
@interface MyProfileViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage* takePhotoImage;
@property (strong, nonatomic) MyProfileTableViewCell* cellForProfile;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addButPressed:)];
    //style: UIBarButtonItemStylePlain
    UIBarButtonItem* searchButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch  target:self action:@selector(addButPressed:)];
    
    UIBarButtonItem* cameraButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(cameraButPressed:)];
    
    UIBarButtonItem* bookmarksButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks  target:self action:@selector(addButPressed:)];
    
    self.navigationItem.rightBarButtonItems = @[addButton, searchButton, cameraButton, bookmarksButton];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)cameraButPressed:(id)sender {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
    
//    MyProfileTableViewCell* peterCell = sender.superview;
//    while ([peterCell isKindOfClass:[MyProfileTableViewCell class]]) {
//        peterCell = peterCell.superview;
//    }

    
        [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"info %p", info);
    //_takePhotoImage = info[@"UIImagePickerControllerOriginalImage"]; //把照片存到手機
    

//    把照片存到手機
    UIImageWriteToSavedPhotosAlbum(_takePhotoImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    把照片存到App
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    NSString *name = [NSString stringWithFormat:@"%f.jpg", interval];
    NSString *path = [documentsDirectory
                      stringByAppendingPathComponent:name];
    NSData *data = UIImageJPEGRepresentation(_takePhotoImage, 0.9);
    [data writeToFile:path atomically:YES];
    
    NSMutableArray* photoArray;//加入array
    [photoArray addObject:data];
    
    [NSKeyedArchiver archiveRootObject:photoArray toFile:path];
    
    
    //Johnny
//    UIImage* newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //_cellForProfile = [self.tableView cellForRowAtIndexPath:0];
//    NSLog(@"cellForProfile %p", _cellForProfile);
//    NSLog(@"newImage %p", newImage);
    

//     _cellForProfile.takePhotoImageView.image = newImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//把照片存到手機的method
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    NSLog(@"err %@", error);
    if (!error) {
//        _cellForProfile = [self.tableView cellForRowAtIndexPath:0];
        NSLog(@"cellForProfile %p", _cellForProfile);
//        _cellForProfile.takePhotoImageView.image = _takePhotoImage;
        
    }
}


-(void)addButPressed:(id)sender {
    MyProfileEditTableViewController* myProfileEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileEditTVC"];
    [self presentViewController:myProfileEditViewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYPROFILE_CELL_ID"];

    
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
