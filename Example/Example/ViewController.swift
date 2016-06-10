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


    @IBAction func onStandardAlert(sender: AnyObject) {
        let alert = PopupViewController(title: "Alert title", message: "Alert message, which can be very long and etc....")
        alert.addAction(PopupAction(title: "Ok", type: .Positive, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func onCustomAlert(sender: AnyObject) {
        var customizable = PopupViewController.Customizable()
        customizable.titleColor = UIColor.blueColor()
        customizable.positiveActionColor = UIColor.redColor()
        customizable.messageColor = UIColor.brownColor()
        customizable.messageFont = UIFont.boldSystemFontOfSize(22)
        customizable.negativeActionColor = UIColor.brownColor()
        customizable.positiveActionColor = UIColor.blueColor()
        customizable.negativeActionBackgroundColor = UIColor.blackColor()
        customizable.positiveActionBackgroundColor = UIColor.whiteColor()
        customizable.positiveActionHighlightColor = UIColor.greenColor()
        customizable.negativeActionHighlightColor = UIColor.redColor()

        let alert = PopupViewController(title: "Alert title",
                                        message: "Alert message, which can be very long message and all that but nobody will ever read it.",
                                        customizable: customizable)
        alert.blurStyle = .ExtraLight
        alert.addAction(PopupAction(title: "Ok", type: .Positive, handler: nil))
        alert.addAction(PopupAction(title: "Cancel", type: .Negative, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
