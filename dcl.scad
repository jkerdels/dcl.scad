


/*

This library can be used to describe Objects by declaring hierarchical object
descriptions first and then translating this description (automatically) into a
scad module hierarchy. The basic idea is, that by describing objects in this 
manner it is possible to keep the parameters of the individual subobjects 
"accessible" in other parts of the description, which is useful when defining
object properties relative to one another.

*/

//-----------------------------------------------------------------------------

/*

The main data structure used is based on a vector like that

[ Identifier, Name, [Children..] ]

with a leaf element 

[ kValue, Name, value ].

Elements in this data structure are created and queried by a set of 
library functions.

*/

// constants used as Identifiers
kValue = 0;

// 2D things
k2D        = 1000;    // offset
kCircle    = k2D + 0;
kSquare    = k2D + 1;
kRectangle = k2D + 1;
kPolygon   = k2D + 2;
kText      = k2D + 3;

// 3D things
k3D         = 2000;    // offset
kSphere     = k3D + 0;
kCube       = k3D + 1;
kBox        = k3D + 2;
kCylinder   = k3D + 3;
kCone       = k3D + 4;
kPolyhedron = k3D + 5;

// transformations
kTransform  = 3000; // offset
kTranslate  = kTransform + 0;
kRotate     = kTransform + 1;
kScale      = kTransform + 2;
kResize     = kTransform + 3;
kMirror     = kTransform + 4;
kMultMatrix = kTransform + 5;
kColor      = kTransform + 6;
kOffset     = kTransform + 7;
kHull       = kTransform + 8;
kMinkowski  = kTransform + 9;

// booleans
kBools        = 4000; // offset
kUnion        = kBools + 0;
kDifference   = kBools + 1;
kIntersection = kBools + 2;

// other
kOther         = 5000; // offset
kLinearExtrude = kOther + 0;
kRotateExtrude = kOther + 1;
kSurface       = kOther + 2;
kProjection    = kOther + 3;
kRender        = kOther + 4;



// named positions
kID       = 0;
kName     = 1;
kChildren = 2;
kVal      = 2; // Value and children share index 2

// function to create a leaf element
function dVal(name,value) = [kValue,name,value];

// functions to create some typical named values in order to prevent
// misspelling
function dPos(value) = dVal("pos",value);
function dVec(value) = dVal("vec",value);
function dMat(value) = dVal("mat",value);

function dWidth(value)  = dVal("width" ,value);
function dHeight(value) = dVal("height",value);
function dDepth(value)  = dVal("depth" ,value);

function dRadius(value)   = dVal("radius"  ,value);
function dDiameter(value) = dVal("diameter",value);

function dPoints(value) = dVal("points",value);
function dCol(value)    = dVal("color",value);

function dSubs(value) = dVal("subs",value);

// functions to create objects with pre-defined sets of values

// 2D
function dCircle(r,d,name="",name="") = [kCircle, name, [
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )
]];

function dSquare(size,name="") = [kSquare, name, [
	dWidth(size),
	dHeight(size)
]];

function dRect(w, h,name="") = [kRectangle, name, [
	dWidth(w),
	dHeight(h)
]];

function dPoly(points,name="") = [kPolygon, name, [
	dPoints(points)
]];

function dText(text,size,font,halign,valign,spacing,direction,language,script,name="") = [kText, name, [
	dVal("text",text),
	dVal("size",size),
	dVal("font",font),
	dVal("halign",halign),
	dVal("valign",valign),
	dVal("spacing",spacing),
	dVal("direction",direction),
	dVal("language",language),
	dVal("script",script)
]];

// 3D
function dSphere(r,d,name="") = [kSphere, name, [
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )	
]];

function dCube(size,name="") = [kCube, name, [
	dWidth(size),
	dHeight(size),
	dDepth(size)
]];

function dBox(w, h, d,name="") = [kBox, name, [
	dWidth(w),
	dHeight(h),
	dDepth(d)
]];

function dCylinder(h, r, d,name="") = [kCylinder, name, [
	dHeight(h),
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )		
]];

