pcb_h = 1.6;

body_dia = 43.7;
body_radius = 1.5;

mount_dist_w = 18.0;
mount_dist_h = 41.0;

nut_dia = 2.0;
screw_gap = 0.2;
screw_dia = nut_dia + screw_gap;
screw_head_dia = 4.0;

$fn = 42;

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

module screw_part(add) {
    cylinder(d = screw_head_dia, h = 10);
    translate([0, 0, -20])
    cylinder(d = screw_dia + add, h = 21);
}

module screw(nut = false) {
    if (nut) {
        translate([0, 0, 20])
        screw_part(-screw_gap);
    } else {
        screw_part(0);
    }
}
