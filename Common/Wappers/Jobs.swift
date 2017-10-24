//
//  Jobs.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/22.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

extension TMDBManager {
    /// [Jobs API](https://developers.themoviedb.org/3/jobs) wrapper class.
    public class JobsAPIWrapper: APIWrapper {
        public func getJobs(completion: @escaping ObjectHandler<[TMDBJob]>) {
            performRequest(path: "/job/list") { (result: ObjectReturn<[String: [TMDBJob]]>) in
                switch result {
                case .success(let _jobs):
                    if let jobs = _jobs["jobs"] {
                        completion(.success(object: jobs))
                    } else {
                        let msg = "Data returned from TMDB dosen't contains \"Jobs\" array."
                        completion(.fail(error: msg.error(domain: "jobs")))
                    }
                case .fail(let error):
                    completion(.fail(error: error))
                }
            }
        }
    }
}
