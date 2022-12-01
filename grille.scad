include <dimensions.scad>
include <DotScad/src/hexagons.scad>



//grille_th = plate_th;
//grille_d = sqrt(3)/2 * (plate_d/2 -5);
levels = 6;

module grille(){

    color("yellow")
    linear_extrude(grille_th)
        difference(){
            circle(grille_r, $fn = 6);
            hexagons(7, 2, 3);
        }
        
    }