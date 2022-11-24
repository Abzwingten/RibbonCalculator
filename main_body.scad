include <dimensions.scad>
use <ribbon_casing.scad>
use <plate.scad>

i = 1;


module body(){
    difference(){
        translate([0, 0, body_h])
        rotate([0, 180, 0])
        union(){
            main_body();
            mounting_holes_mounts();
        }
        translate([-plate_d/4  ,plate_d/2,body_h/2])
            
            rotate([90,0,30]) linear_extrude(25) #circle(aux_body_outer_r - 0.2 - spacing, $fn = 12);
    }
    difference(){ 
        translate([-plate_d/4 +3,plate_d/2 -5,body_h/2])
                rotate([90,0,30])
            aux_connector();
        
    }
}

//aux_connector();
body();


//
rotate([0,0,0]) {
translate([0, 0, (body_h - plate_offset_h/2) * i])
    color("red", 0.6) plate();


translate ([0, 0, (body_h - plate_th - plate_offset_h) * i])
    rotate([0, 180, 0])
        color("yellow", 0.8)
            ribbon_casing();
translate ([0, 0, (body_h - plate_th - plate_offset_h - case_h) * i])
    rotate([0, 0, 0])
        color("green", 0.8)
            ribbon_casing();
}

module main_body() {
//    
    difference(){
         color("Teal", 0.8) hull(){
            linear_extrude(0.1) circle(plate_d/2);
            translate([0, 0, body_h/2.3]) linear_extrude(0.1) circle(plate_d/2, $fn = 12);
            translate([0, 0, body_h/3]) linear_extrude(0.1) circle(plate_d/2, $fn = 6);
            translate([0, 0, body_h]) linear_extrude(0.1) circle(plate_d/2 -10, $fn = 6);
            
        }
        translate([0,0, -body_h/2 + 20])
        scale([1, 1, 0.6]) sphere(d = inner_r*2 + 5);
        plate_offset();
        translate([0, 0, body_h - 1.5])
            cylinder(h=4, r = sqrt(3)/2 * (plate_d/2 -5), $fn = 6);
        
       
    }
}



module aux_connector(){

    difference(){
        cylinder(h = aux_body_h, r = aux_body_outer_r);
        translate([0, 0, -spacing]) cylinder(h = aux_ring_h, r = aux_ring_r/2);
        
        difference(){
            linear_extrude(aux_body_h + spacing)
                    difference(){
                        circle(aux_body_r);
                        for (i = [-1:2:1]) 
                            translate([0, i*aux_body_r, 0])
                                square([aux_body_cutout,1], center = true);
                    }
                }
            }
        }


module plate_offset(){
    translate([0,0,-spacing])
    cylinder(h = plate_offset_h, r = plate_d/2 - plate_offset_w);
}


module mounting_holes_for(){
     for(i = [-3 : 3])
       rotate(i * 360/6){
            translate([
                    0, 
                    plate_d/2 - mounting_hole_spacing,
                    body_mounting_hole_offset
                    ])
                cylinder(h = bolt_hole_depth , r1 = bolt_hole_r + bolt_hole_thickness + 1, r2 = bolt_hole_r + bolt_hole_thickness);

            
           difference(){
               hull(){ 
               //подпорки
                   color("red") translate([0, plate_d/2 - mounting_hole_spacing/2 - 1, body_mounting_hole_offset*2 + 1])
                    cube([ bolt_hole_r*2 + bolt_hole_thickness*5, mounting_hole_spacing -2, bolt_hole_depth-1], center = true);
                for(i = [-1 : 2 : 1])
                   translate([i*11, plate_d/2 - mounting_hole_spacing/2 , -body_mounting_hole_offset + bolt_hole_depth*2 + 1])
                   cylinder(h = 2, r = 1.3);
               }
               

               // скругление подпорок
                for(i = [-1 : 2 : 1])
                    rotate([0, i*(-3), 0])
                   translate([i*10, plate_d/2 - mounting_hole_spacing/2 - 4, -body_mounting_hole_offset])
                   cylinder(h = bolt_hole_depth+15, r1 = 5.25, r2 = 6.995);
          
                
            }
//            
            
        }
                        
}

module mounting_holes_mounts(){
    difference(){
        mounting_holes_for();
        translate([0, 0, 5]) // check nut length!!!!
        mounting_holes();
        rotate([0, 0, 90]) translate([0, 0, 5]) cube([case_l, case_w, case_h+2], center = true);
        
    }
}
    

