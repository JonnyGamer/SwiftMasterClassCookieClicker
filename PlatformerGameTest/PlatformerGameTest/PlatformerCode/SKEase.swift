//
//  SKEase.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/15/21.
//

import Foundation
//import UIKit
import SpriteKit
//#if os(macOS)
//typealias UIColor = NSColor
//#endif

///Curve type
public enum CurveType {
    case linear, quadratic, cubic, quartic, quintic
    case sine, circular, expo, elastic, back, bounce
}

///Ease type
public enum EaseType { case `in`, out, inOut }

open class SKEase {
    /**
     Get an easing function with a curve and ease type.
     - parameter curve: Curve type
     - parameter easeType: Ease type
     */
    open class func getEaseFunction(_ curve:CurveType, easeType:EaseType)->AHEasingFunction {
        var currentFunction:AHEasingFunction
        switch(curve) {
        case .linear:
            currentFunction=LinearInterpolation
        case .quadratic:
            currentFunction = (easeType == .in) ? QuadraticEaseIn : (easeType == .out) ? QuadraticEaseOut : QuadraticEaseInOut;
        case .cubic:
            currentFunction = (easeType == .in) ? CubicEaseIn : (easeType == .out) ? CubicEaseOut : CubicEaseInOut;
        case .quartic:
            currentFunction = (easeType == .in) ? QuarticEaseIn : (easeType == .out) ? QuarticEaseOut : QuarticEaseInOut;
        case .quintic:
            currentFunction = (easeType == .in) ? QuinticEaseIn : (easeType == .out) ? QuinticEaseOut : QuinticEaseInOut;
        case .sine:
            currentFunction = (easeType == .in) ? SineEaseIn : (easeType == .out) ? SineEaseOut : SineEaseInOut;
        case .circular:
            currentFunction = (easeType == .in) ? CircularEaseIn : (easeType == .out) ? CircularEaseOut : CircularEaseInOut;
        case .expo:
            currentFunction = (easeType == .in) ? ExponentialEaseIn : (easeType == .out) ? ExponentialEaseOut : ExponentialEaseInOut;
        case .elastic:
            currentFunction = (easeType == .in) ? ElasticEaseIn : (easeType == .out) ? ElasticEaseOut : ElasticEaseInOut;
        case .back:
            currentFunction = (easeType == .in) ? BackEaseIn : (easeType == .out) ? BackEaseOut : BackEaseInOut;
        case .bounce:
            currentFunction = (easeType == .in) ? BounceEaseIn : (easeType == .out) ? BounceEaseOut : BounceEaseInOut;
        }
        return currentFunction
    }
    /**
     Create a tween between two points.
     - parameter start: Start point
     - parameter end: End point
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createPointTween(_ start:CGPoint, end:CGPoint, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGPoint)->Void))->SKAction {
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let xValue:CGFloat = start.x + CGFloat(timeEq) * (end.x - start.x)
            let yValue:CGFloat = start.y + CGFloat(timeEq) * (end.y - start.y)
            setter(node,CGPoint(x: xValue, y: yValue))
        })
        return action
    }
    /**
     Create a tween between two values.
     - parameter start: Start value
     - parameter end: End value
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createFloatTween(_ start:CGFloat, end:CGFloat, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGFloat)->Void))->SKAction {
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let value:CGFloat = start+CGFloat(timeEq) * (end-start)
            setter(node,value)
        })
        return action
    }
    /**
     Create a tween between two colors.
     - parameter start: Start color
     - parameter end: End color
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createColorTween(_ start:NSColor, end:NSColor, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,NSColor)->Void))->SKAction {
      
      var startRed:CGFloat = 0, startGreen:CGFloat = 0,startBlue:CGFloat = 0,startAlpha:CGFloat = 0
      start.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
      var endRed:CGFloat = 0, endGreen:CGFloat = 0,endBlue:CGFloat = 0,endAlpha:CGFloat = 0
      end.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
      
      let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
        let timeEq = easingFunction(Float(elapsedTime)/Float(time))
        
        let redValue:CGFloat = startRed + CGFloat(timeEq) * (endRed - startRed)
        let greenValue:CGFloat = startGreen + CGFloat(timeEq) * (endGreen - startGreen)
        let blueValue:CGFloat = startBlue + CGFloat(timeEq) * (endBlue - startBlue)
        let alphaValue:CGFloat = startAlpha + CGFloat(timeEq) * (endAlpha - startAlpha)
        
        let color = NSColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
        setter(node,color)
      })
      return action
    }
    //MARK: Color
    /**
     Animate label color
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial color
     - parameter to: destination color
     */
    open class func tweenLabelColor(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:NSColor, to:NSColor)->SKAction {
      let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
      let action = self.createColorTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, color:NSColor) -> Void in
        if let node = node as? SKLabelNode {
          node.fontColor = color
        }
      }
      return action
    }
    //MARK: Color
    /**
     Animate shape fill color
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial color
     - parameter to: destination color
     */
    open class func tweenShapeFillColor(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:NSColor, to:NSColor)->SKAction {
      let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
      let action = self.createColorTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, color:NSColor) -> Void in
        if let node = node as? SKShapeNode {
          node.fillColor = color
        }
      }
      return action
    }
    //MARK: Move
    /**
    Animate x/y movement
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial point
     - parameter to: destination point
    */
    open class func move(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGPoint, to:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createPointTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    ///legacy
    open class func moveToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, to:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let startPosition = target.position
        let action = self.createPointTween(CGPoint(x: startPosition.x,y: startPosition.y), end: to, time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    ///legacy
    open class func moveFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let startPosition = target.position
        let action = self.createPointTween(from, end: CGPoint(x: startPosition.x,y: startPosition.y), time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    
    //MARK: Scale
    /**
     Animate scale
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial scale
     - parameter to: destination scale
     */
    open class func scale(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    /**
     Animate scale X
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial scale X
     - parameter to: destination scale X
     */
    open class func scaleX(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.xScale = scale
        }
        return action
    }
    /**
     Animate scale Y
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial scale Y
     - parameter to: destination scale Y
     */
    open class func scaleY(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.yScale = scale
        }
        return action
    }
    ///legacy
    open class func scaleToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.xScale, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    open class func scaleFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.xScale, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    
    //MARK: Rotate
    /**
     Animate z rotation
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial z rotation
     - parameter to: destination z rotation
     */
    open class func rotate(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    ///legacy
    open class func rotateToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.zRotation, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    open class func rotateFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.zRotation, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    
    
    //MARK: Fade
    /**
     Animate alpha
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial alpha
     - parameter to: destination alpha
     */
    open class func fade(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
    ///legacy
    open class func fadeToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.alpha, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
    ///legacy
    open class func fadeFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.alpha, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
}

let M_PI_2_f = Float(Double.pi / 2)
let M_PI_f = Float(Double.pi)

public typealias AHEasingFunction = (Float)->Float

public func dub(_ num:Float)->Float {
    return (Float(Int32(num)))
}
public func sinFloat(_ num:Float)->Float {
    return sin(num)
}
// Modeled after the line y = x
public func LinearInterpolation(_ p:Float)->Float
{
    return p;
}

// Modeled after the parabola y = x^2
public func  QuadraticEaseIn(_ p:Float)->Float
{
    return p * p;
}

// Modeled after the parabola y = -x^2 + 2x
public func QuadraticEaseOut(_ p:Float)->Float
{
    return -(p * (p - 2));
}

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)             ; [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
public func QuadraticEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 2 * p * p;
    }
    else
    {
        return (-2 * p * p) + (4 * p) - 1;
    }
}

// Modeled after the cubic y = x^3
public func CubicEaseIn(_ p:Float)->Float
{
    return p * p * p;
}

// Modeled after the cubic y = (x - 1)^3 + 1
public func CubicEaseOut(_ p:Float)->Float
{
    let f:Float = (p - 1);
    return f * f * f + 1;
}

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)       ; [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
public func CubicEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 4 * p * p * p;
    }
    else
    {
        let f:Float = ((2 * p) - 2);
        return 0.5 * f * f * f + 1;
    }
}

