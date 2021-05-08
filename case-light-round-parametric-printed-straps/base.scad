include <common.scad>;

base_bottom = 1.5;
base_wall = 4.0;
base_screw_len_add = 0.4 + 0.3;

base_bat_dia = 35.5;
base_bat_cut_w = 22;
base_bat_cut_h = 3;
base_bat_cut_off = 0.9;

base_strap_h = 7.8;
base_strap_d = 5.2 + base_strap_add_l;
base_strap_cyl = 3;
base_strap_warp = 1;
base_strap_cut = 0.1;
base_strap_off = body_radius;

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

module base() {
    difference() {
        union() {
            body(base_bottom, true);
            
            translate([0, 0, base_bottom])
            body(base_wall, false);
            
            for (i = [-1, 1]) {
                scale([1, i, 1])
                translate([0, body_dia / 2 + base_mount_off, base_strap_off])
                base_strap();
            }
        }
        
        translate([0, 0, base_bottom - 0.01])
        base_bat(base_wall + 1.01);
        
        translate([0, 0, base_bottom - base_screw_len_add])
        base_screws();
        
        usb_flatten(base_height);
    }
}

//base();
