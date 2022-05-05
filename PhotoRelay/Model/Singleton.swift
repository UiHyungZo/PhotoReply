//
//  Singleton.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/10.
//

import Foundation

class Singleton{
    static let shared = Singleton()
    var myReply:[ReplyData] = []
    var imgPics:[ImageCell] = []
    private init(){
        
    }
    
}
