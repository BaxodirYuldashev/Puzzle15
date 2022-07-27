//
//  ViewController.swift
//  Puzzle15
//
//  Created by macbook on 2/8/22.
//  Copyright © 2022 macbook. All rights reserved.
//

import UIKit

import AVFoundation

class ButtonModel {
    let senderBtn: UIButton
    let senderCenter: CGPoint
    let emptyCenter: CGPoint
    
    init(senderBtn: UIButton, senderCenter: CGPoint, emptyCenter: CGPoint) {
        self.senderBtn = senderBtn
        self.senderCenter = senderCenter
        self.emptyCenter = emptyCenter
    }
}

class Record {
    let step: Int
    let times: String
    
    init(step: Int, times: String) {
        self.step = step
        self.times = times
    }
    
}

class ViewController: UIViewController {
    
    let wd = UIScreen.main.bounds.size.width
    let hd = UIScreen.main.bounds.size.height
    let backView = UIView()
    let mg: CGFloat = 20
    let padding: CGFloat = 5
    var widthV: CGFloat = 0
    var widthBtn: CGFloat = 0
   
    var undoBtn = UIButton()
    var undoArr = [ButtonModel]()
    var redoArr = [ButtonModel]()
    let counterLbl = UILabel()
    let redoBtn = UIButton()
    let timerLbl = UILabel()
    var timer = Timer()
    let restartBtn = UIButton()
    let youWinLbl = UILabel()
    let scoreLbl = UILabel()
    let scoreBtn = UIButton()
    
    
    var recordListArr = [Record]()
    var ansArr = [String]()
    var counter = 0
    var duration = 0.3
    var sec = 0
    var minut = 0
    var hours = 0
    var number = 0
    var arr = [String]()
    var isEnd = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createUI()
       
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    @objc func startTimer() {
        
        if counter > 0 {
            
            if minut == 59 {
                hours += 1
                minut = 0
            }
            
            if sec == 59 {
                minut += 1
                sec = 0
                
            }
            
            sec += 1
            
            
           
            timerLbl.text = "0" + "\(hours): 0" + "\(minut): 0" + "\(sec)"
            
            if sec > 9 {
                timerLbl.text = "0" + "\(hours): 0" + "\(minut): \(sec)"
            }
            if minut > 9 {
                timerLbl.text = "0" + "\(hours): \(minut): \(sec)"
            }
            if hours > 9 {
                timerLbl.text = "\(hours): \(minut): \(sec)"
            }
//            timerLbl.text = (String(format:"%02i:%02i:%02i", sec/3600, sec/60%60, sec%60))
//            sec += 1      // 2 -variant
          
        }
    
        
    }
 
    
   
    
    @objc func undoClicked(_ sender: UIButton){
        
        if !undoArr.isEmpty{
            let btnUndo = undoArr.last?.senderBtn
            let empty = view.viewWithTag(16) as! UIButton
            let btnCen = undoArr.last?.senderCenter
            let emptyCen = undoArr.last?.emptyCenter
            
            UIView.animate(withDuration: duration) {
                btnUndo?.center = btnCen ?? CGPoint(x: 0, y: 0)
                empty.center = emptyCen ?? CGPoint(x: 0, y: 0)
                
            }
            
            redoArr.append(undoArr.removeLast())
            counter -= 1
            counterLbl.text = "Moves: \(counter)"
        
         
        }
        
    }
    
    @objc func redoClicked(_ sender: UIButton) {
        if !redoArr.isEmpty{
            let btnRedo = redoArr.last?.senderBtn
            let empty = view.viewWithTag(16) as! UIButton
            let btnCenter = redoArr.last?.senderCenter
            let emptyCenter = redoArr.last?.emptyCenter
            
            UIView.animate(withDuration: duration) {
                btnRedo?.center = emptyCenter ?? CGPoint(x: 0, y: 0)
                empty.center = btnCenter ?? CGPoint(x: 0, y: 0)
            }
            undoArr.append(redoArr.removeLast())
            counter += 1
            counterLbl.text = "Moves: \(counter)"

        }
    }
    
    @objc func restartClicked(_ sender: UIButton){
        
        restart()
        youWinLbl.isHidden = true
        
    }
    
    func restart () {
        for item in backView.subviews {
            item.removeFromSuperview()
        }
        
        number = 0
        counter = 0
        sec = 0
        minut = 0
        hours = 0
        counterLbl.text = "Moves \(counter)"
        timerLbl.text = "0" + "\(hours): 0" + "\(minut): 0" + "\(sec)"
        undoArr = [ButtonModel]()
        redoArr = [ButtonModel]()
        arr = [String]()
        isEnd = false

        createUI()
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        if !isEnd {
            replaceBtn(sender)
            redoArr.removeAll()
            youWin()
        }
        
    }
    
