//
//  MainScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if viewModel.news.isEmpty {
                        Text("Новости не найдены")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.news) { news in
                            NewsCard(news: news)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Главная")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

//Text("\(viewModel.greetingForCurrentTime()), \(viewModel.getUserName())")
//    .font(.title2)
//    .foregroundStyle(Color("TextColor"))
//
//Text("Новости нашей школы")
//    .font(.subheadline)
//    .foregroundStyle(Color("TextColor"))
