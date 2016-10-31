//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubSecretID)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)")
        
        let session = URLSession.shared
        
        if let url = url {
            let task = session.dataTask(with: url) { (data, response, error) in
                let httpResponse = response as! HTTPURLResponse
                
                switch httpResponse.statusCode {
                case 204: completion(true)
                case 404: completion(false)
                default: break
                }
            }
            task.resume()
        }
        
    }
    
    class func starRepository(_ fullName: String, completion: @escaping () -> Void) {
        
        let url = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)")
        
        
        
        let session = URLSession.shared
        
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            let task = session.dataTask(with: request) { (data, response, error) in
                completion ()
            }
        
            task.resume()
        }
        
    }
    
    class func unstarRepository(_ fullName: String, comletion: @escaping () -> Void) {
        
        let url = URL(string: "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)")
        
        let session = URLSession.shared
        
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
    
            let task = session.dataTask(with: request) { (data, response, error) in
                comletion ()
            }
            task.resume()
        }
    }
}

