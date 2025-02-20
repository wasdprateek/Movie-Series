//
//  DetailView.swift
//  Movie & Series
//
//  Created by Prateek Kumar Rai on 19/02/25.
//

import SwiftUI

struct DetailsView: View {
    let titleId: Int
    @StateObject var viewModel = DetailsViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let details = viewModel.titleDetails {
                    if let poster = details.poster {
                        AsyncImage(url: URL(string: poster)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(15)
                                .padding(10)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(details.title)
                        .font(.title)
                        .bold()
                    
                    if let releaseDate = details.release_date {
                        Text("Release Date: \(releaseDate)")
                    }
                    
                    if let plot = details.plot_overview {
                        Text("Plot: \(plot)")
                    }
                    
                    if let genres = details.genre_names {
                        Text("Genres: \(genres.joined(separator: ", "))")
                    }
                    
//                        if let sources = details.sources {
//                            Text("Streaming On:")
//                            ForEach(sources) { source in
//                                Text("\(source.name) (\(source.type)) - \(source.region)")
//                            }
//                        }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchTitleDetails(for: titleId)
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


