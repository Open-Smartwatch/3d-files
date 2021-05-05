include <top.scad>;

base_bottom = 1.5;
base_wall = 4.0;

base_bat_dia = 35.5;
base_bat_cut_w = 22;
base_bat_cut_h = 3;
base_bat_cut_off = 0.9;

base_mount_w = mount_dist_w + face_mount_w;
base_mount_d = 10;
base_mount_off = 1.65;

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

module base_screws(nut = true) {
    translate([-mount_dist_w / 2, -mount_dist_h / 2, 0])
    screw(nut);
    
    translate([mount_dist_w / 2, -mount_dist_h / 2, 0])
    screw(nut);
    
    translate([-mount_dist_w / 2, mount_dist_h / 2, 0])
    screw(nut);
    
    translate([mount_dist_w / 2, mount_dist_h / 2, 0])
    screw(nut);
}

module body(h, rounded = false) {
    union() {
    if (rounded) {
        roundedcylinder(body_dia, h, body_radius);
    } else {
        cylinder(d = body_dia, h = h);
    }
    
    translate([-base_mount_w / 2, -body_dia / 2 - base_mount_off, 0])
    roundedcube(base_mount_w, base_mount_d, h, body_radius, rounded);

    scale([1, -1, 1])
    translate([-base_mount_w / 2, -body_dia / 2 - base_mount_off, 0])
    roundedcube(base_mount_w, base_mount_d, h, body_radius, rounded);
    }
}

module base() {
    difference() {
        union() {
            body(base_bottom, true);
            
            translate([0, 0, base_bottom])
            body(base_wall, false);
        }
        
        translate([0, 0, base_bottom - 1])
        base_bat(base_wall + 2);
        
        translate([0, 0, base_bottom])
        base_screws();
    }
}

//base();
