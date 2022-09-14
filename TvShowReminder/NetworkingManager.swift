//
//  NetworkingManager.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import Foundation
import UIKit


protocol NetworkManagerDelegate {
    func didLoadShows(shows: [ShowModel])
    func didFail(_ error: Error?)
}

class NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    
    public func loadImage(in imageView: UIImageView, withPath imagePath: String) {
        
        let urlStr = "https://image.tmdb.org/t/p/w500" + imagePath
        let url = URL(string: urlStr)!

        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    imageView.image = UIImage(data: data)
                }
            }
        }
        
        
    }
    
    public func loadShows() {
        let apiBaseURL = "https://api.themoviedb.org/3"
        let ratedShowsEndpoint = "/genre/tv/list"
        let queryParams = "?api_key=a6432dab41f5d6c4d36fa3b3e65febc3"
        let url = URL(string: apiBaseURL + ratedShowsEndpoint + queryParams)!
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(error)
                return
            }
            if let safeData = data {
                if let genresList = self.parseGenresJSON(safeData) {
                    
                    let ratedShowsEndpoint = "/tv/popular"
                    let queryParams = "?api_key=a6432dab41f5d6c4d36fa3b3e65febc3"
                    let url = URL(string: apiBaseURL + ratedShowsEndpoint + queryParams)!
                    let session = URLSession(configuration: .default)
                    
                    let task = session.dataTask(with: url) { (showsData, response, error) in
                        if error != nil {
                            self.delegate?.didFail(error)
                            return
                        }
                        if let safeShowsData = showsData {
                            if let latestShows = self.parsePopularJSON(safeShowsData) {
                                var shows = [ShowModel]()
                                for genreData in genresList.genres {
                                    for showData in latestShows.results {
                                        if genreData.id == showData.genre_ids.first! {
                                            shows.append(ShowModel(title: showData.name, description: showData.overview, posterPath: showData.poster_path, genre: genreData.name))
                                        }
                                    }
                                }
                                self.delegate?.didLoadShows(shows: shows)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        task.resume()
    }
    
    private func parsePopularJSON(_ data: Data) -> PopularShowsData? {
        var popularShowsData: PopularShowsData?
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PopularShowsData.self, from: data)
            
            popularShowsData = PopularShowsData(results: decodedData.results)
            return popularShowsData
        } catch {
            delegate?.didFail(error)
            return nil
        }
    }
    
    
    
    private func parseSessionJSON(_ data: Data) -> SessionData? {
        var sessionData: SessionData?

        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(SessionData.self, from: data)
            let success = decodedData.success
            let sesion_id = decodedData.guest_session_id
            
            sessionData = SessionData(success: success, guest_session_id: sesion_id)
        } catch {
            delegate?.didFail(error)
            return nil
        }
        
        return sessionData
    }
    
    public func parseGenresJSON(_ data: Data) -> GenreListData? {
        let genreData: GenreListData?
        
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(GenreListData.self, from: data)
            let genres = decodedData.genres
            
            genreData = GenreListData(genres: genres)
            return genreData
        } catch {
            delegate?.didFail(error)
            return nil
        }
    }
}


struct SessionData: Codable {
    let success: Bool
    let guest_session_id: String
}

public struct GenreData: Codable {
    let id: Int
    let name: String
}

struct PopularShowsData: Codable {
    let results: [ShowData]
}

public struct ShowData: Codable {
    let name: String
    let overview: String
    let genre_ids: [Int]
    let id: Int
    let poster_path: String
}

public struct GenreListData: Codable {
    let genres: [GenreData]
}
