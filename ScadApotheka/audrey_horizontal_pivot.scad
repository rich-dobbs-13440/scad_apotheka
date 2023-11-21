/*

This is primarily a Horizontal Pivot with a Barrel configuration.  If special care
it can also be printed so that it pivots vertically.



Usage: 

use <ScadApotheka/audrey_horizontal_pivot.scad>
include <ScadApotheka/audrey_horizontal_pivot_constants.scad>

        // Use the children to generate an attachment
        clipping_diameter = 9;
        child_idx_handle_for_bearing = 0;
        child_idx_handle_for_tcap = 1;
        child_idx_handle_for_lcap = 2;
        
        attachment_instructions = [
            [ADD_HULL_ATTACHMENT, AP_BEARING, child_idx_handle_for_bearing, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_TCAP, child_idx_handle_for_tcap, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_LCAP, child_idx_handle_for_lcap, clipping_diameter],
            [ADD_SPRUES, AP_LCAP, [45, 135, 225, 315]],
        ];
        audrey_horizontal_pivot(size, r_axle, air_gap, angle_bearing, angle_pin attachment_instructions=attachment_instructions) {
            handle_for_bearing();
            handle_for_tcap();
            handle_for_lcap();
        }

*/

use <ScadStoicheia/vector_cylinder.scad>
include <ScadApotheka/audrey_horizontal_pivot_constants.scad>

/* [Boiler Plate] */

$fa = 1;
$fs = 0.4;
eps = 0.001;



/* [Show] */
show_pivot_example_colors = true;
show_pivot_default_colors = true;
show_pivot_with_weird_colors = true;
show_mounting_on_side_hand_crafted = true;

show_pin = false;
show_bearing = false;
show_bearing_rotational_group = false;
show_pin_rotational_group = false;
show_sprues = false;
show_mounting_on_top_of_item = false;
show_bearing_attachment_revision = true;
show_mounting_on_side = true;

show_supports_for_side_attachment = true;

/* [Colors] */
lcap_color_t = "Moccasin"; // ["Moccasin", "red", "blue", "green", "yellow", "orange", "purple"]
lcone_color_t = "LightBlue"; // [LightBlue, "red", "blue", "green", "yellow", "orange", "purple"]
axle_color_t = "IndianRed"; // ["IndianRed", "red", "blue", "green", "yellow", "orange", "purple"]
tcone_color_t = "Coral"; // ["Coral", "red", "blue", "green", "yellow", "orange", "purple"]
tcap_color_t = "AntiqueWhite"; // ["AntiqueWhite", "red", "blue", "green", "yellow", "orange", "purple"]
bearing_color_t = "PaleGreen"; // ["PaleGreen", "red", "blue", "green", "yellow", "orange", "purple"]
bearing_join_color_t = "LightSalmon"; // ["LightSalmon", "red", "blue", "green", "yellow", "orange", "purple"]
lcap_join_color_t = "DeepSkyBlue"; // ["DeepSkyBlue", "red", "blue", "green", "yellow", "orange", "purple"]
tcap_join_color_t = "LightBlue"; // ["LightBlue", "red", "blue", "green", "yellow", "orange", "purple"]

bearing_post_color_t = "OrangeRed"; // ["LightSalmon", "red", "blue", "green", "yellow", "orange", "purple"]

/* [Example Customization] */

size_t = 1; // [0: 0.1 : 10]
r_axle_t = 1.25; // [0: 0.05 : 3]
air_gap_t = 0.45; // [0.3: 0.01 : 0.6]
angle_bearing_t = 0; // [0: 360]
angle_pin_t = 180; // [0: 360]

module end_of_customization() {} 

function colors_t() = [
    lcap_color_t, 
    lcone_color_t, 
    axle_color_t, 
    tcone_color_t, 
    tcap_color_t, 
    bearing_color_t,
    bearing_join_color_t,
    lcap_join_color_t,
    tcap_join_color_t,
 ];

