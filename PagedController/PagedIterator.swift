//
//  PagedIterator.swift
//  PagedIteratorExample
//
//  Created by Korey Hinton on 4/10/15.
//  Copyright (c) 2015 Korey Hinton. All rights reserved.
//

import Foundation
import UIKit

class PagedIterator<T> {
    private var array = Array<T>()
    var loops: Bool = false
    private(set) var index = 0
    
    init(objects: [T]) {
        for obj in objects {
            array.append(obj)
        }
    }
    
    func toIndex(atIndex: Int, peek: Bool? = false) -> T? {
        var newIndex = atIndex
        
        if newIndex < count() && newIndex >= 0 && count() > 0 {

            if peek == false {
                index = newIndex
            }
            return array[newIndex]
        } else {
            return nil
        }
    }
    
    func current() -> T? {
        var current: T? = nil
        if count() > 0 {
            current = array[index]
        }
        return current
    }
    
    func last() -> T? {
        if count() == 0 {
            return nil
        } else {
            index = count() - 1
            return current()
        }
    }
    func first() -> T? {
        index = 0
        return current()
    }
    
    func next(peek: Bool? = false) -> T? {
        
        var next: T? = nil
        var nextIndex = index
        
        if count() == 0 {
            if peek == false {
                index = 0
            }
            return nil
        }
        
        if loops {
            if nextIndex == count() - 1 {
                nextIndex = 0
            } else {
                nextIndex += 1
            }
            
            next = array[nextIndex]
            
        } else {
            
            if nextIndex < count() - 1 {
                nextIndex += 1
                next = array[nextIndex]
            }
        }
        
        if peek == false {
            index = nextIndex
        }
        
        return next
    }
    func previous(peek: Bool? = false) -> T? {
        var previous: T? = nil
        var previousIndex = index
        
        if count() == 0 {
            if peek == false {
                index = 0
            }
            return nil
        }
        
        if loops {
            
            if previousIndex == 0 {
                previousIndex = count() - 1
                
            } else {
                previousIndex -= 1
            }
            previous = array[previousIndex]
        } else {
            if previousIndex > 0 {
                previousIndex -= 1
                previous = array[previousIndex]
            }
        }
        if peek == false {
            index = previousIndex
        }
        return previous
    }
    
    func addCurrent(object: T) {
        array.insert(object, atIndex: index)
    }
    func addNext(object: T) {
        array.insert(object, atIndex: index + 1)
    }
    func addPrevious(object: T) {
        array.insert(object, atIndex: index - 1)
    }
    func addFirst(object: T) {
        array.insert(object, atIndex: 0)
    }
    func addLast(object: T) {
        array.append(object)
    }
    
    func removeCurrent() -> T? {
        
        var canRemove = false
        
        if previous(peek: true) != nil || next(peek: true) != nil {
            canRemove = true
        }
        
        if canRemove {
            var item = array.removeAtIndex(index)
            if index == count() {
                previous()
            }
            return item
        } else {
            return nil
        }
    }
    
    func removeNext() -> T? {
        if next(peek: true) == nil {
            return nil
        } else {
            var item = array.removeAtIndex(index + 1)
            return item
        }
    }
    
    func removePrevious() -> T? {

        if previous(peek: true) == nil {
            return nil
        } else {
            var item = array.removeAtIndex(index - 1)
            return item
        }
    }
    
    func removeFirst() -> T {
        var item = array.removeAtIndex(0)
        return item
    }
    
    func removeLast() -> T {
        return array.removeLast()
    }
    
    func count() -> Int {
        return array.count
    }
    
    func all() -> [T] {
        return array
    }

    func currentIndex() -> Int {
        return index
    }
    
    func indexOf(object: T) -> Int {
        
        var cnt = 0
        for obj in array {
            if (obj as! NSObject) == (object as! NSObject) {
                return cnt
            }
            cnt += 1
        }
        return NSNotFound
    }
}
