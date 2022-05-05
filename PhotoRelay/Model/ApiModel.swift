//
//  ApiModel.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/10.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import Alamofire
import FirebaseFirestore

struct ApiModel{
    let db = Firestore.firestore()
    
    
    
    func insertMarker(_ reply : inout ReplyData){
        let sema = DispatchSemaphore(value:0)//공유자원 접근 제한
//        let markerId:Int = 0
//        let parameter: Parameters = [
//            "userId": reply.userID,
//            "longitude": reply.longitude,
//            "latitude":reply.latitude,
//            "address":reply.address
//
//        ]
        
        db.collection(reply.userID!).document().setData([ "userId": reply.userID,
                                                       "longitude": reply.longitude,
                                                       "latitude":reply.latitude,
                                                          
                                                "Date":reply.date,
                                                          "img":reply.image], merge: true)
        
        db.collection(reply.userID!).document()
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
            }
        
    }
    
//    func deleteMarker(_ userEmail : String){
//        db.collection("AlbumTable").document(reply.userID!).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//
//    }
    
    
    mutating func selectMarker(userEmail : String) {
        db.collection(userEmail).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print(document.get("userId"))
                    print("userId 값")
                    
                }
                
                
            }
        }
        
    }
    
    
   
    
    
    
    
    
    
}
