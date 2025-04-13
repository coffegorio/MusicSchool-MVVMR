//
//  DefaultButton.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct DefaultButton: View {
    
    var action: () -> Void = {}
    var isFill: Bool = true
    var title: String = ""
    var leftsideImage: Image? = nil
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .foregroundStyle(isFill ? Color("ButtonTextColor") : Color("TextColor"))
                    .font(.subheadline)
                
                HStack {
                    if let image = leftsideImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17, height: 17)
                            .foregroundStyle(isFill ? Color("BackgroundColor") : Color("TextColor"))
                    }
                    Spacer()
                }
                .padding(.leading, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isFill ? Color("AccentColor") : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isFill ? Color.clear : Color("AccentColor"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
