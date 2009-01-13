/*
Copyright (c) 2008 James Hight
Copyright (c) 2008 Richard R. Masters, for his changes.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package com.svgweb.svg.core
{
	import com.svgweb.svg.nodes.SVGSVGNode;
	import com.svgweb.svg.nodes.SVGStopNode;
	import com.svgweb.svg.utils.SVGColors;
	
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
    
    public class SVGGradient extends SVGNode
    {   
    	   
        public function SVGGradient(svgRoot:SVGSVGNode, xml:XML = null, original:SVGNode = null):void {            
            super(svgRoot, xml, original);
        }    

        public function beginGradientFill(node:SVGNode):void {
        	
        }
        
        public function lineGradientStyle(node:SVGNode):void {            
        	
        }
        
        public function getMatrix(node:SVGNode):Matrix {   
        	var matrix:Matrix;
        	     	
        	var attr:String = this.getAttribute('gradientTransform');            
            if (attr) {
                matrix = this.parseTransform(attr);                
            }
            else {
                matrix = new Matrix();
                var width:Number = node.xMax - node.xMin;
                var height:Number = node.yMax - node.yMin;
                matrix.createGradientBox(width, height, 0, 0);
            }
            
            var x1:Number = this.getAttribute('x1', 0, false);
            var y1:Number = this.getAttribute('y1', 0, false);
            
            var x2:Number = this.getAttribute('x2', 0, false);
            var y2:Number = this.getAttribute('y2', 0, false);            

            //x & y should already be set
            var objectX:Number = node.x; 
            var objectY:Number = node.y;            

            var dx:Number = x2 - x1;
            var dy:Number = y2 - y1;
            var angle:Number = Math.atan2(dy, dx);
            
            // Disabled because i am currently doing the object adjustment at the
            // end, which seems to be necessary for radial gradients, but it is not
            // clear what the difference is. I will do it the same as radials to
            // be consistent, and on the hunch that it is correct.
            //var tx:Number = (x1 + x2) / 2 - objectX;
            //var ty:Number = (y1 + y2) / 2 - objectY;
            var tx:Number = (x1 + x2) / 2;
            var ty:Number = (y1 + y2) / 2;

            var gradientWidth:Number = Math.abs(x2 - x1);
            var gradientHeight:Number = Math.abs(y2 - y1);
            var sx:Number = Math.sqrt(gradientWidth*gradientWidth+gradientHeight*gradientHeight) / 1638.4;
            var sy:Number = 1;

            //matrix.scale(sx, sy);
            matrix.rotate(angle);
            matrix.translate(tx, ty);            

            matrix.translate(-objectX, -objectY);
            
            return matrix;
        }
        
        public function getSpreadMethod():String {
        	var spreadMethod:String = SpreadMethod.PAD;
        	
        	var attr:String = this.getAttribute('spreadMethod');
            if (attr == 'reflect') {
                spreadMethod = SpreadMethod.REFLECT;
            }
            else if (attr == 'repeat') {
                spreadMethod = SpreadMethod.REPEAT;
            }
            
            return spreadMethod;
        }
        
        public function getStopData():Object {
        	        	
        	var href:String = this.getAttribute("href");
        	
        	if (href) {
        	   href = href.substr(1);
        	   var node:SVGNode = this.svgRoot.getNode(href);
        	   if (node is SVGGradient) {
        	       return SVGGradient(node).getStopData();
        	   }	
        	}
        	
        	var stopData:Object = new Object();
        	
        	var colors:Array = new Array();
            var ratios:Array = new Array();
            var alphas:Array = new Array();
            
            var color:String;
            var ratio:String;
            var alpha:String;
            var ratioNum:Number;
            
            
            var match:Array;
            
            var child:DisplayObject;
            
            var currentRatio:Number;
            
            for (var i:uint = 0; i < this.numChildren; i++) {
            	child = this.getChildAt(i);
            	if (child is SVGStopNode) {
            		color = SVGStopNode(child).getAttribute('stop-color');
            		ratio = SVGStopNode(child).getAttribute('offset');
            		alpha = SVGStopNode(child).getAttribute('stop-opacity', 1);
            		            		
            		match = ratio.match(/([^%]+)%/s);
            		if (match) {
            			ratioNum = 255 * (SVGColors.cleanNumber(match[1]) / 100);
            		}     
            		else {
            			ratioNum = 255 * SVGColors.cleanNumber(ratio);
            		}       		
            		
            		colors.push(SVGColors.getColor(color));
            		ratios.push(ratioNum);
            		alphas.push(SVGColors.cleanNumber(alpha));
            	}
            }
        	
        	stopData['colors'] = colors;
        	stopData['ratios'] = ratios;
        	stopData['alphas'] = alphas;
        	
        	return stopData;
        }


        
        
        
        
    }
}
