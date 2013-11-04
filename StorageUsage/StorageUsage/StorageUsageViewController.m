//
//  StorageUsageViewController.m
//  StorageUsage
//
//  Created by Alexander Rukin on 26.03.13.
//  Copyright (c) 2013 Alexander Rukin. All rights reserved.
//

#import "StorageUsageViewController.h"

@interface StorageUsageViewController ()

@end

@implementation StorageUsageViewController
@synthesize usedSize, freeSize;
@synthesize totalLine, usedLine;
@synthesize freeCriticalIcon, freeCriticalLabel, freeCritical;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
    NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
    uint64_t totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
    uint64_t freeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    uint64_t usedSpace = totalSpace - freeSpace;
    
    if (usedSpace > freeSpace) {
        freeSize.alpha = 0;
        freeCritical.alpha = 1;
        freeCriticalIcon.alpha = 1;
        freeCriticalLabel.alpha = 1;
    } else {
        freeSize.alpha = 1;
        freeCritical.alpha = 0;
        freeCriticalIcon.alpha = 0;
        freeCriticalLabel.alpha = 0;
    }
    
    NSString *free = convertSpace(freeSpace);
    NSString *used = convertSpace(usedSpace);
    
    freeSize.text = [free stringByAppendingString:@" Free"];
    freeCritical.text = free;
    usedSize.text = used;
    
    CGRect rect = usedLine.frame;
    rect.size.width = totalLine.frame.size.width*((float)usedSpace/totalSpace);
    CGRect nullRect = usedLine.frame;
    nullRect.size.width = 0;
    usedLine.frame = nullRect;
    
    NSArray *components = [usedSize.text componentsSeparatedByString:@" "];
    NSString *firstSymbol = [components objectAtIndex:0];
    float first = [firstSymbol floatValue];
    NSString *suffix = [components objectAtIndex:1];
    
    NSArray *fComponents = [freeCritical.text componentsSeparatedByString:@" "];
    NSString *fFirstSymbol = [fComponents objectAtIndex:0];
    float fFirst = [fFirstSymbol floatValue];
    NSString *fSuffix = [fComponents objectAtIndex:1];
    
    NSArray *ffComponents = [freeSize.text componentsSeparatedByString:@" "];
    NSString *ffFirstSymbol = [ffComponents objectAtIndex:0];
    float ffFirst = [ffFirstSymbol floatValue];
    NSString *ffSuffix = [ffComponents objectAtIndex:1];
    
    float fromValue = 0;
    float toValue = 200;
    NSTimeInterval interval = 0.027;
    NSTimeInterval delay = 0.0;
    
    float part = (float)first/200;
    float fPart = (float)fFirst/200;
    float ffPart = (float)ffFirst/200;
    
    for (NSInteger i = fromValue; i <= toValue; i++) {
        NSString *labelText = [NSString stringWithFormat:@"%.2f %@", (float)i*part, suffix];
        [usedSize performSelector:@selector(setText:) withObject:labelText afterDelay:delay];
        NSString *fLabelText = [NSString stringWithFormat:@"%.2f %@", (float)i*fPart, fSuffix];
        [freeCritical performSelector:@selector(setText:) withObject:fLabelText afterDelay:delay];
        NSString *ffLabelText = [NSString stringWithFormat:@"%.2f %@ Free", (float)i*ffPart, ffSuffix];
        [freeSize performSelector:@selector(setText:) withObject:ffLabelText afterDelay:delay];
        
        interval -= interval/60;
        delay += interval;
    }
    
    [UIView beginAnimations:@"widen" context:nil];
    [UIView setAnimationDuration:delay];
    usedLine.frame = rect;
    [UIView commitAnimations];
}

NSString* convertSpace (unsigned long long sizeIn)
{
    NSString *val;
    if (sizeIn >= (1024*1024*1024))
    {
        val = [NSString stringWithFormat:@"%.2f GB", (float)sizeIn/1073741824];
    } else if (sizeIn >= (1024*1024) && sizeIn < (1024*1024*1024))
    {
        val = [NSString stringWithFormat:@"%.2f MB", (float)sizeIn/1048576];
    } else if (sizeIn >= (1024) && sizeIn < (1024*1024))
    {
        val = [NSString stringWithFormat:@"%.2f KB", (float)sizeIn/1024];
    } else
    {
        val = [NSString stringWithFormat:@"%d Bytes", (int)sizeIn];
    }
    return val;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
