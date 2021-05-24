//
//  APICaller.swift
//  NewsApp
//
//  Created by abdrahman on 23/05/2021.
//

import Foundation

class APICaller{
    static let instanse = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-05-23&sortBy=popularity&apiKey=a874e9bc143c471c80b056a3914aa6a1")
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping(Result<APIResponse, Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// MARK: - APIResponse

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    //let publishedAt: Date
    
}

struct Source: Codable {
    let name: String
}

//struct APIResponse: Codable {
//    let status: String
//    let totalResults: Int
//    let articles: [Article]
//}
//
//
//
//// MARK: - Article
//struct Article: Codable {
//    let source: Source
//    let author, title, articleDescription: String
//    let url: String
//    let urlToImage: String
//    let publishedAt: Date
//    let content: String
//
//    enum CodingKeys: String, CodingKey {
//        case source, author, title
//        case articleDescription = "description"
//        case url, urlToImage, content
//        case publishedAt
//    }
//}
//
//
//
//// MARK: - Source
//struct Source: Codable {
//    let name: String
//}
