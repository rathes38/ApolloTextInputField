//
//  LAWTextFieldProtocol.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 29/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

public protocol ApolloTextInputFieldDelegate: class {
    /*
     Implement this method to increase height of your TextInputField if you show success, error or warning message
     You can find your TextInputField on the basis of Tag value.
     */
    func foundValidationMessage(textField: ApolloTextInputField)
    
    /*
     Implement this method to decrease height of your TextInputField if you hide success, error or warning message
     You can find your TextInputField on the basis of Tag value.
     */
    func notFoundValidationMessage(textField: ApolloTextInputField)
    
    /*
     Implement this method to increase/decrease height of your TextInputField if you use TextInputField of type multiline
     You can find your TextInputField on the basis of Tag value.
     */
    func resizeTextField(_ textField: ApolloTextInputField, didResizeHeight height: CGFloat)
    
    func lawTextFieldShouldBeginEditing(textField: ApolloTextInputField) -> Bool
    func lawTextFieldDidBeginEditing(textField: ApolloTextInputField)
    func lawTextFieldDidEndEditing(textField: ApolloTextInputField)
    func lawTextFieldDidChange(textField: ApolloTextInputField)
    func lawShouldChangeCharactersIn(_ textField: ApolloTextInputField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func lawTextFieldShouldReturn(_ textField: ApolloTextInputField) -> Bool
    func dateFieldDoneClicked(_ textField: ApolloTextInputField)
    func timeFieldDoneClicked(_ textField: ApolloTextInputField)
    func lawTextFieldTapped(_ textField: ApolloTextInputField)
}

public extension ApolloTextInputFieldDelegate {
    
    func foundValidationMessage(textField: ApolloTextInputField) {
        // Optional
    }
    
    func notFoundValidationMessage(textField: ApolloTextInputField) {
        // Optional
    }
    
    func resizeTextField(_ textField: ApolloTextInputField, didResizeHeight height: CGFloat) {
        // Optional
    }
    
    func lawTextFieldShouldBeginEditing(textField: ApolloTextInputField) -> Bool {
        // Optional
        return true
    }
    
    func lawTextFieldDidBeginEditing(textField: ApolloTextInputField) {
        // Optional
    }
    
    func lawTextFieldDidEndEditing(textField: ApolloTextInputField) {
        // Optional
    }
    
    func lawTextFieldDidChange(textField: ApolloTextInputField) {
        // Optional
    }
    
    func lawShouldChangeCharactersIn(_ textField: ApolloTextInputField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Optional
        return true
    }
    
    func lawTextFieldShouldReturn(_ textField: ApolloTextInputField) -> Bool {
        //Optional
        textField.resignFirstResponder()
        return true
    }
    
    func dateFieldDoneClicked(_ textField: ApolloTextInputField) {
    }
    
    func lawTextFieldTapped(_ textField: ApolloTextInputField) {
    }
    func timeFieldDoneClicked(_ textField: ApolloTextInputField){
        
    }

 }

