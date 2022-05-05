//
//  ViewController.swift
//  PhotoRelay
//
//  Created by Mac on 2021/12/24.
//

import UIKit
import Firebase



class ViewController: UIViewController,RegistDelegate {
    
    
    @IBOutlet weak var emailLogin: UITextField!
    
    @IBOutlet weak var pwLogin: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        db.collection("data").document("one").setData(docData) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }document는 남겨두기
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            guard let userInfo = auth.currentUser else{return}
            
            if user != nil {
                
            }
            /*
            guard let user = authResult?.user else{
                self.resultText.text = "중복된 아이디가 있습니다."
                self.resultText.textColor = .blue
                self.resultText.textAlignment = .center
                return}
            */
            
        }
    }*/
    
    
    
    @IBAction func registBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "registSegue", sender: sender)
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        //authResult로 반환되 사용가능
        guard let email = emailLogin.text, let password = pwLogin.text
        else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){
            (user, error) in
            if error != nil{
                //로그인 실패시
                print("if")
                self.resultLabel.text = "아이디 및 패스워드를 확인해주세요"
                self.resultLabel.textColor = .red
                self.resultLabel.textAlignment = .center
            }else{
                //로그인 성공시
//                print("else")
//                print(user)
//                print(user.self)
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
            }
        }    
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "registSegue"{
            let registerController = segue.destination as! RegisterController
            registerController.delegate = self
        }
    }
    
    func successEdit(_ controller: RegisterController, id: String, pw: String, result : String) {
        emailLogin.text = id
        pwLogin.text = pw
        resultLabel.text = result
    }
    
}

