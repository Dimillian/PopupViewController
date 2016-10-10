//
//  PopupViewController.swift
//  bookshots
//
//  Created by Thomas Ricouard on 07/06/16.
//  Copyright © 2016 Glose. All rights reserved.
//

import UIKit
import Cartography


// MARK: PopupAction

/**
 Represent an action of a PopupViewController. It have a title, an action handler and a type.
 */
open class PopupAction {

    public enum ActionType {
        case positive, negative
    }

    // MARK: Public properties.

    /// The title of the action, which will be displayed in a clickable button.
    var title: String?

    /// The type of the action, can be Positive (standard) or negative (Usually bold).
    var actionType: ActionType?

    /// The completion handler for when the user trigger the action. The alert will also be dismissed.
    var handler: ((PopupAction) -> Void)?

    fileprivate init() {

    }

    /// Covenience init. Take a title, a type and a completion handler.
    required public convenience init(title: String, type: ActionType, handler: ((PopupAction) -> Void)?) {
        self.init()
        self.title = title
        self.actionType = type
        self.handler = handler
    }
}

// MARK: PopupViewController

/**
 PopupViewController is a drop in replacement of UIAlertController but which much more customization options.

 Come with a default dark theme.

 You only need to call the covenience init, then add one or more action, then present it using presentViewController.
 */
open class PopupViewController: UIViewController, UIViewControllerTransitioningDelegate {

    // MARK: Public properties.

    /// The title which will be displayed in the alert. Can be modified any time.
    override open var title: String! {
        didSet {
            alertView.titleLabel.text = title
            alertView.setNeedsUpdateConstraints()
        }
    }
    /// The message which will be displayed in the alert. Can be modified any time.
    open var message: String! {
        didSet {
            alertView.messageLabel.text = message
            alertView.setNeedsUpdateConstraints()
        }
    }

    /// Blur style for the alert view, default is Dark.
    open var blurStyle = UIBlurEffectStyle.dark {
        didSet {
            blurView.effect = UIBlurEffect(style: blurStyle)
        }
    }

    /// Default customizable used if you don't pass any. Can be set to a new one too
    static open var sharedCustomizable = Customizable()

    /// Init this strict and set any properties to customize your alert view accordingly.
    /// Must be passed in the init parameter.
    public struct Customizable {
        public var titleFont = UIFont.systemFont(ofSize: 17.0)
        public var titleColor = UIColor.red
        public var messageFont = UIFont.systemFont(ofSize: 15.0)
        public var messageColor = UIColor.white
        public var postiveActionFont = UIFont.systemFont(ofSize: 15)
        public var positiveActionColor = UIColor.white
        public var positiveActionBackgroundColor = UIColor.clear
        public var positiveActionHighlightColor = UIColor.lightGray
        public var negativeActionFont = UIFont.boldSystemFont(ofSize: 15)
        public var negativeActionColor = UIColor.white
        public var negativeActionBackgroundColor = UIColor.clear
        public var negativeActionHighlightColor = UIColor.lightGray
        public var actionsSeparatorColor = UIColor.darkGray
        public var alertBorderColor = UIColor.darkGray

        public init() {

        }
    }

    // MARK: Private properties.
    fileprivate var actions: [PopupAction] = []
    fileprivate var alertView: PopupAlertView!
    fileprivate var toVc: UIViewController?
    fileprivate let blurView: UIVisualEffectView = {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 6
        return $0
    }(UIVisualEffectView(effect: UIBlurEffect(style: .dark)))

    /// Conveniance init.
    convenience public init(title: String, message: String, customizable: Customizable? = PopupViewController.sharedCustomizable) {
        self.init(nibName: nil, bundle: nil)

        alertView = PopupAlertView(title: title,
                                   message: message,
                                   customizable: customizable!,
                                   completionHandler: {alertView in
                                    self.dismiss(animated: true, completion: nil)
        })
        self.message = message
        self.title = title

        modalPresentationStyle = .custom
        definesPresentationContext = true
        transitioningDelegate = self
    }
    
    /// Subclass can override to provide its own presenting transition.
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        toVc = presenting
        return PopupViewControllerTransition(fromVC: presenting, toVC: presented)
    }

    
    /// Subclass can override to provide its own dismissal transition.
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let toVc = toVc {
            let transition = PopupViewControllerTransition(fromVC: self, toVC: toVc)
            transition.presenting = false
            return transition
        }
        return nil
    }

    /// Add an action to the PopupViewController. Add all your actions before presenting.
    open func addAction(_ action: PopupAction) {
        actions.append(action)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(blurView)
        view.addSubview(alertView)

        constrain(self.view, alertView) {view, alertView in
            alertView.width == 270
            alertView.center == view.center
        }

        alertView.addActions(actions)

        constrain(blurView, alertView) {blur, view in
            blur.edges == view.edges
        }
    }
}

