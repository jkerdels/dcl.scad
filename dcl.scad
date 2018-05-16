


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

[ Identifier, IsComposite, Name, [ParamName, ParamValue], ... ]

Elements using this data structure are created and queried by a set of 
library functions. Objects are arrays containing the above data structures.

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
kID         = 0;
kComp       = 1;
kName       = 2;
kParamStart = 3;

// function to create a param element
function dVal(name,value) = [name,value];

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

// functions to create objects with pre-defined sets of values

// 2D
function dCircle(r,d,name="") = [kCircle, false,
    name, 
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )
];

function dSquare(size,name="") = [kSquare, false,
    name, 
	dWidth(size),
	dHeight(size)
];

function dRect(w, h,name="") = [kRectangle, false,
    name, 
	dWidth(w),
	dHeight(h)
];

function dPoly(points,name="") = [kPolygon, false,
    name, 
	dPoints(points)
];

function dText(text,size,font,halign,valign,spacing,direction,language,script,name="") = [kText, false,
    name, 
	dVal("text",text),
	dVal("size",size),
	dVal("font",font),
	dVal("halign",halign),
	dVal("valign",valign),
	dVal("spacing",spacing),
	dVal("direction",direction),
	dVal("language",language),
	dVal("script",script)
];

// 3D
function dSphere(r,d,name="") = [kSphere, false,
    name, 
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )	
];

function dCube(size,name="") = [kCube, false,
    name, 
	dWidth(size),
	dHeight(size),
	dDepth(size)
];

function dBox(w, h, d,name="") = [kBox, false,
    name, 
	dWidth(w),
	dHeight(h),
	dDepth(d)
];

function dCylinder(h, r, d,name="") = [kCylinder, false,
    name, 
	dHeight(h),
	dRadius  ( (r == undef) ? d/2 : r ),
	dDiameter( (d == undef) ? r*2 : d )		
];

function dCone(h, r1, d1, r2, d2,name="") = [kCone, false,
    name, 
	dHeight(h),
	dVal("radius_1",   (r1 == undef) ? d1/2 : r1 ),
	dVal("diameter_1", (d1 == undef) ? r1*2 : d1 ),
	dVal("radius_2",   (r2 == undef) ? d2/2 : r2 ),
	dVal("diameter_2", (d2 == undef) ? r2*2 : d2 )		
];

function dPolyhedron(points, triangles, convexity,name="") = [kPolyhedron, false,
    name, 
	dPoints(points),
	dVal("triangles",triangles),
	dVal("convexity",convexity)
];

// transformations
function dTranslate(vec,name="") = [kTranslate, true,
    name, 
	dVec(vec)
];

function dRotate(vec,name="") = [kRotate, true,
    name, 
	dVec(vec)
];

function dScale(vec,name="") = [kScale, true,
    name, 
	dVec(vec)
];

function dResize(vec,auto,name="") = [kResize, true,
    name, 
	dVec(vec),
	dVal("auto",auto)
];

function dMirror(vec,name="") = [kMirror, true,
    name, 
	dVec(vec)
];

function dMultMatrix(mat,name="") = [kMultMatrix, true,
    name, 
	dMat(mat)
];

function dColor(col,name="") = [kColor, true,
    name, 
	dCol(col)
];

function dOffset(r, delta, chamfer,name="") = [kOffset, true, 
    name, 
	dRadius(r),
	dVal("delta",delta),
	dVal("chamfer",chamfer)
];

function dHull(name="") = [kHull, true,
    name
];

function dMinkowski(name="") = [kMinkowski, true,
    name
];

// boolean operations
function dUnion(name="") = [kUnion, true,
    name
];

function dDifference(name="") = [kDifference, true,
    name
];

function dIntersection(name="") = [kIntersection, true,
    name
];

// other
function dLinearExtrude(h, center, convexity, twist, slices, scale,name="") = [kLinearExtrude, true,
    name, 
	dHeight(h),
	dVal("center",center),
	dVal("convexity",convexity),
	dVal("twist",twist),
	dVal("slices",slices),
	dVal("scale",scale)
];

function dRotateExtrude(angle, convexity,name="") = [kRotateExtrude, true,
    name, 
	dVal("angle",angle),
	dVal("convexity",convexity)
];

function dSurface(file, center, invert, convexity,name="") = [kSurface, false,
    name, 
	dVal("file",file),
	dVal("center",center),
	dVal("invert",invert),
	dVal("convexity",convexity)
];

function dProjection(cut,name="") = [kProjection, true,
    name, 
	dVal("cut",cut)
];

function dRender(convexity,name="") = [kRender, true,
    name,
	dVal("convexity",convexity)
];


