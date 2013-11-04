//
//  StorageUsageViewController.h
//  StorageUsage
//
//  Created by Alexander Rukin on 26.03.13.
//  Copyright (c) 2013 Alexander Rukin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageUsageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *usedSize;
@property (strong, nonatomic) IBOutlet UILabel *freeSize;
@property (strong, nonatomic) IBOutlet UIImageView *usedLine;
@property (strong, nonatomic) IBOutlet UIImageView *totalLine;
@property (strong, nonatomic) IBOutlet UILabel *freeCritical;
@property (strong, nonatomic) IBOutlet UIImageView *freeCriticalIcon;
@property (strong, nonatomic) IBOutlet UILabel *freeCriticalLabel;

@end
