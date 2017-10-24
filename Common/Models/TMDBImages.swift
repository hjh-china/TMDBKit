//
//  Images.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/23.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBImage: Codable {
    public let aspectRatio: Double
    public let filePath: String
    public let height: Int
    public let language: String?
    public let voteAverage: Double
    public let voteCount: Int
    public let width: Int
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case language = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

public struct TMDBMovieImages: Codable {
    public let id: Int
    public let backdrops: [TMDBImage]
    public let posters: [TMDBImage]
}

public struct TMDBImages: Codable {
    public let id: Int
    public let backdrops: [TMDBImage]
    public let posters: [TMDBImage]
}

public struct TMDBTaggedImages: TMDBJsonInitable {
    public let id: Int
    public let page: Int
    public let results: [TMDBTaggedImage]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(fromJSON json: JSON) throws {
        guard
            let id = json["id"].int,
            let page = json["page"].int,
            let totalPages = json["total_pages"].int,
            let totalResults = json["total_results"].int
            else {
                throw "Error initing TMDBTaggedImages.".error(domain: "maodels")
        }
        
        self.id = id
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        
        let resultsJSONValue = json["results"].arrayValue
        var results: [TMDBTaggedImage] = []
        for result in resultsJSONValue {
            results.append(try TMDBTaggedImage(fromJSON: result))
        }
        
        self.results = results
    }
    
    public struct TMDBTaggedImage {
        public let aspectRatio: Double
        public let filePath: String
        public let height: Int
        public let id: String
        public let language: String?
        public let voteAverage: Double
        public let voteCount: Int
        public let width: Int
        public let imageType: String
        public let movie: TMDBMovieGeneral?
        public let show: TMDBTVShowGeneral?
        
        init(fromJSON json: JSON) throws {
            let data = try json.rawData()
            let image = try JSONDecoder().decode(TMDBImage.self, from: data)
            
            self.aspectRatio = image.aspectRatio
            self.filePath = image.filePath
            self.height = image.height
            self.language = image.language
            self.voteAverage = image.voteAverage
            self.voteCount = image.voteCount
            self.width = image.width
            
            guard
                let id = json["id"].string,
                let imageType = json["image_type"].string,
                let mediaType = json["media"]["media_type"].string
                else {
                    throw "Error initing TMDBTaggedImage.".error(domain: "maodels")
            }
            self.id = id
            self.imageType = imageType
            
            let mediaData = try json["media"].rawData()
            if mediaType == "movie" {
                self.movie = try JSONDecoder().decode(TMDBMovieGeneral.self, from: mediaData)
                self.show = nil
            } else {
                self.movie = nil
                self.show = try JSONDecoder().decode(TMDBTVShowGeneral.self, from: mediaData)
            }
        }
    }
}
