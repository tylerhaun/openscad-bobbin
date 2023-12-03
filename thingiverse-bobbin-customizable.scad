// parameters

/* [SHAFT] */

SHAFT_LENGTH = 6; // [0.1:250]
SHAFT_DIAMETER = 3; // [0.1:250]
SHAFT_HOLE_DIAMETER = 2; // [0.1:250]

/* [FLANGE] */

FLANGE_LENGTH = 1; // [0.1:250]
FLANGE_DIAMETER = 10; // [0.1:250]
FLANGE_HOLE_DIAMETER=2; // [0.1:250]
FLANGE_NUM_HOLES=8; // [1:50]

/* [FILLET] */

FILLET_LENGTH = 0.8; // [0.01:10]
FILLET_THICKNESS = 0.6; // [0.01:10]


// end paremeters


module repeat_on_ellipse(
    semi_major_axis,
    semi_minor_axis,
    num_instances,
    angle_offset = 0,
    include_last = false
) {


    for (j = [0:num_instances - (include_last ? 0 : 1)]) {
        angle = (j * 360 / num_instances) + angle_offset;
        translate([
            semi_major_axis * cos(angle),
            semi_minor_axis * sin(angle)
        ])
        rotate([0, 0, angle])
            children();
    }

}

module repeat_on_circle(
    radius,
    num_instances,
    angle_offset = 0,
    include_last = false
) {

    repeat_on_ellipse(
        semi_major_axis = radius,
        semi_minor_axis = radius,
        num_instances = num_instances,
        angle_offset = angle_offset,
        include_last = include_last
    )
        children();

}

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
    fillet_thickness = 0.6
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
                    r2=shaft_diameter/2
                );
                
                translate([0,0,fillet_length])
                linear_extrude(shaft_length - fillet_length * 2)
                    circle(d=shaft_diameter);
                    
                translate([0,0,shaft_length - fillet_length])
                cylinder(
                    h=fillet_length,
                    r1=shaft_diameter/2,
                    r2=_fillet_diameter
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
    num_holes=8
 ) {
 
    _hole_diameter = hole_diameter == undef
        ? diameter/5
        : hole_diameter
    ;

    linear_extrude(length)
    difference() {
    
        circle(d=diameter);
        
        repeat_on_circle(
            radius=diameter/3,
            num_instances=num_holes,
            angle_offset = 0,
            include_last = false
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
        fillet_thickness = 0.6
    );

}


bobbin(
    shaft_length = SHAFT_LENGTH,
    shaft_diameter = SHAFT_DIAMETER,
    shaft_hole_diameter = SHAFT_HOLE_DIAMETER,
    flange_length = FLANGE_LENGTH,
    flange_diameter = FLANGE_DIAMETER,
    flange_hole_diameter=FLANGE_HOLE_DIAMETER,
    flange_num_holes=FLANGE_NUM_HOLES,
    fillet_length = FILLET_LENGTH,
    fillet_thickness = FILLET_THICKNESS
);
