//
//  Certifications.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/19.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

// MARK: - Certifications
extension TMDBManager {
    public func getMovieCertifications(completion: @escaping (ObjectReturn<[String: TMDBCertification?]>)-> ()) {
        performRequest(path: "/certification/movie/list") { (result: ObjectReturn<[String: TMDBCertification?]>) in
            switch result {
            case .success(let _certifications):
                print(_certifications)
//                if let certifications = _certifications["certifications"] {
//                    completion(.success(object: certifications))
//                } else {
//                    completion(.fail(error: "Error getting certifications.".error(domain: "certifications")))
//                }
            case .fail(let error):
                completion(.fail(error: error))
            }
        }
    }
}
