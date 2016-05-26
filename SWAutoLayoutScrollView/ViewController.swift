//
//  ViewController.swift
//  SWAutoLayoutScrollView
//
//  Created by DonMag on 5/18/16.
//  Copyright © 2016 DonMag. All rights reserved.
//

import UIKit

extension MutableCollectionType where Self.Index == Int {
	func shuffle() -> Self {
		var r = self
		let c = self.count
		for i in 0..<(c - 1) {
			let j = Int(arc4random_uniform(UInt32(c - i))) + i
			if i != j {
				swap(&r[i], &r[j])
			}
		}
		return r
	}
}

class ViewController: UIViewController {

	@IBOutlet weak var theScrollView: UIScrollView!
	@IBOutlet weak var pScrollView: UIScrollView!
	@IBOutlet weak var theLabel: UILabel!
	
	var imgURLs = ["a", "b", "c", "d", "e", "f"]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

	
		
		var vcnt = self.theScrollView.subviews.count
		
		print("pre  subviews [\(vcnt)]")
		
		theScrollView.removeFromSuperview()
		theLabel.removeFromSuperview()
		
		theScrollView.translatesAutoresizingMaskIntoConstraints = false
		theLabel.translatesAutoresizingMaskIntoConstraints = false
		
		pScrollView.addSubview(theScrollView)
		pScrollView.addSubview(theLabel)
		
		var d = [String:AnyObject]()
		d["theScrollView"] = theScrollView
		d["theLabel"] = theLabel
		d["sv"] = pScrollView
		
		
		var hFmt = "H:|[theScrollView(==sv)]|"
		
		pScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: nil, views: d))

		hFmt = "V:|[theScrollView(250)]-700-[theLabel]|"

		pScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: nil, views: d))

		hFmt = "H:|-40-[theLabel]"
		
		pScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFmt, options: [], metrics: nil, views: d))

		
//		self.addMyViews(8, vWidth: 200, vHeight: 200, vSpacing: 10, bCentered: true)
		
		self.setOfferImages(imgURLs)

		
		vcnt = self.theScrollView.subviews.count
		
		print("post subviews [\(vcnt)]")
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func testTap(sender: AnyObject) {
		var x = 1
		x = 2
		
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
	
	
	func setOfferImages(imageURLs: [String]?) {
		let imageURLs = imageURLs ?? []
		
		let offerImageScrollView = theScrollView
		
		let bundlePath = NSBundle.mainBundle().pathForResource("swift1", ofType: "png")
		let swImage = UIImage(contentsOfFile: bundlePath!)
		
		var views = [String:AnyObject]()

		for (i, imgURL) in imageURLs.enumerate() {
			let imgView = UIImageView()
			imgView.backgroundColor = UIColor.redColor()
			imgView.translatesAutoresizingMaskIntoConstraints = false
			imgView.contentMode = UIViewContentMode.ScaleAspectFit
			
//			if let imgURL = NSURL(string: imgURL) {
//				imgView.setImageWithURL(imgURL, placeholder: UIUtils.DEFAULT_IMAGE)
//			} else {
//				imgView.image = UIUtils.DEFAULT_IMAGE
//			}
			
			imgView.image = swImage
			
			offerImageScrollView.addSubview(imgView)

			views["view\(i)"] = imgView
		}
		
		//MARK: Layout imageViews

		var imageViewConstraints = [NSLayoutConstraint]()
		var vflString = ""

		vflString += "H:|[view0]"
		for i in 1..<views.count {
			vflString += "[view\(i)(==view0)]"
		}
		vflString += "|"
		
		let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(vflString, options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views)
		let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view0]|", options: [], metrics: nil, views: views)
		imageViewConstraints += horizontalConstraint + verticalConstraint
		NSLayoutConstraint.activateConstraints(imageViewConstraints)
		
		if let view0 = views.first?.1 {
			NSLayoutConstraint(item: view0, attribute: .Width, relatedBy: .Equal, toItem: offerImageScrollView, attribute: .Width, multiplier: 1, constant: 0).active = true
			NSLayoutConstraint(item: view0, attribute: .Height, relatedBy: .Equal, toItem: offerImageScrollView, attribute: .Height, multiplier: 1, constant: 0).active = true
		}
	}
	
}

