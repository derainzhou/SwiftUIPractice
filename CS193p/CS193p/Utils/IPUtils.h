//
//  IPAddress.h
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPUtils : NSObject

+ (NSDictionary *)getIPAddresses;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSString *)getLocalIPAddress:(BOOL)preferIPv4;

+ (NSString *)getNetworkIPAddress;

@end

NS_ASSUME_NONNULL_END
