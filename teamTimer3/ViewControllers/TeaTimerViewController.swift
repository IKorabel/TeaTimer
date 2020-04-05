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

class TeaTimerViewController: UIViewController {
    @IBOutlet weak var timerCircle: UICircularProgressRing!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var timerActivateButton: UIButton!
    @IBOutlet weak var greenTeaSegmentButton: UIButton!
    @IBOutlet weak var blackTeaSegmentButton: UIButton!
    @IBOutlet weak var sortOfTeaPickerButton: UIButton!
    @IBOutlet weak var typeOfTeaPicker: UIPickerView!
    @IBOutlet weak var typeOfBlackTeaPicker: UIPickerView!
    @IBOutlet weak var subViewWithPickers: UIView!
    @IBOutlet weak var infoAboutTeaButton: UIButton!
    
    var teaSortsInfo = TeaSortsInfo()
    var uiSettings = UISettingsManager()
    var helpers = Helpers()
    var notificationManager = NotificationManager()
    var greenTeaSorts: [Tea] { return teaSortsInfo.greenTeaSorts }
    var blackTeaSorts: [Tea] { return teaSortsInfo.blackTeaSorts }
    var currentTea = Tea(teaName: "", image: "", teaDescription: "", weldingTime: 0)
    var playerSound = AVAudioPlayer()
    var timerActivationList = 0
    var teaSort: TeaSortEnum? = .green
    var isTimerStopped = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTea = teaSortsInfo.greenTeaSorts[0]
        uiSettings.shapesOfElements(buttons: [timerActivateButton,greenTeaSegmentButton,blackTeaSegmentButton,sortOfTeaPickerButton,infoAboutTeaButton])
        isTimerStopped = true
        sortOfTeaPickerButton.titleLabel?.text = currentTea.teaName
        leftTimeLabel.text = "\(Int(currentTea.weldingTime) / 60) минут(ы)"
        audioPlayer()
  }
    
    func audioPlayer() {
        do {
            if let AudioPath = Bundle.main.path(forResource: "TimerForAppSound2", ofType: "wav") {
                try self.playerSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: AudioPath))
            }
        } catch {
            print("error")
        }
    }
    
    @IBAction func sortOfTeaPickerButtonAction(_ sender: Any) {
      uiSettings.pickerModeControl(teaSort: teaSort!, greenTeaPicker: typeOfTeaPicker , blackTeaPicker: typeOfBlackTeaPicker, subviewWithPickers: subViewWithPickers)
    }
    
    
    @IBAction func timerActivateButtonAction(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
        var cupImages: (String,String,String,String) {
            if teaSort == .black {
                return teaSortsInfo.cupOfTeeImages[0]
            } else if teaSort == .green {
                return teaSortsInfo.cupOfTeeImages[1]
            }
            return teaSortsInfo.cupOfTeeImages[0]
        }
        
        if timerActivateButton.titleLabel?.text == "Начать заварку" {
            timerActivateButton.setTitle("Сбросить заварку", for: .normal)
            timerActivateButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0, alpha: 1)
            isTimerStopped = false
        }
        if timerActivateButton.titleLabel?.text == "Сбросить заварку" {
            timerActivateButton.setTitle("Начать заварку", for: .normal)
            isTimerStopped = true
        }
        
        timerInstall(maxValue: currentTea.weldingTime, cupBeforeStartIMG: cupImages.0, cupAfterStartIMG: cupImages.3, cupInProgressImg: cupImages.2, cupInFinishImg: cupImages.3, timeIntervalForNotification: TimeInterval(currentTea.weldingTime), startTime: Date())
    }
    
    //MARK: ButtonAction
    @IBAction func greenTeaActivateButtonAction(_ sender: UIButton) {
        uiSettings.segmentedButtonSelected(selectedButton: sender, notSelectedButton: blackTeaSegmentButton, colorOfSelectedButton: .green, teaSort: &teaSort!)
    }
    
    @IBAction func blackTeaActivateButtonAction(_ sender: UIButton) {
        uiSettings.segmentedButtonSelected(selectedButton: sender, notSelectedButton: greenTeaSegmentButton, colorOfSelectedButton: .black, teaSort: &teaSort!)
    }
    
    
    // MARK: Developers
    @IBAction func IgorKorabelnikoVShowInfoAction(_ sender: Any) {
        sendMail(sendToAdress: "i.korabel2001@gmail.com")
    }
   @IBAction func DaniilKorzhovShowInfoAction(_ sender: Any) {
        sendMail(sendToAdress: "dan.korzh@gmail.com")
    }
    
    
    @objc func timerInstall(maxValue: CGFloat, cupBeforeStartIMG: String, cupAfterStartIMG: String, cupInProgressImg: String, cupInFinishImg: String, timeIntervalForNotification: TimeInterval,startTime: Date) {
    timerCircle.value = 0
    timerCircle.maxValue = maxValue
    print("MAX VALUE: \(timerCircle.maxValue)")
    timerActivationList += 1
    
   let teaTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timerTea) in
        let TimePassed = Date().timeIntervalSince(startTime)
        let TimerDuration = Date().addingTimeInterval(timeIntervalForNotification)
        self.timerActivateButton.isEnabled = true
        self.sortOfTeaPickerButton.isEnabled = true
        self.timerCircle.value = CGFloat(TimePassed)
        self.leftTimeLabel.text = String("\(Int(TimePassed)) секунд")
        self.notificationManager.scheduleNotifications(inSeconds: TimerDuration)
        self.timerTracker(timer: timerTea, value: Int(TimePassed), maxValue: Int(maxValue), type: .green, images: (cupBeforeStartIMG, cupAfterStartIMG, cupInProgressImg, cupInFinishImg),image: &self.timerImage.image!)
        }
        
         if self.isTimerStopped == true {
        timerCircle.resetProgress()
        timerCircle.maxValue = 0
        timerCircle.value = 0
        print(Date(),#line)
        teaTimer.invalidate()
        } else if self.isTimerStopped == false {
        timerCircle.resetProgress()
        teaTimer.fire()
        }

        if timerActivationList >= 2 {
        teaTimer.invalidate()
        } else {
        timerCircle.value = 0
        teaTimer.fire()
    }
}
    
    func timerTracker(timer: Timer,value: Int, maxValue: Int, type: TeaSortEnum, images: (String,String,String,String), image: inout UIImage) {
        switch value {
        case 0:
        image = UIImage(named: images.0)!
        case maxValue / 2:
        image = UIImage(named: images.1)!
        case maxValue / 3:
        image = UIImage(named: images.2)!
        case maxValue :
        image = UIImage(named: images.3)!
        self.timerActivateButton.isEnabled = true
        self.sortOfTeaPickerButton.isEnabled = true
        self.playerSound.play()
        timer.invalidate()
        self.timerActivateButton.backgroundColor = #colorLiteral(red: 0, green: 0.6549019608, blue: 0.462745098, alpha: 1)
        self.timerActivateButton.titleLabel?.text = "Начать заварку"
        self.leftTimeLabel.text = "Чай готов!"
        self.timerActivationList = 0
        default:
        break
        }
  }
    
//MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ItemSegue" else { return }
        let destination = segue.destination as! SortOfTeaInfoViewController
        destination.teaSortInfo = currentTea
    }
}

//MARK: Mail
extension TeaTimerViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          controller.dismiss(animated: true, completion: nil)
      }
    
    
    func sendMail(sendToAdress : String) {
          if MFMailComposeViewController.canSendMail() {
              let mail = MFMailComposeViewController()
              mail.mailComposeDelegate = self
              mail.setToRecipients([sendToAdress])
              present(mail,animated: true)
          } else {
            helpers.createAlert(title: "Ошибка!", message: "Возникла проблема с отображением электронной почты разработчика", style: .alert, vc: self)
          }
      }
}


//MARK: PickerView
extension TeaTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            return greenTeaSorts[row].teaName
        } else if pickerView == typeOfBlackTeaPicker {
            return blackTeaSorts[row].teaName
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var teaInRow: Tea {
            if teaSort == .green {
                return greenTeaSorts[row]
            } else if teaSort == .black {
                return blackTeaSorts[row]
            }
            return greenTeaSorts[row]
        }
        currentTea = Tea(teaName: teaInRow.teaName, image: teaInRow.image, teaDescription: teaInRow.teaDescription, weldingTime: teaInRow.weldingTime)
        sortOfTeaPickerButton.titleLabel?.text = currentTea.teaName
        leftTimeLabel.text = "\(Int(currentTea.weldingTime) / 60) минут(ы)"
        subViewWithPickers.isHidden = true
        typeOfTeaPicker.isHidden = true
        typeOfBlackTeaPicker.isHidden = true
    }
}
