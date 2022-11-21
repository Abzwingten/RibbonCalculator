include  <dimensions.scad>



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
    color("blue") cube([
        magnet_cutout_w + spacing,
        magnet_cutout_l,
        case_h + case_floor_th], center = true);
}

module magnet_cutouts (){
    for(i = [-1 : 2 : 1], j = [-1 : 2: 1])
              translate([
                i * (ribbon_opening_w/2 + magnet_guard_th/2 + magnet_cutout_w/2),
                j * (magnet_l/2 - magnet_cutout_l/2 - spacing),
                case_floor_th
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
// bullshit, i dunno how to make loops and double difference
    difference() {
        union(){
            roundedcube([case_w, case_l, case_h], center = true, radius = 0.69, "zmax");
            
            ribbon_bolt_outer_shell();            
        }
        ribbon_bolt_holes();
    }
}



module ribbon_casing() {
    magnet_guard_pair();

    difference(){
        case_outer();
        case_inner();
        ribbon_opening(fillet = 0);
    }
}



ribbon_casing();

