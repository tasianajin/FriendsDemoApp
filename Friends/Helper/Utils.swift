//
//  Utils.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//

import Foundation
import UIKit

class Utils : NSObject {
    static func sendRequest(_ url: String,  completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard let myUrl = URL(string: url) else {
            completion(nil, nil)
            return
        }
        var request = URLRequest(url:myUrl)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                error == nil else {                           // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    static func downloadImage(from url: String, completion: @escaping (Data?) -> Void) {
        guard let myUrl = URL(string: url) else {
            completion(nil)
            return
        }
        getData(from: myUrl) { data, response, error in
            completion(nil)
            guard let data = data, error == nil else {
                return
            }
            completion(data)
        }
    }
    static func showAlert(header: String, message:String) -> UIAlertController {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay" , style: .cancel){ (action) -> Void in
            
        }
        
        alert.addAction(okay)
        return alert
    }
    
}
