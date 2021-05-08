include <common.scad>;

face_hole_dia = 33;
body_dia = 43.7;

face_glass_dia = 37.0 + 0.3;
face_glass_height = 0; //1.0 + 0.2;

face_cyl_1_dia = body_dia;
face_cyl_1_height = 0.6;
face_cyl_2_dia = 39.0;
face_cyl_2_height = 1.5;

face_mount_base = 0.6;

face_height = face_cyl_1_height + face_cyl_2_height;

text_off = face_cyl_2_dia / 2 - (face_cyl_2_dia - face_hole_dia) / 4 + 1.3;
text_height = face_height - face_glass_height - 0.8;
text_size = 3.8;
text_font = "Droid Sans:style=Bold";

module face_base() {
    cylinder(d1 = body_dia, d2 = face_cyl_1_dia, h = face_cyl_1_height);
    
    translate([0, 0, face_cyl_1_height])
    cylinder(d1 = face_cyl_1_dia, d2 = face_cyl_2_dia, h = face_cyl_2_height);
}

module face_mount(for_top = true, base = face_mount_base) {
    difference() {
        hull() {
            translate([-face_mount_w / 2, -face_mount_d / 2, 0])
            roundedcube(face_mount_w, face_mount_d, base, body_radius);
            
            if (for_top)
            difference() {
                translate([mount_dist_w / 2, mount_dist_h / 2, 0])
                face_base();
                
                translate([face_mount_w / 2, -face_mount_d / 2 - 1, -25])
                cube([50, 50, 50]);
                
                translate([-50 - face_mount_w / 2, -face_mount_d / 2 - 1, -25])
                cube([50, 50, 50]);
                
                translate([-25, face_mount_d / 2, -25])
                cube([50, 50, 50]);
            }
        }
        
        if (for_top)
        translate([0, 0, base])
        screw();
    }
}

module face_mounts(for_top = true, base = face_mount_base) {
    translate([-mount_dist_w / 2, -mount_dist_h / 2, 0])
    face_mount(for_top, base);
    
    translate([mount_dist_w / 2, -mount_dist_h / 2, 0])
    scale([-1, 1, 1])
    face_mount(for_top, base);
    
    translate([-mount_dist_w / 2, mount_dist_h / 2, 0])
    scale([1, -1, 1])
    face_mount(for_top, base);
    
    translate([mount_dist_w / 2, mount_dist_h / 2, 0])
    scale([-1, -1, 1])
    face_mount(for_top, base);
}

module face_whole() {
    difference() {
        union() {
            face_base();
            face_mounts();
        }
        
        translate([mount_dist_w / 2, mount_dist_h / 2, face_mount_base])
        screw();
        
        translate([-mount_dist_w / 2, mount_dist_h / 2, face_mount_base])
        screw();
        
        translate([mount_dist_w / 2, -mount_dist_h / 2, face_mount_base])
        screw();
        
        translate([-mount_dist_w / 2, -mount_dist_h / 2, face_mount_base])
        screw();
    }
}

module text_rotated(s, angle) {
    rotate([0, 0, -angle])
    translate([0, -text_off, 0])
    rotate([0, 0, angle])
    linear_extrude(height = text_height + 0.1)
    text(text = s, font = text_font, size = text_size, halign = "center", valign = "center");
}

module face() {
    difference() {
        face_whole();
        
        usb_flatten(face_height);
        
        translate([0, 0, -1])
        cylinder(d = face_hole_dia, h = face_height + 2);
        
        translate([0, 0, -1])
        cylinder(d = face_glass_dia, h = face_glass_height + 1);
        
        translate([0, 0, face_height - text_height]) {
            text_rotated("R", button_angle_r);
            text_rotated("1", button_angle_1);
            text_rotated("2", button_angle_2);
            text_rotated("3", button_angle_3);
        }
    }
}

//face();