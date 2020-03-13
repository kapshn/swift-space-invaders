//
//  ViewController.swift
//  space-invaders
//
//  Created by Monday MeoW. on 28.02.2020.
//  Copyright © 2020 MMW. All rights reserved.
//

import UIKit
import CoreMotion




class ViewController: UIViewController {

    var t : Timer?
    var enemies = [[Enemy]]()
    var aliveEnemy : Int = 15
    
    var xchange :CGFloat = -1
    var ychange :CGFloat = 0
    
    let motion = CMMotionManager()
    
    @IBOutlet weak var lvlscore: UILabel!
    @IBOutlet weak var destroyed: UIImageView!
    @IBOutlet weak var player: UIImageView!
    @IBOutlet var hit: UITapGestureRecognizer!
    @IBOutlet weak var score: UILabel!
    
    var scoreNumber : Int = 0
    var lvlnumber : Int = 0
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        lvlnumber = UserDefaults.standard.integer(forKey: "lvlnumber")
        scoreNumber = UserDefaults.standard.integer(forKey: "scoreNumber")
        isDie = UserDefaults.standard.bool(forKey: "isDie")
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        startGame()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    var playerBullets = [UIImageView]()
    var shotCoolDown = 30
    var enemyBullets = [UIImageView]()
    var shotEnemyCoolDown = 30.0
    
    @IBAction func tap(_ sender: Any) {
        if isDie {
            startGame()
        }else{
        if shotCoolDown > 30 {
            let myView = CGRect(x: player.frame.origin.x + player.frame.width * 0.45, y: player.frame.origin.y-player.frame.height * 0.3, width: player.frame.width * 0.1, height: player.frame.height * 0.5)
            let newPlayerBullet = UIImageView(frame: myView)
            newPlayerBullet.image = #imageLiteral(resourceName: "laser")
            view.addSubview(newPlayerBullet)
            playerBullets.append(newPlayerBullet)
            shotCoolDown = 0
        }
        //print(1)
        }
    }
    
    
    var isDie : Bool = true
    
