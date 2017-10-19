//
//  Certifications.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Certifications API](https://developers.themoviedb.org/3/certifications) wrapper class.
    public class CertificationsAPIWrapper {
        /// Get an up to date list of the officially supported movie certifications on TMDb.
        ///
        /// - Parameter completion: Completion handler. If `.success`, carrys a value of `[String: [TMDBCertification]]`, of which key is country code, value is certifications for that country.
        public func getMovieCertifications(completion: @escaping (ObjectReturn<[String: [TMDBCertification]]>)-> ()) {
            TMDBManager.shared.performRequest(path: "/certification/movie/list") { (result: ObjectReturn<[String: [String: [TMDBCertification]]]>) in
                switch result {
                case .success(let _certifications):
                    if let certifications = _certifications["certifications"] {
                        completion(.success(object: certifications))
                    } else {
                        completion(.fail(error: "Error getting certifications.".error(domain: "certifications")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
        
        /// Get an up to date list of the officially supported TV show certifications on TMDb.
        ///
        /// - Parameter completion: Completion handler. If `.success`, carrys a value of `[String: [TMDBCertification]]`, of which key is country code, value is certifications for that country.
        public func getTVCertifications(completion: @escaping (ObjectReturn<[String: [TMDBCertification]]>)-> ()) {
            TMDBManager.shared.performRequest(path: "/certification/tv/list") { (result: ObjectReturn<[String: [String: [TMDBCertification]]]>) in
                switch result {
                case .success(let _certifications):
                    if let certifications = _certifications["certifications"] {
                        completion(.success(object: certifications))
                    } else {
                        completion(.fail(error: "Error getting certifications.".error(domain: "certifications")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
    }
}
