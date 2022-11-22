include<roundedcube.scad>

$fa = 1.0;
$fs = 0.1; // filament size / 2


//VARIABLES
magnet_h = 20;
magnet_l = 60;
magnet_w = 5;

metal_bar_long_l = 68;
metal_bar_long_w = 2;
metal_bar_long_h = 10;

bolt_hole_r = 3 / 2;
bolt_hole_depth = 7;
bolt_hole_thickness = 2;

ribbon_opening_l = 58;
ribbon_opening_w = 18;

case_l = metal_bar_long_l;
case_w = 40;
case_h = 7;
case_floor_th = case_h - magnet_w;

magnet_cutout_w = magnet_w;
magnet_cutout_l = 1;

magnet_guard_th = 0.3;



plate_th = 2.5;
plate_d = 95;
plate_offset_h = 2;
plate_offset_w = 2;


grille_th = plate_th;
grille_d = sqrt(3)/2 * (plate_d/2 -5);

mounting_hole_spacing = 10;
spacing = 0.01;
body_mounting_hole_offset = plate_offset_h;

inner_r = sqrt(3)/2*plate_d/2;
body_h = 28;

// <__________________________> //

module plate_base(diameter = plate_d){
rotate([0,0,90]) 
            linear_extrude(height = plate_th, center = true)
                circle(d = diameter);
}

module ribbon_opening (fillet = 1) {
    if (fillet == 0)
        cube([ribbon_opening_w, ribbon_opening_l, 10], center = true);
    
    else if (fillet == 1)
        roundedcube([ribbon_opening_w, ribbon_opening_l, 10], center = true, radius = 1, "all");
    
}

module ribbon_bolt_holes() {
    for (i = [-25 : 25 : 25], j = [-1 : 2 : 1])
            translate([j * case_w/2, i, 0]) bolt_hole();
}    

module ribbon_bolt_outer_shell() {
for (i = [-25 : 25 : 25], j = [-1 : 2 : 1])
                translate([j * case_w/2, i, 0]) bolt_outer();    
}


module mounting_holes() {
    for(i = [-3 : 3])
       rotate(i * 360/6)
            translate([0, plate_d/2 - mounting_hole_spacing, 0])
                bolt_hole();
}



module bolt_outer () {
    linear_extrude(height = bolt_hole_depth, center = true)
        circle(bolt_hole_r + bolt_hole_thickness);

}

module bolt_hole () {
    linear_extrude(height = bolt_hole_depth + spacing, center = true)
        circle(bolt_hole_r);

}
