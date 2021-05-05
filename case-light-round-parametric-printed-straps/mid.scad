include <base.scad>;

lcd_parts_height = 6.0 - 1.6;
electronics_height = lcd_parts_height + pcb_h;

mid_base = 0.8;
electronics_dia = 36.7;
cut_w = 6.2;
cut_h = 37.3;
cut_tw = 19.5;
cut_th = 3.5;
cut_off = 1;

usb_w = 8.3;
usb_h = 3.8;

mid_height = mid_base + electronics_height;

module mid_cutout(h) {
    translate([-cut_w / 2, -cut_h / 2, 0])
    linear_extrude(h) {
        square([cut_w, cut_h]);
        
        translate([-(cut_tw - cut_w) / 2, cut_h - cut_th])
        square([cut_tw, cut_th]);
    }
}

module mid() {
    difference() {
        body(mid_height);
        
        rotate([0, 0, 180])
        translate([0, -cut_off, -1])
        mid_cutout(mid_base + 2);
        
        translate([-body_dia / 2 - 1, -usb_w / 2, mid_base])
        cube([body_dia / 2, usb_w, usb_h]);
        
        translate([0, 0, -1])
        base_screws(false);
        
        translate([0, 0, mid_base])
        cylinder(d = electronics_dia, h = mid_height - mid_base + 1);
    }
}

//mid();
