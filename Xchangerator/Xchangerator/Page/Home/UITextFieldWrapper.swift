//
//  UITextFieldWrapper.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-01.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
struct TextFieldTyped: UIViewRepresentable {
 
    
    let placeholder: String
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    @Binding var text: String
    @Binding var isfocusAble: [Bool]

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = self.returnVal
        textField.tag = self.tag
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
//        if isfocusAble[tag] {
//            uiView.becomeFirstResponder()
//        } else {
//            uiView.resignFirstResponder()
//        }
    }

    func makeCoordinator() -> TextFieldTyped.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldTyped

        init(_ textField: TextFieldTyped) {
            self.parent = textField
        }

        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if  let retTxt = textField.text {
                return retTxt != ""
            } else {
                return false

            }

        }

    }
}
