//
//  AIScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI

struct AIScreenView: View {
    
    var viewModel: AIScreenViewModel
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: 1, text: "Привет! Я музыкальный ассистент. Чем я могу помочь?", isUser: false),
    ]
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Text("AI Ассистент")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    
                    Spacer()
                    
                    Image(systemName: "waveform")
                        .foregroundColor(Color("AccentColor"))
                        .font(.title2)
                }
                .padding()
                
                // Список сообщений
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            chatBubble(message: message)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                
                // Поле ввода
                HStack(spacing: 12) {
                    TextField("Введите сообщение...", text: $messageText)
                        .padding(12)
                        .background(Color("SecondaryBackgroundColor"))
                        .cornerRadius(25)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("BackgroundColor"))
                            .frame(width: 50, height: 50)
                            .background(Color("AccentColor"))
                            .clipShape(Circle())
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
                .padding()
            }
        }
    }
    
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let userMessage = ChatMessage(id: messages.count + 1, text: text, isUser: true)
            messages.append(userMessage)
            messageText = ""
            
            // Имитация ответа от ИИ
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let aiResponse = generateAIResponse(to: text)
                let aiMessage = ChatMessage(id: messages.count + 1, text: aiResponse, isUser: false)
                messages.append(aiMessage)
            }
        }
    }
    
    private func generateAIResponse(to text: String) -> String {
        let responses = [
            "Пока что я нахожусь в разработке, скоро буду радовать Вас своей помощью!"
        ]
        
        return responses.randomElement() ?? "Извините, я не понимаю. Попробуйте перефразировать вопрос."
    }
    
    private func chatBubble(message: ChatMessage) -> some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color("AccentColor") : Color("SecondaryBackgroundColor"))
                .foregroundColor(message.isUser ? Color("BackgroundColor") : Color("TextColor"))
                .cornerRadius(18)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

// Модель сообщения чата
struct ChatMessage: Identifiable {
    var id: Int
    var text: String
    var isUser: Bool
}

