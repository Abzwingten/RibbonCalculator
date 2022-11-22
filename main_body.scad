include <dimensions.scad>
use <ribbon_casing.scad>



translate([0, 0, body_h])
rotate([0, 180, 0])
union(){
    main_body();
    mounting_holes_mounts();
}

module main_body() {
    difference(){
         color("green") hull(){
            linear_extrude(0.1) circle(plate_d/2);
            translate([0, 0, body_h/2]) linear_extrude(0.1) circle(plate_d/2, $fn = 12);
            translate([0, 0, body_h/2.5]) linear_extrude(0.1) circle(plate_d/2, $fn = 6);
            translate([0, 0, body_h]) linear_extrude(0.1) circle(plate_d/2 -10, $fn = 6);
            
        }
        translate([0,0, -body_h/2 + 20])
        scale([1, 1, 0.6]) sphere(d = inner_r*2 + 5);
        plate_offset();
        translate([0, 0, body_h - 1.5])
            cylinder(h=4, r = sqrt(3)/2 * (plate_d/2 -5), $fn = 6);
        
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
                linear_extrude(bolt_hole_depth-2)
                   circle(bolt_hole_r + bolt_hole_thickness);
            
           difference(){
               hull(){ 
               //подпорки
                   color("red") translate([0, plate_d/2 - mounting_hole_spacing/2 - 1, body_mounting_hole_offset*2 + 0.5])
                    cube([ bolt_hole_r*2 + bolt_hole_thickness*6, mounting_hole_spacing -3, bolt_hole_depth-2], center = true);
                for(i = [-1 : 2 : 1])
                   translate([i*11, plate_d/2 - mounting_hole_spacing/2 , -body_mounting_hole_offset + bolt_hole_depth*2])
                   #cylinder(h = 1, r = 1);
               }
               // скругление подпорок
                for(i = [-1 : 2 : 1])
                   translate([i*10.2, plate_d/2 - mounting_hole_spacing/2 - 4, -body_mounting_hole_offset])
                   cylinder(h = bolt_hole_depth+12, r = 6.6);
          
                
            }
//            
            
        }
                        
}

module mounting_holes_mounts(){
    difference(){
        mounting_holes_for();
        translate([0, 0, 5]) // check nut length!!!!
        mounting_holes();
    }
}
    

