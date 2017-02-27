//
//  ViewController.swift
//  Quiz
//
//  Created by Jayden Olsen on 1/20/17.
//  Copyright © 2017 Jayden Olsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var answerLabel: UILabel!
    
    //for fixing the answers when the question is off screen
    var isVisible = false
    var doubleTap = false
    
    let questions: [String] = [
       "What is 7+7?",
       "What is the capital of Vermont?",
       "What is cognac made from?"
    ]
    
    let answers: [String] = [
       "14",
       "Montpelier",
       "Grapes"
    ]
    var currentQuestionIndex: Int = 0
    
    //shows next question and sets isVisbile to true, or hides the current question
    //and sets isVisible to false
    @IBAction func showNextQuestion(_ sender: UIButton) {
        if (doubleTap){
            isVisible=false
            doubleTap=false
        }else{
            isVisible=true
            doubleTap=true
        }
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    //shows the answer if the current question isVisible
    @IBAction func showAnswer(_ sender: UIButton) {
        if isVisible{
            let answer: String = answers[currentQuestionIndex]
            answerLabel.text = answer
        }
    }
    
    //sets up the view and the UILayoutGuide
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionLabel.text = questions[currentQuestionIndex]
        let space1 = UILayoutGuide()
        view.addLayoutGuide(space1)
        space1.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive=true
        currentQuestionLabel.leadingAnchor.constraint(equalTo: space1.trailingAnchor).isActive = true
        currentQuestionLabel.trailingAnchor.constraint(equalTo: space1.leadingAnchor).isActive = true
        isVisible=false
        
        updateOffScreenLabel()
    }
    
    //puts one of the question labels off screen
    func updateOffScreenLabel() {
        
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
    
    //animates the question label
    func animateLabelTransitions() {
        //Force any outstanding layout changes to occur
        view.layoutIfNeeded()
        
        //Animate the alpha
        //and the center x constraints
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping:0.5,
            initialSpringVelocity:1,
            options: [.curveLinear],
            animations: {
            self.currentQuestionLabel.alpha = 0
            self.nextQuestionLabel.alpha = 1
                
            self.view.layoutIfNeeded()
        },
            completion: { _ in
                swap(&self.currentQuestionLabel,
                     &self.nextQuestionLabel)
                swap(&self.currentQuestionLabelCenterXConstraint,
                     &self.nextQuestionLabelCenterXConstraint)
                
                self.updateOffScreenLabel()
        
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set the label's initial alpha
        nextQuestionLabel.alpha = 0
    }
    
}

