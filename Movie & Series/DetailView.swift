//
//  DetailView.swift
//  Movie & Series
//
//  Created by Prateek Kumar Rai on 19/02/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DetailsView: View {
    let titleId: Int
    @State var alert = false
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
                    
                    HStack{
                        Text(details.title)
                            .font(.title)
                            .bold()
                            .onLongPressGesture {
                                UIPasteboard.general.string = details.title
                                alert.toggle()
                            }
                            .onAppear{
                                
                            }
                        Spacer()
                        ShareLink(item: "\(details.title)\n\(details.plot_overview ?? "")") {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .padding()
                    if let releaseDate = details.release_date {
                        Text("Release Date: \(dateFormatter(isoDate: releaseDate))")
                        //dateformatter(isoDate: releaseDate)
                    }
                    
                    if let plot = details.plot_overview {
                        Text("Plot: \(plot)")
                            .onLongPressGesture {
                                UIPasteboard.general.string = details.plot_overview
                                alert.toggle()
                            }
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
        .alert(isPresented: $alert) {
            Alert(title: Text("Alert"), message: Text("Copied to clipbord"), dismissButton: .default(Text("OK")))
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                showingAlert = true
            }
        }
    }
//    private func dateformatter(isoDate:String) -> Date{
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from:isoDate)!
////        print(dateFormatter.string(from: date))
//        return date
//    }
    
    private func dateFormatter(isoDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use reliable locale
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: isoDate) else { return "Invalid Date" }

        dateFormatter.dateFormat = "d MMMM yyyy" // Desired format
        return dateFormatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


