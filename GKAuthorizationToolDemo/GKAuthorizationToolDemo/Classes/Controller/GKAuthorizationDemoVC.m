//
//  GKAuthorizationDemoVC.m
//  GKAuthorizationToolDemo
//
//  Created by 高坤 on 16/8/23.
//  Copyright © 2016年 高坤. All rights reserved.
//

#import "GKAuthorizationDemoVC.h"
#import "GKAuthorizationTool.h"

@interface GKAuthorizationDemoVC ()

/** 相册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
/** 相机按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
/** 麦克风按钮 */
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;

@end

@implementation GKAuthorizationDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self changeBtn:self.photoBtn  type:GKAuthorizationTypePhoto];
    [self changeBtn:self.cameraBtn type:GKAuthorizationTypeCamera];
    [self changeBtn:self.audioBtn  type:GKAuthorizationTypeAudio];
    
}

- (void)changeBtn:(UIButton *)btn type:(GKAuthorizationType)type
{
    BOOL author = [GKAuthorizationTool checkAuthorizationWithType:type];
    
    btn.selected = author;
}

- (void)changeBtn:(UIButton *)btn status:(GKAuthorizationStatus)status
{
    switch (status) {
        case GKAuthorizationStatusAuthorized: // 允许访问
            btn.selected = YES;
            break;
        case GKAuthorizationStatusDenied:
        case GKAuthorizationStatusRestricted: // 拒绝访问
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户拒绝授权" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        case GKAuthorizationStatusNotSupport: // 不支持
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    if (status == GKAuthorizationStatusAuthorized) {
        btn.selected = YES;
    }else{ // 拒绝访问
        
    }
}

/** 获取相册权限 */
- (IBAction)getPhotoAuth:(UIButton *)sender {
    BOOL photoAuth = [GKAuthorizationTool checkAuthorizationWithType:GKAuthorizationTypePhoto];
    if (photoAuth) { // 已经授权
        sender.selected = YES;
    }else{
        sender.selected = NO;
        // 开始授权
        GKAuthorizationStatus status = [GKAuthorizationTool getPhotoAuthorizationStatus];
        if (status == GKAuthorizationStatusNotDetermined) {
            [GKAuthorizationTool requestPhotoAuthorizationCallback:^(GKAuthorizationStatus status) {
                [self changeBtn:sender status:status];
            }];
        }else{
            [self openSettingURL];
        }
    }
}

/** 获取相机权限 */
- (IBAction)getCameraAuth:(UIButton *)sender {
    BOOL cameraAuth = [GKAuthorizationTool checkAuthorizationWithType:GKAuthorizationTypeCamera];
    if (cameraAuth) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        // 开始授权
        GKAuthorizationStatus status = [GKAuthorizationTool getCameraAuthorizationStatus];
        if (status == GKAuthorizationStatusNotDetermined) {
            [GKAuthorizationTool requestCameraAuthorizationCallback:^(GKAuthorizationStatus status) {
                [self changeBtn:sender status:status];
            }];
        }else{
            [self openSettingURL];
        }
    }
}

/** 获取麦克风权限 */
- (IBAction)getAudioAuth:(UIButton *)sender {
    BOOL audioAUth = [GKAuthorizationTool checkAuthorizationWithType:GKAuthorizationTypeAudio];
    if (audioAUth) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        // 开始授权
        GKAuthorizationStatus status = [GKAuthorizationTool getAudioAuthorizationStatus];
        
        if (status == GKAuthorizationStatusNotDetermined) {
            [GKAuthorizationTool requestAudioAuthorizationCallback:^(GKAuthorizationStatus status) {
                [self changeBtn:sender status:status];
            }];
        }else{
            [self openSettingURL];
        }
    }
}

/**
 *  打开系统设置中对应应用的授权页面
 */
- (void)openSettingURL
{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}

@end
