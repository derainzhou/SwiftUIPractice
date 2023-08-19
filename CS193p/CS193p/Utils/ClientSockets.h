//
//  ClientSockets.h
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientSockets : NSObject

+ (instancetype)shared;

- (void)connect;

- (void)sendMessage;

@end

NS_ASSUME_NONNULL_END
