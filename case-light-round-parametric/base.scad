include <common.scad>;

base_bottom = 1.5;
base_wall = 4.0;
base_screw_len_add = 0.4 + 0.3;

base_bat_dia = 35.5;
base_bat_cut_w = 22;
base_bat_cut_h = 3 + 1.5;
base_bat_cut_off = 0.9 - 1.5;

use_printed_strap = false;

base_strap_h = 7.8;
base_strap_d = 5.2 + base_strap_add_l;
base_strap_cyl = 3;
base_strap_warp = 1;
base_strap_cut = 0.1;
base_strap_off = body_radius;

fstrap_width = 20;
fstrap_dist = fstrap_width + 0.2;
fstrap_hole = 1.1;
fstrap_depth = 1.9;
fstrap_add = 1.5;
fstrap_h = base_strap_h - 2;
fstrap_warp = base_strap_warp - 1;

base_height = base_bottom + base_wall;

module base_bat(h) {
    difference() {
        cylinder(d = base_bat_dia, h = h);
        
        translate([-base_bat_dia / 2, -base_bat_dia + base_bat_cut_off, -1])
        cube([base_bat_dia, base_bat_dia / 2, h + 2]);
    }
    
    translate([-base_bat_cut_w / 2, -base_bat_dia / 2 + base_bat_cut_off, 0])
    cube([base_bat_cut_w, base_bat_cut_h, h]);
}

module base_strap() {
    translate([-base_strap_w / 2, 0, 0])
    difference() {
        hull() {
            cube([base_strap_w, 0.1, base_strap_h]);
            
            translate([0, base_strap_d - 0.1 - base_strap_cyl / 2, base_strap_h / 2 - 0.05 + base_strap_warp])
            rotate([0, 90, 0])
            cylinder(d = base_strap_cyl, h = base_strap_w);
        }
        
        translate([-1, base_strap_d - strap_d / 2, base_strap_h / 2 + base_strap_warp])
        rotate([0, 90, 0])
        screw(true, true);
        
        translate([-0.1, -0.1, -base_strap_off + base_height])
        cube([base_strap_w + 0.2, base_strap_cut + 0.1, base_strap_h]);
    }
}

module fstrap_piece(w, s) {
    translate([-w / 2, 0, 0])
    difference() {
        hull() {
            translate([0, -fstrap_add, 0])
            cube([w, 0.1 + fstrap_add, fstrap_h]);
            
            translate([0, base_strap_d - 0.1 - base_strap_cyl / 2, fstrap_h / 2 - 0.05 + fstrap_warp])
            rotate([0, 90, 0])
            cylinder(d = base_strap_cyl, h = w);
        }
        
        translate([-1, base_strap_d - strap_d / 2, fstrap_h / 2 + fstrap_warp])
        rotate([0, 90, 0])
        cylinder(d = s, h = w + 2);
        
        translate([-0.1, -0.1 - fstrap_add, -base_strap_off + base_height])
        cube([w + 0.2, base_strap_cut + 0.1 + fstrap_add, fstrap_h]);
    }
}

module fstrap() {
    for (i = [-1, 1])
    scale([i, 1, 1])
    translate([(fstrap_dist + fstrap_depth) / 2, 0, 0])
    fstrap_piece(fstrap_depth, fstrap_hole);
}

module base() {
    difference() {
        union() {
            body(base_bottom, true);
            
            translate([0, 0, base_bottom])
            body(base_wall, false);
            
            if (use_printed_strap)
            for (i = [-1, 1])
            scale([1, i, 1])
            translate([0, body_dia / 2 + base_mount_off, base_strap_off])
            base_strap();
            
            if (!use_printed_strap)
            for (i = [-1, 1])
            scale([1, i, 1])
            translate([0, body_dia / 2 + base_mount_off, base_strap_off])
            fstrap();
        }
        
        translate([0, 0, base_bottom - 0.01])
        base_bat(base_wall + 1.01);
        
        translate([0, 0, base_bottom - base_screw_len_add])
        base_screws();
        
        usb_flatten(base_height);
    }
}

//base();