    func youWin() {
        
        var result = 0
        var tag = 1
        var x = padding + widthBtn/2
        var y = padding + widthBtn/2
        
        
        for _ in 0...3{
            for _ in 0...3 {
                let btn = backView.viewWithTag(tag) as! UIButton
                if btn.center == CGPoint(x: x, y: y) {
                    
                    result += 1

                    
                } else {
                    break
                }
                x += (padding + widthBtn)
                tag += 1
                
            }
            x = padding + widthBtn/2
            y += (padding + widthBtn)
            
        }
        
        if result == 16 {
            
            youWinLbl.text = "YOU WIN!!!"
            youWinLbl.textAlignment = .center
            isEnd = true
            AudioServicesPlaySystemSound(SystemSoundID(1030))
            undoBtn.isHidden = true
            redoBtn.isHidden = true
            scoreLbl.isHidden = false
            scoreBtn.isHidden = false
            youWinLbl.isHidden = false
            recordListArr.append(Record(step: counter, times: timerLbl.text ?? ""))
            
           

            let sortedRecordList = recordListArr.sorted {
                if $0.step < $1.step {
                    return true
                } else if $0.step == $1.step {
                    return $0.times < $1.times
                } else {
                    return false
                }


            }
            
            var str = ""
            var i = 0
            for item in sortedRecordList {

                    str += "\(i+1). Steps: \(item.step). Times: \(item.times) \n "
                
                    i += 1
                if i == 3 {
                    break
                }

            }
            
                scoreLbl.text = str
            

            if counter == counter {
                counter = 0
                startTimer()
            }
         
        }
    }
    
    @objc func scoreClicked(_ sender: UIButton){
       
        undoBtn.isHidden = true
        redoBtn.isHidden = true
        counterLbl.isHidden = true
        timerLbl.isHidden = true
        backView.isHidden = true
        youWinLbl.isHidden = true
        scoreBtn.isHidden = true
        scoreLbl.isHidden = false
        scoreLbl.frame = CGRect(x: padding + mg, y: mg * 3, width: wd - (2 * mg + 2 * padding), height: 180)
    
      
        
    }
   
    
    func replaceBtn (_ btn: UIButton) {
        
        let emptyBtn = (view.viewWithTag(16) as! UIButton)
        
        let emptyCenter = emptyBtn.center
        let btnCenter = btn.center
 
        let xEmpty = emptyBtn.frame.origin.x
        let yEmpty = emptyBtn.frame.origin.y
        let xSender = btn.frame.origin.x
        let ySender = btn.frame.origin.y
        
        if yEmpty == ySender && abs(xEmpty - xSender) == widthBtn + padding {
            undoArr.append(ButtonModel(senderBtn: btn, senderCenter: btnCenter, emptyCenter: emptyCenter))
            
            UIView.animate(withDuration: duration) {
               emptyBtn.center = btn.center
                btn.center = emptyCenter
                self.counter += 1

            }
        }
        
        if xEmpty == xSender && abs(yEmpty - ySender) == widthBtn + padding {
            undoArr.append(ButtonModel(senderBtn: btn, senderCenter: btnCenter, emptyCenter: emptyCenter))
            UIView.animate(withDuration: duration) {
                emptyBtn.center = btn.center
                btn.center = emptyCenter
                self.counter += 1
                
            }
        }
        self.counterLbl.text = "Moves: \(self.counter)"
        
        
    }
    
   
    
