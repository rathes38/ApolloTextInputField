//
//  String.swift
//  ApolloTextInputField
//
//  Created by Jaiswal, Akash on 29/06/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import Foundation

extension String {
    
    func keepOnlyDigits() -> String {
        let ucString = self.uppercased()
        let validCharacters = "0123456789"
        let characterSet: CharacterSet = CharacterSet(charactersIn: validCharacters)
        let stringArray = ucString.components(separatedBy: characterSet.inverted)
        let allNumbers = stringArray.joined(separator: "")
        return allNumbers
    }
    var toDate: Date {
        get {
            guard let date = Date.dateFormatter.date(from: self)
                else {
                    preconditionFailure("Take a look to your format")
            }
            return date
        }
    }
}
