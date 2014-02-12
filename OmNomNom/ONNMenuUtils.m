//
//  ONNMenuUtils.m
//  OmNomNom
//
//  Created by Elliot Lynde on 2/12/14.
//
//

#import <Parse/Parse.h>
#import "ONNMenuUtils.h"
#import "ONNAppDelegate.h"

@implementation ONNMenuUtils

+(void) getMenu:(void ( ^ )(NSString *) ) completionHandler {
    NSString *fromDisk = [self readFromFile];
    
    if (fromDisk == nil) {
        [self downloadMenu:completionHandler];
        return;
    }
    
    completionHandler(fromDisk);
    [self downloadMenu:^(NSString *newMenu) {
        if ([newMenu compare:fromDisk] != NSOrderedSame) {
            completionHandler(newMenu);
        }
    }];

}

+(void) downloadMenu:(void ( ^ )(NSString *) ) completionHandler {
    [FBRequestConnection startWithGraphPath:@"fbnyccafe/posts"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              NSString *last_post= [(NSArray *)[result data] objectAtIndex:0][@"message"];
                              [self writeToFile:last_post];
                              completionHandler(last_post);
                          }];
}

+(void)writeToFile:(NSString *)menu {
    NSData* data = [menu dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:[self filePath] atomically:YES];
}

+(NSString *)readFromFile {
    NSData * data2 = [NSData dataWithContentsOfFile:[self filePath]];
    if (data2 == nil) {
        return nil;
    }
    NSString* newStr = [NSString stringWithUTF8String:[data2 bytes]];
    return newStr;
}

+(NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"nyc.txt"];
}

+(void)deleteMenu {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self filePath] error:/*yolohackathon*/nil];
}

@end
