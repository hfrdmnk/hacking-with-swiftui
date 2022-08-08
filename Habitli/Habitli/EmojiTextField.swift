//
//  EmojiTextField.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import SwiftUI
import Foundation

class UIEmojiTextField: UITextField {
    
    var isEmoji = false {
        didSet {
            setEmoji()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setEmoji() {
        self.reloadInputViews()
    }
    
    override var textInputContextIdentifier: String? {
        return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" && self.isEmoji{
                self.keyboardType = .default
                return mode
                
            } else if !self.isEmoji {
                return mode
            }
        }
        return nil
    }
    
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    @Binding var isEmoji: Bool
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        emojiTextField.isEmoji = self.isEmoji
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
        uiView.isEmoji = isEmoji
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

extension String {
    func onlyEmoji() -> String {
        return self.filter({$0.isEmoji})
    }
}

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }
}
