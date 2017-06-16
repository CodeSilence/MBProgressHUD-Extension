//
//  MBProgressHUD+Extension.swift
//  
//
//  Created by silence on 2017/6/6.
//  Copyright © 2017年 silence. All rights reserved.
//

import UIKit
import MBProgressHUD

enum MBProgressHUDMessageLocation : Int {
    case center = 0, bottom = 1000000, top = -1000000
}

extension MBProgressHUD {
    
    /// Show Loading and Text
    ///
    /// - Parameters:
    ///   - view: `nil` -> window
    ///   - text: default `nil`
    static func showLoading(_ view:UIView?, text:String? = nil) {
        showText(text: text, icon: nil, view: view)
    }
    
    /// Only Message text
    ///
    /// - Parameters:
    ///   - text: default `Message here!`
    ///   - location: default `center`
    ///   - afterDelay: default `3`
    static func showMessage(_ text:String = "Message here!", location:MBProgressHUDMessageLocation = .center, afterDelay:TimeInterval = 3) {
        
        let view = currentlyWithShow(nil)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.textColor = UIColor.white
        hud.offset = CGPoint(x: 0, y: location.rawValue)
        hud.bezelView.backgroundColor = rgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
    /// Success
    ///
    ///  text is `nil`, show image
    /// - Parameter text: default `nil`
    static func showSuccess(_ text: String? = nil) {
        let view = currentlyWithShow(nil)
        showText(text: text, icon: "Checkmark", view: view)
    }
    
    /// Error
    ///
    ///  text is `nil` , show image
    /// - Parameter text: default `nil`
    static func showError(_ text: String? = nil ) {
        let view = currentlyWithShow(nil)
        showText(text: text, icon: "Error", view: view)
    }
    
    /// Dismiss
    ///
    /// - Parameter view: `nil` -> window
    static func dismiss(_ view:UIView?) {
        let view = currentlyWithShow(view)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    fileprivate static func showText(text: String? = nil, icon: String?, view:UIView?) {
        let view = currentlyWithShow(view)
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.backgroundColor = rgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
        hud.contentColor = UIColor.white
        if icon != nil && icon!.characters.count > 0 {
            hud.mode = .customView
            let image = UIImage(named: "MBProgressHUD.bundle/" + icon!)!.withRenderingMode(.alwaysTemplate)
            hud.customView = UIImageView(image: image)
            hud.isSquare = true
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: 3)
        }
        
        if text != nil {
            hud.label.text = text
            hud.label.textColor = UIColor.white
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