IDX_LCAP_COLOR = 0;
IDX_LCONE_COLOR = 1;
IDX_AXLE_COLOR = 2;
IDX_TCONE_COLOR = 3;
IDX_TCAP_COLOR = 4;
IDX_BEARING_COLOR = 5;
IDX_BEARING_JOIN_COLOR = 6;
IDX_LCAP_JOIN_COLOR = 7;
IDX_TCAP_JOIN_COLOR = 8;

COLOR_IDX_COUNT = 9;

function default_colors() = 
[ for (idx = [0:COLOR_IDX_COUNT]) 
    idx == IDX_BEARING_JOIN_COLOR ? "Plum"  :
    "SteelBlue"
];


if (show_sprues) {
    sprues(size=size_t, r_axle =r_axle_t, air_gap=air_gap_t, l_angles=[0, 120, 240], t_angles=[0,90, 180, 270]);
}

if (show_pin) {
    pin(size=size_t, r_axle=r_axle_t, air_gap=0, colors=colors_t()); 
}

if (show_bearing) {
    bearing(size=size_t, r_axle=r_axle_t, air_gap=air_gap_t, colors=colors_t()); 
}

if (show_bearing_rotational_group) {
    rotational_group(RG_BEARING, r_axle=r_axle_t, size=size_t, colors=colors_t()); 
}

 if (show_pin_rotational_group) {
    rotational_group(RG_PIN, size=size_t, r_axle=r_axle_t, colors=colors_t());
}

if (show_pivot_example_colors) {
    translate([10, 0, 0]) 
        audrey_horizontal_pivot(size_t, r_axle_t, air_gap_t, angle_bearing_t, angle_pin_t, colors=colors_t());
} 

if (show_pivot_default_colors) {
    translate([20, 0, 0]) 
        audrey_horizontal_pivot(size_t, r_axle_t, air_gap_t, angle_bearing_t, angle_pin_t);
} 

if (show_pivot_with_weird_colors) {
    weird_colors = [
        "Thistle", "Salmon", "LightSteelBlue", "PeachPuff", "MidnightBlue",
        "WhiteSmoke", "Salmon", "LightSteelBlue", "PeachPuff", "MidnightBlue"
    ];
    translate([30, 0, 0]) 
      audrey_horizontal_pivot(size_t, r_axle_t, air_gap_t, angle_bearing_t, angle_pin_t, colors=weird_colors);
}




if (show_mounting_on_side_hand_crafted) {
    pivot_size = 0.7;
    r_axle = pivot_size * 1.25;
    air_gap = 0.35;
    translate([40, 0, 0]) 
        vertical_pivot_with_hand_crafted_mounting_on_side(pivot_size, r_axle, air_gap);
}




module vertical_pivot_with_hand_crafted_mounting_on_side(size, r_axle, air_gap, colors) {
    
    // Although this pivot is design for horizontal rotation, it is printable so that it can 
    // rotate vertically if special care is taken:
    
    x = 3*size;
    y = 3*size;
    z_l = 2*size;
    z_t = 0.5*size;
    dy_t = 9*size;
    dy_l = 6*size;
    dz_l = z_l/2;
    dz_t = z_t/2;
    
    d_hdl = 8*size;
    h_hdl = r_connector_size(size, r_axle);
    dy_hdl = 10*size;
    dz_hdl = d_hdl/2 + size;
     
    
    attachment_instructions = [
        [ADD_HULL_ATTACHMENT, AP_LCAP, 0, -1],
        [ADD_HULL_ATTACHMENT, AP_TCAP, 1, -1],
        [ADD_HULL_ATTACHMENT, AP_BEARING, 2]
    ];
    rotate([90,0, 0]) {

        audrey_horizontal_pivot(
            size, 
            r_axle,
            air_gap, 
            0, 
            180,
            attachment_instructions=attachment_instructions) {
                
            translate([0, dy_l, dz_l]) cube([x, y, z_l], center=true);
            translate([0, dy_t, dz_t]) cube([x, y, z_t], center=true);
            translate([0, dy_hdl, dz_hdl]) rotate([0,90,0]) cylinder(d=d_hdl, h=h_hdl, center=true);
        }
        
        // Add spruces so that bearing is not hanging in mid air!
        sprues(size=size, r_axle=r_axle_t, air_gap=air_gap, l_angles=[0], t_angles=[0]);
        
    }
        
}

