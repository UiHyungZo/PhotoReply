//
//  AlbumController.swift
//  PhotoRelay
//
//  Created by Mac on 2021/12/28.
//

import UIKit
import Firebase
import FirebaseStorage

class AlbumController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    
    let db = Firestore.firestore()
    var handle : AuthStateDidChangeListenerHandle?//로그인 정보
    var userEmail:String?
    var flag:Bool = false
    var imageModel = ImageCell()
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let storageRef = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        handle = Auth.auth().addStateDidChangeListener({auth, user in
            if user != nil{
                self.userEmail = user?.email
                print("email : \(self.userEmail)")
                
                self.db.collection(self.userEmail!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        
                    } else {
                        
                        for document in querySnapshot!.documents {
                            //                            print("\(document.documentID) => \(document.data())")
                            //                            print(document.get("userId"))
                            //                            print("userId 값")
                            print("document Albume값")
//                            self.imageModel.imageInfoList.append(ImageInfo(name: document.get("img") as! String))
                            // Create reference to the file whose metadata we want to retrieve
                            print("documete type 값 : \(type(of: document.get("img")))")
                            print("document get 값 : \(document.get("img"))")
                            
                            var str = document.get("img") as! String
                            print("str type : \(type(of: str))")
                            print("str 값 : \(str)")
                            
                            let isImage = self.storageRef.child(str)
                            
                            isImage.getData(maxSize: 1 * 1024 * 1024) { data, error in
                              if let error = error {
                                // Uh-oh, an error occurred!
                                print("error 발생")
                              } else {
                                // Data for "images/island.jpg" is returned
                                print("else 부분")
                                  print("type : \(type(of: data))")
//                                  imageModel.imageInfoList.append(data)
                              }
                            }
                            
                            
                            // Get metadata properties
//                            self.storageRef.reference(forURL: str).downloadURL(completion: {(url, error) in
//
//                                if let error = error{
//
//                                    return
//                                }
//
//                                let data = NSData(contentsOf: url!)
//                                let image = UIImage(data: data as! Data)
//                                self.imageModel.imageInfoList.append(ImageInfo(name: data!.description))
//
//                            })
                                
                            
                        }
                        
                       
                        
                        
                    }
                }
                
            }else{
                print("잘못된 정보")
            }
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModel.countOfImageList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCell else{
            return UICollectionViewCell()
        }
        
        let imageInfo = imageModel.imageInfo(at: indexPath.item)
        cell.update(info: imageInfo)
        
        if(flag == true){
            collectionView.reloadData()
            flag = false
        }
        
        
        
        
        print("추가")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("들어옴")
        let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default, handler: {
            _ in self.imageModel.imageInfoList.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        })
        
        let noAction = UIAlertAction(title: "아니요", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
//        print("section : \(collectionView.numberOfSections) and item : \(self.viewModel.countOfImageList)")
        present(alert, animated: true, completion: nil)
        
//        viewModel.imageInfoList.remove(at: indexPath.item)//list에서 삭제
//        collectionView.deleteItems(at: [indexPath])//view 삭제
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
        /*let itemSpacing: CGFloat = 10
            let textAreaHeight: CGFloat = 65
            
            let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2
            let height: CGFloat = width * 10/7 + textAreaHeight
            return CGSize(width: width, height: height)*/
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("indexPath selectshould : \(indexPath.row)")
        
        return true
    }

   

}
