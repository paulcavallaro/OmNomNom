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

+(void) getMenuForCafe:(CafeName)cafeName completion:(void (^)(NSString *))completionHandler
{
    NSString *fromDisk = [self readFromFileForCafe:cafeName];
    
    if (fromDisk == nil) {
        [self downloadMenuForCafe:cafeName completion:completionHandler];
        return;
    }
    
    completionHandler(fromDisk);
    [self downloadMenuForCafe:cafeName completion:^(NSString *newMenu) {
        if ([newMenu compare:fromDisk] != NSOrderedSame) {
            completionHandler(newMenu);
        }
    }];

}

+(void) downloadMenuForCafe:(CafeName)cafeName completion:(void (^)(NSString *))completionHandler
{
    switch (cafeName) {
        case NYC:
        {
            [FBRequestConnection startWithGraphPath:@"fbnyccafe/posts"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      NSString *last_post= [(NSArray *)[result data] objectAtIndex:0][@"message"];
                                      [self writeToFile:last_post forCafe:cafeName];
                                      completionHandler(last_post);
                                  }];
            break;
        }
        case LTD:
        case EPIC:
        {
            // TODO(ptc) LTD and EPIC are the same for now
            [FBRequestConnection startWithGraphPath:@"FacebookCulinaryTeam/posts"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      NSString *last_post= [(NSArray *)[result data] objectAtIndex:0][@"message"];
                                      [self writeToFile:last_post forCafe:cafeName];
                                      completionHandler(last_post);
                                  }];
            break;
        }
        case SEA:
        {
            [FBRequestConnection startWithGraphPath:@"fbseattlecafe/posts"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      NSString *last_post= [(NSArray *)[result data] objectAtIndex:0][@"message"];
                                      [self writeToFile:last_post forCafe:cafeName];
                                      completionHandler(last_post);
                                  }];
            break;
        }
    }

}

+(void)writeToFile:(NSString *)menu forCafe:(CafeName)cafeName {
    NSData* data = [menu dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:[self filePathForCafeName:cafeName] atomically:YES];
}

+(NSString *)readFromFileForCafe:(CafeName)cafeName {
    NSData * data2 = [NSData dataWithContentsOfFile:[self filePathForCafeName:cafeName]];
    if (data2 == nil) {
        return nil;
    }
    NSString* newStr = [NSString stringWithUTF8String:[data2 bytes]];
    return newStr;
}

+(NSString *)filePathForCafeName:(CafeName)cafeName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"menu%d.txt", cafeName];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(void)deleteMenuForCafe:(CafeName)cafeName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self filePathForCafeName:cafeName] error:/*yolohackathon*/nil];
}

@end
