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

package com.sgweb.svg.nodes.mask
{
    import com.sgweb.svg.nodes.SVGNode;
    import com.sgweb.svg.nodes.SVGRoot;
    
    import flash.events.Event;
    import flash.geom.Matrix;
    

    public class SVGMask extends SVGNode
    {

        protected var _clipPathXML:XML;

        public function SVGMask(svgRoot:SVGRoot, clipPathXML:XML):void {
            this._clipPathXML = new XML(this.copyXMLUnique(clipPathXML).toXMLString());
            //svgRoot.debug("_clipPathXML: " + this._clipPathXML.toXMLString());
            super(svgRoot, this._clipPathXML);
        }    


        public function getClipId():String {
            return this._clipPathXML.child(0).@id;
        }

        override public function transformNode():void {
            this.transform.matrix = new Matrix();
        }


    }
}