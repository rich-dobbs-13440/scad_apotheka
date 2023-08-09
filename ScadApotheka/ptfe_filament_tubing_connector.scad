/*

This system implements quarter turn connections of PTFE tubing and
3d printed parts to form a filament path. 

Compared to the stainless steel quick connect fittings, this is much 
lower cost, considering it just uses 3d printed parts to join the tubing.  

Compared to the 3d printed quick connect style fittings also in 
ScadApotheka, this holds the tubing more securely and is less 
prone to breakage of the collet.  However, nut used securing the
fittings results in a less spacing of components.  With the quick
connect parallel filament paths can be spaced about 15 mm apart.  
With this system, parallel paths must be spaced about 25 mm apart. 

The modules and functions use a common suffix "flute_" for avoiding
name clashes with other librarie. You can think of this as: 

    Filament 
    Locking
    Using
    Turn 
    Engagement
 
Usage:

    use <ScadApotheka/ptfe_filament_tubing_connector.scad>
    
     flute_collet(is_filament_entrance = true, as_clearance = false);
     
      flute_collet_nut();
      
    render(convexity=10) difference() {
        base();  
        flute_keyhole(is_filament_entrance = true, print_from_key_opening=true);
    }      
     
     If necessary for using placing parts, the dimensions of functional components
     can be retrieved using these utility functions:
     
        clamp = flute_clamp_dimensions();
        connector = flute_connector_dimensions();   
  
    In forming custom fittings, the following utility function may be helpful:
    
        flute_filament_path(is_entrance, multiplier = 5);
    
   

*/
include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>


od_ptfe_tubing = 4 + 0;
id_ptfe_tubing = 2 + 0;
d_filament = 1.75 + 0;
a_lot = 100 + 0;

/* [Example] */
show_assembled = false;

show_collet = true;
show_collet_nut = true;
show_union = true;
show_sample_key_hole = true;
show_filament_path = true;
is_filament_entrance = true;


/* [Animation] */

az_clip = 0; //[0:90]
dz_crossection =-1; // [-1:0.1:30]

dy_crossection = -30; // [-30:0.5: 30]

alpha_clip = 1; //[1: Solid, 0.25: Ghostly, 0:Invisible]

/* [Clearances] */
x_clearance = 0.25;
y_clearance = 0.25;
z_clearance = 0.25;
tube_clearance = 0.25;
loose_tube_clearance = 1;
filament_clearance = 0.25;
key_clearance = 0.5;

aspect_ratio_tuning = 1;

/* [PTFE Tubing Core Dimensions] */
core_length = 0.1;

/* [PTFE Clamp Dimensions] */ 

entrance_diameter = 4.2;

x_clamp = 10;
y_clamp = 6; 
z_clamp = 8;
x_neck_clamp = 6;
x_slot_clamp = 1;
z_slot_clamp = 5;
// Tune if necessary to hold tube
dx_squeeze_clamp = 1.5; // [0:0.25:3]  
barb_spacing = 2;
barb_bite = 0.5;

/* [PTFE Connector Dimensions] */ 

x_connector = 10;
y_connector = 6;
z_connector = 8;
x_neck_connector = 6;
x_slot_connector = 0.5;
z_slot_connector = 3;

// Tune if necessary to hold connector in keyhole
dx_squeeze_connector = 1.5;  

/* [PTFE Tubing Nut Dimensions] */

nut_wall = 1;
h_nut = 6;
h_nut_base = 1.;
nut_sides = 4; //[4, 6]

/* [Dimensions] */
h_union_core = 4;
union_sides = 4; //[4, 6]

module end_of_customization() { }

// Example

module flute_sample_key_hole(is_filament_entrance) {
    
    module base() {
        block([20, 20, z_connector + 4], center=ABOVE);  
    }
    render(convexity=10) difference() {
        base();  
        flute_keyhole(is_filament_entrance, print_from_key_opening=true);
    }
}

if (show_collet) {
    rotation = [0, 0, 0];
    translation = show_assembled ? [0, 0, h_nut_base] : [20, 0, 0]; 
    translate(translation) rotate(rotation) flute_collet(is_filament_entrance=is_filament_entrance);
}

if (show_collet_nut) {
     translate([40, 0, 0]) rotate([0, 0, az_clip])  flute_collet_nut(sides = 4);
    translate([40, 20, 0]) rotate([0, 0, az_clip])  flute_collet_nut(sides = 6);
}

if (show_union) {
    translate([60, 0, 0]) flute_union(sides=union_sides, h_union_core = h_union_core);
}

if (show_sample_key_hole) {
  translate([80, 0, 0])  flute_sample_key_hole(is_filament_entrance = is_filament_entrance);
}



if (show_filament_path) {
    translate([100, 0, 0])  flute_filament_path(is_entrance=is_filament_entrance);
}


function flute_clamp_connector() = 
    quarter_turn_connector(
            [x_clamp, y_clamp, z_clamp],
            [x_clearance, y_clearance, z_clearance],
            [x_slot_clamp, -1, z_slot_clamp],
            [x_neck_clamp, -1, -1],
            [dx_squeeze_clamp, -1, -1],
            aspect_ratio_tuning);


