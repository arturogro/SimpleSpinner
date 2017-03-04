//
//  ViewController.swift
//  SimpleSpinner
//
//  Created by Arturo Guerrero on 04/03/17.
//  Copyright © 2017 Mega Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var simpleSpinnerView: SimpleSpinner!
    
    let tintColor = UIColor(red: 72/255.0, green: 133/255.0, blue: 237/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        simpleSpinnerView.lineWidth = 5
        simpleSpinnerView.tintColor = tintColor
        simpleSpinnerView.startAnimating()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.simpleSpinnerView.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

