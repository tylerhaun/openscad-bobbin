use <libraries/utils.scad>

$fn=20;


module bobbin(
    shaft_length = 6,
    shaft_diameter = 3,
    shaft_hole_diameter = 2,
    flange_length = 1,
    flange_diameter = 10,
    flange_hole_diameter,
    flange_num_holes=8,
    fillet_length = 0.8,
    fillet_thickness = 0.6,
) {

    difference() {

        union() {

            bobbin_flange(
                flange_length,
                flange_diameter,
                flange_hole_diameter,
                flange_num_holes
            );
            
            _fillet_diameter = shaft_diameter/2 + fillet_thickness;

            translate([0,0,flange_length]) {
            
                cylinder(
                    h=fillet_length,
                    r1=_fillet_diameter,
                    r2=shaft_diameter/2,
                );
                
                translate([0,0,fillet_length])
                linear_extrude(shaft_length - fillet_length * 2)
                    circle(d=shaft_diameter);
                    
                translate([0,0,shaft_length - fillet_length])
                cylinder(
                    h=fillet_length,
                    r1=shaft_diameter/2,
                    r2=_fillet_diameter,
                );
            }

            translate([0,0,flange_length + shaft_length])
                bobbin_flange(
                    flange_length,
                    flange_diameter,
                    flange_hole_diameter,
                    flange_num_holes
                );

        }

        linear_extrude(flange_length * 2 + shaft_length)
        circle(d=shaft_hole_diameter);
    
    }

}


module bobbin_flange(
    length,
    diameter,
    hole_diameter,
    num_holes=8,
 ) {
 
    _hole_diameter = hole_diameter == undef
        ? diameter/5
        : hole_diameter
    ;

    linear_extrude(length)
    difference() {
    
        circle(d=diameter);
        
        repeat_around_circle(
            radius=diameter/3,
            num_instances=num_holes,
            angle_offset = 0,
            include_last = false,
        )
            circle(d=_hole_diameter);

        
        
    
    }
    

}


module test() {

    bobbin(
        shaft_length = 6,
        shaft_diameter = 3,
        shaft_hole_diameter = 2,
        flange_length = 1,
        flange_diameter = 10,
        flange_hole_diameter=2,
        flange_num_holes=8,
        fillet_length = 0.8,
        fillet_thickness = 0.6,
    );

}

test();