include <dimensions.scad>


//headband_mount_inner_d = 5;
plate_th = 4.5;
plate_d = 40;

bolt_d = 3;
nut_d = 4;


module tube_vise_plate (){
    linear_extrude(plate_th)
    circle(plate_d/2, $fn = 6);
}

module bolt_hole(diameter = 3) {
    translate([0, 0, -0.5])
    linear_extrude(plate_th + 10)
    circle(diameter/2);
}


module knob(){
    
    difference() {
        hull(){
            translate([0, 0, 4])
                sphere(d = 6);
            cylinder(h = 1, d1 = 31, d2 = 35,  $fn = 6);
            cylinder(h = 4, d1 = 31, d2 = 30,  $fn = 12);
        }
    bolt_hole(3);
    }
}

module copper_tube(){
    c_t_d = 5;
    c_t_l = 50;
    c_t_offset = 10;
    c_t_h = 10;
    rotate([90, 0, 0])
    for (i = [-1:2:1])
        translate([c_t_offset * i, plate_th, -c_t_l/2])
        cylinder(h = c_t_l, r = c_t_d/2);
}


module tube_vise (nut_or_bolt = 1) {

    diameter = (nut_or_bolt) ? nut_d:bolt_d;
    echo(diameter)
    difference(){
        tube_vise_plate();
        copper_tube();
        bolt_hole(diameter);
    }
}

knob();


module main () {
tube_vise(true);

translate([0, 0, 10])
rotate([180, 0, 0])
tube_vise(false);    
    
}
