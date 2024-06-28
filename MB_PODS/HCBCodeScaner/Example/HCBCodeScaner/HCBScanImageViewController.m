//
//  HCBScanImageViewController.m
//  HCBCodeScaner_Example
//
//  Created by tp on 2018/5/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "HCBScanImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <HCBCodeScaner/HCBCodeScaner.h>

@interface HCBScanImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)tap:(UITapGestureRecognizer *)sender;

- (IBAction)scan;

- (void)selectImage;

@end

@implementation HCBScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self selectImage];
}

- (void)scan {
    if (!_imageView.image) {
        return;
    }
    NSString *result = [HCBCodeScaner scanImageWithoutCallback:_imageView.image];
    _label.text = result;
    NSLog(@"scan data: %@", result);
}

- (void)selectImage {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[(id)kUTTypeImage];
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
