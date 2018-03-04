//
//  TermsController.swift
//  Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class TermsController: UIViewController {

    // UI
    @IBOutlet private weak var pageWebView: UIWebView!
    private var interfaceLoader: InterfaceLoader!

    // MARK: Life circle
    public init() {
        super.init(nibName: "TermsControllerView", bundle: Bundle.main)
    }
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        pageWebView.delegate = self
        pageWebView.loadRequest(URLRequest(url: URL(string: "http://medvedstudio.azurewebsites.net/restomania-terms-user.html")!))

        interfaceLoader = InterfaceLoader(for: self.view)
        interfaceLoader.show()

        navigationItem.title = Keys.title.localized
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension TermsController: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        interfaceLoader.hide()
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        interfaceLoader.hide()

        self.showToast(Keys.problemWithLoadMessage)
    }
}
extension TermsController {
    public enum Keys: String, Localizable {

        public var tableName: String {
            return String.tag(TermsController.self)
        }

        case title = "Title"

        case problemWithLoadMessage = "Errors.ProblemWithLoad.Message"
    }
}