// Modeled after the quartic x^4
public func QuarticEaseIn(_ p:Float)->Float
{
    return p * p * p * p;
}

// Modeled after the quartic y = 1 - (x - 1)^4
public func QuarticEaseOut(_ p:Float)->Float
{
    let f:Float = (p - 1);
    return f * f * f * (1 - p) + 1;
}

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)        ; [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
public func QuarticEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 8 * p * p * p * p;
    }
    else
    {
        let f:Float = (p - 1);
        return -8 * f * f * f * f + 1;
    }
}

// Modeled after the quintic y = x^5
public func QuinticEaseIn(_ p:Float)->Float
{
    return p * p * p * p * p;
}

// Modeled after the quintic y = (x - 1)^5 + 1
public func QuinticEaseOut(_ p:Float)->Float
{
    let f:Float = (p - 1);
    return f * f * f * f * f + 1;
}

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)       ; [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
public func QuinticEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 16 * p * p * p * p * p;
    }
    else
    {
        let f:Float = ((2 * p) - 2);
        return  0.5 * f * f * f * f * f + 1;
    }
}

// Modeled after quarter-cycle of sine wave
public func SineEaseIn(_ p:Float)->Float
{
    return sinFloat((p - 1.0) * M_PI_2_f)+1.0
}

// Modeled after quarter-cycle of sine wave (different phase)
public func SineEaseOut(_ p:Float)->Float
{
    return sinFloat(p * M_PI_2_f)
}

