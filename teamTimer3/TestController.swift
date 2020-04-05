//
//  ViewController.swift
//  teamTimer3
//
//  Created by Игорь Корабельников on 19/04/2019.
//  Copyright © 2019 Игорь Корабельников. All rights reserved.
//

import UIKit
import SafariServices
import UICircularProgressRing
import UserNotifications
import AVFoundation
import MessageUI

class ViewController2 : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    let typesOfTeas = ["Не выбрано","Травяной", "Молочный улун","Йау хаун"]
    let greenTeaSorts = ["Классический","Молочный улун","Лу Дзинь","Японская липа","Сенча","Фруктовый","Травяной"]
    let blackTeaSorts = ["Классический","Эрл грей","Ассам","Фруктовый"]
    var maxValueGreenTea : TimeInterval = 5
    var playerSound = AVAudioPlayer()
    var maxValueBlackTea: TimeInterval = 360
    var teaSort = String()
    @IBOutlet weak var timerCircle: UICircularProgressRing!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var timerActivateButton: UIButton!
    @IBOutlet weak var typeOfTeaTextField: UITextField!
    @IBOutlet weak var greenTeaSegmentButton: UIButton!
    @IBOutlet weak var blackTeaSegmentButton: UIButton!
    @IBOutlet weak var sortOfTeaPickerButton: UIButton!
    @IBOutlet weak var teaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var typeOfTeaPicker: UIPickerView!
    @IBOutlet weak var typeOfBlackTeaPicker: UIPickerView!
    @IBOutlet weak var subViewWithPickers: UIView!
    @IBOutlet weak var stopButton: UIButton!
    var timerForGreen = Timer()
    var timerForBlack = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        shapesOfElements()
        teaSort = "Green"
        switch teaSort {
        case "Black":
            sortOfTeaPickerButton.titleLabel?.text = "Классический"
            leftTimeLabel.text = "\(Int(maxValueBlackTea) / 60) минут(ы)"
            
        case "Green":
            sortOfTeaPickerButton.titleLabel?.text = "Зеленый чай"
            leftTimeLabel.text = "\(Int(maxValueGreenTea) / 60) минут(ы)"
        default:
            break
        }
        do {
            if let AudioPath = Bundle.main.path(forResource: "TimerForAppSound2", ofType: "wav") {
                try self.playerSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: AudioPath))
            }
        } catch {
            print("error")
        }
  }
