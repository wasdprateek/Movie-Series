//
//  Movie&TvList.swift
//  Movie & Series
//
//  Created by Prateek Kumar Rai on 19/02/25.
//

import SwiftUI

// MARK: - Views

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Type", selection: $viewModel.isMovies) {
                    Text("Movies").tag(true)
                    Text("TV Shows").tag(false)
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: viewModel.isMovies) {
//                    viewModel.fetchTitles() // Refetch data on toggle change
                }
                
                if viewModel.isLoading {
                    ShimmerView()
                } else {
                    TitleView(viewModel: viewModel)
                }
            }
            .navigationTitle("Movies & TvSeries")
            .refreshable(action: {
                viewModel.reloadView()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "An error occurred"), dismissButton: .default(Text("OK")))
            }
            .onReceive(viewModel.$error) { error in
                if error != nil {
                    showingAlert = true
                }
            }
        }
    }
}


struct ShimmerView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(0..<10, id: \.self) { _ in
                    VStack {
                        Text("Loading...")
                            .font(.headline)
                            .redacted(reason: .placeholder)
                        Text("0000")
                            .font(.subheadline)
                            .redacted(reason: .placeholder)
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2)
                    )
//                    .shimmerEffect()
                }
            }
            .padding()
        }
    }
}

struct TitleView :View {
    @ObservedObject var viewModel : ViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.isMovies ? viewModel.movies : viewModel.tvSeries, id: \.id) { title in
                    NavigationLink(destination: DetailsView(titleId: title.id)) {
                        VStack {
                            Text(title.title)
                                .font(.headline)
                            Text("\(title.year.description)")
                                .font(.subheadline)
                        }
                        .onAppear{
                            let lastItemId = viewModel.isMovies ? viewModel.movies.last?.id : viewModel.tvSeries.last?.id
                            if(title.id == lastItemId){
                                guard !viewModel.isLoading else { return }
                                if(viewModel.isMovies){
                                    viewModel.moviePage += 1
                                }else{
                                    viewModel.tvPage += 1
                                }
                                viewModel.fetchMoviesAndTvSeries()
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 100) // Ensures equal width & height
                        .padding()
                        .background(Color.white) // Add background for visibility
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                }
            }
            .padding()
        }
    }
}
