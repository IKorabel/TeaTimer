//
//  Helpers.swift
//  teamTimer3
//
//  Created by Игорь Корабельников on 05.04.2020.
//  Copyright © 2020 Игорь Корабельников. All rights reserved.
//

import UIKit

class Helpers: NSObject {

     func createAlert(title: String , message: String, style: UIAlertController.Style,vc: UIViewController) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: style )
         let alertAction = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
         alert.addAction(alertAction)
         vc.present(alert, animated: true , completion: nil)
     }
    
}
