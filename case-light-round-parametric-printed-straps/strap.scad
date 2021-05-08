include <common.scad>;

strap_piece_body_w = 5;
strap_piece_body_h = 20;
strap_latch_l = 6.8;
strap_latch_gap = 2 * 0.2;
strap_radius = 1.0;

strap_latch_w_body = base_strap_w + strap_latch_gap; //13.4;

strap_piece_w = strap_piece_body_w + 2 * strap_latch_l;
strap_latch_dist = strap_latch_wl + strap_latch_gap;

strap_rows = 2;
strap_cols = 6;
strap_piece_dist = 5;

module strap_latch(long = false, id = 0) {
    if (long) {
        translate([strap_latch_l - strap_radius, 0, 0])
        roundedcube(strap_d / 2 + strap_radius, strap_latch_wl, strap_d, strap_radius, true, true);
    } else {
        translate([strap_latch_l - strap_radius, 0, 0])
        roundedcube(strap_d / 2 + strap_radius, strap_latch_ws, strap_d, strap_radius, true, true);
    }
    
    difference() {
        union() {
            if (long) {
                translate([strap_d / 2 - strap_radius, 0, 0])
                roundedcube(strap_latch_l - strap_d / 2 + strap_radius * 2, strap_latch_wl, strap_d, strap_radius, true, true);
            } else {
                translate([strap_d / 2 - strap_radius, 0, 0])
                roundedcube(strap_latch_l - strap_d / 2 + strap_radius * 2, strap_latch_ws, strap_d, strap_radius, true, true);
            }
            
            if (long) {
                translate([strap_d / 2, 0, strap_d / 2])
                rotate([-90, 0, 0])
                roundedcylinder(strap_d, strap_latch_wl, strap_radius, true);
            } else {
                translate([strap_d / 2, 0, strap_d / 2])
                rotate([-90, 0, 0])
                roundedcylinder(strap_d, strap_latch_ws, strap_radius, true);
            }
        }
        
        if (long) {
            translate([strap_d / 2, -1, strap_d / 2])
            rotate([-90, 0, 0])
            cylinder(d = nut_dia, h = strap_latch_wl + 2);
        } else {
            translate([strap_d / 2, -1, strap_d / 2])
            rotate([-90, 0, 0])
            cylinder(d = screw_dia, h = strap_latch_ws + 2);
        }
    }
    
    if (!long) {
        if (visualize_screws) {
            if (id == 1) {
                %translate([strap_d / 2, 0, strap_d / 2 + screw_visual_off])
                rotate([90, 0, 0])
                screw(false, false, screw_len_strap);
            } else if (id == 2) {
                %translate([strap_d / 2, strap_latch_ws, strap_d / 2 + screw_visual_off])
                rotate([-90, 0, 0])
                screw(false, false, screw_len_strap);
            }
        }
    }
}

module strap_piece(latch_dist = strap_latch_dist) {
    translate([0, (strap_piece_body_h - latch_dist) / 2 - strap_latch_ws, 0]) {
        strap_latch(false, 1);
        
        translate([0, strap_latch_ws + latch_dist, 0])
        strap_latch(false, 2);
    }
    
    translate([strap_latch_l, 0, 0])
    roundedcube(strap_piece_body_w, strap_piece_body_h, strap_d, strap_radius, true, true);
    
    translate([strap_latch_l * 2 + strap_piece_body_w, strap_latch_wl / 2 + strap_piece_body_h / 2, 0])
    rotate([0, 0, 180])
    strap_latch(true);
}

module strap(assembled = true, c = strap_rows, angle = 0) {
    for (y = [0 : c - 1]) {
        translate([0, y * (strap_piece_body_h + strap_piece_dist), 0])
        translate([strap_piece_w - strap_d / 2, 0, strap_d / 2])
        rotate([0, angle, 0])
        translate([-strap_piece_w + strap_d / 2, 0, -strap_d / 2])
        strap_piece(strap_latch_w_body);
        
        if (strap_cols > 1) {
            for (x = [1 : strap_cols - 1]) {
                if (assembled) {
                    translate([x * (strap_piece_w - strap_d), y * (strap_piece_body_h + strap_piece_dist), 0])
                    strap_piece();
                } else {
                    translate([x * (strap_piece_w + strap_piece_dist), y * (strap_piece_body_h + strap_piece_dist), 0])
                    strap_piece();
                }
            }
        }
    }
}

//strap(false);
