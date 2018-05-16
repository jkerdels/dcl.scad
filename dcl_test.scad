
include <dcl.scad>

// make an unnamed object
wheel = [
  dDifference(),[
    dRotate([0,90,0]),
    dCylinder(h=10,r=20),
    
    dTranslate([5,0,0]),
    dRotate([0,90,0]),
    dCylinder(h=10,r=16)
  ]
];

// make a named union and demonstrate local variable via "let"
body = let( 
  bodywidth    = 100, 
  bodylength   = 200, 
  bodyheight   = 50,
  centerwidth  = 140, 
  centerlength = 80, 
  centerheight = 50
)[
  dUnion("body"),[
    dBox(bodywidth,bodyheight,bodylength,"main"),
    dTranslate([-(centerwidth-bodywidth)/2,(bodylength-centerlength)/2,0],"center_translate"),
      dBox(centerwidth,centerheight,centerlength,"center")
  ]
];

// create an axle based on the main body width
axle = [
  dRotate([0,90,0],"rot"),
    dCylinder(h=gVal(body,"body.main.width")+20,r=2,name="shaft")
];

// assemble car
car = [
  dUnion("car"),[
    body,
    // position axles
    
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2,
                gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    axle,
    
        
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2,
                gVal(body,"body.main.depth") - gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    axle,
    
          
    // add wheels
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2 + gVal(axle,"shaft.height"),
                gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    wheel,
          
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2 + gVal(axle,"shaft.height"),
                gVal(body,"body.main.depth") - gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    wheel,
          
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2,
                gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    dRotate([0,0,180]),
    wheel,
          
    dTranslate([-(gVal(axle,"rot.shaft.height") - gVal(body,"body.main.width"))/2,
                gVal(body,"body.main.depth") - gVal(body,"body.center_translate.vec")[1]/2,
                10]),
    dRotate([0,0,180]),
    wheel
  ]
];

dcl_make(car);


