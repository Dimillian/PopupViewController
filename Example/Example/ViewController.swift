//
//  ViewController.swift
//  Example
//
//  Created by Thomas Ricouard on 08/06/16.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit
import PopupViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onStandardAlert(_ sender: AnyObject) {
        let alert = PopupViewController(title: "Alert title", message: "Alert message, which can be very long and etc....")
        alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func onCustomAlert(_ sender: AnyObject) {
        var customizable = PopupViewController.Customizable()
        customizable.titleColor = UIColor.blue()
        customizable.positiveActionColor = UIColor.red()
        customizable.messageColor = UIColor.brown()
        customizable.messageFont = UIFont.boldSystemFont(ofSize: 22)
        customizable.negativeActionColor = UIColor.brown()
        customizable.positiveActionColor = UIColor.blue()
        customizable.negativeActionBackgroundColor = UIColor.black()
        customizable.positiveActionBackgroundColor = UIColor.white()
        customizable.positiveActionHighlightColor = UIColor.green()
        customizable.negativeActionHighlightColor = UIColor.red()

        let alert = PopupViewController(title: "Alert title",
                                        message: "Alert message, which can be very long message and all that but nobody will ever read it.",
                                        customizable: customizable)
        alert.blurStyle = .extraLight
        alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
        alert.addAction(PopupAction(title: "Cancel", type: .negative, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