// Modeled after half sine wave
public func SineEaseInOut(_ p:Float)->Float
{
    return 0.5 * (1.0 - cos(p * M_PI_f));
}

// Modeled after shifted quadrant IV of unit circle
public func CircularEaseIn(_ p:Float)->Float
{
    return 1 - sqrt(1 - (p * p));
}

// Modeled after shifted quadrant II of unit circle
public func CircularEaseOut(_ p:Float)->Float
{
    return sqrt((2 - p) * p);
}

// Modeled after the piecewise circular public function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
public func CircularEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (p * p)));
    }
    else
    {
        return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
    }
}

// Modeled after the exponential public function y = 2^(10(x - 1))
public func ExponentialEaseIn(_ p:Float)->Float
{
    return (p == 0.0) ? p : pow(2, 10 * (p - 1));
}

// Modeled after the exponential public function y = -2^(-10x) + 1
public func ExponentialEaseOut(_ p:Float)->Float
{
    return (p == 1.0) ? p : 1 - pow(2, -10 * p);
}

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
public func ExponentialEaseInOut(_ p:Float)->Float
{
    if(p == 0.0 || p == 1.0) { return p; }
    
    if(p < 0.5)
    {
        return 0.5 * pow(2, (20 * p) - 10);
    }
    else
    {
        return -0.5 * pow(2, (-20 * p) + 10) + 1;
    }
}

// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
public func ElasticEaseIn(_ p:Float)->Float
{
    return sinFloat(13 * M_PI_2_f * p) * pow(2, 10.0 * (p - 1.0));
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
public func ElasticEaseOut(_ p:Float)->Float
{
    return sinFloat(-13 * M_PI_2_f * (p + 1)) * pow(2, -10 * p) + 1;
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
public func ElasticEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 0.5 * sinFloat(13.0 * M_PI_2_f * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
    }
    else
    {
        return 0.5 * (sinFloat(-13 * M_PI_2_f * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
    }
}

// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
public func BackEaseIn(_ p:Float)->Float
{
    return p * p * p - p * sinFloat(p * M_PI_f);
}

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
public func BackEaseOut(_ p:Float)->Float
{
    let f:Float = (1 - p);
    return 1 - (f * f * f - f * sinFloat(f * M_PI_f));
}

// Modeled after the piecewise overshooting cubic public function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
public func BackEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        let f:Float = 2 * p;
        return 0.5 * (f * f * f - f * sinFloat(f * M_PI_f));
    }
    else
    {
        let f:Float = (1 - (2*p - 1));
        return 0.5 * (1 - (f * f * f - f * sinFloat(f * M_PI_f))) + 0.5;
    }
}

public func BounceEaseIn(_ p:Float)->Float
{
    return 1 - BounceEaseOut(1 - p);
}

public func BounceEaseOut(_ p:Float)->Float
{
    if(p < 4/11.0)
    {
        return (121 * p * p)/16.0;
    }
    else if(p < 8/11.0)
    {
        return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0;
    }
    else if(p < 9/10.0)
    {
        return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0;
    }
    else
    {
        return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
    }
}

public func BounceEaseInOut(_ p:Float)->Float
{
    if(p < 0.5)
    {
        return 0.5 * BounceEaseIn(p*2);
    }
    else
    {
        return 0.5 * BounceEaseOut(p * 2 - 1) + 0.5;
    }
}
