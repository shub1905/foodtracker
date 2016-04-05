//
//  ViewController.swift
//  FoodTracker
//
//  Created by satan on 4/5/16.
//  Copyright © 2016 satan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Action

    @IBAction func labelButton(sender: UIButton) {
        labelName.text = "Hudson"
    }
}

