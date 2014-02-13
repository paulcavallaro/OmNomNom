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
    SEA,
};

@interface ONNMenuUtils : NSObject

+(void) getMenuForCafe:(CafeName)cafeName completion:(void ( ^ )(NSString *) ) completionHandler;
+(void) downloadMenuForCafe:(CafeName)cafeName completion:(void ( ^ )(NSString *) ) completionHandler;
+(void) deleteMenuForCafe:(CafeName)cafeName;
@end
