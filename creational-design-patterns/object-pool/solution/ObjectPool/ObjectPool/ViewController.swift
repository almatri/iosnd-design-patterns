//
//  ViewController.swift
//  ObjectPool
//
//  Created by Christopher Arriola on 2/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var timer: Timer?
    private var snowflakePool: [SnowflakeView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for _ in 1...100 {
            let snowflake = SnowflakeView()
            snowflakePool.append(snowflake)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1. Create a timer that will add snowflakes at regular intervals
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            
            // 2. When the timer is triggered, add a snowflake
            guard let snowflake = self.snowflakePool.popLast() else {
                print("No more snowflakes in the pool!")
                return
            }
            snowflake.animateFallingSnowflake(to: self.view) {
                self.snowflakePool.append(snowflake)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        super.viewWillDisappear(animated)
    }
}

class SnowflakeView: UIImageView {
    
    private var randomXPosition: CGFloat {
        get {
            let maxX = self.superview?.frame.width ?? self.frame.width
            return CGFloat(arc4random_uniform(UInt32(maxX)))
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        image = UIImage(named: "snowflake")
        contentMode = .scaleAspectFit
    }
    
    func animateFallingSnowflake(to view: UIView, completion: @escaping (() -> Void)) {
        view.addSubview(self)
        
        frame = CGRect(x: randomXPosition, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        
        UIView.animate(withDuration: 3, animations: {
            self.frame = CGRect(x: self.randomXPosition, y: self.superview!.frame.height + self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { _ in
            // Animation complete
            completion()
        }
    }
}

