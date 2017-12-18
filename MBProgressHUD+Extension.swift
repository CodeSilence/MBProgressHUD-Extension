//
//  MBProgressHUD+Extension.swift
//  
//
//  Created by Devin on 2017/6/6.
//  Copyright © 2017年 Devin. All rights reserved.
//

import UIKit
import MBProgressHUD

public enum MBProgressHUDMessageLocation : Int {
    case center = 0, bottom = 1000000, top = -1000000
}

extension MBProgressHUD {
    
    private static var swiftAnyClass:Swift.AnyClass? = nil
    
    /// 显示loading和文字
    ///
    /// - Parameters:
    ///   - view: 如果传入`nil`,则显示在Window上
    ///   - text: 默认为 `nil`
    public static func showLoading(_ view:UIView?, text:String? = nil) {
        showText(text: text, icon: nil, view: view)
    }
    
    /// 显示进度和文字
    ///
    /// - Parameters:
    ///   - view: 如果传入`nil`,则显示在Window上
    ///   - text: 默认为 `nil`
    public static func showProgress(_ view:UIView?, text:String? = nil) {
        let view = currentlyWithShow(view)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.backgroundColor = rgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
        hud.contentColor = UIColor.white
        hud.mode = .annularDeterminate
        if text != nil {
            hud.label.text = text
        }
    }
    
    /// 设置显示进度,对应showProgress(:)方法
    ///
    /// - Parameters:
    ///   - view: 如果传入`nil`,则显示在Window上
    ///   - progress: 进度,Float类型
    ///   - text: 默认为 `nil`
    public static func setShowProgress(_ view:UIView?, progress:Float, text:String? = nil) {
        let view = currentlyWithShow(view)
        MBProgressHUD(for: view)!.progress = progress
        if text != nil, !text!.isEmpty {
            MBProgressHUD(for: view)!.label.text = text
        }
    }
    
    /// 仅显示文本
    ///
    /// - Parameters:
    ///   - text: String
    ///   - location: 默认在底部显示
    ///   - afterDelay: 默认持续2秒
    public static func showMessage(_ text:String?, location:MBProgressHUDMessageLocation = .bottom, afterDelay:TimeInterval = 2) {
        
        guard text != nil else {
            return
        }
        
        let view = currentlyWithShow(nil)
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = text
            hud.label.textColor = UIColor.white
            hud.label.numberOfLines = 0
            hud.label.font = UIFont.systemFont(ofSize: 18)
            hud.offset = CGPoint(x: 0, y: location.rawValue)
            hud.bezelView.backgroundColor = rgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
            hud.hide(animated: true, afterDelay: afterDelay)
        }
    }
    
    /// Success
    ///
    ///  text is `nil`, show image
    /// - Parameter text: default `nil`
    public static func showSuccess(_ text: String? = nil) {
        let view = currentlyWithShow(nil)
        showText(text: text, icon: swiftAnyClass ? "CheckmarkW" : "Checkmark", view: view)
    }
    
    /// Error
    ///
    ///  text is `nil` , show image
    /// - Parameter text: default `nil`
    public static func showError(_ text: String? = nil ) {
        let view = currentlyWithShow(nil)
        showText(text: text, icon: swiftAnyClass ? "ErrorW" : "Error", view: view)
    }
    
    /// Dismiss
    ///
    /// - Parameter view: `nil` -> window
    public static func dismiss(_ view:UIView?) {
        let view = currentlyWithShow(view)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    /// 当前扩展做自己的库时，调用
    ///
    /// - Parameter swiftClass: 当前库任意同级的Swift Class文件,用于定位`bundle`
    public static func setClass(_ swiftClass:Swift.AnyClass) {
        swiftAnyClass = swiftClass
    }
    
    fileprivate static func showText(text: String? = nil, icon: String?, view:UIView?) {
        let view = currentlyWithShow(view)
        var imageView:UIImageView?
    
        // 拿取图片
        if icon != nil && icon!.count > 0 {
            var image:UIImage?
            if swiftAnyClass != nil {
                let bundle = Bundle(for: swiftAnyClass!)
                let url = bundle.url(forResource: "MBProgressHUD", withExtension: "bundle")!
                let imageBundle = Bundle(url: url)!
                image = UIImage(named: icon!, in: imageBundle, compatibleWith: nil)
            }else {
                image = UIImage(named: "MBProgressHUD.bundle/" + icon!)!.withRenderingMode(.alwaysTemplate)
            }
            
            if image != nil {
                imageView = UIImageView(image: image)
            }
        }
        
        DispatchQueue.main.async {
             // 避免覆盖
            MBProgressHUD.hide(for: view, animated: true)
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.bezelView.backgroundColor = rgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
            hud.contentColor = UIColor.white
            if imageView != nil {
                hud.mode = .customView
                hud.customView = imageView
                hud.isSquare = true
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 2)
            }
            
            if text != nil {
                hud.label.text = text
            }
        }
    }
    
    /// Get view
    fileprivate static func currentlyWithShow(_ view:UIView?) -> UIView {
        
        if view == nil {
            var window = UIApplication.shared.keyWindow!
            if window.windowLevel != UIWindowLevelNormal {
                let windowArray = UIApplication.shared.windows
                
                for tempWin in windowArray {
                    if tempWin.windowLevel == UIWindowLevelNormal {
                        window = tempWin
                        break
                    }
                }
            }
            return window
        }
        
        return view!
    }
    
    /// Hexadecimal convert RGBA
    ///
    /// - Parameters:
    ///   - rgb: example: `0xDFDFDF`
    ///   - alpha: default `1.0`
    /// - Returns: `color`
    fileprivate static func rgbaColorFromHex(rgb:Int, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
}
