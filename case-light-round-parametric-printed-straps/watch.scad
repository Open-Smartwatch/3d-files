include <base.scad>;
include <mid.scad>;
include <top.scad>;
include <strap.scad>;

view_assembly = false;

assembly_dist = 0;
print_dist = 5;
assembly_strap_angle = 50;
assembly_strap_off = 2;

module assembly() {
    color("green")
    translate([0, 0, base_height + mid_height + assembly_dist * 2])
    face();

    color("blue")
    translate([0, 0, base_height + assembly_dist])
    mid();

    color("orange")
    base();
    
    color("cyan")
    translate([strap_piece_w / 2, body_dia / 2 + assembly_strap_off, 0])
    rotate([0, 0, 90])
    strap(true, 1, assembly_strap_angle);
    
    color("cyan")
    translate([-strap_piece_w / 2, -body_dia / 2 - assembly_strap_off, 0])
    rotate([0, 0, -90])
    strap(true, 1, assembly_strap_angle);
}

module print() {
    face();
    
    translate([body_dia + print_dist, 0, 0])
    mid();
    
    translate([(body_dia + print_dist) * 2, 0, 0])
    base();
    
    translate([-body_dia / 2 + print_dist, body_dia / 2 + print_dist * 2, 0])
    strap(false);
}

if (view_assembly) {
    rotate([0, 0, 90])
    assembly();
} else {
    print();
}
