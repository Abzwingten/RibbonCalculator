include <dimensions.scad>
include <tile_functions.scad>

radius = 4;

size = sqrt(3)/2 * radius; // радиус описанной окружности
height = size * 2; // высота шестиугольника

vert_dist = height * 3/4;

width = radius * 2;

horiz_dist = width;


//for(x = [0 : horiz_dist : 25], y = [0 : vert_dist : 25]){
//   
//    translate([x, y, 0])
//        circle(radius);
//
//}


//plate_base();
hull(){
    linear_extrude(1) circle(90, $fn = 6);
    translate([0, 0, 40]) linear_extrude(1)  circle(90);
}

