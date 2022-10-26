//
//  Comparable+clamped.swift
//  GPC-Swift
//
//  Created by Nikita on 24.10.2022.
//

import Foundation

extension Comparable {
	
	func clamped(to limits: ClosedRange<Self>) -> Self {
		return min(max(self, limits.lowerBound), limits.upperBound)
	}
}
