//
//  ONNMenuUtils.h
//  OmNomNom
//
//  Created by Elliot Lynde on 2/12/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CafeName) {
    NYC,
    EPIC,
    LTD,
};

@interface ONNMenuUtils : NSObject

+(void) getMenuForCafe:(CafeName)cafeName completion:(void ( ^ )(NSDictionary *) ) completionHandler;
+(void) downloadMenuForCafe:(CafeName)cafeName completion:(void ( ^ )(NSDictionary *) ) completionHandler;
+(void) deleteMenuForCafe:(CafeName)cafeName;
+(NSString *) stringForCafe:(CafeName)cafeName;
+(NSString *) imageForCafe:(CafeName)cafeName;

@end
