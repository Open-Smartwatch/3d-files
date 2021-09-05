include <base.scad>;
include <mid.scad>;
include <top.scad>;
include <strap.scad>;

view_assembly = true;

assembly_dist = 0;
print_dist = 5;
assembly_strap_angle = 16.5;
assembly_strap_off = 1.3 + base_strap_add_l;

module assembly() {
    color("green")
    translate([0, 0, base_height + mid_height + assembly_dist * 2])
    face();
    
    color("red")
    translate([0, 0, base_height + assembly_dist])
    buttons_assembly();

    color("blue")
    translate([0, 0, base_height + assembly_dist])
    mid();

    color("orange")
    base();
    
    color("cyan")
    translate([strap_piece_body_h / 2, body_dia / 2 + assembly_strap_off, 0])
    rotate([0, 0, 90])
    strap(true, 1, assembly_strap_angle);
    
    color("cyan")
    translate([-strap_piece_body_h / 2, -body_dia / 2 - assembly_strap_off, 0])
    rotate([0, 0, -90])
    strap(true, 1, assembly_strap_angle);
    
    // visualize 12mm screw with 0.3mm high washer
    if (visualize_screws) {
        %translate([-mount_dist_w / 2 - screw_visual_off, -mount_dist_h / 2, base_height + mid_height + face_mount_base])
        screw(false, false, screw_len_body - 0.3);
    }
}

module print() {
    face();
    
    translate([body_dia + print_dist, 0, 0])
    mid();
    
    translate([(body_dia + print_dist) * 2, 0, 0])
    base();
    
    translate([body_dia * 5 / 2 + print_dist * 3, 0, 0])
    buttons_print();
    
    translate([-body_dia / 2 + print_dist, body_dia / 2 + print_dist * 2, 0])
    strap(false);
}

if (view_assembly) {
    rotate([0, 0, 90])
    assembly();
} else {
    print();
}
