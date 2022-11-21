include <dimensions.scad>
include <tile_functions.scad>

radius = 4;

size = sqrt(3)/2 * radius; // радиус описанной окружности
height = size * 2; // высота шестиугольника

vert_dist = height * 3/4;

width = radius * 2;

horiz_dist = width;


for(x = [0 : horiz_dist : 25], y = [0 : vert_dist : 25]){
   
    translate([x, y*row_mult, 0])
        circle(radius);

}


//plate_base();


hex_peri =  repeat([[1,120]],6);
hex_tile= peri_to_tile(hex_peri);
dx=[1+cos(60),-sin(60),0];
dy=[0,2*sin(60),0];
echo(dx,dy);
scale(20) 
   repeat_tile(2,2,dx,dy)
      fill_tile(inset_tile(hex_tile,0.02));