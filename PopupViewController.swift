//
//  PopupViewController.swift
//  Trivia
//
//  Created by Adriel Dube on 3/12/25.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
        let count = DataManager.shared.correctAttempts
        scoreLabel.text = """
        \(count)/5 correct 
        Let's go again
        """

    }
    
    
    
}