if (show_mounting_on_top_of_item) {
    translate([50, 0,0]) {
        plate_thickness = 0.5;
        plate_size = 11;
        dz = -plate_thickness/2;
        translate([0, 0, dz]) cube([plate_size, plate_size, plate_thickness], center=true);

        pivot_size = 1.;
        r_axle= 1.25 * pivot_size;
        air_gap = 0.35;
        angle = 90;
        
        // Detemine the handle mask parameters, so that bearing handle isn't in contact with base plate
        x_hm = 2*r_connector_size(pivot_size);
        y_hm = 2*t_connector_size(pivot_size);
        z_hm = r_lcap(pivot_size, r_axle, air_gap);
        dy_hm = y_hm/2 + r_lcap(pivot_size, r_axle, air_gap) - air_gap;
        dz_hm = z_hm/2;

        difference() {
            color("LightSteelBlue")  pivot(pivot_size, air_gap, angle);
            translate([0, dy_hm, dz_hm]) cube([x_hm, y_hm, z_hm], center=true);
        }
        
        // Now attach a hande that rests on the build plate.
        d_hdl = h_total(pivot_size) + plate_thickness;
        h_hdl = r_connector_size(pivot_size);
        dy_hdl = r_lcap(pivot_size, air_gap) + d_hdl/2; 
        dz_hdl = d_hdl/2 - plate_thickness ;
        translate([0, dy_hdl, dz_hdl]) 
        rotate([0,90,0]) cylinder(d=d_hdl, h=h_hdl, center=true);  
    }
}


if (show_supports_for_side_attachment) {
    
    translate([70, 0, 0]) {
    
        plate_thickness = 1;
        plate_size = 11;
        dz = -plate_thickness/2;
        dy = -3;
        translate([0, dy, dz]) cube([plate_size, plate_size, plate_thickness], center=true);  
        
        wall_thickness = 1;
        wall_height  = 12;
        x_w = plate_size;
        y_w = wall_thickness;
        z_w = wall_height;
        dz_w = z_w/2;
        translate([0, 0, dz_w]) cube([x_w, y_w, z_w], center=true);
        
        pivot_size = 1;
        r_axle = 2;
        air_gap = 0.55;
        dz_p = 9;
        
        instructions = [
            [ADD_CAP_YOKE, AP_LCAP],
            [ADD_SPRUES, AP_LCAP, [165, 195]],
            [ADD_SPRUES, AP_TCAP, [165, 195]],
            [ADD_HULL_ATTACHMENT, AP_BEARING, 0],
            [ADD_HULL_ATTACHMENT, AP_CAP_YOKE, 1],
        ];
        translate([0, 0, dz_p]) { 
        
            rotate([90, 0, 0]) {
                audrey_horizontal_pivot(pivot_size, r_axle, air_gap, angle_bearing=0, attachment_instructions=instructions) {
                    
                    bearing_handle(pivot_size);
                    yoke_brace_attachment(pivot_size);
                
                }
            }
        
        }
    }
        
    
}


module fake_handle(pivot_size, r_axle) {
    
    d_hdl = 10*pivot_size;
    h_hdl = r_connector_size(pivot_size, r_axle);
    dy_hdl = 8;
    dz_hdl = d_hdl/2 ;
    translate([0, dy_hdl, dz_hdl]) 
    rotate([0,90,0]) cylinder(d=d_hdl, h=h_hdl, center=true); 
}


if (show_bearing_attachment_revision) {
    
    translate([80, 0, 0]) {
    //    pivot_size = 0.5;
    //    air_gap = 0.35;
    //    * fake_handle(pivot_size);
        
        
        // Want to use the child to generate an attachment
        clipping_diameter = 9;
        attachment_instructions = [
            [ADD_HULL_ATTACHMENT, AP_BEARING, 0, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_TCAP, 1, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_LCAP, 1, clipping_diameter],
            [ADD_SPRUES, AP_LCAP, [45, 135, 225, 315]],
        ];
        * echo("attachment_instructions", attachment_instructions);
            audrey_horizontal_pivot(size_t, r_axle_t, air_gap_t, angle_bearing_t, angle_pin_t, attachment_instructions=attachment_instructions) {
            fake_handle(size_t, r_axle_t);
            fake_handle(0.75*size_t, r_axle_t);
        }
    }
}


