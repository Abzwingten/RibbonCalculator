// DIMENSIONS

$fn = 50;

magnet_h = 10;
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
case_wall_w = 3.5;
case_floor_th = case_h - magnet_w;

magnet_cutout_w = magnet_w;
magnet_cutout_l = 1;

magnet_guard_th = 0.5;


spacing = 0.01;



module bolt_outer () {
    linear_extrude(height = bolt_hole_depth, center = true)
        circle(bolt_hole_r + bolt_hole_thickness);

}

module bolt_hole () {
    linear_extrude(height = bolt_hole_depth, center = true)
        circle(bolt_hole_r);

}


module magnet() {
    translate([ribbon_opening_w/2 + magnet_guard_th/2, -magnet_l/2, -magnet_h/2 + case_floor_th]){
        #cube([magnet_w, magnet_l, magnet_h]);
    }
}


module metal_bar(){
    offset = ribbon_opening_w/2 + magnet_cutout_w + magnet_guard_th/2 + metal_bar_long_w/2;
    translate([offset, 0, metal_bar_long_h/4])
    cube([metal_bar_long_w, metal_bar_long_l + spacing, metal_bar_long_h], center = true);
    
    translate([-offset, 0, metal_bar_long_h/4])
    cube([metal_bar_long_w, metal_bar_long_l + spacing, metal_bar_long_h], center = true);
}


module magnet_guard(side = 1){
    magnet_guard_l = ribbon_opening_l;
        translate([side * ribbon_opening_w/2, 0, 0])
        cube([magnet_guard_th, magnet_guard_l, case_h], center = true);
}


module magnet_guard_pair() {
    magnet_guard();
    side = -1;
    magnet_guard(side);
}


module magnet_cutout (){
    cube([
        magnet_cutout_w + spacing,
        magnet_cutout_l + spacing,
        magnet_h/2 + case_floor_th + spacing], center = true);
}


module magnet_cutouts (){
    //right top
    translate([
        ribbon_opening_w/2 + magnet_guard_th/2 + magnet_cutout_w/2,
        magnet_l/2 - magnet_cutout_l/2 - spacing,
        magnet_h/4 - case_floor_th/1.3
        ])
        { magnet_cutout();}

    //right bottom
    translate([
        ribbon_opening_w/2 + magnet_guard_th/2 + magnet_cutout_w/2,
        -(magnet_l/2 - magnet_cutout_l/2 - spacing),
        magnet_h/4 - case_floor_th/1.3
        ])
        { magnet_cutout();}


    //left top
    translate([
        -(ribbon_opening_w/2 + magnet_guard_th/2 + magnet_cutout_w/2),
        (magnet_l/2 - magnet_cutout_l/2 - spacing),
        magnet_h/4 - case_floor_th/1.3
        ])
        { magnet_cutout();}

    //left bottom
    translate([
        -(ribbon_opening_w/2 + magnet_guard_th/2 + magnet_cutout_w/2),
        -(magnet_l/2 - magnet_cutout_l/2 - spacing),
        magnet_h/4 - case_floor_th/1.3
        ])
        { magnet_cutout();}
}



module case_inner() {
    width = (magnet_w + metal_bar_long_w) * 2 + ribbon_opening_w;
    union() {
        translate([0, 0, case_floor_th]) cube([
            width + magnet_guard_th,
            ribbon_opening_l,
            case_h + case_floor_th
        ], center = true);
        magnet_cutouts();
        metal_bar();
    }
}

module case_outer() {
    union(){
        
        cube([case_w, case_l, case_h], center = true);
        difference(){
            translate([case_w/2, 0, 0]) bolt_outer();
            translate([case_w/2, 0, 0]) bolt_hole();
        }
//        translate([-case_w/2, 0, 0]) bolt_hole();
   
    }
}


module ribbon_opening () {
    cube([ribbon_opening_w, ribbon_opening_l, 10], center = true);
}


magnet_guard_pair();

difference(){
    case_outer();
    case_inner();
    ribbon_opening();
}

//bolt_hole();
//magnet();
//difference() {
//    cube([magnet_h, magnet_l, magnet_w]);
//    sphere(5);
//};


