
include <dcl.scad>

// make an unnamed object
wheel = dDifference(
            dRotate([0,90,0],
                dCylinder(h=10,r=20)),
            dTranslate([5,0,0],
                dRotate([0,90,0],
                    dCylinder(h=10,r=16)
                )
            )
        );

// make a named union using local variable via "let"
body = let( bodywidth = 100, bodylength = 200, bodyheight = 50,
            centerwidth = 140, centerlength = 80, centerheight = 50)
       dUnion("body", [
           dBox(bodywidth,bodyheight,bodylength,"main"),
           dTranslate([-(centerwidth-bodywidth)/2,(bodylength-centerlength)/2,0],
                dBox(centerwidth,centerheight,centerlength,"center"),
                "center_translate"
           )
       ]);

// create an axle based on the main body width
axle = dRotate([0,90,0],
           dCylinder(h=gVal(body,"main.width")+20,r=2,name="shaft")
       );

// assemble car
car = dUnion("car", [
          body,
          // position axles, make named copies
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2,
                      gVal(body,"center_translate.vec")[1]/2,
                      10],
              dCopy(axle,"front_axle")
          ),
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2,
                      gVal(body,"main.depth") - gVal(body,"center_translate.vec")[1]/2,
                      10],
              dCopy(axle,"back_axle")
          ),
          // add wheels
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2 + gVal(axle,"shaft.height"),
                      gVal(body,"center_translate.vec")[1]/2,
                      10],
              dCopy(wheel,"front_left")
          ),
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2 + gVal(axle,"shaft.height"),
                      gVal(body,"main.depth") - gVal(body,"center_translate.vec")[1]/2,
                      10],
              dCopy(wheel,"back_left")
          ),
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2,
                      gVal(body,"center_translate.vec")[1]/2,
                      10],
              dRotate([0,0,180],dCopy(wheel,"front_right"))
          ),
          dTranslate([-(gVal(axle,"shaft.height") - gVal(body,"main.width"))/2,
                      gVal(body,"main.depth") - gVal(body,"center_translate.vec")[1]/2,
                      10],
              dRotate([0,0,180],dCopy(wheel,"back_right"))
          )
      ]);

dcl_make(car);


