//
//  CacheManager.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import AlamofireImage
import UIKit
class CacheManager {
    static let shared = CacheManager()
    let downloader = ImageDownloader.default
    let imageCache = AutoPurgingImageCache()
    private init() {

    }
    
    func saveFile(Data data:NSData, Filename fileName : String)
    {
        // Save data to file
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName)
        //print("Saving File in Path: \(fileURL.path) ")
        data.write(to: fileURL, atomically: true)
//        do {
//            // Write to the file
//            try
//        } catch let error as NSError {
//            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
//        }
        
    }
    
    func readFile(Filename fileName : String)->NSData? {
        var data : NSData = NSData()
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName)
        //print("Reading File in Path: \(fileURL.path) ")
        //data = NSData(contentsOf: fileURL)
        do {
           data = try NSData(contentsOf: fileURL)
        } catch let error as NSError{
            print("Failed reading: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }
        return data
    }

}


