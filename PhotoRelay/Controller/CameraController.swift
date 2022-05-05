//
//  CameraController.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/10.
//

import UIKit
import MobileCoreServices
import Firebase
import UniformTypeIdentifiers
import BSImagePicker
import FirebaseStorage
import CoreLocation



class CameraController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    let db = Firestore.firestore()
    let imagePicker:UIImagePickerController! = UIImagePickerController()
    var captureImage : UIImage!
    var flagImage: Bool = false
    var handle : AuthStateDidChangeListenerHandle?//로그인 정보
    let singleton = Singleton.shared
    var apiModel = ApiModel()
    var latitude: Double?
    var logitude: Double?
    var email: String?
    var formatter = DateFormatter()
    var userEmail:String?
    var locationManager: CLLocationManager!
    
    @IBOutlet var resultRabel: UILabel!
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        
        handle = Auth.auth().addStateDidChangeListener({auth, user in
            if user != nil{
                self.userEmail = user?.email
                print("email : \(self.userEmail)")
            }else{
                print("잘못된 정보")
            }
        })
        
        

    }
    
    
    
    @IBAction func photoCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            flagImage = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            print("ibAction")
            present(imagePicker, animated: true,completion: nil)
        }else{
            myAlert("카메라 사용 불가", message: "카메라에 접근이 불가합니다.")
            

        }
        
       
    }
    

    @IBAction func photoSave(_ sender: UIButton) {
        var reference:URL?
        if imgView.image == nil{
            //            sender.setTitleColor(UIColor.clear, for: UIControl.State.disabled)
            print("photoSave if")
            myAlert("사진이 없습니다", message: "사진을 찍어주세요")
        }else{
            print("photoSave else")
           
            var name = randomString(of: 3)
            StorageManager.shared.uploadProfilePicture(with: (imgView.image?.jpegData(compressionQuality: 0.4))!, fileName: name){ [self]
                
                result in
                switch result {
                case .success(let downloadUrl):
                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                    print("downloadUrl : \(downloadUrl)")
                    self.resultRabel.text = "업로드가 성공되었습니다"
                    self.resultRabel.textColor = .blue
                    self.resultRabel.textAlignment = .center
                    self.formatter.dateFormat = "yyyy-MM-dd"
                    var current_date_string = self.formatter.string(from: Date())
                    print(current_date_string)
                    let storageRef = Storage.storage().reference()
                    var storagePath = storageRef.child("images/\(name)")
                    /*
                    self.singleton.myReply.append(ReplyData(userID: self.email!, image: storagePath, latitude: latitude!, longitude: logitude!, date: current_date_string))
                    apiModel.insertMarker(singleton.myReply)
                    */
                    print("storagePath : \(storagePath)")
                    print("storagePath type : \(type(of: storagePath))")
//                    let fullPath = String(storagePath)
//                    let fullPath = db.document(NSString(storagePath) as! String)
                    let fullPath = "gs://"+storagePath.bucket+"/"+storagePath.fullPath
                    print("fullPath : \(fullPath)")
                    print("fullpath type : \(type(of: fullPath))")
                    var replyData = ReplyData(userID: self.userEmail!, image: fullPath, latitude: latitude!, longitude: logitude!, date: current_date_string)

                    apiModel.insertMarker(&replyData)
                    
                    
                    
                    
                case .failure(let error):
                    print("Storage manager error: \(error)")
                    self.resultRabel.text = "업로드가 실패하였습니다."
                    self.resultRabel.textColor = .red
                    self.resultRabel.textAlignment = .center
                }
                
            }
        }
    }
    
    func myAlert(_ title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         
            if flagImage{
                self.imgView.image = captureImage
                print("captureImage name : \(captureImage)")
                
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
                print("들어왔음")
                flagImage = false
            }
        }
        self.dismiss(animated: true, completion: nil)//현재의 뷰 컨트롤러를 제거합니다. 즉, 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여 줍니다.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
        
    
    
    
    
}

extension CameraController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("camera Location: \(location)")
        print("camera locationManager touch")

        logitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        
        print("logitude : \(logitude) extension")


    }

}
