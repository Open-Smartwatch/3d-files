include <common.scad>;

face_hole_dia = 33;
body_dia = 43.7;

face_glass_dia = 37.0 + 0.3;
face_glass_height = 1.0 + 0.2;

face_cyl_1_dia = body_dia;
face_cyl_1_height = 0.6;
face_cyl_2_dia = 39.0;
face_cyl_2_height = 1.5;

face_mount_w = 6.0;
face_mount_d = face_mount_w;
face_mount_base = 0.6;

face_height = face_cyl_1_height + face_cyl_2_height;

module face_base() {
    cylinder(d1 = body_dia, d2 = face_cyl_1_dia, h = face_cyl_1_height);
    
    translate([0, 0, face_cyl_1_height])
    cylinder(d1 = face_cyl_1_dia, d2 = face_cyl_2_dia, h = face_cyl_2_height);
}

module face_mount() {
    difference() {
        hull() {
            translate([-face_mount_w / 2, -face_mount_d / 2, 0])
            roundedcube(face_mount_w, face_mount_d, face_mount_base, body_radius);
            
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
        
        translate([0, 0, face_mount_base])
        screw();
    }
}

module face_mounts() {
    translate([-mount_dist_w / 2, -mount_dist_h / 2, 0])
    face_mount();
    
    translate([mount_dist_w / 2, -mount_dist_h / 2, 0])
    scale([-1, 1, 1])
    face_mount();
    
    translate([-mount_dist_w / 2, mount_dist_h / 2, 0])
    scale([1, -1, 1])
    face_mount();
    
    translate([mount_dist_w / 2, mount_dist_h / 2, 0])
    scale([-1, -1, 1])
    face_mount();
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

module face() {
    difference() {
        face_whole();
        
        translate([0, 0, -1])
        cylinder(d = face_hole_dia, h = face_height + 2);
        
        translate([0, 0, -1])
        cylinder(d = face_glass_dia, h = face_glass_height + 1);
    }
}

//face();