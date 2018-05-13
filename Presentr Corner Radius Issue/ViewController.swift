//
//  ViewController.swift
//  Presentr Corner Radius Issue
//
//  Created by Martin Otyeka on 2018-05-13.
//  Copyright © 2018 Dopeness Academy. All rights reserved.
//

import UIKit
import Pageboy
import SnapKit
import Presentr

class PageViewController: PageboyViewController, PageboyViewControllerDelegate, PageboyViewControllerDataSource {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
        }
        for _ in 0...3 {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .random
            self.viewControllers.append(viewController)
        }
        self.isScrollEnabled = true
        self.bounces = false
        self.delegate = self
        self.dataSource = self
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        self.label.text = "Page: \(String(index))"
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return Page.at(index: 0)
    }
    
}


class BaseViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Touch Me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.button)
        self.button.snp.makeConstraints({ (make) in
            make.center.equalTo(view.snp.center)
        })
    }
    
    @objc func tap() {
        self.customPresentViewController(cardDismissable, viewController: PageViewController(), animated: true)
    }
}

public let cardDismissable: Presentr = {
    let width = ModalSize.custom(size: floorf(Float(UIScreen.main.bounds.width * 0.94)))
    let height = ModalSize.custom(size: floorf(Float(UIScreen.main.bounds.width * 0.65)))
    let center = ModalCenterPosition.center
    let card = PresentationType.custom(width: width, height: height, center: center)
    let presenter = Presentr(presentationType: card)
    presenter.cornerRadius = (UIScreen.main.bounds.width - 32) * 0.03
    presenter.dismissOnSwipe = true
    presenter.dismissAnimated = true
    presenter.backgroundOpacity = 0
    return presenter
}()

public extension Collection where Index == Int {
    
    public var random: Element? {
        guard !isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

public extension UIColor {
    
    public class var random: UIColor {
        let colors: [UIColor] = [.blue, .yellow, .red, .purple, .gray, .green]
        return colors.random ?? .yellow
    }
}