// some internal helper functions
function dcl_remove_first(array) = (len(array) == 1) ? [] : [for (i = [1:len(array)-1]) array[i]];

function dcl_array_to_str(first,rest) = (len(rest) == 1) ? str(first,rest[0]) : str(first,dcl_array_to_str(rest[0],dcl_remove_first(rest)));

function dcl_split_str(string,delimiter) =
    let (s = search(delimiter,string)) 
	(s == []) ? 
		[string,""] :
        [let (a = [for (i = [0:s[0]-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a)),
         let (a = [for (i = [s[0]+1:len(string)-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a))];

function dcl_split_str_last(string,delimiter) =
    let (s = search(delimiter,string,0)) 
	(s == [[]]) ? 
		[string,""] :
        [let (a = [for (i = [0:s[0][len(s[0])-1]-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a)),
         let (a = [for (i = [s[0][len(s[0])-1]+1:len(string)-1]) string[i]]) dcl_array_to_str(a[0],dcl_remove_first(a))];



function dcl_find_name(dcl_geom,name,start_idx = 0) =
	((dcl_geom[0][0] == undef) || (start_idx >= len(dcl_geom))) ? ( // if dcl_geom is not an array of geometries
        undef
    ) : (
    	let (
    		result = [for (i = [start_idx:len(dcl_geom)-1]) if (dcl_geom[i][0][0] == undef) if (dcl_geom[i][kName] == name) i]
    	)
    	(len(result) > 0) ? result[0] : undef
    );
	


// a function to get sub-geometry based on the geometries name, e.g. "base.subelement.subsubelement"
function gSub(dcl_geom,name,start_idx=0) = 
    ((dcl_geom[0][0] == undef) || (start_idx >= len(dcl_geom))) ? ( // if dcl_geom is not an array of geometries
        undef
    ) : (
        let (
        	a = dcl_split_str(name,"."),
        	idx = dcl_find_name(dcl_geom,a[0],start_idx)
        )
        (idx == undef) ? (
        	undef
        ) : (
	        (a[1] == "") ? ( // if there are no more subelements
	        	dcl_geom[idx]
	        ) : (
	        	(idx+1 >= len(dcl_geom)) ? undef :	        	
	        	(dcl_geom[idx+1][0][0] == undef) ? (
	        		gSub(dcl_geom,a[1],idx+1)
	        	) : (
					gSub(dcl_geom[idx+1],a[1])
	        	)
	        ) 
        )
    );
                                   
// a function to retrieve some named value from a geometry
function gVal(dcl_geom,name) = 
    (dcl_geom[0][0] == undef) ? (
        [for (i = [kParamStart:len(dcl_geom)-1]) if (dcl_geom[i][0] == name) dcl_geom[i][1]][0]
    ) : (
        let (b = dcl_split_str_last(name,"."), a = gSub(dcl_geom,b[0])) 
        [for (i = [kParamStart:len(a)-1]) if (a[i][0] == b[1]) a[i][1]][0]
    );


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

function dcl_get_comp_depth(dcl_geom, i) = 
	((dcl_geom[i][0][0] != undef) || (dcl_geom[i][kComp] == false)) ? 
		1 : 
		1 + dcl_get_comp_depth(dcl_geom, i+1);

// the function that converts the dcl tree to actual geometry
module dcl_make(dcl_geom, i=0, stop=false) {	
	// check if element is not an array of geometries, then make it one
	if (i < len(dcl_geom))
    if (dcl_geom[0][0] == undef) {
        dcl_make([dcl_geom],0);
    } else {
	    // check if input is an array of geometries
	    if (dcl_geom[i][0][0] != undef) {
	        dcl_make(dcl_geom[i],0);
	    } else
	    if (dcl_geom[i][kID] == kCircle) {
		    circle(radius = gRadius(dcl_geom[i]));
	    } else
	    if (dcl_geom[i][kID] == kSquare) {
		    square([gWidth(dcl_geom[i]),gHeight(dcl_geom[i])]);
	    } else
	    if (dcl_geom[i][kID] == kRectangle) {
		    square([gWidth(dcl_geom[i]),gHeight(dcl_geom[i])]);
	    } else
	    if (dcl_geom[i][kID] == kPolygon) {
		    polygon(gPoints(dcl_geom[i]));
	    } else
	    if (dcl_geom[i][kID] == kText) {
		    text(gVal(dcl_geom[i],"text"),
			     gVal(dcl_geom[i],"size"),
			     gVal(dcl_geom[i],"font"),
			     gVal(dcl_geom[i],"halign"),
			     gVal(dcl_geom[i],"valign"),
			     gVal(dcl_geom[i],"spacing"),
			     gVal(dcl_geom[i],"direction"),
			     gVal(dcl_geom[i],"language"),
			     gVal(dcl_geom[i],"script"));
	    } else
	    if (dcl_geom[i][kID] == kSphere) {
		    sphere(r = gRadius(dcl_geom[i]));
	    } else
	    if (dcl_geom[i][kID] == kCube) {
		    cube([gWidth(dcl_geom[i]),gDepth(dcl_geom[i]),gHeight(dcl_geom[i])]);
	    } else
	    if (dcl_geom[i][kID] == kBox) {
		    cube([gWidth(dcl_geom[i]),gDepth(dcl_geom[i]),gHeight(dcl_geom[i])]);
	    } else
	    if (dcl_geom[i][kID] == kCylinder) {
		    cylinder(gHeight(dcl_geom[i]),
			         r = gRadius(dcl_geom[i]));
	    } else
	    if (dcl_geom[i][kID] == kCone) {
		    cylinder(gHeight(dcl_geom[i]),
			         r1 = gVal(dcl_geom[i],"radius_1"), 
			         r2 = gVal(dcl_geom[i],"radius_2"));
	    } else
	    if (dcl_geom[i][kID] == kPolyhedron) {
		    polyhedron(gVal(dcl_geom[i],"points"),
			           gVal(dcl_geom[i],"triangles"),
			           gVal(dcl_geom[i],"convexity"));
	    } else
	    if (dcl_geom[i][kID] == kTranslate) {
		    translate(gVec(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kRotate) {
		    rotate(gVec(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kScale) {
		    scale(gVec(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kResize) {
		    resize(gVec(dcl_geom[i]),gVal(dcl_geom[i],"auto")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kMirror) {
		    mirror(gVec(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kMultMatrix) {
		    multmatrix(gMat(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kColor) {
		    mirror(gCol(dcl_geom[i])) {
			    dcl_make(dcl_geom,i+1,true);
		    }		
	    } else
	    if (dcl_geom[i][kID] == kOffset) {
		    offset(gRadius(dcl_geom[i]),gVal(dcl_geom[i],"delta"),gVal(dcl_geom[i],"chamfer")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kHull) {
		    hull() {
			    dcl_make(dcl_geom,i+1,dcl_get_comp_depth(dcl_geom,i+1));
		    }		
	    } else
	    if (dcl_geom[i][kID] == kMinkowski) {
		    minkowski() {
			    dcl_make(dcl_geom[i+1],0,true);
			    dcl_make(dcl_geom[i+1],dcl_get_comp_depth(dcl_geom[i+1],0));
		    }
	    } else
	    if (dcl_geom[i][kID] == kUnion) {
		    union() {
			    dcl_make(dcl_geom,i+1,true);
		    }		
	    } else
	    if (dcl_geom[i][kID] == kDifference) {
		    difference() {
			    dcl_make(dcl_geom[i+1],0,true);
			    dcl_make(dcl_geom[i+1],dcl_get_comp_depth(dcl_geom[i+1],0));
		    }
	    } else
	    if (dcl_geom[i][kID] == kIntersection) {
		    intersection() {
			    dcl_make(dcl_geom[i+1],0,true);
			    dcl_make(dcl_geom[i+1],dcl_get_comp_depth(dcl_geom[i+1],0));
		    }
	    } else
	    if (dcl_geom[i][kID] == kLinearExtrude) {
		    linear_extrude(gHeight(dcl_geom[i]),
			               gVal(dcl_geom[i],"center"),
			               gVal(dcl_geom[i],"convexity"),
			               gVal(dcl_geom[i],"twist"),
			               gVal(dcl_geom[i],"slices"),
			               gVal(dcl_geom[i],"scale")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kRotateExtrude) {
		    rotate_extrude(gVal(dcl_geom[i],"angle"),
			               gVal(dcl_geom[i],"convexity")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kSurface) {
		    surface(gVal(dcl_geom[i],"file"),
			        gVal(dcl_geom[i],"center"),
			        gVal(dcl_geom[i],"invert"),
			        gVal(dcl_geom[i],"convexity"));
	    } else
	    if (dcl_geom[i][kID] == kProjection) {
		    projection(gVal(dcl_geom[i],"cut")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    } else
	    if (dcl_geom[i][kID] == kRender) {
		    render(gVal(dcl_geom[i],"convexity")) {
			    dcl_make(dcl_geom,i+1,true);
		    }
	    }
	    if (stop == false) {
	    	if ((dcl_geom[i][0][0] == undef) && (dcl_geom[i][kComp])) {
	    		dcl_make(dcl_geom,i+1+dcl_get_comp_depth(dcl_geom,i+1));
	    	} else {
				dcl_make(dcl_geom,i+1);
	    	}
		}
	}
}

