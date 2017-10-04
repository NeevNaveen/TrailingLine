//
//  ViewController.swift
//  TrailingLine
//
//  Created by Successive Software on 9/29/17.
//  Copyright © 2017 Naveen Nautiyal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var doneLoading: Bool = false;
    var trailView: TrailContainer!;
    
    @IBOutlet var xField: UITextField!;
    @IBOutlet var yField: UITextField!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        if !doneLoading
        {
            initialize();
        }
    }
}


extension ViewController{
    func initialize ()
    {
        doneLoading = true;
        
        trailView = TrailContainer.init(frame: CGRect(x:0,y:20,width:self.view.frame.size.width,height:200));
        self.view.addSubview(trailView);
    }
    
    @IBAction func updateDestination ()
    {
        let x = (xField.text! as NSString).doubleValue;
        let y = (yField.text! as NSString).doubleValue;
        
        trailView.setPositionForDestination(position: CGPoint(x:x,y:y));
    }
}
