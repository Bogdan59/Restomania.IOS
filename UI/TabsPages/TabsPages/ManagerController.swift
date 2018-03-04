//
//  ManagerController.swift
//  Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit
import MdsKit
import CoreTools
import UITools
import UIElements
import UIServices

public class ManagerController: UIViewController {

    private let _tag = "ManagerController"

    //UI
    @IBOutlet private weak var LogoutButton: UIButton!

    private let authService = DependencyResolver.resolve(AuthUIService.self)
    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let keysService = DependencyResolver.resolve(ApiKeyService.self)

    //Properties
    private var isAuth: Bool {
        return keysService.isAuth
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        authService = AuthService(open: .signup, with: self.navigationController!)

        loadMarkup()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func loadMarkup() {

        view.backgroundColor = colorsTheme.contentBackground

        LogoutButton.isHidden = !isAuth
    }

    @IBAction public func Logout() {

        keysService.logout()
        LogoutButton.isHidden = true
    }

    // MARK: Navigate to sub managers screens
    @IBAction public func goToEditProfile() {
//        presentSubmanager(controller: ManagerEditProfileController())
    }
    @IBAction public func goToEditNotificationPreferences() {
//        presentSubmanager(controller: ManagerEditNotificationPreferencesController())
    }
    @IBAction public func goToChangePassword() {
        present(ManagerChangePasswordController.create())
    }
    @IBAction public func goToPaymentCards() {
        present(ManagerPaymentCardsController())
    }
    @IBAction public func goToOrders() {
        present(ManagerOrdersController())
    }
    @IBAction public func goToTerms() {
        present(TermsController(), needAuth: false)
    }
    private func present(_ controller: UIViewController, needAuth: Bool = true) {

        if (!needAuth || isAuth) {
            navigationController?.pushViewController(controller, animated: true)
            return
        }

        authService.show(complete: { success in
            if (success) {
                self.present(controller, needAuth: needAuth)
            }
        })
    }
}
