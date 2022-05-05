//
//  ImageCell.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/19.
//

import UIKit
import FirebaseStorage
import BSImagePicker
import SwiftUI

struct ImageInfo{
    let name:String
//    let name:StorageMetadata?
    var image: UIImage? {
        
        
        return UIImage(named: "\(name).jpg")
//        return UIImage(named: name)
    }
    
    init (name: String) {
        self.name = name
    }
    
    
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func update(info:ImageInfo){
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        imgView.frame = contentView.bounds
        imgView.image = info.image
    }
    
    
    var imageInfoList: [ImageInfo] = [
        //test 이미지
        ImageInfo(name: "common"),
        ImageInfo(name: "common1"),
        ImageInfo(name: "common3"),
        ImageInfo(name: "common4"),
        ImageInfo(name: "common5"),
        ImageInfo(name: "common6"),
        ImageInfo(name: "common6"),
        ImageInfo(name: "common6"),
        ImageInfo(name: "common6"),
        ImageInfo(name: "common6"),
        ImageInfo(name: "common6"),
        
    ]
    
    var countOfImageList : Int{
        return imageInfoList.count
    }
    
    func imageInfo(at index : Int)->ImageInfo{
        return imageInfoList[index]
    }
    
}
