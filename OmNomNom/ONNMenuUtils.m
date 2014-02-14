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

+(void) getMenuForCafe:(CafeName)cafeName completion:(void (^)(NSString *))completionHandler
{
    NSString *fromDisk = [self readFromFileForCafe:cafeName];
    if (fromDisk == nil) {
        [self downloadMenuForCafe:cafeName completion:completionHandler];
    } else {
        completionHandler(fromDisk);
    }
}

+(void) downloadMenuForCafe:(CafeName)cafeName completion:(void (^)(NSString *))completionHandler
{
    NSDictionary *response= [self downloadMenuJSON:cafeName];
    
    NSString *menu = [self getMenuAsString:response];
    [self writeToFile:menu forCafe:cafeName];
    completionHandler(menu);
}

+(NSDictionary *)downloadMenuJSON:(CafeName) cafe {
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
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    return (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:
                                            NSJSONReadingMutableContainers error:&error];
}

+(NSString *)getMenuAsString:(NSDictionary *)menu_json {
    NSString *menu = @"";
    menu = [menu stringByAppendingString:menu_json[@"header"]];
    menu = [menu stringByAppendingString:@"\n"];
    menu = [menu stringByAppendingString:@"\n"];    
    
    for (NSDictionary * section in menu_json[@"sections"]) {
        menu = [menu stringByAppendingString:section[@"name"]];
        menu = [menu stringByAppendingString:@"\n"];
        for (NSString * item in section[@"items"]) {
            menu = [menu stringByAppendingString:item];
            menu = [menu stringByAppendingString:@"\n"];
        }
        menu = [menu stringByAppendingString:@"\n"];
        
    }
    
    return menu;

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
