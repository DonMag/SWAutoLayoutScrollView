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
	@IBOutlet weak var pScrollView: UIScrollView!
	@IBOutlet weak var theLabel: UILabel!
	
	var imgURLs = ["a", "b", "c", "d", "e", "f"]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

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

		
		// add simple subviews
		self.addMyViews(8, vWidth: 160, vHeight: 120, vSpacing: 16, bCentered: true)
		
		// or, add images as subviews
//		self.setOfferImages(imgURLs)

		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func doTap(sender: AnyObject) {
		print("do tap")
	}
	
	func addControlsInView() -> Void {
		
		
		
		
	}
	
	// Set constraints using Anchors and "activate"
	func addMyViews(n: Int, vWidth: CGFloat, vHeight: CGFloat, vSpacing: CGFloat, bCentered: Bool) {
		
		var prevView: AnyObject?
		
		for i in 1...n {
			
			// load an instance of our SampleView... would have proper error handling in real-world-usage
			guard let v = UINib(nibName: "SampleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView else { return }
			
			v.translatesAutoresizingMaskIntoConstraints = false
			
			// the UILabel in our SampleView was assigned a Tag of 99 in IB... would have proper error handling in real-world-usage
			guard let lbl = v.viewWithTag(99) as? UILabel else { return }
			lbl.text = "\(i)"
			
			// add this view to the ScrollView
			self.theScrollView.addSubview(v)
			
			var horizontalConstraint = NSLayoutConstraint()
			var verticalConstraint = NSLayoutConstraint()
			
			if prevView == nil {
				
				horizontalConstraint = v.leadingAnchor.constraintEqualToAnchor(v.superview?.leadingAnchor, constant: vSpacing)
				
			} else {
				
				if let pv = prevView as? UIView {
					horizontalConstraint = v.leadingAnchor.constraintEqualToAnchor(pv.trailingAnchor, constant: vSpacing)
				}
				
			}
			
			if bCentered {
				
				// set the CenterY of our SampleView equal to the CenterY of the ScrollView
				
				verticalConstraint = v.centerYAnchor.constraintEqualToAnchor(v.superview?.centerYAnchor)
				
			} else {
				
				// set the Top of our SampleView equal to the Top of the ScrollView + Spacing
				
				verticalConstraint = v.topAnchor.constraintEqualToAnchor(v.superview?.topAnchor, constant: vSpacing)
				
			}
			
			NSLayoutConstraint.activateConstraints([
				horizontalConstraint,
				verticalConstraint,
				v.widthAnchor.constraintEqualToConstant(vWidth),
				v.heightAnchor.constraintEqualToConstant(vHeight)
				])
			
			// assign the "current view" reference to the "previous" reference
			prevView = v
			
		}
		
		// add a "closing" Horizontal constraint, to pin the right edge of the last view to the right-edge of the ScrollView - sort of...
		// because the First added view is pinned to the left, and the Last added view is pinned to the right, the contentSize is "auto-magically" handled
		
		if let pv = prevView as? UIView {
			NSLayoutConstraint.activateConstraints([
				self.theScrollView.trailingAnchor.constraintEqualToAnchor(pv.trailingAnchor, constant: vSpacing)
				])
		}
		
		let btn = UIButton(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
		btn.setTitle("abc", forState: UIControlState())
		btn.addTarget(self, action: #selector(ViewController.doTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		self.theScrollView.addSubview(btn)
		
	}
	

	
	// Set constraints creating Constraints and adding them to views
	func addMyViewsOldStyle(n: Int, vWidth: Int, vHeight: Int, vSpacing: Int, bCentered: Bool) {
		
		var curView: AnyObject?
		var prevView: AnyObject?
		var vConstraint: NSLayoutConstraint?
		
		for i in 1...n {
			
			// load an instance of our SampleView... would have proper error handling in real-world-usage
			guard let v = UINib(nibName: "SampleView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView else { return }
			
			v.translatesAutoresizingMaskIntoConstraints = false
			
			// the UILabel in our SampleView was assigned a Tag of 99 in IB... would have proper error handling in real-world-usage
			guard let lbl = v.viewWithTag(99) as? UILabel else { return }
			lbl.text = "\(i)"
			
			// add this view to the ScrollView
			self.theScrollView.addSubview(v)
			
			curView = v
			
			if (prevView == nil) {
				
				vConstraint = NSLayoutConstraint(item: v,
				                                 attribute: .Leading,
				                                 relatedBy: .Equal,
				                                 toItem: self.theScrollView,
				                                 attribute: .Leading,
				                                 multiplier: 1.0,
				                                 constant: CGFloat(vSpacing))
				
			} else {
				
				vConstraint = NSLayoutConstraint(item: v,
				                                 attribute: .Leading,
				                                 relatedBy: .Equal,
				                                 toItem: prevView,
				                                 attribute: .Trailing,
				                                 multiplier: 1.0,
				                                 constant: CGFloat(vSpacing))
				
			}
			
			self.theScrollView.addConstraint(vConstraint!)
			
			// set the width & height
			
			vConstraint = NSLayoutConstraint(item: v,
			                                 attribute: .Width,
			                                 relatedBy: .Equal,
			                                 toItem: nil,
			                                 attribute: .Width,
			                                 multiplier: 1.0,
			                                 constant: CGFloat(vWidth))
			
			self.theScrollView.addConstraint(vConstraint!)
			
			
			vConstraint = NSLayoutConstraint(item: v,
			                                 attribute: .Height,
			                                 relatedBy: .Equal,
			                                 toItem: nil,
			                                 attribute: .Height,
			                                 multiplier: 1.0,
			                                 constant: CGFloat(vHeight))
			
			self.theScrollView.addConstraint(vConstraint!)
			
			
			if bCentered {
				
				
				// now set the CenterY of our SampleView equal to the CenterY of the ScrollView
				
				vConstraint = NSLayoutConstraint(item: v,
				                                 attribute: .CenterY,
				                                 relatedBy: .Equal,
				                                 toItem: self.theScrollView,
				                                 attribute: .CenterY,
				                                 multiplier: 1.0,
				                                 constant: 0)
				
				self.theScrollView.addConstraint(vConstraint!)
				
				
			}
			
			// assign the "current SampleView" reference to the "previous" reference
			
			prevView = v
			
		}
		
		// add a "closing" Horizontal constraint, to pin the right edge of the last view to the right-edge of the ScrollView - sort of...
		// because the First added view is pinned to the left, and the Last added view is pinned to the right, the contentSize is "auto-magically" handled
		
		guard let v = curView else { return }
		
		vConstraint = NSLayoutConstraint(item: self.theScrollView,
		                                 attribute: .Trailing,
		                                 relatedBy: .Equal,
		                                 toItem: v,
		                                 attribute: .Trailing,
		                                 multiplier: 1.0,
		                                 constant: CGFloat(vSpacing))
		
		self.theScrollView.addConstraint(vConstraint!)
		
		
	}
	

	// Set constraints using Visual Format Language
	func addMyViewsVFL(n: Int, vWidth: Int, vHeight: Int, vSpacing: Int, bCentered: Bool) {
		
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

		for (i, _) in imageURLs.enumerate() {
			
			let imgView = UIImageView()
			imgView.backgroundColor = UIColor.redColor()
			imgView.translatesAutoresizingMaskIntoConstraints = false
			imgView.contentMode = UIViewContentMode.ScaleAspectFit
			
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

