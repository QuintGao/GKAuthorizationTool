//
//  GKAuthorizationTool.h
//  GKAuthorizationTool
//
//  Created by 高坤 on 16/8/23.
//  Copyright © 2016年 高坤. All rights reserved.
//

#import <Foundation/Foundation.h>

// 授权状态
typedef NS_ENUM(NSUInteger, GKAuthorizationStatus){
    GKAuthorizationStatusNotDetermined = 0, // 未授权访问
    GKAuthorizationStatusDenied,            // 拒绝访问
    GKAuthorizationStatusAuthorized,        // 已授权
    GKAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如：家长控制
    GKAuthorizationStatusNotSupport         // 不支持授权
};

// 授权类型
typedef NS_ENUM(NSUInteger, GKAuthorizationType){
    GKAuthorizationTypePhoto = 0,  // 相册
    GKAuthorizationTypeCamera,     // 相机
    GKAuthorizationTypeAudio       // 麦克风
};

// 请求授权后的回调
typedef void(^requestCallback)(GKAuthorizationStatus status);

@interface GKAuthorizationTool : NSObject

/**
 *  获取相册授权状态
 */
+ (GKAuthorizationStatus)getPhotoAuthorizationStatus;

/**
 *  获取相机授权状态
 */
+ (GKAuthorizationStatus)getCameraAuthorizationStatus;

/**
 *  获取麦克风授权状态
 */
+ (GKAuthorizationStatus)getAudioAuthorizationStatus;

/**
 *  检测某一授权类型是否授权成功
 *
 *  @param type 需要授权的类型
 *
 *  @return 授权是否成功
 */
+ (BOOL)checkAuthorizationWithType:(GKAuthorizationType)type;

/**
 *  相册授权
 *
 *  @param callback 授权后的回调状态
 */
+ (void)requestPhotoAuthorizationCallback:(requestCallback)callback;

/**
 *  相机授权
 *
 *  @param callback 授权后的回调状态
 */
+ (void)requestCameraAuthorizationCallback:(requestCallback)callback;

/**
 *  麦克风授权
 *
 *  @param callback 授权后的回调状态
 */
+ (void)requestAudioAuthorizationCallback:(requestCallback)callback;

@end