/// Private transition for presenting and dismissal.
private class PopupViewControllerTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var presenting = true
    weak var fromVC : UIViewController!
    weak var toVC: UIViewController!

    override init() {

    }

    init(fromVC: UIViewController, toVC: UIViewController) {
        self.fromVC = fromVC
        self.toVC = toVC
    }

    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        if (presenting) {
            let alertController = toVC as! PopupViewController

            containerView.addSubview(alertController.view!)

            alertController.view.alpha = 0
            alertController.alertView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            alertController.blurView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                       delay: 0,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 15,
                                       options: UIViewAnimationOptions(),
                                       animations: {
                                        alertController.view.alpha = 1
                                        alertController.alertView.layer.transform = CATransform3DIdentity
                                        alertController.blurView.layer.transform = CATransform3DIdentity
                }, completion: { (completed) in
                    if completed {
                        self.toVC.view.alpha = 1
                        transitionContext.completeTransition(true)
                    }
            })
        } else {
            let alertController = fromVC as! PopupViewController
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                       delay: 0,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 15,
                                       options: UIViewAnimationOptions(),
                                       animations: {
                                        alertController.view.alpha = 0
                                        alertController.alertView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
                                        alertController.blurView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
                }, completion: { (completed) in
                    if completed {
                        transitionContext.completeTransition(true)
                    }
            })
        }
    }

}

private class PopupAlertView: UIView {

    let titleLabel: PopupAlertLabel
    let messageLabel: PopupAlertLabel
    var buttons: [PopupAlertButton] = []
    let completionHandler: ((PopupAlertView) -> Void)?
    let customizable: PopupViewController.Customizable

    init(title: String, message: String, customizable: PopupViewController.Customizable, completionHandler: ((PopupAlertView) -> Void)?) {
        self.titleLabel = PopupAlertLabel(text: title)
        self.messageLabel = PopupAlertLabel(text: message)
        self.customizable = customizable
        self.completionHandler = completionHandler

        super.init(frame: CGRect.zero)

        addSubview(titleLabel)
        addSubview(messageLabel)

        backgroundColor = UIColor.clear

        titleLabel.font = customizable.titleFont
        titleLabel.textColor = customizable.titleColor

        messageLabel.font = customizable.messageFont
        messageLabel.textColor = customizable.messageColor

        layer.masksToBounds = true
        layer.cornerRadius = 6
        layer.borderWidth = 0.5
        layer.borderColor = customizable.alertBorderColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func addActions(_ actions: [PopupAction]) {

        for action in actions {

            let button = PopupAlertButton(action: action, customizable: customizable, touchHandler: {button in
                if let completionHandler = self.completionHandler {
                    completionHandler(self)
                }
            })

            addSubview(button)

            if let lastButton = buttons.last {
                constrain(self, button, lastButton){view, button, lastButton in
                    button.height == 50
                    button.top == lastButton.bottom
                    button.left == view.left
                    button.right == view.right
                }

            } else {
                constrain(self, button, messageLabel){view, button, messageLabel in
                    button.height == 50
                    button.top == messageLabel.bottom + 15
                    button.left == view.left
                    button.right == view.right
                }
            }
            buttons.append(button)
        }

        if let lastButton = buttons.last {
            constrain(self, lastButton) {view, lastButton in
                view.bottom == lastButton.bottom
            }
        }
    }

    fileprivate override func updateConstraints() {
        super.updateConstraints()

        constrain(self, titleLabel) {view, label in
            label.top == view.top + 15
            label.left == view.left + 15
            label.right == view.right - 15
        }

        titleLabel.sizeToFit()

        constrain(titleLabel, messageLabel) {title, message in
            message.top == title.bottom + 10
            message.left == title.left
            message.right == title.right
        }

        messageLabel.sizeToFit()

    }
}

private class PopupAlertLabel: UILabel {

    init(text: String) {
        super.init(frame: CGRect.zero)

        self.text = text
        textAlignment = .center
        numberOfLines = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private class PopupAlertButton: UIButton {

    var hightlight = false {
        didSet {
            UIView.animate(withDuration: 0.15) {
                switch self.action!.actionType! {
                case .positive:
                    self.backgroundColor = self.hightlight ?
                        self.customizable.positiveActionHighlightColor : self.customizable.positiveActionBackgroundColor
                    break
                case .negative:
                    self.backgroundColor = self.hightlight ?
                        self.customizable.negativeActionHighlightColor : self.customizable.negativeActionBackgroundColor
                    break
                }
            }
        }
    }

    fileprivate let topBorder = UIView(frame: CGRect.zero)

    var action: PopupAction?
    var handler: ((PopupAlertButton) -> Void)?
    var customizable: PopupViewController.Customizable!

    init(action: PopupAction, customizable: PopupViewController.Customizable, touchHandler: ((PopupAlertButton) -> Void)?) {
        super.init(frame: CGRect.zero)

        self.customizable = customizable
        self.action = action
        self.handler = touchHandler

        setTitle(action.title!, for: UIControlState())

        topBorder.backgroundColor = customizable.actionsSeparatorColor

        switch action.actionType! {
        case .positive:
            titleLabel?.font = customizable.postiveActionFont
            backgroundColor = customizable.positiveActionBackgroundColor
            setTitleColor(customizable.positiveActionColor, for: UIControlState())
            break
        case .negative:
            titleLabel?.font = customizable.negativeActionFont
            backgroundColor = customizable.negativeActionBackgroundColor
            setTitleColor(customizable.negativeActionColor, for: UIControlState())
            break
        }

        addTarget(self, action: #selector(PopupAlertButton.onActionTap), for: .touchUpInside)
        addSubview(topBorder)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onActionTap() {
        if let actionHandler = action!.handler {
            actionHandler(action!)
        }
        if let handler = handler {
            handler(self)
        }
    }

    fileprivate override func updateConstraints() {
        constrain(self, topBorder){view, border in
            border.left == view.left
            border.right == view.right
            border.height == 0.5
            border.top == view.top
        }

        super.updateConstraints()
    }

    fileprivate override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        hightlight = true
    }

    fileprivate override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        hightlight = false
    }
}
