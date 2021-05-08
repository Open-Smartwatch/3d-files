include <common.scad>;

use_single_piece_buttons = false;

lcd_parts_height = 4.3;
electronics_height = lcd_parts_height + pcb_h;

mid_base = 0.8;
electronics_dia = 37.3;
cut_w = 7.0;
cut_h = 38.0;
cut_tw = 14.5;
cut_th = 4.5;
cut_off = 1;

top_cut_w = 14.6;
top_cut_l = 3.0;
top_cut_off = 1.6; //2.0;
bot_cut_w = 15.8;
bot_cut_l = 4.2;
bot_cut_off = 2.3; //0.5;
bot_cut_wall_h = pcb_h + 0.2; //1.8;
bot_cut_wall_w = 1.2;

usb_w = 8.3;
usb_h = 3.8;
usb_cut = 8.5;
usb_cut_off = 0.7;
usb_cut_len = 1.6;

mid_strap_cut_w = 10;
mid_strap_cut_h = 5;
mid_strap_cut_d = mid_strap_cut_h - 1;
mid_strap_cut_off_y = 1.1;
mid_strap_cut_off_z = 0.5;

mid_button_width = 4.3 - 0.3;
mid_button_height = 3.0;
mid_button_depth = 4.0;
mid_button_gap_width = 2.6;
mid_button_gap_wall = 1.6;
mid_button_off = 0.25; //1.3; //pcb_h - 0.3;
mid_button_holder_width = 5.4;
mid_button_holder_depth = 1.4;

button_height = 2.2;
button_length = 5.0;
button_width = 3.7;
button_radius = 0.5;
button_wing = 0.5;
button_wing_len = 1.0;

mid_snap_dia = 2;
mid_snap_off = 2.55;

mid_threshold = 4.0;

mid_height = mid_base + electronics_height;

module mid_cutout(h) {
    translate([-cut_w / 2, -cut_h / 2, 0])
    linear_extrude(h) {
        square([cut_w, cut_h]);
        
        translate([-(cut_tw - cut_w) / 2, cut_h - cut_th])
        square([cut_tw, cut_th]);
    }
}

module mid_button_cut_original() {
    translate([-mid_button_width / 2, -1, 0])
    cube([mid_button_width, mid_button_depth + 2, mid_button_height]);
    
    translate([-mid_button_holder_width / 2, (body_dia - electronics_dia) / 2 - mid_button_holder_depth, 0])
    cube([mid_button_holder_width, mid_button_holder_depth + 1, mid_button_height]);
    
    translate([-mid_button_gap_width / 2, mid_button_gap_wall, mid_button_height - 1])
    cube([mid_button_gap_width, mid_button_depth - mid_button_gap_wall + 1, mid_height]);
}

module mid_button_original() {
    translate([button_width + button_wing, 0, button_length])
    rotate([0, 180, 0])
    roundedcube(button_width, button_height, button_length, button_radius, true);
    
    cube([button_wing + button_radius, button_height, button_wing_len]);
    
    translate([button_width, 0, 0])
    cube([button_wing + button_radius, button_height, button_wing_len]);
}

module mid_buttons_original() {
    for (i = [button_angle_r, button_angle_1, button_angle_2, button_angle_3]) {
        rotate([0, 0, i])
        translate([-button_width / 2 - button_wing, -body_dia / 2 + button_length - button_wing_len, button_height])
        rotate([90, 0, 0])
        mid_button_original();
    }
}

module buttons_cutouts() {
    if (use_single_piece_buttons) {
        // TODO
    } else {
        mid_button_cut_original();
    }
}

module buttons_print() {
    if (use_single_piece_buttons) {
        // TODO
    } else {
        translate([button_height, 0, 0])
        rotate([0, 0, 90])
        mid_button_original();
        
        translate([button_height * 2 + 2, 0, 0])
        rotate([0, 0, 90])
        mid_button_original();
        
        translate([button_height * 3 + 4, 0, 0])
        rotate([0, 0, 90])
        mid_button_original();
        
        translate([button_height * 4 + 6, 0, 0])
        rotate([0, 0, 90])
        mid_button_original();
    }
}

module buttons_assembly() {
    if (use_single_piece_buttons) {
        // TODO
    } else {
        mid_buttons_original();
    }
}

module mid_body_cut_2() {
    translate([-mid_strap_cut_w / 2, -body_dia / 2 - 7, mid_height - 5])
    rotate([45, 0, 45])
    cube([5, 10, 1]);
}

module mid_body_cut() {
    translate([-mid_strap_cut_w / 2, -body_dia / 2 + mid_strap_cut_off_y, mid_height + mid_strap_cut_off_z])
    rotate([180, 0, 0])
    prism(mid_strap_cut_w, mid_strap_cut_d, mid_strap_cut_h);
    
    mid_body_cut_2();
    
    scale([-1, 1, 1])
    mid_body_cut_2();
}

module mid_body() {
    difference() {
        body(mid_height);
        
        mid_body_cut();
        
        scale([1, -1, 1])
        mid_body_cut();
    }
    
    translate([0, 0, mid_height - 1])
    cylinder(d = body_dia, h = 1);
}

module mid() {
    difference() {
        mid_body();
        
        rotate([0, 0, 180])
        translate([0, -cut_off, -1])
        mid_cutout(mid_base + 2);
        
        translate([-body_dia / 2 - 1, -usb_w / 2, mid_base])
        cube([body_dia / 2, usb_w, usb_h]);
        
        translate([-usb_cut_len - body_dia / 2 + (body_dia - electronics_dia) / 2 + usb_cut_off, -usb_cut / 2, mid_base])
        cube([usb_cut_len, usb_cut, mid_height]);
        
        usb_flatten(mid_height);
        
        for (i = [button_angle_r, button_angle_1, button_angle_2, button_angle_3]) {
            rotate([0, 0, i])
            translate([0, -body_dia / 2, mid_base + mid_button_off])
            buttons_cutouts();
        }
        
        translate([0, 0, -1])
        base_screws(false, true);
        
        translate([0, 0, mid_base]) {
            cylinder(d = electronics_dia, h = mid_height - mid_base + 1);
            
            translate([-top_cut_w / 2, electronics_dia / 2 - top_cut_off, 0])
            cube([top_cut_w, top_cut_l, mid_height - mid_base + 1]);
            
            translate([-bot_cut_w / 2, -electronics_dia / 2 - bot_cut_off, 0])
            difference() {
                cube([bot_cut_w, bot_cut_l, mid_height - mid_base + 1]);
                
                translate([-1, -1, -1])
                cube([bot_cut_w + 2, bot_cut_wall_w + 1, mid_height - mid_base - bot_cut_wall_h + 1]);
            }
        }
    }
    
    rotate([0, 0, -135 - 10])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, -45 + 10])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, 135 + 10])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, 45 - 10])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
}

//mid();
//#buttons_assembly();

//buttons_print();
