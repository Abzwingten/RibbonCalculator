include <dimensions.scad>


//headband_mount_inner_d = 5;
vise_th = 4.5;
vise_d = 40;

vise_bolt_d = 3;
vise_nut_d = 4;


knob_d = 31;

module tube_vise_plate (){
    linear_extrude(vise_th)
    circle(vise_d/2, $fn = 6);
}

module bolt_hole(diameter = 3) {
    translate([0, 0, -0.5])
    linear_extrude(vise_th + 10)
    circle(diameter/2);
}

module knob_fillets (){
    for(i = [-3 : 3])
            rotate(i * 360/6)
            translate([0, knob_d/2+ 2, -spacing])
                cylinder(h = 6, r1 = 5, r2 = 0.5);
}

module knob(){
    
    difference() {
       
        hull(){
            translate([0, 0, 4])
                sphere(d = 6);
            cylinder(h = 1, d1 = knob_d, d2 = knob_d+5,  $fn = 6);
            cylinder(h = 4, d1 = knob_d + 1, d2 = knob_d,  $fn = 12);
        }
        knob_fillets();
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
        translate([c_t_offset * i, vise_th, -c_t_l/2])
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
