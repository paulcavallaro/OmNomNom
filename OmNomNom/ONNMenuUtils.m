//
//  ONNMenuUtils.m
//  OmNomNom
//
//  Created by Elliot Lynde on 2/12/14.
//
//

#import "ONNMenuUtils.h"
#import "ONNAppDelegate.h"

@implementation ONNMenuUtils

+(NSString *) stringForCafe:(CafeName)cafeName
{
    switch (cafeName) {
        case EPIC:
            return @"Epic (MPK)";
        case LTD:
            return @"Livin' The Dream (MPK)";
        case NYC:
            return @"Yolo Café (NYC)";
    }
}

+(NSString *) imageForCafe:(CafeName)cafeName
{
    switch (cafeName) {
        case EPIC:
            return @"Cafe_Epic_Panorama";
        case LTD:
            return @"LTD";
        case NYC:
            return @"NYC";
    }
}

+(void) getMenuForCafe:(CafeName)cafeName completion:(void (^)(NSDictionary *))completionHandler
{
    NSDictionary *fromDisk = [self readFromFileForCafe:cafeName];
    if (fromDisk == nil) {
        [self downloadMenuForCafe:cafeName completion:completionHandler];
    } else {
        completionHandler(fromDisk);
        [self downloadMenuForCafe:cafeName completion:^(NSDictionary * downloaded) {
            if (![downloaded isEqualToDictionary:fromDisk]) {
                completionHandler(downloaded);
            }
        }];
    }
}

+(void) downloadMenuForCafe:(CafeName)cafeName completion:(void (^)(NSDictionary *))completionHandler
{
    NSData *data = [self downloadMenuJSONData:cafeName];
    
    NSDictionary *response= [self downloadMenuJSON:cafeName];
    
    [self writeToFile:data forCafe:cafeName];
    completionHandler(response);
}

+(NSData *)downloadMenuJSONData:(CafeName) cafe {
    NSString *cafe_name = @"";
    
    if (cafe == NYC) {
        cafe_name = @"nyc";
    } else if (cafe == LTD) {
        cafe_name = @"ltd";
    } else if (cafe == EPIC) {
        cafe_name = @"epic";
    }
    
    NSString *str=[NSString stringWithFormat:@"http://www.elliotlynde.com/nomparse/%@.json", cafe_name];
    NSURL *url=[NSURL URLWithString:str];
    return [NSData dataWithContentsOfURL:url];
}

+(NSDictionary *)downloadMenuJSON:(CafeName) cafe {
    NSData *data = [self downloadMenuJSONData:cafe];
    
    NSError *error;
    return (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:
                                            NSJSONReadingMutableContainers error:&error];
}


+(void)writeToFile:(NSData *)menu forCafe:(CafeName)cafeName {
    [menu writeToFile:[self filePathForCafeName:cafeName] atomically:YES];
}

+(NSDictionary *)readFromFileForCafe:(CafeName)cafeName {
    NSData * data2 = [NSData dataWithContentsOfFile:[self filePathForCafeName:cafeName]];
    if (data2 == nil) {
        return nil;
    }
    NSError *error;
    return (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data2 options:
                            NSJSONReadingMutableContainers error:&error];
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
