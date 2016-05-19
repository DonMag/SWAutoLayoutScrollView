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
		
		self.addMyViews(8, vWidth: 140, vHeight: 180, vSpacing: 10, bCentered: true)
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
		
		var v: UIView
		var lbl: UILabel

		var dViews = [String:AnyObject]()
		
		let dMetrics: [String:Int] = [
			"width" : vWidth,
			"height" : vHeight
		]
		
		prevRef = ""
		
		var i = 1
		
		while (i < n + 1) {
			
			currRef = "mv\(i)"
			
			v = UINib(nibName: "SampleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
			v.translatesAutoresizingMaskIntoConstraints = false
			lbl = v.viewWithTag(99) as! UILabel
			lbl.text = "\(i)"
			
			self.theScrollView.addSubview(v)
			
			dViews[currRef] = v
			
			if (prevRef == "") {
				hFmt = "H:|[\(currRef)(width)]"
			} else {
				hFmt = "H:[\(prevRef)]-\(vSpacing)-[\(currRef)(width)]"
			}
			
			self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: dMetrics, views: dViews))

			
			if bCentered {
				
				// Center vertically in scroll view
				
				vFmt = "V:[\(currRef)(height)]";
				self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFmt, options: [], metrics: dMetrics, views: dViews))

				let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
					"H:[scrollview]-(<=1)-[sampleview]",
					options: NSLayoutFormatOptions.AlignAllCenterY,
					metrics: nil,
					views: ["scrollview":self.theScrollView, "sampleview":v])
				
				view.addConstraints(constraints)
				
			} else {
				
				// aligned to top of scroll view
				
				vFmt = "V:|[\(currRef)(height)]|"
				
				self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFmt, options: [], metrics: dMetrics, views: dViews))
				
			}

			prevRef = currRef

			i = i + 1
			
		}
		
		hFmt = "H:[\(prevRef)]|"
		self.theScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: dMetrics, views: dViews))
		
	}
	
}

