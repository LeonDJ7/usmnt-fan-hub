//
//  Functions.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 7/7/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import Foundation
import UIKit

func getImageFromURL(url: URL) -> UIImage {
    
    var image = UIImage()
    
    let session = URLSession(configuration: .default)

    // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
    let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
        // The download has finished.
        if let e = error {
            print("Error downloading cat picture: \(e)")
        } else {
            // No errors found.
            // It would be weird if we didn't have a response, so check for that too.
            if let res = response as? HTTPURLResponse {
                print("Downloaded cat picture with response code \(res.statusCode)")
                if let imageData = data {
                    // Finally convert that Data into an image and do what you wish with it.
                    image = UIImage(data: imageData)!
                    // Do something with your image.
                } else {
                    print("Couldn't get image: Image is nil")
                }
            } else {
                print("Couldn't get response code for some reason")
            }
        }
    }
    
    return image
    
}


