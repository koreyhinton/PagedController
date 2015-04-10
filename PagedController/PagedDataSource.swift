//
//  PagedDataSource.swift
//  PagedIteratorExample
//
//  Created by Korey Hinton on 4/10/15.
//  Copyright (c) 2015 Korey Hinton. All rights reserved.
//

import Foundation
import UIKit

enum PageState {
    case HasNextHasPrevious, HasNext, HasPrevious, NoNextNoPrevious
    
    static func pageStateForNext(next: Bool, previous: Bool) -> PageState {
        if next == true && previous == true {
            return PageState.HasNextHasPrevious
        } else if next == true {
            return PageState.HasNext
        } else if previous == true {
            return PageState.HasPrevious
        } else {
            return PageState.NoNextNoPrevious
        }
    }
}

class PagedDataSource: NSObject, UIPageViewControllerDataSource  {
    
    var pagedIterator: PagedIterator<UIViewController>
    weak var pagedController: PagedController?
    private var loops: Bool
    
    var pageStateCompletion: ((state: PageState)->Void)?
    
    init(viewControllers: [UIViewController], loops: Bool,pageStateCompletion: ((state: PageState)->Void)? = nil) {
        pagedIterator = PagedIterator<UIViewController>(objects: viewControllers)
        pagedIterator.loops = loops
        self.loops = loops
        self.pageStateCompletion = pageStateCompletion
        super.init()
    }
    
    func load(pagedController: PagedController) {
        self.pagedController = pagedController
        pagedIterator.first()
        assignCurrent(false)
    }
    

    func addCurrent(viewController: UIViewController, animated: Bool) {
        pagedIterator.addCurrent(viewController)
        assignCurrent(animated)
    }
    func addNext(viewController: UIViewController, animated: Bool) {
        pagedIterator.addNext(viewController)
        assignCurrent(animated)
    }
    func addPrevious(viewController: UIViewController, animated: Bool) {
        pagedIterator.addPrevious(viewController)
        assignCurrent(animated,direction:.Reverse)
    }
    func addLast(viewController: UIViewController, animated:Bool) {
        pagedIterator.addLast(viewController)
        assignCurrent(animated)
    }
    func addFirst(viewController: UIViewController, animated:Bool) {
        pagedIterator.addFirst(viewController)
        assignCurrent(animated)
    }
    
    @objc private func moveNext() {
        moveNext(true)
    }
    func moveNext(animated: Bool) {
        if pagedIterator.next(peek: true) != nil {
            pagedIterator.next()
        }
        assignCurrent(animated)
    }
    
    
    @objc private func movePrevious() {
        movePrevious(true)
    }
    func movePrevious(animated: Bool) {
        if pagedIterator.previous(peek: true) != nil {
            pagedIterator.previous()
        }
        assignCurrent(animated, direction: .Reverse)
    }
    
    @objc private func moveFirst() {
        moveFirst(true)
    }
    func moveFirst(animated: Bool) {
        pagedIterator.first()
        assignCurrent(animated,direction: .Reverse)
    }
    
    @objc private func moveLast() {
        moveLast(true)
    }
    func moveLast(animated: Bool) {
        pagedIterator.last()
        assignCurrent(animated)
    }
    
    func moveToIndex(index:Int, animated: Bool, direction: UIPageViewControllerNavigationDirection = .Forward) {
        if pagedIterator.toIndex(index, peek: true) != nil {
            pagedIterator.toIndex(index)
        }
        assignCurrent(animated, direction: direction)
    }
    
    @objc private func removeCurrent() {
        if pagedIterator.next(peek: true) == nil {
            removeCurrent(.Reverse)
        } else {
            removeCurrent(.Forward)
        }
    }
    func removeCurrent(direction: UIPageViewControllerNavigationDirection) -> UIViewController? {
        var oldCurrent = pagedIterator.removeCurrent()
        if oldCurrent != nil {
            assignCurrent(true, direction:direction)
        }
        return oldCurrent
    }
    
    @objc func removeNext() -> UIViewController? {
        var oldNext = pagedIterator.removeNext()
        assignCurrent(false)
        return oldNext
    }
    
    @objc func removePrevious() -> UIViewController? {
        var oldPrevious = pagedIterator.removePrevious()
        assignCurrent(false)
        return oldPrevious
    }
    
    @objc func removeLast() -> UIViewController {
        var oldLast = pagedIterator.removeLast()
        assignCurrent(false)
        return oldLast
    }
    
    @objc func removeFirst() -> UIViewController {
        var oldFirst = pagedIterator.removeFirst()
        assignCurrent(false)
        return oldFirst
    }
    
    
    
    private func assignCurrent(animated: Bool, direction: UIPageViewControllerNavigationDirection = .Forward) {
        if animated == true {
            pagedController!.disablePagingIfNecessary()
        }

        self.pagedController!.setViewControllers([pagedIterator.current()!], direction: direction, animated: animated) { (completed) -> Void in
            if animated == true && completed == true {
                self.pagedController!.enablePagingIfNecessary()
            }
            self.updatePageState()
        }
    }
    
    func updatePageState() {
        if self.pageStateCompletion != nil {
            self.pageStateCompletion!(state: PageState.pageStateForNext(self.pagedIterator.next(peek: true) !== nil, previous: self.pagedIterator.previous(peek: true) != nil))
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return pagedIterator.previous(peek: true)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return pagedIterator.next(peek: true)
    }

    
}