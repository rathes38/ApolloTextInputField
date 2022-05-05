//
//  LAWTextFieldAccessibility.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 23/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

extension ApolloTextInputField {
    
    func setupAccessibility() {
        self.isAccessibilityElement = false
        self.shouldGroupAccessibilityChildren = false
        self.titleLabel.isAccessibilityElement = true
        self.textField.isAccessibilityElement = true
        self.textField.rightView?.isAccessibilityElement = true
        self.errorLabel.isAccessibilityElement = true
        self.accessibilityLabel = (titleLabel?.text ?? "")
        self.accessibilityHint = "Double tap to edit"
    }
    
    override public func accessibilityElementDidBecomeFocused() {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        sepratorView.backgroundColor = lineFocusColor
    }
    
    override public func accessibilityElementDidLoseFocus() {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        sepratorView.backgroundColor = lineDefaultColor
    }
    
    override public func accessibilityElementIsFocused() -> Bool {
        if #available(iOS 9.0, *) {
            return !textField.isFocused
        } else {
            fatalError("ApolloTextInputField minimum deployment target is 11.0")
        }
    }
}
