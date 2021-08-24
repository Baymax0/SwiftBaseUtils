//
//  AnyViewSource.swift
//  CollectionKitExample
//
//  Created by Luke Zhao on 2018-06-06.
//  Copyright © 2018 lkzhao. All rights reserved.
//



public protocol AnyViewSource {
  func anyView(data: Any, index: Int) -> UIView
  func anyUpdate(view: UIView, data: Any, index: Int)
}
