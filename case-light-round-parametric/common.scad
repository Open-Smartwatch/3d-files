pcb_h = 1.6;

body_dia = 43.7;
body_radius = 1.5;

mount_dist_w = 18.0;
mount_dist_h = 41.0;

face_mount_w = 6.0;
face_mount_d = face_mount_w;

base_mount_w = mount_dist_w + face_mount_w;
base_mount_d = 10;
base_mount_off = 1.65;

nut_dia = 1.9;
screw_dia = 2.3;
screw_gap = screw_dia - nut_dia;
screw_head_dia = 5.0;
screw_head_height = 2.3;

usb_flat = 0.7;

button_angle_off = 32.5;

button_angle_r = 90 + button_angle_off;
button_angle_1 = 90 - button_angle_off;
button_angle_2 = -90 + button_angle_off;
button_angle_3 = -90 - button_angle_off;

strap_d = 5;
strap_latch_ws = 3.3;
strap_latch_wl = 8.4;
base_strap_w = strap_latch_wl; //12.2;
base_strap_add_l = 0.3;

visualize_screws = false;
screw_visual_off = 5;
screw_len_body = 12;
screw_len_strap = 7.5;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module usb_flatten(h) {
    translate([-body_dia / 2, -body_dia / 2, -1])
    cube([usb_flat, body_dia, h + 1.1]);
}

module roundedcylinder(d, h, r, top = false) {
    hull() // needed, otherwise rendering fails
    rotate_extrude(convexity = 10)
    translate([d / 2, 0, 0])
    rotate([0, 180, 0]) {
        if (top) {
            translate([0, r])
            square([d / 2, h - r * 2]);
        } else {
            translate([0, r])
            square([d / 2, h - r]);
        }
        
        //translate([r, 0])
        //square([d / 2 - r, r]);
        
        translate([r, r])
        circle(r = r);
        
        if (top) {
            translate([r, h - r])
            circle(r = r);
        
            //translate([r, h - r])
            //square([d / 2 - r, r]);
        }
    }
}

module roundedcube_side(x, y, z, r) {
    translate([r, r, 0])
    cube([x - r * 2, y - r * 2, z]);
    
    translate([r, 0, 0])
    cube([x - r * 2, y, z]);
    
    translate([0, r, 0])
    cube([x, y - r * 2, z]);
    
    translate([r, r, 0])
    cylinder(d = r * 2, h = z);
    
    translate([x - r, r, 0])
    cylinder(d = r * 2, h = z);
    
    translate([r, y - r, 0])
    cylinder(d = r * 2, h = z);
    
    translate([x - r, y - r, 0])
    cylinder(d = r * 2, h = z);
}

module roundedcube_bot_half(x, y, z, r) {
    translate([0, y, 0])
    rotate([90, 0, 0])
    linear_extrude(height = y) {
        translate([0, r])
        square([x, z - r]);
        
        translate([r, 0])
        square([x - r * 2, r]);
        
        translate([r, r])
        circle(r = r);
        
        translate([x - r, r])
        circle(r = r);
    }
}

module roundedcube_side_bot(x, y, z, r) {
    translate([0, r, 0])
    roundedcube_bot_half(x, y - r * 2, z, r);
    
    translate([x - r, 0, 0])
    rotate([0, 0, 90])
    roundedcube_bot_half(y, x - r * 2, z, r);
    
    translate([r, r, r])
    sphere(r = r);
    
    translate([x - r, r, r])
    sphere(r = r);
    
    translate([r, y - r, r])
    sphere(r = r);
    
    translate([x - r, y - r, r])
    sphere(r = r);
    
    translate([0, 0, r])
    roundedcube(x, y, z - r, r);
}

module roundedcube(x, y, z, r, round_bot = false, round_top = false) {
    if (!round_bot) {
        roundedcube_side(x, y, z, r);
    } else {
        if (round_top) {
            roundedcube_side_bot(x, y, z / 2, r);
            
            translate([0, y, z])
            rotate([180, 0, 0])
            roundedcube_side_bot(x, y, z / 2, r);
        } else {
            roundedcube_side_bot(x, y, z, r);
        }
    }
}

module screw_part(add, height = 0) {
    if (height == 0) {
        cylinder(d = screw_head_dia, h = 10);
        
        translate([0, 0, -20])
        cylinder(d = screw_dia + add, h = 21);
    } else {
        cylinder(d = screw_head_dia, h = screw_head_height);
        
        translate([0, 0, -height])
        cylinder(d = screw_dia + add, h = height + 1);
    }
}

module screw(nut = false, bottom = false, height = 20) {
    if (nut) {
        if (bottom) {
            translate([0, 0, height])
            screw_part(-screw_gap, height);
        } else {
            screw_part(-screw_gap, height);
        }
    } else {
        if (bottom) {
            translate([0, 0, height])
            screw_part(0, height);
        } else {
            screw_part(0, height);
        }
    }
}

module base_screws(nut = true, bottom = true) {
    for (i = [1, -1]) {
        for (j = [1, -1]) {
            translate([i * mount_dist_w / 2, j * mount_dist_h / 2, 0])
            screw(nut, bottom);
            
            if (visualize_screws) {
                %translate([i * mount_dist_w / 2 - screw_visual_off + 1, j * mount_dist_h / 2, 0])
                screw(nut, bottom);
            }
        }
    }
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
