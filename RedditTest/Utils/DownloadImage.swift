//
//  DownloadImage.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 12/05/21.
//

import Foundation

class DownloadImage{
    
    func download(url:URL, toFile file:URL, completion: @escaping (Error?) -> Void){
        let task = URLSession.shared.downloadTask(with: url){ (tempURL, response, error) in
            guard let tempURL = tempURL else {
                completion(error)
                return
            }
            
            do{
                if FileManager.default.fileExists(atPath: file.path){
                    try FileManager.default.removeItem(at: file)
                }
                
                try FileManager.default.copyItem(at: tempURL, to: file)
                
                completion(nil)
            }catch _{
                completion(error)
            }
        }
        task.resume()
    }
    
    func loadData(url:URL, completion: @escaping (Data?, Error?) -> Void){
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(url.lastPathComponent, isDirectory: false)
        
        if let data = try? Data(contentsOf: fileCachePath){
            completion(data, nil)
            return
        }
        
        download(url: url, toFile: fileCachePath) { (error) in
            let data = try? Data(contentsOf: fileCachePath)
            completion(data,error)
        }
    }
}