@IBAction func sortOfTeaPickerButtonAction(_ sender: Any) {
    switch teaSort {
    case "Green":
        subViewWithPickers.isHidden = false
        typeOfTeaPicker.isHidden = false
        typeOfBlackTeaPicker.isHidden = true
    case "Black":
        subViewWithPickers.isHidden = false
        typeOfBlackTeaPicker.isHidden = false
        typeOfTeaPicker.isHidden = true
    default:
        break
    }
}
    
    
    
    func shapesOfElements() {
        timerActivateButton.layer.cornerRadius = timerActivateButton.frame.size.height / 2
        greenTeaSegmentButton.layer.cornerRadius = greenTeaSegmentButton.frame.size.height / 2
        blackTeaSegmentButton.layer.cornerRadius = blackTeaSegmentButton.frame.size.height / 2
        sortOfTeaPickerButton.layer.cornerRadius = sortOfTeaPickerButton.frame.size.height / 2
        sortOfTeaPickerButton.titleLabel?.textAlignment = .center
        timerActivateButton.titleLabel?.textAlignment = .center
    }
    @IBAction func stopTimerAction(_ sender: Any) {
      timerActivateButton.isEnabled = true
      sortOfTeaPickerButton.isEnabled = true
    stopButton.isSelected = true
      timerCircle.resetProgress()
    }
    
    @IBAction func timerActivateButtonAction(_ sender: Any) {
        timerActivateButton.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.8274509804, blue: 0.7294117647, alpha: 1)
        timerCircle.value = 0
        timerCircle.maxValue = CGFloat(maxValueBlackTea)
            switch teaSort {
            case "Black":
              timerForBlack = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(activateBlackTeaTimer), userInfo: nil, repeats: true)
                timerForGreen.invalidate()
            case "Green":
                timerForGreen = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(activateGreenTeaTimer), userInfo: nil, repeats: true)
                timerForBlack.invalidate()
            default:
                break
            }
    }
    
    //MARK: ButtonAction
    @IBAction func greenTeaActivateButtonAction(_ sender: Any) {
        greenTeaSegmentButton.isSelected = true
        blackTeaSegmentButton.isSelected = false
        if greenTeaSegmentButton.isSelected {
          teaSort = "Green"
         greenTeaButtonColor()
        }
        print(teaSort)
    }
    func switchUrl(link : String) {
        let url = URL(string: link)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func blackTeaActivateButtonAction(_ sender: Any) {
        blackTeaSegmentButton.isSelected = true
        greenTeaSegmentButton.isSelected = false
        if blackTeaSegmentButton.isSelected {
            teaSort = "Black"
            blackTeaButtonColor()
        }
        print(teaSort)
    }
    func greenTeaButtonColor() {
    greenTeaSegmentButton.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
    greenTeaSegmentButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    blackTeaSegmentButton.backgroundColor = #colorLiteral(red: 0.7739834189, green: 0.7929247022, blue: 0.8539995551, alpha: 1)
    blackTeaSegmentButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    }
    func blackTeaButtonColor() {
    blackTeaSegmentButton.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
    blackTeaSegmentButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    greenTeaSegmentButton.backgroundColor = #colorLiteral(red: 0.7739834189, green: 0.7929247022, blue: 0.8539995551, alpha: 1)
    greenTeaSegmentButton.titleLabel?.textColor = #colorLiteral(red: 0.9529623389, green: 0.9598125815, blue: 0.9751449227, alpha: 1)
    }
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typeOfTeaPicker {
            return greenTeaSorts.count
        } else if pickerView == typeOfBlackTeaPicker {
            return blackTeaSorts.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typeOfTeaPicker {
            return greenTeaSorts[row]
        } else if pickerView == typeOfBlackTeaPicker {
            return blackTeaSorts[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch teaSort {
        case "Green":
            sortOfTeaPickerButton.titleLabel?.text = greenTeaSorts[row]
            if pickerView == typeOfTeaPicker {
                switch row {
                case 0:
                    maxValueGreenTea = 120 // Классический
                case 1:
                    maxValueGreenTea = 180 // Молочный Улун
                case 2:
                    maxValueGreenTea = 150 // Лу Дзинь
                case 3:
                    maxValueGreenTea = 240 // Японская липа
                case 4:
                    maxValueGreenTea = 60 // Сенча
                case 5:
                    maxValueGreenTea = 120 // Фруктовый чай
                case 6:
                    maxValueGreenTea = 180  // Травяной чай
                default:
                    break
                }
                leftTimeLabel.text = "\(Int(maxValueGreenTea) / 60) минут(ы)"
            }
        case "Black":
            sortOfTeaPickerButton.titleLabel?.text = blackTeaSorts[row]
            if pickerView == typeOfBlackTeaPicker {
                switch row {
                case 0:
                    maxValueBlackTea = 5 // Классический
                case 1:
                    maxValueBlackTea = 240 // Эрл Грей
                case 2:
                    maxValueBlackTea = 300 // Ассам
                case 3:
                    maxValueBlackTea = 240 // Фруктовый
                default:
                    break
                }
                 leftTimeLabel.text = "\(Int(maxValueBlackTea) / 60) минут(ы)"
            }
        default:
            sortOfTeaPickerButton.titleLabel?.text = "Выберите чай"
        }
        subViewWithPickers.isHidden = true
        typeOfTeaPicker.isHidden = true
        typeOfBlackTeaPicker.isHidden = true
    }
    
    // MARK: Developers
    @IBAction func IgorKorabelnikoVShowInfoAction(_ sender: Any) {
        sendMail(sendToAdress: "i.korabel2001@gmail.com")
        // switchUrl(link: "https://www.instagram.com/igor_korabel/")
    }
@IBAction func DaniilKorzhovShowInfoAction(_ sender: Any) {
    sendMail(sendToAdress: "dan.korzh@gmail.com")
   //   switchUrl(link: "https://www.instagram.com/korzhov_daniil/")
    }
    func createAlert(title: String , message: String, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style )
        let alertAction = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true , completion: nil)
    }
    func createAlertMenu(title: String, message: String, style: UIAlertController.Style) {
        let alertMenu = UIAlertController(title: "Поддержка!", message: "Связь с разработчиками", preferredStyle: .actionSheet)
        let alertActionShare = UIAlertAction(title: "Telegram", style: .default) { (shareInfo) in
        }
    }
    func sendMail(sendToAdress : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([sendToAdress])
            present(mail,animated: true)
        } else {
            createAlert(title: "Ошибка!", message: "Возникла проблема с отображением электронной почты разработчика", style: .alert)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func makeAudioSound(forResourse : String , ofType: String) {
        do {
            if let AudioPath = Bundle.main.path(forResource: forResourse, ofType: ofType) {
                try playerSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: AudioPath))
            }
        } catch {
            print("error")
        }
        playerSound.play()
    }
