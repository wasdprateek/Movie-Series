//
//  ViewModel.swift
//  Movie & Series
//
//  Created by Prateek Kumar Rai on 19/02/25.
//

import Combine
import SwiftUI



class ViewModel: ObservableObject {
    @Published var movies: [Title] = []
    @Published var tvSeries: [Title] = []
    @Published var regions : [Region] = []
    @Published var isLoading = true
    @Published var error: Error?
    @Published var multiMediaType: MultiMediType = .movies
    @Published var moviePage = 1;
    @Published var tvPage = 1;
    
    private var cancellables = Set<AnyCancellable>()
    
    let apiKey = "NsToz2yWCc1S3HfdEkftPbtkgwd1EbPQOYCfLPTS" // Store securely

    init(){
        fetchMoviesAndTvSeries()
    }
    
    func reloadView(){
        if (multiMediaType == .movies){
            moviePage = 1
        }else if (multiMediaType == .tvSeries){
            tvPage = 1
        }
        movies = []
        tvSeries = []
        fetchMoviesAndTvSeries()
    }
    
    
    func fetchMoviesAndTvSeries() {
//        isLoading = true
        
        let moviePublisher = fetchTitles(type: "movie")
        let tvSeriesPublisher = fetchTitles(type: "tv_series")
        let regionPublisher = fetchRegions(type: "regions")
        
        moviePublisher
            .zip(tvSeriesPublisher,regionPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                    print("Fetch error:", error.localizedDescription)
                }
            }, receiveValue: { [weak self] (movies, tvSeries, region) in
                self?.movies.append(contentsOf: movies)
                self?.tvSeries.append(contentsOf: tvSeries)
                self?.regions.append(contentsOf: region)
            })
            .store(in: &cancellables)
    }

    private func fetchTitles(type: String) -> AnyPublisher<[Title], Error> {
        let urlString = "https://api.watchmode.com/v1/list-titles/?apiKey=\(apiKey)&types=\(type)&limit=20&page=\(multiMediaType == .movies ? moviePage : tvPage)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    private func fetchRegions(type: String) -> AnyPublisher<[Region], Error> {
        let urlString = "https://api.watchmode.com/v1/regions/?apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: [Region].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


class DetailsViewModel: ObservableObject {
    @Published var titleDetails: TitleDetails?
    @Published var isLoading = true
    @Published var error: Error?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTitleDetails(for titleId: Int) {
        isLoading = true
        let urlString = "https://api.watchmode.com/v1/title/\(titleId)/details/?apiKey=NsToz2yWCc1S3HfdEkftPbtkgwd1EbPQOYCfLPTS&append_to_response=sources"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.invalidResponse
                }
                print(data)
                return data
            }
            .decode(type: TitleDetails.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished: break
                }
            }, receiveValue: { [weak self] details in
                self?.titleDetails = details
            })
            .store(in: &cancellables)
    }
    
    
    }
    
struct SearchResponse: Decodable {
        let results: [Title]
        private enum CodingKeys: String, CodingKey{
            case results = "titles"
        }
}
enum APIError: Error {
    case invalidResponse
}
    
    
   
    
    