// Start of implementation

// Rotation groups
RG_PIN = 3001;
RG_BEARING = 3002;



ROTATION_MAP = [
    [AP_BEARING, RG_BEARING],
    [AP_LCAP, RG_PIN],
    [AP_TCAP, RG_PIN],
    [AP_CAP_YOKE, RG_PIN],
    [AP_TOP_OF_TCAP, RG_PIN],
    [AP_BOTTOM_OF_LCAP, RG_PIN]
];

function rotation_match(mapping, attachment_point_id, group_id) = 
    mapping[0] == attachment_point_id && mapping[1] == group_id;

function is_in_rotational_group(group_id, attachment_point_id) = 
    len([for (mapping = ROTATION_MAP) if (rotation_match(mapping, attachment_point_id, group_id)) true]) > 0;
      
assert(is_in_rotational_group(RG_PIN, AP_LCAP), "Internal error: is_in_rotational_group implementation"); 
assert(!is_in_rotational_group(AP_BEARING, AP_LCAP), "Internal error: is_in_rotational_group implementation");  



FIRST_CHILD = 0;
SECOND_CHILD = 1; 

// Pivot geometry ratios to size

// Height rations should sum to 10 for backwards compatibility for total height.
S_H_LCAP = 2.0;
S_H_LCONE = 2.0;
S_H_AXLE = 2.0;
S_H_TCONE = 2.0;
S_H_TCAP = 2.0;

R_CONNECTOR_SIZE = 1.0;
T_CONNECTOR_SIZE = 2.5;


function r_lcap(size, r_axle, air_gap) =  r_axle + S_H_LCONE * size + air_gap;
function r_lcone(size, r_axle, air_gap) = r_axle + S_H_LCONE * size + air_gap;
function r_tcone(size, r_axle, air_gap) = r_axle + S_H_TCONE * size + air_gap;
function r_tcap(size, r_axle, air_gap) = r_axle + S_H_TCONE * size + air_gap;
function r_bearing(size, r_axle) = r_axle + S_H_LCONE * size ;

function r_connector_size(size, r_axle) =  r_axle + S_H_LCONE * size;  
function t_connector_size(size) = T_CONNECTOR_SIZE * size;

function h_lcap(size) = S_H_LCAP * size;
function h_lcone(size) = S_H_LCONE * size;
function h_axle(size) = S_H_AXLE * size;
function h_tcone(size) = S_H_TCONE * size;
function h_tcap(size) = S_H_TCAP * size;

function h_bearing(size) = h_lcone(size) + h_axle(size) + h_tcone(size);
function h_total(size) = 
    h_lcap(size) + 
    h_lcone(size) + 
    h_axle(size) + 
    h_tcone(size) + 
    h_tcap(size);


function columns() = [vcf_r1_idx(), vcf_r2_idx(), vcf_h_idx(), vcf_color_idx()];

// TODO add a shoulder to make vertical slop less?  Or change aspect ratio?
function pin_data(s, r_axle, dr, colors) = 
[   [ r_lcap(s, r_axle, dr),    r_lcone(s, r_axle, dr), h_lcap(s),  IDX_LCAP_COLOR ],
    [ r_lcone(s, r_axle, dr),   r_axle,  h_lcone(s), IDX_LCONE_COLOR ],
    [ r_axle,    r_axle,  h_axle(s),  IDX_AXLE_COLOR ],
    [ r_axle,    r_tcone(s, r_axle, dr), h_tcone(s), IDX_TCONE_COLOR ],
    [ r_tcone(s, r_axle, dr),   r_tcap(s, r_axle, dr),  h_tcap(s),  IDX_TCAP_COLOR ],
];



