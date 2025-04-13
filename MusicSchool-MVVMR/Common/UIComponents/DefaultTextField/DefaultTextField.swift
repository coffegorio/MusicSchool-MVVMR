//
//  DefaultTextField.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct DefaultTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var leftIcon: Image? = nil
    
    var body: some View {
        HStack {
            if let icon = leftIcon {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 17)
                    .foregroundStyle(Color("TextColor"))
                    .padding(.leading, 15)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.horizontal, leftIcon == nil ? 15 : 8)
                    .foregroundStyle(Color("TextColor"))
                    .font(.subheadline)
            } else {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, leftIcon == nil ? 15 : 8)
                    .foregroundStyle(Color("TextColor"))
                    .font(.subheadline)
            }
        }
        .frame(height: 50)
        .background(Color("SecondaryBackgroundColor"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

// Для предпросмотра в SwiftUI Preview
struct DefaultTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DefaultTextField(text: .constant(""), placeholder: "Обычное поле")
            DefaultTextField(text: .constant(""), placeholder: "Пароль", isSecure: true)
            DefaultTextField(text: .constant(""), placeholder: "С иконкой", leftIcon: Image(systemName: "person.fill"))
        }
        .padding()
        .background(Color("BackgroundColor"))
    }
} 