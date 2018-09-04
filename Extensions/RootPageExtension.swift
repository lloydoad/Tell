//
//  RootPageExtension.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import Foundation
import UIKit

extension RootPageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = fabs(point.x - view.frame.size.width)/view.frame.size.width
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: (1-percentComplete))]
        
        if 1 - percentComplete < 0.97{
            self.leftBtn.alpha = 1 - percentComplete
            self.rightBtn.alpha = 1 - percentComplete
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        floatingButtonControl()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        rightBtn.alpha = 0
        leftBtn.alpha = 0
        floatingButtonControl()
    }
    
    func addFloatingButtons(isLeft: Bool, size: CGFloat) -> UIButton {
        var button: UIButton
        
        if isLeft {
            button = UIButton(frame: CGRect(x: 15, y: (self.view.frame.height-size-15), width: size, height: size))
            button.setBackgroundImage(UIImage(named: "search"), for: .normal)
            button.tag = 0
        } else {
            button = UIButton(frame: CGRect(x: (self.view.frame.width-size-15), y: (self.view.frame.height-size-15), width: size, height: size))
            button.setBackgroundImage(UIImage(named: "setting"), for: .normal)
            button.tag = 1
        }
        
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.backgroundColor = UIColor.clear
        button.setTitleShadowColor(UIColor.black, for: .highlighted)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = size/2
        button.clipsToBounds = true
        
        return button
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        guard let currentVC = self.viewControllers?.first else {return}
        guard let currentIndex = viewControllerList.index(of: currentVC) else {return}
        var index: Int
        
        if sender.tag == 0 {
            index = currentIndex - 1
            self.setViewControllers([viewControllerList[index]], direction: .reverse, animated: true, completion: nil)
            floatingButtonControl()
        } else {
            index = currentIndex + 1
            self.setViewControllers([viewControllerList[index]], direction: .forward, animated: true, completion: nil)
            floatingButtonControl()
        }
    }
    
    func floatingButtonControl() {
        guard let title = self.viewControllers?.first?.title else {return}
        rightBtn.layer.zPosition = 1
        leftBtn.layer.zPosition = 1
        
        
        switch title {
        case "Settings":
            logOutButton.isEnabled = true
            logOutButton.tintColor = UIColor.white
            
            self.rightBtn.isEnabled = false
            self.rightBtn.isHidden = true
            self.leftBtn.isEnabled = true
            self.leftBtn.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.leftBtn.alpha = 1
            }
        case "Search":
            logOutButton.isEnabled = false
            logOutButton.tintColor = UIColor.clear
            
            self.leftBtn.isEnabled = false
            self.leftBtn.isHidden = true
            self.rightBtn.isEnabled = true
            self.rightBtn.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.rightBtn.alpha = 1
            }
        default:
            logOutButton.isEnabled = false
            logOutButton.tintColor = UIColor.clear
            
            self.rightBtn.isEnabled = true
            self.leftBtn.isEnabled = true
            self.rightBtn.isHidden = false
            self.leftBtn.isHidden = false
            
            UIView.animate(withDuration: 0.2) {
                self.rightBtn.alpha = 1
                self.leftBtn.alpha = 1
            }
        }
    }
}