@objc func scheduleNotifications(inSeconds seconds : Date) {
        let date = seconds
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "Ваш чай готов, доставайте пакетик!"
        notificationContent.sound = UNNotificationSound.default
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "YourTeaIsReady", content: notificationContent, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    
    
    @objc func timerInstall(maxValue: CGFloat, cupBeforeStartIMG: String, cupAfterStartIMG: String, cupInProgressImg: String, cupInFinishImg: String, timeIntervalForNotification: TimeInterval,startTime: Date) {
        // Arguments
       timerCircle.value = 0
       timerCircle.maxValue = CGFloat(maxValue)
        self.timerActivateButton.isEnabled = false
        self.sortOfTeaPickerButton.isEnabled = false
        let TimePassed = Date().timeIntervalSince(startTime)
    print("Времени прошло: \(TimePassed)")
        let TimerDuration = Date().addingTimeInterval(timeIntervalForNotification)
        print(TimerDuration)
        self.timerCircle.value = CGFloat(TimePassed)
        let valueInt = Int(self.timerCircle.value )
        let valueMaxInt = Int(self.timerCircle.maxValue)
        self.leftTimeLabel.text = String("\(valueInt) секунд")
        print(valueInt)
        self.scheduleNotifications(inSeconds: TimerDuration)
        switch valueInt {
        case valueMaxInt / 2:
            self.timerImage.image = UIImage(named: cupAfterStartIMG)
        case valueMaxInt / 3:
            self.timerImage.image = UIImage(named: cupInProgressImg)
        case valueMaxInt :
            self.timerImage.image = UIImage(named: cupInFinishImg)
            self.timerActivateButton.isEnabled = true
            self.sortOfTeaPickerButton.isEnabled = true
            self.playerSound.play()
            self.timerActivateButton.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
            self.timerActivateButton.titleLabel?.text = "Новая чашка"
            self.leftTimeLabel.text = "Чай готов!"
        default:
            break
        }
    }
   @objc func activateGreenTeaTimer() {
    let startTime = Date()
        timerInstall(maxValue: CGFloat(self.maxValueGreenTea),cupBeforeStartIMG: "green-cup-1", cupAfterStartIMG: "green-cup-3", cupInProgressImg: "green-cup-2",cupInFinishImg: "green-cup-4",timeIntervalForNotification: maxValueGreenTea,startTime: startTime)
    }
    @objc func activateBlackTeaTimer() {
        let startTime = Date()
        timerInstall(maxValue: CGFloat(self.maxValueBlackTea), cupBeforeStartIMG: "black-cup-1", cupAfterStartIMG: "black-cup-3", cupInProgressImg: "black-cup-2", cupInFinishImg: "black-cup-4", timeIntervalForNotification: maxValueBlackTea,startTime: startTime)
    }
}