* echo("Sample pin data for cavity", pin_data(size_t, r_axle_t, 0.0));
* echo("Sample pin data for cavity", pin_data(size_t, r_axle_t, air_gap_t));


module pin(size, r_axle, air_gap, colors=default_colors()) {

    data = pin_data(size, r_axle, air_gap);
    * echo("In pin module: size", size, "air_gap", air_gap, "pin data", data);

    v_conic_frustrum(
        columns(), 
        data, 
        colors);  
}

module bearing(size, r_axle, air_gap, colors) {
    
    bearing_color = colors[IDX_BEARING_COLOR];
    r = r_bearing(size, r_axle);
    dz = h_lcap(size) + h_bearing(size)/2;
    color(bearing_color, alpha=0.35) {
        difference() {
            translate([0,0,dz]) cylinder(h=h_bearing(size), r=r, center=true);
            pin(size, r_axle, air_gap, colors); 
        }
    } 
}

module connector_post(size, r_axle, air_gap, positive_offset) {
    x = t_connector_size(size);
    y = r_connector_size(size, r_axle) + r_tcone(size, r_axle, 0);
    z = h_total(size);
    dy = (positive_offset ? 1: -1) * y/2;
    dz = z / 2;
    h_clearance = 3 * h_total(size);
    r_clearance = r_tcone(size, r_axle, air_gap);
    
    difference() { 
        translate([0, dy, dz]) cube([x, y, z], center=true);
        cylinder(r=r_clearance, h=h_clearance, center=true);
    }
}

module bearing_join(size, r_axle, colors) {
    x = t_connector_size(size);
    y = r_connector_size(size, r_axle) + r_bearing(size, r_axle);
    z = h_bearing(size);
    dy = y/2;
    dz = z / 2 + h_lcap(size);
    color(colors[IDX_BEARING_JOIN_COLOR]) {
        difference() {
            translate([0, dy, dz]) cube([x, y, z], center=true);
            cylinder(r=r_bearing(size, r_axle), h=2*h_total(size), center=true);
        }
    }
}

module l_cap_join(size, r_axle, colors) {
    x = t_connector_size(size);
    y = r_connector_size(size, r_axle) + r_bearing(size, r_axle);
    z = h_lcap(size);
    dy = y/2;
    dz = z / 2;   
    color(colors[IDX_LCAP_JOIN_COLOR]) {
        difference() {
            translate([0, dy, dz]) cube([x, y, z], center=true);
            pin(size, r_axle, 0);
        } 
    }
}

module t_cap_join(size, r_axle, colors) {
    x = t_connector_size(size);
    y = r_connector_size(size, r_axle) + r_bearing(size, r_axle);
    z = h_tcap(size);
    dy = y/2;
    dz = h_total(size) - z / 2;   
    color(colors[IDX_TCAP_JOIN_COLOR]) {
        difference() {
            translate([0, dy, dz]) cube([x, y, z], center=true);
            pin(size, r_axle, 0);
        } 
    }
}

module attachment_target(connector_id, size, r_axle, air_gap, colors) {
    if (connector_id == AP_BEARING) {
        bearing_join(size, r_axle, colors);
    } 
    if (connector_id == AP_CAP_YOKE) {
        connector_post(size, r_axle, air_gap, positive_offset= true); 
    }
    if (connector_id == AP_LCAP) {
        l_cap_join(size, r_axle, colors);
    }
    if (connector_id == AP_TCAP) {
        t_cap_join(size, r_axle, colors);
    }
}


module attach(attachment_point_id, size, r_axle, air_gap, colors, instruction) {
    command = instruction[0];
    if (command == ADD_HULL_ATTACHMENT) {
        child_idx = instruction[2];
        hull() {
            children(child_idx);
            attachment_target(attachment_point_id, size, r_axle, air_gap, colors); 
        }
    }
    if (command == ADD_CAP_YOKE) { 
        attachment_target(AP_CAP_YOKE, size, r_axle, air_gap, colors); 
    }
    if (command == ADD_SPRUES) {
        angles = instruction[2];
        * echo("angles", angles);
        if (attachment_point_id == AP_LCAP) {
            sprues(size, r_axle, air_gap, l_angles=angles); 
        }
        if (attachment_point_id == AP_TCAP) {
            sprues(size, r_axle, air_gap, t_angles=angles); 
        }
    }
}

