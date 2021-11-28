# RibbonCalculator
Draft ribbon topology generator for custom planar ribbon technology audio driver for project https://www.thingiverse.com/thing:4758902

# What is it
This is Unity3D project, that can helps in custom ribbon headphones development. It can makes topology with your size parameters. 
It can optimize force gradient over entire ribbon, that appears by magnetic field with known curvature. 
Why Unity3D. 
It's my everyday tool. Initially, that project starts as OpenSCAD project, but i was not satisfied with OpenSCAD language limitations. 

# How and why it works
Project contains code for procedurical generation of non-linear magnet field compensated ribbon.
Common parameters placed in ./Assets/FormGenerator.cs
```C#
            var linesCount = 17;
            var space = 0.3f;
            var baseWidth = 17.2f;
            var actionZoneHeigth = 69;
            var deadZone = 16;
            var thin = 0.05f;
```
 - linesCount - generated lines count inside work zone
 - space - space between lines
 - baseWidth - width of work zone must be a little bit lesser, than distance between magnets, for example 17.2 mm generated for 18mm magnet space
 - actionZoneHeigth - height of generated topology
 - deadZone - distance between two rows of lines
 - thin - generated model thin

Project adds RibbonSolver item into Unity3D main menu.
There are two options:
 - Create Ribbon Form
Creates 3d mesh with parameters inside of ./Assets/FormGenerator.cs and performs stl mesh export. You can select save path in save file dialog.
Generated mesh also visible inside of Unity3D viewport.
 - Clear
Removes generated mesh from scene. Works only for current session.

# Math
Curvature of magnetic field contains inside GetWidth() fuction. It's approximated magnetig field density module over two driver sides, in line between center of magnets. Algorithm creates wide lines in strength field, and in weak - narrow lines.

P.S. Sorry for bad code, i have no time for cleaning, so i will be very grateful if someone helps me.

# License
MIT
