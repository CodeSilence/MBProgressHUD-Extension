# MBProgressHUD-Extension

#### 适配现有`MBProgressHUD 1.1.0` 扩展
- 和老版`MBProgressHUD`效果一直[黑色背景，白色字体]
- 默认2秒,显示在底部

### Swift 使用

#### 1. loading

```swift
// 示例
MBProgressHUD.showLoading(self.view)
MBProgressHUD.dismiss(self.view)
```

#### 2. 吐司

```swift
// 示例
MBProgressHUD.showMessage("file")
```

#### 3. 显示进度和文字

```swift
// 示例
MBProgressHUD.showProgress(self.view, text: "update")
MBProgressHUD.setShowProgress(self.view, progress: Float(progress) / 100)
MBProgressHUD.dismiss(self.view)
```

#### 4. 显示成功和失败
- 注意：如果以此扩展，充当自己库的代码，并作为第三方库，先设置`swiftAnyClass`,避免找不到`bundle`,否不用去设置
```swift
- AppDelegate.swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        MBProgressHUD.setClass(AnyClass.self)
        
        return true
    }
```

```swift
// 示例
MBProgressHUD.showSuccess("update")
MBProgressHUD.showError("update")
```
