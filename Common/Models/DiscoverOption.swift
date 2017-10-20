//
//  DiscoverOption.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/20.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBMovieDiscoverOption {
    public let key: String
    public let value: String
    
    /// Specify a language to query translatable fields with.
    /// - minLength: 2
    /// - pattern: `([a-z]{2})-([A-Z]{2})`
    /// - default: en-US
    public init(language: String) {
        self.key = "language"
        self.value = language
    }
    
    /// Specify a ISO 3166-1 code to filter release dates. Must be uppercase.
    /// - Pattern: `^[A-Z]{2}$`
    public init(region: String) {
        self.key = "region"
        self.value = region
    }
    
    /// Choose from one of the many available sort options.
    /// - default: `.popularityDesc`
    public init(sortBy: TMDBMovieDiscoverySortBy) {
        self.key = "sort_by"
        self.value = sortBy.rawValue
    }
    
    /// Used in conjunction with the certification filter, use this to specify a country with a valid certification.
    public init(certificationCountry: String) {
        self.key = "certification_country"
        self.value = certificationCountry
    }
    
    /// Filter results with a valid certification from the 'certification_country' field.
    public init(certification: String) {
        self.key = "certification"
        self.value = certification
    }
    
    /// Filter and only include movies that have a certification that is less than or equal to the specified value.
    public init(certificationLte: String) {
        self.key = "certification.lte"
        self.value = certificationLte
    }
    
    /// A filter and include or exclude adult movies.
    public init(includeAdult: Bool) {
        self.key = "include_adult"
        self.value = includeAdult ? "true" : "false"
    }
    
    /// A filter to include or exclude videos.
    public init(includeVideo: Bool) {
        self.key = "include_video"
        self.value = includeVideo ? "true" : "false"
    }
    
    /// Specify the page of results to query.
    /// - minimum: 1
    /// - maximum: 1000
    /// - default: 1
    public init(page: Int) {
        self.key = "page"
        self.value = "\(page)"
    }
    
    /// A filter to limit the results to a specific primary release year.
    public init(primaryReleaseYear: Int) {
        self.key = "primary_release_year"
        self.value = "\(primaryReleaseYear)"
    }
    
    /// Filter and only include movies that have a primary release date that is greater or equal to the specified value.
    ///
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(primaryReleaseDateGte: String) {
        self.key = "primary_release_date.gte"
        self.value = primaryReleaseDateGte
    }
    
    /// Filter and only include movies that have a primary release date that is less than or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(primaryReleaseDateLte: String) {
        self.key = "primary_release_date.lte"
        self.value = primaryReleaseDateLte
    }
    
    /// Filter and only include movies that have a release date (looking at all release dates) that is greater or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(releaseDateGte: String) {
        self.key = "release_date.gte"
        self.value = releaseDateGte
    }
    
    /// Filter and only include movies that have a release date (looking at all release dates) that is less than or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(releaseDateLte: String) {
        self.key = "release_date.Lte"
        self.value = releaseDateLte
    }
    
    /// Filter and only include movies that have a vote count that is greater or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - minimum: 0
    public init(voteCountGte: Int) {
        self.key = "vote_count.gte"
        self.value = "\(voteCountGte)"
    }
    
    /// Filter and only include movies that have a vote count that is less than or equal to the specified value.
    /// - minimum: 1
    public init(voteCountLte: Int) {
        self.key = "vote_count.lte"
        self.value = "\(voteCountLte)"
    }
    
    /// Filter and only include movies that have a rating that is greater or equal to the specified value.
    /// - minimum: 0
    public init(voteAverageGte: Int) {
        self.key = "vote_average.gte"
        self.value = "\(voteAverageGte)"
    }
    
    /// Filter and only include movies that have a rating that is less than or equal to the specified value.
    /// - minimum: 0
    public init(voteAverageLte: Int) {
        self.key = "vote_average.lte"
        self.value = "\(voteAverageLte)"
    }
    
    /// A comma separated list of person ID's. Only include movies that have one of the ID's added as an actor.
    public init(withCast: String) {
        self.key = "with_cast"
        self.value = withCast
    }
    
    /// A comma separated list of person ID's. Only include movies that have one of the ID's added as a crew member.
    public init(withCrew: String) {
        self.key = "with_crew"
        self.value = withCrew
    }
    
    /// A comma separated list of production company ID's. Only include movies that have one of the ID's added as a production company.
    public init(withCompanies: String) {
        self.key = "with_companies"
        self.value = withCompanies
    }
    
    /// Comma separated value of genre ids that you want to include in the results.
    public init(withGenres: String) {
        self.key = "with_genres"
        self.value = withGenres
    }
    
    /// A comma separated list of keyword ID's. Only include movies that have one of the ID's added as a keyword.
    public init(withKeywords: String) {
        self.key = "with_keywords"
        self.value = withKeywords
    }
    
    /// A comma separated list of person ID's. Only include movies that have one of the ID's added as a either a actor or a crew member.
    public init(withPeople: String) {
        self.key = "with_people"
        self.value = withPeople
    }
    
    /// A filter to limit the results to a specific year (looking at all release dates).
    public init(year: Int) {
        self.key = "yaer"
        self.value = "\(year)"
    }
    
    /// Comma separated value of genre ids that you want to exclude from the results.
    public init(withoutGenres: String) {
        self.key = "without_genres"
        self.value = withoutGenres
    }
    
    /// Filter and only include movies that have a runtime that is greater or equal to a value.
    public init(withRuntimeGte: Int) {
        self.key = "with_runtime.gte"
        self.value = "\(withRuntimeGte)"
    }
    
    /// Filter and only include movies that have a runtime that is less than or equal to a value.
    public init(withRuntimeLte: Int) {
        self.key = "with_runtime.lte"
        self.value = "\(withRuntimeLte)"
    }
    
    /// Specify a comma (AND) or pipe (OR) separated value to filter release types by. These release types map to the same values found on the movie release date method.
    /// - minimum: 1
    /// - maximum: 6
    public init(withReleaseType: Int) {
        self.key = "with_release_type"
        self.value = "\(withReleaseType)"
    }
    
    /// Specify an ISO 639-1 string to filter results by their original language value.
    public init(withOriginalLanguage: String) {
        self.key = "with_original_language"
        self.value = withOriginalLanguage
    }
    
    /// Exclude items with certain keywords. You can comma and pipe seperate these values to create an 'AND' or 'OR' logic.
    public init(withoutKeywords: String) {
        self.key = "without_keywords"
        self.value = withoutKeywords
    }
    
    public enum TMDBMovieDiscoverySortBy: String {
        case popularityAsc = "popularity.asc"
        case popularityDesc = "popularity.desc"
        case releaseDateAsc = "release_date.asc"
        case releaseDateAesc = "release_date.desc"
        case revenueAsc = "revenue.asc"
        case revenueDesc = "revenue.desc"
        case primaryReleaseDateAsc="primary_release_date.asc"
        case primaryReleaseDateDesc="primary_release_date.desc"
        case originalTitleAsc="original_title.asc"
        case originalTitleDesc="original_title.desc"
        case voteAverageAsc="vote_average.asc"
        case voteAverageDesc="vote_average.desc"
        case voteCountAsc="vote_count.asc"
        case voteCountDesc = "vote_count.desc"
    }
}

// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------

public struct TMDBTVDiscoverOption {
    public let key: String
    public let value: String
    
    /// Specify a language to query translatable fields with.
    /// - minLength: 2
    /// - pattern: `([a-z]{2})-([A-Z]{2})`
    /// - default: en-US
    public init(language: String) {
        self.key = "language"
        self.value = language
    }
    
    /// Choose from one of the many available sort options.
    /// - default: `.popularityDesc`
    public init(sortBy: TMDBTVDiscoverySortBy) {
        self.key = "sort_by"
        self.value = sortBy.rawValue
    }
    
    /// Filter and only include TV shows that have a air date (by looking at all episodes) that is greater or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(airDateGte: String) {
        self.key = "air_date.gte"
        self.value = airDateGte
    }
    
    /// Filter and only include TV shows that have a air date (by looking at all episodes) that is less than or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(airDateLte: String) {
        self.key = "air_date.lte"
        self.value = airDateLte
    }
    
    /// Filter and only include TV shows that have a original air date that is greater or equal to the specified value. Can be used in conjunction with the "include_null_first_air_dates" filter if you want to include items with no air date.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(firstAirDateGte: String) {
        self.key = "first_air_date.gte"
        self.value = firstAirDateGte
    }
    
    /// Filter and only include TV shows that have a original air date that is less than or equal to the specified value. Can be used in conjunction with the "include_null_first_air_dates" filter if you want to include items with no air date.
    /// - TODO: Use Date instead of String.
    /// - Format: Date ("YYYY-MM-dd")
    public init(firstAirDateLte: String) {
        self.key = "first_air_date.lte"
        self.value = firstAirDateLte
    }
    
    /// Filter and only include TV shows that have a original air date year that equal to the specified value. Can be used in conjunction with the "include_null_first_air_dates" filter if you want to include items with no air date.
    init(firstAirDateYear: Int) {
        self.key = "first_air_date_year"
        self.value = "\(firstAirDateYear)"
    }
    
    /// Specify the page of results to query.
    /// - minimum: 1
    /// - maximum: 1000
    /// - default: 1
    public init(page: Int) {
        self.key = "page"
        self.value = "\(page)"
    }
    
    /// Used in conjunction with the air_date.gte/lte filter to calculate the proper UTC offset.
    /// - default: America/New_York
    public init(timezone: String) {
        self.key = "timezone"
        self.value = timezone
    }
    
    /// Filter and only include movies that have a rating that is greater or equal to the specified value.
    /// - minimum: 0
    public init(voteAverageGte: Int) {
        self.key = "vote_average.gte"
        self.value = "\(voteAverageGte)"
    }
    
    /// Filter and only include movies that have a vote count that is greater or equal to the specified value.
    /// - TODO: Use Date instead of String.
    /// - minimum: 0
    public init(voteCountGte: Int) {
        self.key = "vote_count.gte"
        self.value = "\(voteCountGte)"
    }
    
    /// Comma separated value of genre ids that you want to include in the results.
    public init(withGenres: String) {
        self.key = "with_genres"
        self.value = withGenres
    }
    
    /// Comma separated value of network ids that you want to include in the results.
    init(withNetworks: String) {
        self.key = "with_networks"
        self.value = withNetworks
    }
    
    /// Comma separated value of genre ids that you want to include in the results.
    public init(withoutGenres: String) {
        self.key = "without_genres"
        self.value = withoutGenres
    }
    
    /// Filter and only include movies that have a runtime that is greater or equal to a value.
    public init(withRuntimeGte: Int) {
        self.key = "with_runtime.gte"
        self.value = "\(withRuntimeGte)"
    }
    
    /// Filter and only include movies that have a runtime that is less than or equal to a value.
    public init(withRuntimeLte: Int) {
        self.key = "with_runtime.lte"
        self.value = "\(withRuntimeLte)"
    }
    
    public init(includeNullFirstAirDates: Bool) {
        self.key = "include_null_first_air_dates"
        self.value = includeNullFirstAirDates ? "true" : "false"
    }
    
    /// Specify an ISO 639-1 string to filter results by their original language value.
    public init(withOriginalLanguage: String) {
        self.key = "with_original_language"
        self.value = withOriginalLanguage
    }
    
    /// Exclude items with certain keywords. You can comma and pipe seperate these values to create an 'AND' or 'OR' logic.
    public init(withoutKeywords: String) {
        self.key = "without_keywords"
        self.value = withoutKeywords
    }
    
    /// Filter results to include items that have been screened theatrically.
    public init(screenedTheatrically: Bool) {
        self.key = "screened_theatrically"
        self.value = screenedTheatrically ? "true" : "false"
    }
    
    public enum TMDBTVDiscoverySortBy: String {
        case voteAverageAsc   = "vote_average.asc"
        case voteAverageDesc  = "vote_average.desc"
        case firstAirDateDesc = "first_air_date.desc"
        case firstAirDateAsc  = "first_air_date.asc"
        case popularityDesc   = "popularity.desc"
        case popularityAsc    = "popularity.asc"
    }
}
