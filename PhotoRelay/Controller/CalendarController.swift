//
//  CalendarController.swift
//  PhotoRelay
//
//  Created by Mac on 2021/12/28.
//

import UIKit
import FSCalendar
import Firebase



class CalendarController: UIViewController {

    var events:[Date] = []
    var handle : AuthStateDidChangeListenerHandle?//로그인 정보
    var userEmail:String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        handle = Auth.auth().addStateDidChangeListener({auth, user in
            print("handle closure")
            if user != nil{
                self.userEmail = user?.email
                print("email : \(self.userEmail)")
//                self.apiModel.selectMarker(userEmail: self.userEmail!)
                print("apiModel user != 문")
                //select
                self.db.collection(self.userEmail!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        
                    } else {
                        
                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
//                            print(document.get("userId"))
//                            print("userId 값")
//                            let loc2 = CLLocationCoordinate2D(latitude: document.get("latitude") as! CLLocationDegrees , longitude: document.get("longitude") as! CLLocationDegrees)
//                            self.marker.append(GMSMarker.init(position: loc2))
                            print("document id : \(document.get("Date"))")
                            let event = document.get("Date")
                            print("event type : \(type(of: event))")
                            var str : String = event as! String
                            print("str : \(str) and str type : \(type(of: str))")
                            let local = formatter.date(from: str)
                            self.events.append(local!)
                        }
                        
//                        for i in self.marker{
//                            i.map = self.mapView
//                        }
                        
                        
                    }
                }
            }else{
                print("잘못된 정보")
            }
        })
                
//        let xmas = formatter.date(from: "2021-12-25")
//        let sampledate = formatter.date(from: "2022-01-22")
//        events = [xmas!, sampledate!]
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
                

        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
        
    }

   
}
extension CalendarController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
}
