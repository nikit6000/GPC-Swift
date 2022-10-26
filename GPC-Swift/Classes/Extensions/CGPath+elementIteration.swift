//
//  CGPath+elementIteration.swift
//  GPC-Swift
//
//  Created by Nikita on 24.10.2022.
//

import Foundation
import CoreGraphics

extension CGPath {
	
	func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
		
		typealias Body = @convention(block) (CGPathElement) -> Void
		
		let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
			let body = unsafeBitCast(info, to: Body.self)
			body(element.pointee)
		}
		
		let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
		self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
	}
}
