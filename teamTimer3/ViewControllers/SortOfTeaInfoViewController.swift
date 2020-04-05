//
//  SortOfTeaInfoViewController.swift
//  teamTimer3
//
//  Created by Игорь Корабельников on 10/05/2019.
//  Copyright © 2019 Игорь Корабельников. All rights reserved.
//

import UIKit

class SortOfTeaInfoViewController: UIViewController {
    @IBOutlet weak var nameOfTheTeaLabel: UILabel!
    @IBOutlet weak var teaImage: UIImageView!
    @IBOutlet weak var sortOfTeaInfo: UITextView!
    var teaSortInfo : Tea!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        sortOfTeaInfo.contentOffset = CGPoint.zero
        nameOfTheTeaLabel.text = teaSortInfo.teaName
        teaImage.image = UIImage(named: teaSortInfo.image)
        sortOfTeaInfo.text = teaSortInfo.teaDescription
    }
}
