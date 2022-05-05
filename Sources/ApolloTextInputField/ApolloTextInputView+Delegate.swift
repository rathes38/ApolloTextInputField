//
//  LAWTextView+Delegate.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 09/05/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

extension ApolloTextInputField: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.setupClearButtonImage(withImage: "clear_ic")
        removeTextViewPlaceholder()
        resizeTextViewHeight()
        return self.delegate?.lawTextFieldShouldBeginEditing(textField: self) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        animateIn()
        self.delegate?.lawTextFieldDidBeginEditing(textField: self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        animateOut()
        addTextViewPlaceholder()
        self.delegate?.lawTextFieldDidEndEditing(textField: self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        resizeTextViewHeight()
        self.delegate?.lawTextFieldDidChange(textField: self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.delegate?.lawShouldChangeCharactersIn(self, shouldChangeCharactersIn: range, replacementString: text) ?? true
    }
}
