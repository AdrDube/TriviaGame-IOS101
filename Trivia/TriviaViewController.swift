//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Adriel Dube on 3/12/25.
//

import UIKit

class TriviaViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var attemptsLabel: UILabel!
    
    
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    
    @IBOutlet weak var fourthButton: UIButton!
    
    
    var totalAttempts=0, answer=0, correctAttempts=0
    
    var triviaQuestions: [TriviaQuestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(imageName: "Background")
        loadQuestions()
        
    }
    
    
    func setBackground(imageName: String) {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        view.insertSubview(backgroundImage, at: 0)
    }
    
    @IBAction func didTabfirstButton(_ sender: UIButton) {
        updateScores(index:0)
        setQuestion()
    }
    
    @IBAction func didTabSecondButton(_ sender: UIButton) {
        updateScores(index: 1)
        setQuestion()
    }
    
    @IBAction func didTabThirdButton(_ sender: UIButton) {
        updateScores(index: 2)
        setQuestion()
    }
    
    @IBAction func didTabFourthButton(_ sender: UIButton) {
        updateScores(index: 3)
        setQuestion()
    }
    
    
    
    func updateScores(index:Int){
        if triviaQuestions[index].answers[index] == triviaQuestions[index].correctAnswer{
            correctAttempts += 1
        }
        totalAttempts += 1
    }
    
    func setQuestion(){
        guard !triviaQuestions.isEmpty else {
            loadQuestions()
            return
        }
        
    
        if totalAttempts==5 {
            DataManager.shared.correctAttempts = correctAttempts
            showPopup()
            totalAttempts=0
            correctAttempts=0
            loadQuestions()
            return
        }
        

         
            
        let i = totalAttempts
        attemptsLabel.text = "Question: \(totalAttempts+1)/5"
        questionLabel.text = triviaQuestions[i].question.htmlDecoded()
        genreLabel.text = "Category: " + triviaQuestions[i].genre.genreString
        firstButton.setTitle(triviaQuestions[i].answers[0], for: .normal)
        secondButton.setTitle(triviaQuestions[i].answers[1], for: .normal)
        thirdButton.setTitle(triviaQuestions[i].answers[2], for: .normal)
        fourthButton.setTitle(triviaQuestions[i].answers[3], for: .normal)
            
    }
        
    func showPopup() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupViewController") as? PopupViewController {
                popupVC.modalPresentationStyle = .overCurrentContext
                popupVC.modalTransitionStyle = .crossDissolve
                present(popupVC, animated: true, completion: nil)
            }
        }
        
    func loadQuestions() {
            Questions.get(number: 5, difficulty: "easy") { [weak self] questions in
                DispatchQueue.main.async {
                    guard let self = self, let questions = questions else { return }
                    self.triviaQuestions = questions
                    self.setQuestion()
                    
                }
                
            }
        
    }
    

}


extension String {
    func htmlDecoded() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(data: data, options: options, documentAttributes: nil).string) ?? self
    }
}
