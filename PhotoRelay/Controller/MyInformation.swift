//
//  MyInformation.swift
//  PhotoRelay
//
//  Created by Mac on 2021/12/28.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyInformation: UIViewController {
    
    @IBOutlet var loginInfo: UILabel!
    var handle : AuthStateDidChangeListenerHandle?//로그인 정보
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        handle = Auth.auth().addStateDidChangeListener({auth, user in
            if user != nil{
                self.loginInfo.text = user?.email
            }else{
                self.loginInfo.text = "잘못된 정보"
            }
        })
        
        
        
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        
        
        do{
            try Auth.auth().signOut()
//            navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            print("try")
        }catch let signOutError as NSError{
            print("Error signing out: %@",signOutError)
        }
        
        
        
    }
    
  
}
