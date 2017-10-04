//
//  TrailContainer.swift
//  TrailingLine
//
//  Created by Successive Software on 9/29/17.
//  Copyright © 2017 Naveen Nautiyal. All rights reserved.
//

import UIKit

class TrailContainer: UIView {

    fileprivate var sourceView: UIView!;
    fileprivate var destinationView: UIView!;

    // Source Properties
    fileprivate var sourceFrame: CGRect = CGRect(x:0,y:0,width:40,height:40);
    fileprivate var sourceBGColor: UIColor = UIColor.red;
    fileprivate var accessoryViewSource: UIView?;
    
    
    // Destination Properties
    fileprivate var destinationFrame: CGRect = CGRect(x:0,y:0,width:40,height:40);
    fileprivate var destinationBGColor: UIColor = UIColor.green;
    fileprivate var accessoryViewDestination: UIView?;
    
    
    // Trail
    @IBInspectable var trailColor: UIColor = UIColor.orange;
    @IBInspectable var trailTime: Float = 5.0;
    var trailDots = [UIView]();
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black;
        initializeTrailView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

/*
 //////////////////////////////
 MARK:-  public methods
 /////////////////////////////
 */
extension TrailContainer
{
    func initializeTrailView ()
    {
        // Adding Source and Destination view
        sourceFrame = CGRect(x:self.frame.size.width/2 - 20,y:self.frame.size.height/2 - 20,width:40,height:40);
        accessoryViewSource = UIView.init(frame: sourceFrame);
        accessoryViewSource?.backgroundColor = sourceBGColor;
        accessoryViewSource?.layer.cornerRadius = 20;
        
        accessoryViewDestination = UIView.init(frame: destinationFrame);
        accessoryViewDestination?.backgroundColor = destinationBGColor;
        accessoryViewDestination?.layer.cornerRadius = 20;
        
        // Creating Way Points
        createMidPointbetween(pointA: (accessoryViewSource?.center)!, pointB: (accessoryViewDestination?.center)!);
        
        // Adding Source Destination to view
        self.addSubview(accessoryViewSource!);
        self.addSubview(accessoryViewDestination!);
        
        sortAndAnimateWayPoints();
    }
    
    
    func setPositionForDestination(position: CGPoint)
    {
        for trailDot in trailDots
        {
            trailDot.removeFromSuperview();
        }
        trailDots.removeAll();
        destinationFrame = CGRect(x:position.x - 20,y:position.y - 20,width:40,height:40);
        accessoryViewDestination?.frame = destinationFrame;
        
        // Creating Way Points
        createMidPointbetween(pointA: (accessoryViewSource?.center)!, pointB: (accessoryViewDestination?.center)!);

        self.bringSubview(toFront: accessoryViewSource!);
        self.bringSubview(toFront: accessoryViewDestination!);
        
        sortAndAnimateWayPoints();
    }
   
}



/*
 ////////////////////////////////////////////////////////////
 MARK:-  Private Trail Methods and Calculations
 ///////////////////////////////////////////////////////////
 */
extension TrailContainer
{
    /*
     * Aranging the way points
     * Animating the way points
     */
    
    fileprivate func sortAndAnimateWayPoints ()
    {
        // Sorting List of Dots
        var tempArray = [UIView]();
        let startPoint = sourceFrame.origin;
        
        while trailDots.count > 0
        {
            var lowestDist = distanceBetween(p1: startPoint, p2: destinationFrame.origin);
            var indexForLowestDist: Int = 0;
            for i in 0..<trailDots.count
            {
                let dot = trailDots[i];
                let newDist = distanceBetween(p1: startPoint, p2: dot.frame.origin);
                
                if newDist < lowestDist
                {
                    lowestDist = newDist;
                    indexForLowestDist = i;
                }
            }
            
            let nearestDot = trailDots[indexForLowestDist];
            tempArray.append(nearestDot);
            trailDots.remove(at: indexForLowestDist);
        }
        
        trailDots = tempArray;
        tempArray.removeAll();
        
        // Calling for animation
        for i in 0..<trailDots.count
        {
            let trail = trailDots[i];
            print("Trail Frame = \(trail.frame) \n");
            trail.alpha = 0.0;
            let delay = CGFloat(i)/10 + 0.5;
            UIView.animateKeyframes(withDuration: 0.5, delay: TimeInterval(delay), options: [.repeat], animations: {
                trail.alpha = 1.0;
            }, completion: {
                done in
            })
        }
    }
    
    
    /*
     * MARK:- getting distance between 2 points
     */
    fileprivate func distanceBetween(p1: CGPoint, p2: CGPoint) -> Double
    {
        return Double(sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2)));
    }
    
    
    /*
     * Creating Mid Way points between
     * source and destination
     */
    fileprivate func createMidPointbetween(pointA: CGPoint, pointB: CGPoint)
    {
        let distance = distanceBetween(p1: pointA, p2: pointB);
        
        if distance >= 10.0
        {
            let midPoint = CGPoint(x:(pointB.x+pointA.x)/2,y:(pointB.y+pointA.y)/2);
            let trailDot = UIView.init(frame: CGRect(x:midPoint.x-2,y:midPoint.y-2,width:4,height:4));
            trailDot.backgroundColor = trailColor;
            trailDot.layer.cornerRadius = 2;
            trailDots.append(trailDot);
            self.addSubview(trailDot);
            
            createMidPointbetween(pointA: pointA, pointB: midPoint);
            createMidPointbetween(pointA: midPoint, pointB: pointB);
        }
    }
    
    
}







