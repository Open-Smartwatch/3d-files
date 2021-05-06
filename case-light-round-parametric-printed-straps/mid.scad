include <base.scad>;

lcd_parts_height = 6.0 - 1.6;
electronics_height = lcd_parts_height + pcb_h;

mid_base = 0.8;
electronics_dia = 36.7;
cut_w = 6.2;
cut_h = 37.3;
cut_tw = 14.5;
cut_th = 3.5;
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

mid_button_width = 4.3;
mid_button_height = 3.0;
mid_button_depth = 4.0;
mid_button_gap_width = 2.6;
mid_button_gap_wall = 1.6;
mid_button_off = 1.3; //pcb_h - 0.3;

mid_snap_dia = 2;
mid_snap_off = 2.5 + 0.2;

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

module mid_button() {
    translate([-mid_button_width / 2, -1, 0])
    cube([mid_button_width, mid_button_depth + 2, mid_button_height]);
    
    translate([-mid_button_gap_width / 2, mid_button_gap_wall, mid_button_height - 1])
    cube([mid_button_gap_width, mid_button_depth - mid_button_gap_wall + 1, mid_height]);
}

module mid() {
    difference() {
        body(mid_height);
        
        rotate([0, 0, 180])
        translate([0, -cut_off, -1])
        mid_cutout(mid_base + 2);
        
        translate([-body_dia / 2 - 1, -usb_w / 2, mid_base])
        cube([body_dia / 2, usb_w, usb_h]);
        
        usb_flatten(mid_height);
        
        rotate([0, 0, button_angle_r])
        translate([0, -body_dia / 2, mid_base + mid_button_off])
        mid_button();
        rotate([0, 0, button_angle_1])
        translate([0, -body_dia / 2, mid_base + mid_button_off])
        mid_button();
        rotate([0, 0, button_angle_2])
        translate([0, -body_dia / 2, mid_base + mid_button_off])
        mid_button();
        rotate([0, 0, button_angle_3])
        translate([0, -body_dia / 2, mid_base + mid_button_off])
        mid_button();
        
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
    
    rotate([0, 0, -135])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, -45])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, 135])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
    rotate([0, 0, 45])
    translate([0, -body_dia / 2 + mid_snap_off, mid_base])
    cylinder(d = mid_snap_dia, h = mid_height - mid_base);
}

//mid();
