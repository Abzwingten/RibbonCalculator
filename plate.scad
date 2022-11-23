include  <dimensions.scad>

module plate(){
    difference(){
        plate_base();
        pressure_equalization_holes();
        ribbon_opening(fillet = 1);
        ribbon_bolt_holes();
        mounting_holes();
    }
}

module pressure_equalization_holes() {
    for (i = [-12 : 24 : 12], j = [-1 : 2 : 1])
        translate([j * (case_w/2 + bolt_hole_r * 2), i, 0])
            roundedcube([3, 10, 3 + spacing], center = true, radius = 2, "z");

}


plate();