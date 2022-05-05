//
//  LAWTextFieldDelegate.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 16/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

extension ApolloTextInputField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        animateIn()
        resetTextField()
        self.delegate?.lawTextFieldDidBeginEditing(textField: self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        animateOut()
        self.delegate?.lawTextFieldDidEndEditing(textField: self)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resetErrorText()
        return self.delegate?.lawShouldChangeCharactersIn(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.lawTextFieldShouldReturn(self) ?? resignKeyBoard(textField)
    }
    
    private func resignKeyBoard(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}



