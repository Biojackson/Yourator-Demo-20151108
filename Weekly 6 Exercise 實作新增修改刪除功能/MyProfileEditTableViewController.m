//
//  MyProfileEditTableViewController.m
//  Yourator v.1
//
//  Created by 洪駿之 on 2015/10/24.
//  Copyright © 2015年 洪駿之. All rights reserved.
//

#import "MyProfileEditTableViewController.h"
#import "MyProfileViewController.h"
#import "MyProfileTableViewCell.h"
#import "MyProfileEditTableViewCell.h"
@interface MyProfileEditTableViewController () <UINavigationBarDelegate>

//@property (readonly,nonatomic) UINavigationBar* navigationBar;
//@property(nonatomic,readonly,strong) UINavigationItem
//*navigationItem;


@end

@implementation MyProfileEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addButPressed)];
//    //style: UIBarButtonItemStylePlain
//    UIBarButtonItem* searchButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch  target:self action:@selector(addButPressed)];
//    
//    UIBarButtonItem* cameraButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(addButPressed)];
//    
//    UIBarButtonItem* bookmarksButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks  target:self action:@selector(addButPressed)];
 
//    self.navigationItem.rightBarButtonItems = @[addButton, searchButton, cameraButton, bookmarksButton];
}

//顯示alert，詢問想不想談戀愛.回答yes了話，再以action sheet詢問願意跟誰談戀愛，選項自填。

- (IBAction)alertButPressed:(id)sender {

    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"想不想談戀愛?" message:@"請認真思考" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"YES 太好了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //if ([self respondsToSelector:@selector(whichOneToChoose)]){
        [self performSelector:@selector(actionSheetAfterAlertButPressed:) withObject:nil  afterDelay:0];
    }];
    
    UIAlertAction* maybeButton = [UIAlertAction actionWithTitle:@"Maybe 多多考慮是好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Nope 小可惜了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alertController addAction:yesButton];
    [alertController addAction:maybeButton];
    [alertController addAction:noButton];
    
    [self presentViewController:alertController animated:YES completion:nil ];
}

//- (void) whichOneToChoose {}
- (void) actionSheetAfterAlertButPressed: (id) sender {

    UIAlertController* alertSheetController = [UIAlertController alertControllerWithTitle:@"那要開始戀愛了!" message:@"想跟以下哪位開始戀愛!?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* girl1Button = [UIAlertAction actionWithTitle:@"林可彤"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* girl2Button = [UIAlertAction actionWithTitle:@"徐嬌"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //無法在裡面放照片
        UIImage* image = [UIImage imageNamed:@"徐嬌png"];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
    }];
    
    UIAlertAction* girl3Button = [UIAlertAction actionWithTitle:@"尤緻妍"  style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction* noGirlButton = [UIAlertAction actionWithTitle:@"我都不想要"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alertSheetController addAction:girl1Button];
    [alertSheetController addAction:girl2Button];
    [alertSheetController addAction:girl3Button];
    [alertSheetController addAction:noGirlButton];
    
    //alertSheetController.view.tintColor = [UIColor redColor];
    [self presentViewController:alertSheetController animated:YES completion:nil];
}

- (IBAction)cancelButPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYPROFILEEDIT_CELL_ID" forIndexPath:indexPath];
    
//    NSDictionary *dic = self.ACPeopleArray[indexPath.row];
//    NSLog(@"%lu",(unsigned long)self.ACPeopleArray.count);
//    
//    //DEBUG!!!!!!!!!!!!!!!!!!!
//    NSLog(@"NAME %@",dic[@"Name"]);
//    NSLog(@"DESCRIPTION %@",dic[@"Description"]);
//    cell.textLabel.text = dic[@"Name"];
//    cell.detailTextLabel.text = dic[@"Description"];
    

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
