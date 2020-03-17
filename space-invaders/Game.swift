//
//  Game.swift
//  space-invaders
//
//  Created by Monday MeoW. on 13.03.2020.
//  Copyright © 2020 MMW. All rights reserved.
//

import Foundation

class Game{
    private var scoreNumber : Int = 0
    private var lvlnumber : Int = 1
    private var bestScoreNumber : Int = 0
    private var isDie : Bool = true
    
    func setScoreNumber(newScore:Int){
        scoreNumber = newScore
    }
    func saveScore(){
        UserDefaults.standard.set(scoreNumber, forKey: "scoreNumber")
    }
    func setLvlNumber(newLvl:Int) {
        lvlnumber = newLvl
    }
    func saveLVL() {
        UserDefaults.standard.set(lvlnumber, forKey: "lvlnumber")
    }
    func setStatus(status : Bool) {
        isDie = status
        UserDefaults.standard.set(isDie, forKey: "isDie")
    }
    func setBestScore(newRecord : Int) {
        bestScoreNumber = newRecord
        UserDefaults.standard.set(bestScoreNumber, forKey: "bestScore")
    }
    func updateScore()  {
        scoreNumber += Int(10 * sqrt(Double(lvlnumber)))
    }
    func updateBestScore() {
        if bestScoreNumber < scoreNumber {
            bestScoreNumber = scoreNumber
            UserDefaults.standard.set(bestScoreNumber, forKey: "bestScore")
        }
    }
    
    init() {
        lvlnumber = UserDefaults.standard.integer(forKey: "lvlnumber")
        scoreNumber = UserDefaults.standard.integer(forKey: "scoreNumber")
        isDie = UserDefaults.standard.bool(forKey: "isDie")
        bestScoreNumber = UserDefaults.standard.integer(forKey: "bestScore")
    }
    func getScore() -> Int{
        return scoreNumber
    }
    func getLVL() -> Int{
        return lvlnumber
    }
    func getBestScore() -> Int{
        return bestScoreNumber
    }
    func getIsDie() -> Bool{
        return isDie
    }
}
