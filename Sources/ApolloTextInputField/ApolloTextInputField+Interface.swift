//
//  LAWTextFieldValidation.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 26/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

public enum LAWTextFieldValidationType {
    case none
    case email
    case password
    case multiline
    case dropdown
    case ssn
    case date
    case time
}

public protocol LAWTextFieldInterface  {
    func resetTextField()
    func showErrorMessage(withIcon icon: Bool, sepratorColor: UIColor?)
    func showWarningMessage(withIcon icon: Bool, sepratorColor: UIColor?)
    func showSuccessMessage(withIcon icon: Bool, sepratorColor: UIColor?)
}

extension ApolloTextInputField: LAWTextFieldInterface {
    
    open func resetTextField() {
        DispatchQueue.main.async {
            if (self.validationType != .password
                && self.validationType != .ssn && self.validationType != .date  && self.validationType != .dropdown && self.validationType != .time) {
                self.setupClearButtonImage(withImage: "clear_ic")
            }
            // notify class to not found validation message
            self.delegate?.notFoundValidationMessage(textField: self)
        }
    }
    open func resetErrorText() {
        DispatchQueue.main.async {
            self.errorLabel.text = ""
            self.errorLabel.alpha = 0.0
        }
    }
    
    open func showErrorMessage(withIcon icon: Bool, sepratorColor: UIColor? = nil) {
        DispatchQueue.main.async {
            self.sepratorView.backgroundColor = sepratorColor ?? self.lineFailiureColor
            self.errorLabel.textColor = sepratorColor ?? self.lineFailiureColor
            if (self.validationType != .password
                && self.validationType != .ssn && self.validationType != .date  && self.validationType != .dropdown) {
                self.setupClearButtonImage(withImage: "error_ic")
            }
            self.errorLabel.text = self.errorText
            self.errorLabel.alpha = 1.0
            self.showClearButton(icon)
            
            // notify class to found validation message
            self.delegate?.foundValidationMessage(textField: self)
        }
    }
    
    open func showSuccessMessage(withIcon icon: Bool, sepratorColor: UIColor? = nil) {
        
        DispatchQueue.main.async {
            self.sepratorView.backgroundColor = sepratorColor ?? self.lineSuccessColor
            self.errorLabel.textColor = self.lineSuccessColor
            if (self.validationType != .password
                && self.validationType != .ssn && self.validationType != .date  && self.validationType != .dropdown) {
                self.setupClearButtonImage(withImage: "success_ic")
            }
            self.errorLabel.text = self.successText
            self.errorLabel.alpha = 1.0
            self.showClearButton(icon)
                    //
            // notify class to found validation message
            
            self.delegate?.foundValidationMessage(textField: self)
            
        }
    }
    
    open func showWarningMessage(withIcon icon: Bool, sepratorColor: UIColor? = nil) {
        DispatchQueue.main.async {
            if (self.validationType != .password
                && self.validationType != .ssn && self.validationType != .date  && self.validationType != .dropdown) {
                self.setupClearButtonImage(withImage: "warning_ic")
            }
            self.sepratorView.backgroundColor = sepratorColor ?? self.lineWarningColor
            self.errorLabel.textColor = self.lineWarningColor
            self.errorLabel.text = self.warningText
            self.errorLabel.alpha = 1.0
            self.showClearButton(icon)
            // notify class to found validation message
            self.delegate?.foundValidationMessage(textField: self)
        }
    }
}
