//
//  SignupController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 15.08.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import Foundation

public class SignupController: BaseAuthController {

    public static let nibName = "SignupPage"

    @IBOutlet weak var Signup: BlackButton!
    @IBOutlet weak var Login: WhiteButton!
    @IBOutlet weak var ForgetPassword: UIButton!

    private var _interfaceLoader: InterfaceLoader!

    override public func viewDidLoad() {
        super.viewDidLoad()

        let theme = AppSummary.current.theme
        ForgetPassword.tintColor = theme.blackColor
        ForgetPassword.titleLabel?.font = UIFont(name: theme.susanBookFont, size: theme.subheadFontSize)!

        _interfaceLoader = InterfaceLoader(for: self.view)
    }

    //Sign up
    @IBAction public func signUpAction() {

        if (!isValidLogin() || !isValidPassword()) {
            return
        }

        _interfaceLoader.show()

        let container = authContainer
        let task = client.SignUp(email: container.login, password: container.password, rights: container.rights)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._interfaceLoader.hide()

                //Success result
                if (response.isSuccess) {

                    self.storage.set(keys: response.data!, for: container.rights)
                    self.root!.close()

                    return
                }

                //Process errors
                let title = NSLocalizedString("Authorization error", comment: "Auth")
                if (response.statusCode == .ConnectionError) {

                    self.showAlert(about: NSLocalizedString("No internet connection.", comment: "Network"), title: title)
                } else if (response.statusCode == .BadRequest) {

                    self.showAlert(about: NSLocalizedString("Account with same email founded. Maybe you have an account?", comment: "Auth"), title: title)
                } else {

                    self.showAlert(about: NSLocalizedString("Try signup later.", comment: "Auth"), title: title)
                }
            }
        })
    }
    //Login
    @IBAction public func loginAction() {

//        root?.moveTo(.Login)
        unfocusControls()

        if (!isValidLogin() || !isValidPassword()) {
            return
        }

        _interfaceLoader.show()

        let container = authContainer
        let task = client.Login(email: container.login, password: container.password, rights: container.rights)
        task.async(.background, completion: { response in

            DispatchQueue.main.async {

                self._interfaceLoader.hide()

                //Success result
                if (response.isSuccess) {

                    self.storage.set(keys: response.data!, for: container.rights)
                    self.root!.close()

                    return
                }

                //Process errors
                let title = NSLocalizedString("Authorization error", comment: "Auth")
                if (response.statusCode == .ConnectionError) {

                    self.showAlert(about: NSLocalizedString("No internet connection.", comment: "Network"), title: title)
                } else if (response.statusCode == .BadRequest) {

                    self.showAlert(about: NSLocalizedString("Not valid login or password.", comment: "Auth"), title: title)
                } else {

                    self.showAlert(about: NSLocalizedString("Try login later.", comment: "Auth"), title: title)
                }
            }
        })
    }

    @IBAction public func forgetPasswordAction() {

        root?.moveTo(.ForgetPassword)
    }
}
