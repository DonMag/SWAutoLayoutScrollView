//
//  ViewController.swift
//  SWAutoLayoutScrollView
//
//  Created by DonMag on 5/18/16.
//  Copyright © 2016 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var theScrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.addMyViews(8, vWidth: 200, vHeight: 200, vSpacing: 10, bCentered: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func addMyViews(n: Int, vWidth: Int, vHeight: Int, vSpacing: Int, bCentered: Bool) {
		
		var prevRef: String
		var currRef: String
		var vFmt: String
		var hFmt: String

		var dViews = [String:AnyObject]()
		
		let dMetrics: [String:Int] = [
			"width" : vWidth,
			"height" : vHeight
		]
		
		prevRef = ""
		
		for i in 1...n {

			// load an instance of our SampleView... would have proper error handling in real-world-usage
			guard let v = UINib(nibName: "SampleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView else { return }
			
			v.translatesAutoresizingMaskIntoConstraints = false
			
			// the UILabel in our SampleView was assigned a Tag of 99 in IB... would have proper error handling in real-world-usage
			guard let lbl = v.viewWithTag(99) as? UILabel else { return }
			lbl.text = "\(i)"
			
			// add this view to the ScrollView
			self.theScrollView.addSubview(v)
			
			// create a string "named" reference to the current view
			currRef = "mv\(i)"
			
			// add this view to our Views dictionary
			dViews[currRef] = v
			
			if (prevRef == "") {

				// if this is the first view, add an "Opening" Horizontal constraint by pinning it to the left
				hFmt = "H:|[\(currRef)(width)]"

				// use this format if you want left / leading padding
				// hFmt = "H:|-\(vSpacing)-[\(currRef)(width)]"
				
			} else {
				
				// this is not the first view, so we pin it to the previous view, with spacing
				hFmt = "H:[\(prevRef)]-\(vSpacing)-[\(currRef)(width)]"
				
			}
			
			// add the Horizontal constraints
			self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: dMetrics, views: dViews))

			
			if bCentered {
				
				// Center vertically in scroll view
				
				// first, set the height constraint of our SampleView
				vFmt = "V:[\(currRef)(height)]";
				self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFmt, options: [], metrics: dMetrics, views: dViews))

				// now set the CenterY of out SampleView equal to the CenterY of the ScrollView
				let c = NSLayoutConstraint(
					item: v,
					attribute: NSLayoutAttribute.CenterY,
					relatedBy: NSLayoutRelation.Equal,
					toItem: self.theScrollView,
					attribute: NSLayoutAttribute.CenterY,
					multiplier: 1,
					constant: 0)

				self.theScrollView.addConstraint(c)
				
				
			} else {
				
				// aligned to top of scroll view
				
				// also sets the height constraint
				vFmt = "V:[\(currRef)(height)]"
				self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFmt, options: [], metrics: dMetrics, views: dViews))
				
			}

			// assign the "current SampleView" reference to the "previous" reference
			prevRef = currRef

		}
		
		// add a "closing" Horizontal constraint, to pin the right edge of the last view to the right-edge of the ScrollView - sort of...
		// because the First added view is pinned to the left, and the Last added view is pinned to the right, the contentSize is "auto-magically" handled
		hFmt = "H:[\(prevRef)]|"
		
		// use this format if you want right / trailing padding
		// hFmt = "H:[\(prevRef)]-\(vSpacing)-|"

		self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: dMetrics, views: dViews))
		
	}
	
}

