//
//  RegisterController.swift
//  PhotoRelay
//
//  Created by Mac on 2021/12/24.
//

import UIKit

import FirebaseAuth

protocol RegistDelegate{
    func successEdit(_ controller : RegisterController, id : String, pw : String, result : String)
}


class RegisterController: UIViewController {
   
    @IBOutlet weak var registEmail: UITextField!
    
    @IBOutlet weak var registPw: UITextField!
       
    @IBOutlet weak var resultText: UILabel!
    
    var delegate : RegistDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    @IBAction func registUser(_ sender: Any) {
        
        guard let email = registEmail.text, let password = registPw.text else{return}

        Auth.auth().createUser(withEmail: email, password: password){
            (authResult, error) in
            
            guard let user = authResult?.user else{
                self.resultText.text = "중복된 아이디가 있습니다."
                self.resultText.textColor = .blue
                self.resultText.textAlignment = .center
                return}
            //중복 아이디를 체크 해야한다.
            print("auth 두번째")
            if error == nil{
                //회원가입 성공
                print("가입성공")
                if self.delegate != nil {
                    print("delegate")
                    self.delegate?.successEdit(self, id: self.registEmail.text!, pw: self.registPw.text!, result: "가입성공")
                }
                
//                _ = self.popoverPresentationController
                self.resultText.text = "가입성공 로그인창으로 돌아가 주세요"
                self.resultText.textColor = .brown
                self.resultText.textAlignment = .center
                self.registEmail.text = ""
                self.registPw.text = ""
                print("pop")
                self.dismiss(animated: true, completion: nil)
            }else{
                //회원가입 실패
                print("가입실패")
            }
        }
        
        
     
        
    }
    
     
    
    

}
