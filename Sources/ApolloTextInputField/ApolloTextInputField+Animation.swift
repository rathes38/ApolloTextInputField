//
//  LAWTextFieldAnimation.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 16/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

extension ApolloTextInputField {
    
    internal func animateInWithText(text: String) {
        if(validationType == .multiline) {
            textView.text = text
        }
        else {
            textField.text = text
        }
        if(!text.isEmpty) {
            sepratorView.backgroundColor = self.isTextFieldEditable ? separatorDefaultColor :lineDisableColor
            titleLabelTextFieldConstraint?.constant = 0
            UIView.animate(withDuration: 0, animations: { [weak self] in
                self?.titleLabel.alpha = 1.0
                self?.layoutIfNeeded()
            }) { (_) in
                self.showClearButton(false)
            }
        }
        else {
            self.showClearButton(false)
            self.setupPlaceholderColor(text: placeholder ?? "")
            sepratorView.backgroundColor = lineDefaultColor
            titleLabelTextFieldConstraint?.constant = -20
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.titleLabel.alpha = 0.0
                self?.layoutIfNeeded()
            })
        }
    }
    
    internal func animateIn() {
        DispatchQueue.main.async {
            self.textField.placeholder = ""
            self.sepratorView.backgroundColor = self.lineActiveColor
            self.titleLabelTextFieldConstraint?.constant = 0
            if !(self.errorLabel.text?.isEmpty ?? false) {
                self.errorLabel.alpha = 1.0
            } else {
                self.errorLabel.alpha = 0
            }
            UIView.animate(withDuration: 0, animations: { [weak self] in
                self?.titleLabel.alpha = 1.0
                self?.layoutIfNeeded()
            }) { (_) in
                self.showClearButton(true)
            }
        }
    }
    
    internal func animateOut() {
        DispatchQueue.main.async {
            self.showClearButton(false)
            guard let text = self.textField.text, text.isEmpty, (self.textView.text.isEmpty || self.textView.text == self.placeholder) else {
                self.sepratorView.backgroundColor = self.lineFocusColor
                return
            }
            self.setupPlaceholderColor(text: self.placeholder ?? "")
            self.sepratorView.backgroundColor = self.lineDefaultColor
            self.titleLabelTextFieldConstraint?.constant = -20
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.titleLabel.alpha = 0.0
                self?.layoutIfNeeded()
            }
        }
    }
    
    internal func showClearButton(_ show: Bool) {
        if (validationType == .password || validationType == .ssn || validationType == .date || validationType == .dropdown || validationType == .time) {
            self.clearButton.isHidden = false
        }
        else {
            self.clearButton.isHidden = !show
        }
    }
}
