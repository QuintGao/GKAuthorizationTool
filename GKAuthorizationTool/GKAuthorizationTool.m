//
//  GKAuthorizationTool.m
//  GKAuthorizationTool
//
//  Created by 高坤 on 16/8/23.
//  Copyright © 2016年 高坤. All rights reserved.
//

#import "GKAuthorizationTool.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation GKAuthorizationTool

/**
 *  获取相册授权状态
 */
+ (GKAuthorizationStatus)getPhotoAuthorizationStatus
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined:
            return GKAuthorizationStatusNotDetermined;
            break;
        case ALAuthorizationStatusAuthorized:
            return GKAuthorizationStatusAuthorized;
            break;
        case ALAuthorizationStatusDenied:
            return GKAuthorizationStatusDenied;
            break;
        case ALAuthorizationStatusRestricted:
            return GKAuthorizationStatusAuthorized;
            break;
        default:
            return GKAuthorizationStatusNotSupport;
            break;
    }
}

/**
 *  获取相机授权状态
 */
+ (GKAuthorizationStatus)getCameraAuthorizationStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            return GKAuthorizationStatusNotDetermined;
            break;
        case AVAuthorizationStatusAuthorized:
            return GKAuthorizationStatusAuthorized;
            break;
        case AVAuthorizationStatusDenied:
            return GKAuthorizationStatusDenied;
            break;
        case AVAuthorizationStatusRestricted:
            return GKAuthorizationStatusRestricted;
            break;
            
        default:
            return GKAuthorizationStatusNotSupport;
            break;
    }
}

/**
 *  获取麦克风授权状态
 */
+ (GKAuthorizationStatus)getAudioAuthorizationStatus
{
    AVAudioSessionRecordPermission permission = [AVAudioSession sharedInstance].recordPermission;
    switch (permission) {
        case AVAudioSessionRecordPermissionUndetermined:
            return GKAuthorizationStatusNotDetermined;
            break;
        case AVAudioSessionRecordPermissionGranted:
            return GKAuthorizationStatusAuthorized;
            break;
        case AVAudioSessionRecordPermissionDenied:
            return GKAuthorizationStatusDenied;
            break;
        default:
            return GKAuthorizationStatusNotSupport;
            break;
    }
}

/**
 *  检测某一授权类型是否授权成功
 *
 *  @param type 需要授权的类型
 *
 *  @return 授权是否成功
 */
+ (BOOL)checkAuthorizationWithType:(GKAuthorizationType)type
{
    GKAuthorizationStatus status;
    switch (type) {
        case GKAuthorizationTypePhoto:
            status = [self getPhotoAuthorizationStatus];
            break;
        case GKAuthorizationTypeCamera:
            status = [self getCameraAuthorizationStatus];
            break;
        case GKAuthorizationTypeAudio:
            status = [self getAudioAuthorizationStatus];
            break;
            
        default:
            status = -1;
            break;
    }
    if (status == GKAuthorizationStatusAuthorized) { // 可以访问
        return YES;
    }else{ // 不可访问
        return NO;
    }
}

#pragma mark - 相册授权
+ (void)requestPhotoAuthorizationCallback:(requestCallback)callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
        if (authorStatus == ALAuthorizationStatusNotDetermined) {
            if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
                [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
            }else{ // ios8以后
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { // 授权成功
                        [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
                    }else if (status == PHAuthorizationStatusDenied){
                        [self executerCallback:callback status:GKAuthorizationStatusDenied];
                    }else if (status == PHAuthorizationStatusRestricted){
                        [self executerCallback:callback status:GKAuthorizationStatusRestricted];
                    }
                }];
            }
        }else if (authorStatus == ALAuthorizationStatusAuthorized){
            [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
        }else if (authorStatus == ALAuthorizationStatusDenied){
            [self executerCallback:callback status:GKAuthorizationStatusDenied];
        }else if (authorStatus == ALAuthorizationStatusRestricted){
            [self executerCallback:callback status:GKAuthorizationStatusRestricted];
        }
    }else{
        [self executerCallback:callback status:GKAuthorizationStatusNotSupport];
    }
}

#pragma mark - 相册授权
+ (void)requestCameraAuthorizationCallback:(requestCallback)callback
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
                }else{
                    [self executerCallback:callback status:GKAuthorizationStatusDenied];
                }
            }];
        }else if (authorStatus == AVAuthorizationStatusAuthorized){
            [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
        }else if (authorStatus == AVAuthorizationStatusDenied){
            [self executerCallback:callback status:GKAuthorizationStatusDenied];
        }else if (authorStatus == AVAuthorizationStatusRestricted){
            [self executerCallback:callback status:GKAuthorizationStatusRestricted];
        }
    }else{
        [self executerCallback:callback status:GKAuthorizationStatusNotSupport];
    }
}

#pragma mark - 麦克风权限
+ (void)requestAudioAuthorizationCallback:(requestCallback)callback
{
    AVAudioSessionRecordPermission audioStatus = [AVAudioSession sharedInstance].recordPermission;
    if (audioStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
            }else{
                [self executerCallback:callback status:GKAuthorizationStatusDenied];
            }
        }];
    }else if (audioStatus == AVAudioSessionRecordPermissionGranted){
        [self executerCallback:callback status:GKAuthorizationStatusAuthorized];
    }else if (audioStatus == AVAudioSessionRecordPermissionDenied){
        [self executerCallback:callback status:GKAuthorizationStatusDenied];
    }
}

#pragma mark - 回调函数
+ (void)executerCallback:(void(^)(GKAuthorizationStatus))callback status:(GKAuthorizationStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}


@end
