include <dimensions.scad>


module triangles (){
         for (i = [0:30:360])
                            rotate([0, 0, i+15])
                                translate([-headband_mount_inner_d+0.1, 0, 0])
                                    color("red") circle(0.3, $fn = 3);
    }
    
module outer_shell(radius_off = 0){color("blue") circle(headband_mount_outer_d + radius_off, $fn = 6);}

module inner_shell(){color("green") circle(headband_mount_inner_d + spacing, $fn = 24);}
    
    
module headband_mount(triangle = true, length = 0){
    
    
    union(){
        linear_extrude(headband_mount_length_1 + length){
            difference(){
                       outer_shell();
                       if (triangle) inner_shell();
                }
                if (triangle) triangles();
            }
        linear_extrude(5 + length){
            difference(){
                       outer_shell(2);
                       if (triangle) inner_shell();
                }
                if (triangle) triangles();
            }
    }
}

headband_mount();

module headband_mount_hole(length = 0){
    headband_mount(false, length);
}