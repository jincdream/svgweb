/*
 Copyright (c) 2009 by contributors:

 * James Hight (http://labs.zavoo.com/)
 * Richard R. Masters

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package com.sgweb.svg.nodes {
    
    import com.sgweb.svg.core.SVGNode;
    import com.sgweb.svg.utils.SVGUnits;
        
    public class SVGRectNode extends SVGNode {
                        
        public function SVGRectNode(svgRoot:SVGSVGNode, xml:XML = null, original:SVGNode = null):void {
            super(svgRoot, xml, original);
        }    
        
        /**
         * Generate graphics commands to draw a rectangle
         **/
        protected override function generateGraphicsCommands():void {
            
            this._graphicsCommands = new  Array();
                
            var widthStr:String = this.getAttribute('width','0');
            var heightStr:String = this.getAttribute('height','0');
            
            //var width:Number = SVGUnits.cleanNumber2(widthStr, getWidth());
            //var height:Number = SVGUnits.cleanNumber2(heightStr, getHeight());
            
            var width:Number = SVGUnits.cleanNumber(widthStr);
            var height:Number = SVGUnits.cleanNumber(heightStr);
            
            var rx:String = this.getAttribute('rx');
            var ry:String = this.getAttribute('ry');            
            
            if ((rx != null) && (ry == null)) {
                ry = rx;
            }
            if ((ry != null) && (rx == null)) {
                rx = ry;
            }
            
            //x & y loaded in setAttributes()
            if (rx != null) {
                this._graphicsCommands.push(['RECT', 0, 0, width, height, (SVGUnits.cleanNumber(rx) * 2), SVGUnits.cleanNumber(ry) * 2]);                
            }
            else {
                this._graphicsCommands.push(['RECT', 0, 0, width, height]);
            }
            
            //Width/height calculations for gradients
            this.setXMinMax(0);
            this.setYMinMax(0);
            this.setXMinMax(width);
            this.setYMinMax(height);
        }        
    }
}