    func createUI() {
       
        widthV = wd - mg * 2
        widthBtn = (widthV - padding * 5)/4
        
        arr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
        arr.append("16")
        ansArr = arr
//        arr = arr.shuffled()
       
       
        
        
        view.backgroundColor = .black
       
        view.addSubview(undoBtn)
        undoBtn.frame = CGRect(x: 2 * mg, y: mg * 3, width: wd/3, height: 60)
        undoBtn.backgroundColor = .purple
        undoBtn.layer.cornerRadius = 12
        undoBtn.setTitle("Undo", for: .normal)
        undoBtn.isHidden = false
        undoBtn.addTarget(self, action: #selector(undoClicked(_:)), for: .touchUpInside)
        
        view.addSubview(redoBtn)
        redoBtn.frame = CGRect(x: 4 * mg + wd/3, y: mg * 3, width: wd/3, height: 60)
        redoBtn.backgroundColor = .purple
        redoBtn.layer.cornerRadius = 12
        redoBtn.setTitle("Redo", for: .normal)
        redoBtn.isHidden = false
        redoBtn.addTarget(self, action: #selector(redoClicked(_:)), for: .touchUpInside)
        
        
        view.addSubview(counterLbl)
        counterLbl.frame = CGRect(x: 3 * mg, y: mg * 5 + 60, width: wd/4, height: 50)
        counterLbl.backgroundColor = .cyan
        counterLbl.text = "Moves: \(counter)"
        counterLbl.textAlignment = .center
        counterLbl.layer.cornerRadius = 12
        counterLbl.clipsToBounds = true
        counterLbl.layer.borderColor = UIColor.black.cgColor
        counterLbl.layer.borderWidth = 3
        counterLbl.isHidden = false
        
        view.addSubview(timerLbl)
        timerLbl.frame = CGRect(x: 6 * mg + wd/4 + padding * 2, y: mg * 5 + 60, width: wd/4, height: 50)
        timerLbl.backgroundColor = .cyan
        timerLbl.clipsToBounds = true
        timerLbl.layer.borderColor = UIColor.black.cgColor
        timerLbl.layer.borderWidth = 3
        timerLbl.layer.cornerRadius = 8
        timerLbl.text = "0" + "\(hours): 0" + "\(minut): 0" + "\(sec)"
        timerLbl.textAlignment = .center
        timerLbl.font = UIFont.systemFont(ofSize: 17)
        timerLbl.isHidden = false
        
        
        view.addSubview(backView)
        backView.center = view.center
        backView.frame = CGRect(x: mg, y: hd/3, width: widthV, height: widthV)
        backView.center = view.center
        backView.backgroundColor = .lightGray
        backView.layer.cornerRadius = 12
        backView.isHidden = false
        
        view.addSubview(restartBtn)
        restartBtn.frame = CGRect(x: wd/3, y: mg * 7 + 60 + widthV + wd/4, width: wd/3, height: 60)
        restartBtn.backgroundColor = .purple
        restartBtn.layer.cornerRadius = 12
        restartBtn.setTitle("Restart", for: .normal)
        restartBtn.tag = 17
        restartBtn.addTarget(self, action: #selector(restartClicked(_:)), for: .touchUpInside)
        
        for i in 0...3 {
            for j in 0...3 {
                let button = UIButton()
                backView.addSubview(button)
                button.frame = CGRect(x:padding * CGFloat(j+1) + widthBtn * CGFloat(j), y:padding * CGFloat(i+1) + widthBtn * CGFloat(i), width: widthBtn, height: widthBtn)
                button.backgroundColor = .red
                button.layer.cornerRadius = 12
                button.tag = Int(arr[number]) ?? 0
                button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                
                if button.tag == 16 {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = .darkGray
                } else {
                    button.setTitle("\(arr[number])", for: .normal)
                    
                }
                number += 1
                
            }
            
        }

       view.addSubview(youWinLbl)
        youWinLbl.frame = CGRect(x: wd/3, y: mg * 8 + 120 + widthV + wd/4, width: wd/3, height: 60)
        youWinLbl.backgroundColor = .green
        youWinLbl.layer.cornerRadius = 12
        youWinLbl.clipsToBounds = true
        youWinLbl.text = ""
        youWinLbl.isHidden = true
        
        view.addSubview(scoreLbl)
        scoreLbl.frame = CGRect(x: padding + mg, y: mg * 3, width: wd - (2 * mg + 2 * padding), height: 90)
        scoreLbl.backgroundColor = .orange
        scoreLbl.isHidden = true
        scoreLbl.layer.cornerRadius = 12
        scoreLbl.clipsToBounds = true
        scoreLbl.layer.borderWidth = 3
        scoreLbl.textAlignment = .center
        scoreLbl.numberOfLines = 0
        
        view.addSubview(scoreBtn)
        scoreBtn.frame = CGRect(x: mg + (widthV - widthBtn), y: mg * 9 + 60 + widthV + wd/4, width: wd/5, height: wd/6)
        scoreBtn.backgroundColor = .darkGray
        scoreBtn.layer.cornerRadius = wd/12
        scoreBtn.setTitle("Scores", for: .normal)
        scoreBtn.isHidden = true
        scoreBtn.addTarget(self, action: #selector(scoreClicked(_:)), for: .touchUpInside)
    }
    

}