module rotational_group(group_id, size, r_axle, air_gap, colors, instructions) {
    
    // TODO - handle this as instructions using default values.
    if (group_id == RG_BEARING) {
        bearing_join(size, r_axle, colors);  
    } 
    if (group_id == RG_PIN) {
        // TODO:  add this as default as an attachment!
        l_cap_join(size, r_axle, colors); 
        t_cap_join(size, r_axle, colors); 
    }
    * echo("rotational_group: instructions", instructions);
    if (!is_undef(instructions) ) {
        if (len(instructions) > 0) {
            for (instruction = instructions) {
                * echo("instruction: instructions", instruction);
                attachment_point_id = instruction[1];
                * echo("attachment_point_id", attachment_point_id);
                if (is_in_rotational_group(group_id, attachment_point_id)) {
                    attach(attachment_point_id, size, r_axle, air_gap, colors, instruction) {    
                        children(0);
                        children(1);
                        children(2);
                        children(3);
                        children(4);
                    }
                }
            } 
        }
    } 
}

module audrey_horizontal_pivot(size, r_axle, air_gap =0.4, angle_bearing=0, angle_cap=180, colors=default_colors(), attachment_instructions=[]) {

    assert(!is_undef(size), "You must specify size");
    assert(!is_undef(air_gap), "You must specify air_gap");
    assert(is_num(angle_bearing), "angle_bearing must be a number");
    assert(is_num(angle_cap), "angle_cap must be a number");
    assert(len(colors) >= 5,"The number of colors must be at least 5");
    
    * echo("In pivot module")
    * echo("size = ", size);
    * echo("air_gap = ", air_gap);
    * echo("angle_bearing = ", angle_bearing);
    * echo("angle_cap = ", angle_cap);
    * echo("colors", colors);
    * echo("attachment_instructions", attachment_instructions);
    
    pin(size, r_axle, 0.0, colors);
    bearing(size, r_axle, air_gap, colors);
    rotate([0, 0, angle_cap]) {
        rotational_group(RG_PIN, size, r_axle, air_gap, colors, attachment_instructions) {
            // Kludge to avoid implicit union!
            children(0);
            children(1);
            children(2);
            children(3);
            children(4);
        }
    } 
    rotate([0, 0, angle_bearing]) {
         
        rotational_group(RG_BEARING, size, r_axle, air_gap, colors, attachment_instructions) {
            children(0);
            children(1);
            children(2);
            children(3);
            children(4);
        }
    }
    * echo("Exit pivot module");
}

module sprues(size, r_axle, air_gap, l_angles, t_angles) {
    // Design tweek to help with printing
    
    h_sprue = 2*air_gap;
    r_sprue = air_gap;
    dy = - r_bearing(size, r_axle) - air_gap/2;
    
    for (a = l_angles) {
        dz = h_lcap(size) + h_sprue/2;
        rotate([0, 0, a]) translate([0, dy, dz]) cylinder(r=air_gap, h=h_sprue, center=true);
    }
    for (a = t_angles) {
        dz = h_tcap(size) + h_bearing(size) - h_sprue/2;
        rotate([0, 0, a]) translate([0, dy, dz]) cylinder(r=air_gap, h=h_sprue, center=true);
    }
}








module bearing_handle(size) {
    
    d_hdl = 7*size;
    r_axle = 3 * size;
    h_hdl = r_connector_size(size, r_axle);
    dy_hdl = 10*size;
    dz_hdl = d_hdl/2 + 1.5* size;
    translate([0, dy_hdl, dz_hdl]) rotate([0,90,0]) {
        cylinder(d=d_hdl, h=h_hdl, center=true);
    }
}

module yoke_brace_attachment(size) {
    x = 0.5*size;
    y = 0.5*size;
    z = 0.5*size;

    dy = 9*size;
    dz = z/2;
    translate([0, dy, dz]) cube([x, y, z], center=true);
}






