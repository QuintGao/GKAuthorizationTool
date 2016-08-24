**1.使用方法，以获取系统相册权限为例**

```
// 检测当前应用是否获取相册权限
    BOOL photoAuth = [GKAuthorizationTool checkAuthorizationWithType:GKAuthorizationTypePhoto];
    if (photoAuth) {
        // 已经授权
    }else{ // 未授权
        // 开始授权，获取授权状态
        GKAuthorizationStatus status = [GKAuthorizationTool getPhotoAuthorizationStatus];
        if (status == GKAuthorizationStatusNotDetermined) { // 未授权过
            [GKAuthorizationTool requestPhotoAuthorizationCallback:^(GKAuthorizationStatus status) {
                if (status == GKAuthorizationStatusAuthorized){
                    // 授权成功
                }else{
                    // 授权失败
                }
            }];
        }else{ // 已授权过，后又关闭权限，直接跳转到系统设置中该应用的授权界面
            [self openSettingURL];// 打开系统设置该应用授权界面
        }
    }
```
**2.支持CocoaPods**

pod 'GKAuthorizatonTool' 
