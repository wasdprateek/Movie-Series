//
//  Model.swift
//  Movie & Series
//
//  Created by Prateek Kumar Rai on 19/02/25.
//

// MARK: - Models
import SwiftUI

struct Title: Identifiable, Decodable {
    let id: Int
    let title: String
    let year: Int
    let imdb_id: String?
    let tmdb_id: Int?
}

struct TitleDetails: Identifiable, Decodable {
    let id: Int
    let title: String
    let plot_overview: String?
    let type: String
    let runtime_minutes: Int?
    let year: Int?
    let poster: String?
    let backdrop: String?
    let genres: [Int]?
    let genre_names: [String]?
    let release_date: String?
}

struct Region: Decodable, Hashable{
    let country : String
    let name : String
    let flag : String
}

enum MultiMediType : String, Hashable{
    case movies = "Movies"
    case tvSeries = "Tv Shows"
    case region = "Regions"
}
