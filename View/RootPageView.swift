//
//  ViewController.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit
import Firebase

class RootPageView: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var leftBtn: UIButton!
    var rightBtn: UIButton!
    var logOutButton: UIBarButtonItem!
    var hasParent: Bool = false
    lazy var viewControllerList:[UIViewController] = {
        let vc1 = SearchController()
        let vc2 = RecentController()
        let vc3 = SettingController()
        
        return [vc1, vc2, vc3]
    }()

    // MARK: - VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.dataSource = self
        self.delegate = self
        if let _ = viewControllerList.first {
            self.setViewControllers([viewControllerList[1]], direction: .forward, animated: true, completion: nil)
        }
        
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        leftBtn = addFloatingButtons(isLeft: true, size: 40)
        rightBtn = addFloatingButtons(isLeft: false, size: 40)
        self.view.addSubview(leftBtn)
        self.view.addSubview(rightBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setup or update realm
    }
    
    func setupNavigationBar() {
        view.backgroundColor = BASE_BACKGROUND_COLOR
        navigationController?.navigationBar.barTintColor = BASE_BACKGROUND_COLOR
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView?.tintColor = .white
        
        logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        logOutButton.tintColor = .white
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    // MARK: - PAGE CONTROLLER
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let prevIndex = vcIndex - 1
        if prevIndex < 0 || prevIndex >= viewControllerList.count { return nil }
        
        return viewControllerList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        if nextIndex >= viewControllerList.count { return nil }
        
        return viewControllerList[nextIndex]
    }
    
    // MARK: - HELPER FUNCTIONS
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            if hasParent {
                dismiss(animated: true, completion: nil)
            } else {
                let vc = AccountController()
                vc.hasParent = true
                present(vc, animated: true, completion: nil)
            }
        } catch let error {
            print("FATAL ERROR: \(error)")
        }
    }
    
}

