// DIMENSIONS

magnet_h = 10;
magnet_l = 60;
magnet_w = 5;


metal_bar_long_l = 68;
metal_bar_long_w = 1;
metal_bar_long_h = 10;

bolt_hole_r = 3 / 2;
bolt_hole_depth = 7;

ribbon_opening_l = 58;
ribbon_opening_w = 18;

case_l = metal_bar_long_l;
case_w = 40;
case_h = 7;
case_wall_w = 3.5;
case_floor_th = 1.9;

magnet_cutout_w = magnet_w;
magnet_cutout_l = 1;

magnet_guard_th = 1;

module magnet() {
    translate([ribbon_opening_w/2 + magnet_guard_th/2, -magnet_l/2, -magnet_h/2 + case_floor_th]){
        #cube([magnet_w, magnet_l, magnet_h]);
    }
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
    translate([
        ribbon_opening_w/2 + magnet_guard_th/2,
        magnet_l/2 - 0.01 - magnet_cutout_l,
        case_floor_th
        ]) {cube([
            magnet_cutout_w,
            magnet_cutout_l,
            magnet_h/2 + case_floor_th]);

    }
}

module case_inner() {
    union() {
        width = (magnet_w + metal_bar_long_w) * 2 + ribbon_opening_w;
            translate([0, 0, case_floor_th]) cube([width + magnet_guard_th, ribbon_opening_l, case_h + case_floor_th], center = true);
        magnet_cutout();
    }
}

module case_outer() {
    cube([case_w, case_l, case_h], center = true);
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

//magnet();

//difference() {
//    cube([magnet_h, magnet_l, magnet_w]);
//    sphere(5);
//};