function dCone(h, r1, d1, r2, d2,name="") = [kCone, name, [
	dHeight(h),
	dVal("radius_1",   (r1 == undef) ? d1/2 : r1 ),
	dVal("diameter_1", (d1 == undef) ? r1*2 : d1 ),
	dVal("radius_2",   (r2 == undef) ? d2/2 : r2 ),
	dVal("diameter_2", (d2 == undef) ? r2*2 : d2 )		
]];

function dPolyhedron(points, triangles, convexity,name="") = [kPolyhedron, name, [
	dPoints(points),
	dVal("triangles",triangles),
	dVal("convexity",convexity)
]];

// transformations
function dTranslate(vec,obj,name="",s=[]) = [kTranslate, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVec(vec)
])];

function dRotate(vec,obj,name="",s=[]) = [kRotate, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVec(vec)
])];

function dScale(vec,obj,name="",s=[]) = [kScale, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVec(vec)
])];

function dResize(vec,obj, auto,name="",s=[]) = [kResize, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVec(vec),
	dVal("auto",auto)
])];

function dMirror(vec,obj,name="",s=[]) = [kMirror, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVec(vec)
])];

function dMultMatrix(mat,obj,name="",s=[]) = [kMultMatrix, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dMat(mat)
])];

function dColor(col,obj,name="",s=[]) = [kColor, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dCol(col)
])];

function dOffset(r, delta, chamfer,obj,name="",s=[]) = [kOffset, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dRadius(r),
	dVal("delta",delta),
	dVal("chamfer",chamfer)
])];

function dHull(name="",s=[]) = [kHull, name, concat(s,[
	dSubs(s)
])];

function dMinkowski(obj_a, obj_b, name="",sa=[],sb=[]) = [kMinkowski, name, concat((obj_a==undef) ? sa : [obj_a],(obj_b==undef) ? sb : [obj_b],[
	dVal("subs_a",(obj_a==undef) ? sa : [obj_a]),
	dVal("subs_b",(obj_b==undef) ? sb : [obj_b])
])];

// boolean operations
function dUnion(name="",s=[]) = [kUnion, name, concat(s,[
	dSubs(s)
])];

function dDifference(obj_a, obj_b, name="",sa=[],sb=[]) = [kDifference, name, concat((obj_a==undef) ? sa : [obj_a],(obj_b==undef) ? sb : [obj_b],[
	dVal("subs_a",(obj_a==undef) ? sa : [obj_a]),
	dVal("subs_b",(obj_b==undef) ? sb : [obj_b])
])];

function dIntersection(obj_a, obj_b, name="",sa=[],sb=[]) = [kIntersection, name, concat((obj_a==undef) ? sa : [obj_a],(obj_b==undef) ? sb : [obj_b],[
	dVal("subs_a",(obj_a==undef) ? sa : [obj_a]),
	dVal("subs_b",(obj_b==undef) ? sb : [obj_b])
])];

// other
function dLinearExtrude(h, center, convexity, twist, slices, scale,obj,name="",s=[]) = [kLinearExtrude, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dHeight(h),
	dVal("center",center),
	dVal("convexity",convexity),
	dVal("twist",twist),
	dVal("slices",slices),
	dVal("scale",scale)
])];

function dRotateExtrude(angle, convexity,obj,name="",s=[]) = [kRotateExtrude, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVal("angle",angle),
	dVal("convexity",convexity)
])];

function dSurface(file, center, invert, convexity,name="") = [kSurface, name, [
	dVal("file",file),
	dVal("center",center),
	dVal("invert",invert),
	dVal("convexity",convexity)
]];

function dProjection(cut,obj,name="",s=[]) = [kProjection, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVal("cut",cut)
])];

function dRender(obj,convexity,name="",s=[]) = [kRender, name, concat((obj==undef) ? s : [obj],[
	dSubs((obj==undef) ? s : [obj]),
	dVal("convexity",convexity)
])];


// some internal helper functions
function dcl_remove_first(array) = (len(array) == 1) ? [] : [for (i = [1:len(array)-1]) array[i]];