    func startGame()  {

        if isDie {
            scoreNumber = 0
            score.text = "0"
            lvlnumber = 1
            lvlscore.text = "1"
            
        }
        else {
            lvlscore.text = String(lvlnumber)
            score.text = String(scoreNumber)
        }
        aliveEnemy = 15
        isDie = false
        for (number, _) in enemyBullets.enumerated() {
            enemyBullets[number].removeFromSuperview()
        }
        
        for (number, _) in playerBullets.enumerated() {
            playerBullets[number].removeFromSuperview()
        }
        
        playerBullets.removeAll()
        enemyBullets.removeAll()
        
        
        
        destroyed.isHidden = true
        
        let const = CGRect(x: view.frame.width * 0.4 , y: view.frame.height - 0.2 * view.frame.width - (1/11) * view.frame.width, width: 0.2 * view.frame.width , height:  0.2 * view.frame.width)
        player.frame = const
        if enemies.count == 0 {
        for i in 1...5 {
            var enemyX = [Enemy]()
            for j in 1...3{
                let enemyCGRect = CGRect(x:view.frame.width * CGFloat(i*2-1) * (1/11), y:view.frame.width * (1.5/11) * CGFloat(j), width: view.frame.width * (1/11), height: view.frame.width * (1/11))
                let newEnemy = Enemy(frame: enemyCGRect)
                newEnemy.image = #imageLiteral(resourceName: "shipmod-space-invader")
                view.addSubview(newEnemy)
                enemyX.append(newEnemy)
                
            }
            enemies.append(enemyX)
        }
        } else {
            for i in 0...4 {
                for j in 0...2 {
                    enemies[i][j].isHidden = false
                    let enemyCGRect = CGRect(x:view.frame.width * CGFloat((i+1)*2-1) * (1/11), y:view.frame.width * (1.5/11) * CGFloat(j+1), width: view.frame.width * (1/11), height: view.frame.width * (1/11))
                    enemies[i][j].frame = enemyCGRect
                    enemies[i][j].transform = CGAffineTransform(scaleX: xchange, y: 1)
                }
            }
        }
        t = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(draw), userInfo: nil, repeats: true)
        
    }
    
    @objc func draw()  {
        //if lvlnumber == 100 {drawMultik()}
        shotCoolDown += 1
        shotEnemyCoolDown += sqrt(Double(lvlnumber))
        
        if shotEnemyCoolDown >= 180 {
            let randx = Int.random(in: 0...4)
            let randy = Int.random(in: 0...2)
            if enemies[randx][randy].isHidden==false {
                let myView = CGRect(x: enemies[randx][randy].frame.origin.x + enemies[randx][randy].frame.width * 0.45, y: enemies[randx][randy].frame.origin.y + enemies[randx][randy].frame.height * 0.3, width: enemies[randx][randy].frame.width * 0.5, height: enemies[randx][randy].frame.height * 0.5)
                let newEnemyBullet = UIImageView(frame: myView)
                newEnemyBullet.image = #imageLiteral(resourceName: "firebulletplayer")
                view.addSubview(newEnemyBullet)
                enemyBullets.append(newEnemyBullet)
                shotEnemyCoolDown = 0
            }
        }
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.x += xchange
            }
        }
        if enemies[0][2].frame.origin.y + enemies[0][2].frame.height > player.frame.origin.y {
            var isIntersect : Bool = false
            for i in 0...3 {
                for j in 0...2 {
                    if (enemies[i][j].frame.origin.y + enemies[i][j].frame.height > player.frame.origin.y) && (enemies[i][j].isHidden == false){
                        isIntersect = true
                    }
                }
            }
            if isIntersect {
                destroyed.isHidden = false
                t?.invalidate()
                isDie = true
            }
        }
        for i in 0...4{
            if enemies[i][0].frame.origin.x + enemies[i][0].frame.width >= view.frame.width {
                xchange = -1
                ychange += view.frame.width * (1/44)
            }
            if enemies[i][0].frame.origin.x  <= 0 {
                xchange = 1
                ychange += view.frame.width * (1/44)
            }
        }
        
        for (number, item) in enemyBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                enemyBullets[number].removeFromSuperview()
                enemyBullets.remove(at: number)
            }
            if item.frame.origin.y - player.frame.height*0.3 > player.frame.origin.y{
                if (item.frame.intersects(player.frame)) {
                    destroyed.isHidden = false
                    t?.invalidate()
                    isDie = true
                    UserDefaults.standard.set(isDie, forKey: "isDie")
                }
            }
        }
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.y += ychange
                enemies[i][j].transform = CGAffineTransform(scaleX: xchange, y: 1)
            }
        }
        ychange = 0
        let enemyPos = enemies[0][2].frame.origin.y + enemies[0][2].frame.height
        outer: for (number, item) in playerBullets.enumerated(){
            item.frame.origin.y -= 10
            if item.frame.origin.y < -50 {
                playerBullets[number].removeFromSuperview()
                playerBullets.remove(at: number)
            } else {
                if enemyPos >= item.frame.origin.y {
                    inner : for i in 0...4 {
                        for j in 0...2 {
                            if (item.frame.intersects(enemies[i][j].frame) && enemies[i][j].isHidden==false) {
                                playerBullets[number].removeFromSuperview()
                                playerBullets.remove(at: number)
                                enemies[i][j].isHidden = true
                                scoreNumber += Int(10 * sqrt(Double(lvlnumber)))
                                score.text = String(scoreNumber)
                                aliveEnemy -= 1
                            
                                if aliveEnemy == 0 {
                                    aliveEnemy = 15
                                    t?.invalidate()
                                    isDie = false
                                    lvlnumber += 1
                                    UserDefaults.standard.set(isDie, forKey: "isDie")
                                    UserDefaults.standard.set(scoreNumber, forKey: "scoreNumber")
                                    UserDefaults.standard.set(lvlnumber, forKey: "lvlnumber")
                                    startGame()
                                    break outer
                                }
                                break inner
                            }
                        }
                    }
                }
            }
        }
        
        //do not touch coz it work
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            if let data = self.motion.accelerometerData {
                let x = data.acceleration.x
                if (x > 0 && player.frame.origin.x < (view.frame.maxX-player.frame.width-10)) {
                    player.frame.origin.x += 3
                }
                
                if (player.frame.origin.x>10 && x < 0) {
                    player.frame.origin.x += -3
                }
            }
        }
    }
}