function flute_connector() = 
    quarter_turn_connector(
        [x_connector, y_connector, z_connector], 
        [x_clearance, y_clearance, z_clearance], 
        [x_slot_connector, -1, z_slot_connector],
        [x_neck_connector, -1, -1],
        [dx_squeeze_connector, -1, -1],
        aspect_ratio_tuning);  

module flute_barbed_tubing_clearance() {
    barb_count = ceil(z_clamp/barb_spacing);
    id = od_ptfe_tubing+2*tube_clearance;
    for (i = [0: barb_count-1]) {
        translate([0, 0, i*barb_spacing]) 
            can(d=id, taper=id-barb_bite,  h = barb_spacing, center=ABOVE);
    }
}

module flute_collet(is_filament_entrance=true, as_clearance=false) {
    clamp = flute_clamp_connector();
    connector = flute_connector();
    
    module cavity() {
        flute_barbed_tubing_clearance();
        translate([0, 0, z_clamp + core_length])  
            flute_filament_path(is_entrance = is_filament_entrance);
        
    }
    if (as_clearance) {
        quarter_turn_clamping_connector_key(core_length,  clamp, connector);
        cavity();        
    } else {

        render(convexity=10) difference() {
            quarter_turn_clamping_connector_key(core_length,  clamp, connector);
            cavity();
        }
    }
}

module flute_filament_path(is_entrance=true, multiplier = 5, include_below = true) {
    module filament_exit() {
        can(d=d_filament+ 2*filament_clearance, h = z_connector*multiplier, center = ABOVE);
    }    
    module filament_entrance() {
            can(d=d_filament + 2*filament_clearance, taper=entrance_diameter*multiplier,  h = z_connector*multiplier,  center=ABOVE);
            
    }    
    if (is_entrance) {
        filament_entrance();
    } else {
        filament_exit(); 
    }
    if (include_below) { 
        can(d=d_filament + 2*filament_clearance, h = z_clamp*multiplier, center=BELOW);
    }
}


module nut_blank(sides, h_nut, nut_wall, connector) {
    az = 180/sides;
    extent = gtcc_extent(connector);  
    r = sqrt(extent.x^2 + extent.y^2)/2;
    s_nut = 2 * ceil(r + nut_wall);
    echo("s_nut", s_nut);   
    d_nut = s_nut/cos(az);
    echo("d_nut", d_nut);
    rotate([0, 0, az]) can(d =d_nut, h = h_nut, $fn=sides, center=ABOVE);
}  
    
 
module flute_collet_nut(sides = 6) { 
    clamp = flute_clamp_connector();
    key_extent = gtcc_extent(clamp);   
    module clamping_keyhole() {
        translate([0, 0, key_extent.z + h_nut_base]) 
            rotate([180, 0, 0]) 
                quarter_turn_clamping_connector_keyhole(clamp, print_from_key_opening=false);        
    }
    module tubing() {
        can(d=od_ptfe_tubing + 2 * loose_tube_clearance, h = z_clamp + core_length/2, center=ABOVE);
    }    
    color(PART_20, alpha = alpha_clip) {
        render(convexity=10) difference() {
            nut_blank(sides, h_nut, nut_wall, clamp);
            clamping_keyhole();
            tubing();
            translate([0, 0, dz_crossection]) plane_clearance(BELOW);
        }
    }
} 


module flute_union(sides=6, h_union_core = 6) {
    connector = flute_connector();
    key_extent = gtcc_extent(connector);   
//    cam = gtcc_cam(connector);   
//    d_nut = 2 * ceil((cam.x + nut_wall));
    h_union = 2 *key_extent.z + h_union_core;
    module filament() {
        can(d=id_ptfe_tubing, h = a_lot);
    }
    color(PART_21, alpha = alpha_clip) {
        render(convexity=10) difference() {
            nut_blank(sides, h_union, nut_wall, connector);
            quarter_turn_clamping_connector_keyhole(connector, print_from_key_opening=true);  
            translate([0, 0, 2 * key_extent.z + h_union_core]) 
                rotate([180, 0, 0]) 
                    quarter_turn_clamping_connector_keyhole(connector, print_from_key_opening=false);    
            filament();
            translate([0, 0, dz_crossection]) plane_clearance(BELOW);
            translate([0, dy_crossection, 0]) plane_clearance(LEFT);
        }
    }
    
}


module flute_keyhole(is_filament_entrance, print_from_key_opening) {
    connector = flute_connector();
     bridging_diameter = is_filament_entrance ? entrance_diameter: d_filament+ 2*filament_clearance;
    echo("bridging_diameter", bridging_diameter);
    quarter_turn_clamping_connector_keyhole(connector, print_from_key_opening, bridging_diameter=bridging_diameter) {
        // Need to pass chidren through this module
        children();
    }
    // Adjustment of opening so there is no edge to catch at top of collet for entrances, and outlet doesn't interfere with bridging. 
   dz_path =  print_from_key_opening && is_filament_entrance ? 5 : 0;
    translate([0, 0, dz_path]) flute_filament_path(is_entrance = is_filament_entrance);
}



