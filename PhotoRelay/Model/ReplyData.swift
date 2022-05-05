//
//  ReplyData.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/09.
//

import UIKit
import Photos
import Firebase
import SwiftyJSON
import FirebaseStorage


class ReplyData{
    
    var userID:String?
    var imgPath:[String] = []
    var localID:String?
    var latitude:Double?
    var longitude:Double?
    var address:String?
    var date:String?
    var makerId:Int?
    var image:String?
    
    init(userID:String, image:String, latitude: Double, longitude:Double, date:String){
        self.userID = userID
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        
    }
    
    
    
    /*
    init(){
        self.asset = nil
    }
    
    init(json:JSON){
        parseJson(json)
    }
    
    init(asset:PHAsset){
        self.asset = asset
        self.localID = self.asset!.localIdentifier
        if let loc = self.asset!.location{
            self.latitude = Double(loc.coordinate.latitude)
            self.longitude = Double(loc.coordinate.longitude)
        }
        if let date = self.asset!.creationDate{
            self.date = date
        }
    }
    
    init(localID:String){
        self.localID = localID
        let option = PHFetchOptions()
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [self.localID!], options: option)
        
        self.asset = result[0]
        
        if let loc = self.asset!.location {
            self.latitude = Double(loc.coordinate.latitude)
            self.longitude = Double(loc.coordinate.longitude)
        }
        if let userid = UserDefaults.standard.string(forKey: "userEmail") {
            self.userID = userid
        }
    }
    
    func parseJson(_ json: JSON) {
        self.userID = json["userId"].stringValue
        
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        
        self.address = json["loadAddress"].stringValue
        let tempPaths = json["totalImageUrl"].stringValue
        self.imgPath = tempPaths.components(separatedBy: ";;")
        self.imgPath.removeLast()
    }
    
    func toData() -> Data?{
        if let asset = self.asset{
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, into) -> Void in image = result!
                
            })
            return image.jpegData(compressionQuality: 0.8)
        }
        
        return nil
    }*/
    
}
