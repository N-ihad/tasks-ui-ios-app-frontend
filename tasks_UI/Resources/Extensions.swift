//
//  Extensions.swift
//  tasks_UI
//
//  Created by Nihad on 4/17/21.
//

import UIKit
import MaterialComponents.MaterialButtons

// MARK: - String
//============================================================================
extension String
{
    //----------------------------------------------------------------------------
    mutating func removeExtraCharsBase64()
    {
        self = String(dropFirst(2))
        self = String(dropLast(1))
    }

    //----------------------------------------------------------------------------
    func removeExtraCharsBase64NoMutating() -> String
    {
        
        var result = self.dropFirst(2)
        result = result.dropLast(1)

        return String(result)
    }
}

// MARK: - UILabel
//============================================================================
extension UILabel
{
    //----------------------------------------------------------------------------
    static func makeMethodLabel(withText text: String) -> UILabel
    {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        return lbl
    }
}

// MARK: - UIImageView
//============================================================================
extension UIImageView
{
    //----------------------------------------------------------------------------
    static func makeMethodResultImageView() -> UIImageView
    {
        let iv = UIImageView()
        iv.autoSetDimensions(to: CGSize(width: 220, height: 220))
        iv.backgroundColor = themeImagePlaceholderColor
        
        return iv
    }
    
    //----------------------------------------------------------------------------
    static func makeMethodResultImageView34tasks() -> UIImageView
    {
        let iv = UIImageView()
        iv.autoSetDimensions(to: CGSize(width: 955, height: 411))
        iv.backgroundColor = themeImagePlaceholderColor
        
        return iv
    }

    //----------------------------------------------------------------------------
    static func makeMethodResultImageView34tasks3d(width: CGFloat = 900, height: CGFloat
     = 900) -> UIImageView
    {
        let iv = UIImageView()
        iv.autoSetDimensions(to: CGSize(width: width, height: height))
        iv.backgroundColor = themeImagePlaceholderColor
        
        return iv
    }
}

// MARK: - MDCButton
//============================================================================
extension MDCButton
{
    //----------------------------------------------------------------------------
    static func makeButton(withTitle title: String, target: Any?, andSelector selector: Selector) -> MDCButton
    {
        let btn = MDCButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setBackgroundColor(themeButtonColor)
        btn.addTarget(target, action: selector, for: .touchUpInside)

        return btn
    }
}