function dcl_array_to_str(first,rest) = (len(rest) == 1) ? str(first,rest[0]) : str(first,dcl_array_to_str(rest[0],dcl_remove_first(rest)));

function dcl_split_str(string,delimiter) = 
	(search(delimiter,string) == []) ? 
		[string,""] :
        [let (a = [for (i = [0:search(delimiter,string)[0]-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a)),
         let (a = [for (i = [search(delimiter,string)[0]+1:len(string)-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a))];

// a function to get sub-geometry based on the geometries name, e.g. "base.subelement.subsubelement"
function gSub(dcl_geom,name) = 
	let (a = dcl_split_str(name,".")) (a[1] == "") ?
		[for (i = [0:len(dcl_geom[kChildren])-1]) if (dcl_geom[kChildren][i][kName] == name) dcl_geom[kChildren][i]][0] :
		gSub([for (i = [0:len(dcl_geom[kChildren])-1]) if (dcl_geom[kChildren][i][kName] == a[0]) dcl_geom[kChildren][i]][0],a[1]);

// a function to retrieve some named value from a geometry
function gVal(dcl_geom,name) = let (a = gSub(dcl_geom,name)) (a[kID] == kValue) ? a[kVal] : undef;

// some convenience functions
function gPos(dcl_geom) = gVal(dcl_geom,"pos");
function gVec(dcl_geom) = gVal(dcl_geom,"vec");
function gMat(dcl_geom) = gVal(dcl_geom,"mat");

function gWidth(dcl_geom)  = gVal(dcl_geom,"width" );
function gHeight(dcl_geom) = gVal(dcl_geom,"height");
function gDepth(dcl_geom)  = gVal(dcl_geom,"depth" );

function gRadius(dcl_geom)   = gVal(dcl_geom,"radius"  );
function gDiameter(dcl_geom) = gVal(dcl_geom,"diameter");

function gPoints(dcl_geom) = gVal(dcl_geom,"points");
function gCol(dcl_geom)    = gVal(dcl_geom,"color");

// function to copy a geomentry, but give it a new name
function dCopy(dcl_geom,name) = [dcl_geom[kID], name, dcl_geom[kChildren]];


// the function that converts the dcl tree to actual geometry
module dcl_make(dcl_geom) {
	if (dcl_geom[kID] == kCircle) {
		circle(radius = gRadius(dcl_geom));
	} else
	if (dcl_geom[kID] == kSquare) {
		square([gWidth(dcl_geom),gHeight(dcl_geom)]);
	} else
	if (dcl_geom[kID] == kRectangle) {
		square([gWidth(dcl_geom),gHeight(dcl_geom)]);
	} else
	if (dcl_geom[kID] == kPolygon) {
		polygon(gPoints(dcl_geom));
	} else
	if (dcl_geom[kID] == kText) {
		text(gVal(dcl_geom,"text"),
			 gVal(dcl_geom,"size"),
			 gVal(dcl_geom,"font"),
			 gVal(dcl_geom,"halign"),
			 gVal(dcl_geom,"valign"),
			 gVal(dcl_geom,"spacing"),
			 gVal(dcl_geom,"direction"),
			 gVal(dcl_geom,"language"),
			 gVal(dcl_geom,"script"));
	} else
	if (dcl_geom[kID] == kSphere) {
		sphere(radius = gRadius(dcl_geom));
	} else
	if (dcl_geom[kID] == kCube) {
		cube([gWidth(dcl_geom),gDepth(dcl_geom),gHeight(dcl_geom)]);
	} else
	if (dcl_geom[kID] == kBox) {
		cube([gWidth(dcl_geom),gDepth(dcl_geom),gHeight(dcl_geom)]);
	} else
	if (dcl_geom[kID] == kCylinder) {
		cylinder(gHeight(dcl_geom),
			     r = gRadius(dcl_geom));
	} else
	if (dcl_geom[kID] == kCone) {
		cylinder(gHeight(dcl_geom),
			     r1 = gVal(dcl_geom,"radius_1"), 
			     r2 = gVal(dcl_geom,"radius_2"));
	} else
	if (dcl_geom[kID] == kPolyhedron) {
		polyhedron(gVal(dcl_geom,"points"),
			       gVal(dcl_geom,"triangles"),
			       gVal(dcl_geom,"convexity"));
	} else
	if (dcl_geom[kID] == kTranslate) {
		sb = gVal(dcl_geom,"subs");
		translate(gVec(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kRotate) {
		sb = gVal(dcl_geom,"subs");
		rotate(gVec(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kScale) {
		sb = gVal(dcl_geom,"subs");
		scale(gVec(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kResize) {
		sb = gVal(dcl_geom,"subs");
		resize(gVec(dcl_geom),gVal(dcl_geom,"auto")) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kMirror) {
		sb = gVal(dcl_geom,"subs");
		mirror(gVec(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kMultMatrix) {
		sb = gVal(dcl_geom,"subs");
		multmatrix(gMat(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kColor) {
		sb = gVal(dcl_geom,"subs");
		mirror(gCol(dcl_geom)) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}		
	} else
	if (dcl_geom[kID] == kOffset) {
		sb = gVal(dcl_geom,"subs");
		offset(gRadius(dcl_geom),gVal(dcl_geom,"delta"),gVal(dcl_geom,"chamfer")) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}
	} else
	if (dcl_geom[kID] == kHull) {
		sb = gVal(dcl_geom,"subs");
		hull() {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}		
	} else
	if (dcl_geom[kID] == kMinkowski) {
		sba = gVal(dcl_geom,"subs_a");
		sbb = gVal(dcl_geom,"subs_b");
		minkowski() {
			for (i = [0:len(sba)-1])
				dcl_make(sba[i]);
			for (i = [0:len(sbb)-1])
				dcl_make(sbb[i]);			
		}
	} else
	if (dcl_geom[kID] == kUnion) {
		sb = gVal(dcl_geom,"subs");
		union() {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);
		}		
	} else
	if (dcl_geom[kID] == kDifference) {
		sba = gVal(dcl_geom,"subs_a");
		sbb = gVal(dcl_geom,"subs_b");
		difference() {
			for (i = [0:len(sba)-1])
				dcl_make(sba[i]);
			for (i = [0:len(sbb)-1])
				dcl_make(sbb[i]);			
		}
	} else
	if (dcl_geom[kID] == kIntersection) {
		sba = gVal(dcl_geom,"subs_a");
		sbb = gVal(dcl_geom,"subs_b");
		intersection() {
			for (i = [0:len(sba)-1])
				dcl_make(sba[i]);
			for (i = [0:len(sbb)-1])
				dcl_make(sbb[i]);			
		}
	} else
	if (dcl_geom[kID] == kLinearExtrude) {
		sb = gVal(dcl_geom,"subs");
		linear_extrude(gHeight(dcl_geom),
			           gVal(dcl_geom,"center"),
			           gVal(dcl_geom,"convexity"),
			           gVal(dcl_geom,"twist"),
			           gVal(dcl_geom,"slices"),
			           gVal(dcl_geom,"scale")) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);			
		}
	} else
	if (dcl_geom[kID] == kRotateExtrude) {
		sb = gVal(dcl_geom,"subs");
		rotate_extrude(gVal(dcl_geom,"angle"),
			           gVal(dcl_geom,"convexity")) {
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);			
		}
	} else
	if (dcl_geom[kID] == kSurface) {
		surface(gVal(dcl_geom,"file"),
			    gVal(dcl_geom,"center"),
			    gVal(dcl_geom,"invert"),
			    gVal(dcl_geom,"convexity"));
	} else
	if (dcl_geom[kID] == kProjection) {
		sb = gVal(dcl_geom,"subs");
		projection(gVal(dcl_geom,"cut")){
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);						
		}
	} else
	if (dcl_geom[kID] == kRender) {
		sb = gVal(dcl_geom,"subs");
		render(gVal(dcl_geom,"convexity")){
			for (i = [0:len(sb)-1])
				dcl_make(sb[i]);						
		}
	}
}

