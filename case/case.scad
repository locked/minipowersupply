thickness = 1.8;
pcb_thickness = 1.7;
front_pcb = [180, 80];
front_pcb_screw = [168, 68, 4, 8];	// x, z, diam, ecrou diam
pcb_margin = 1.2;

cubewidth = front_pcb[0] - front_pcb_screw[0] + pcb_margin;
cubedepth = 10;

power_screws_x = 145;
power_screws_zs = [12, 69];

feet_width = 13.5;
feet_thickness = 1.5;
feet_spacing = 8;

case = [
    front_pcb[0] + thickness * 2 + pcb_margin,
    80,
    front_pcb[1] + thickness * 2 + pcb_margin
];


module vents() {
	count = 30;
	ventx = 60;
	ventz = 35;
	venty = 20;
	for (number = [0:(count-1)]){
        translate([$case[0]/2-ventx + number * ((ventx * 2)/count), $case[1] - venty, $case[2]/2 + ventz])
        cube([ventx/count, venty, ventz]);
    }
}

module power_holes() {
    power_vent_diam = 38;
    power_vent_diam_pos = [40];
    translate([case[0]/2 - thickness, case[1] - thickness - power_vent_diam_pos[0]/2, -case[2]/2 + thickness + power_vent_diam_pos[0]/2 + 2])
    rotate([-90, 0, -90]) cylinder(h=thickness, d=power_vent_diam, $fn=30);

    power_plug = [32, 25];
    power_plug_pos = [38];
    translate([case[0]/2 - thickness, case[1] - thickness - power_plug_pos[0], case[2]/2 - thickness - power_plug[1] - 3])
    cube([thickness, power_plug[0], power_plug[1]]);

    for (screw = [0:1]) {
        translate([case[0]/2 - thickness - power_screws_x, case[1] - thickness, -case[2]/2 + thickness + power_screws_zs[screw]])
        rotate([-90, 0, 0]) cylinder(h=thickness, d=3, $fn=20);
    }
}
//power_holes();

module feets() {
    feet_full_width = feet_width + feet_thickness * 2;
    translate([-case[0]/2+feet_spacing, feet_spacing, -case[2]/2 - feet_thickness])
    foot();
    translate([case[0]/2-feet_spacing-feet_full_width, feet_spacing, -case[2]/2 - feet_thickness])
    foot();
    translate([-case[0]/2+feet_spacing, case[1] - feet_full_width - feet_spacing, -case[2]/2 - feet_thickness])
    foot();
    translate([case[0]/2-feet_spacing-feet_full_width, case[1] - feet_full_width - feet_spacing, -case[2]/2 - feet_thickness])
    foot();
}
module foot() {
    difference() {
        cube([feet_width+feet_thickness*2, feet_width+feet_thickness*2, feet_thickness]);
        translate([feet_thickness, feet_thickness])
        cube([feet_width, feet_width, feet_thickness]);
    }
}

module case($case) {
    translate([-$case[0]/2, 0, -$case[2]/2])

    difference() {
        color("Grey")
        cube([$case[0], $case[1], $case[2]]);
        translate([thickness, -thickness, thickness])
        color("Green")
        cube([$case[0]-thickness*2, $case[1], $case[2]-thickness*2]);

        // Thermal vents
        vents();
    }

	// Front screws
    difference() {
        color("Blue") {
            translate([-case[0]/2 + thickness, pcb_thickness + 0.5, -case[2]/2 + thickness])
            cube([cubewidth, cubedepth, cubewidth]);
            translate([case[0]/2 - thickness - cubewidth, pcb_thickness + 0.5, -case[2]/2 + thickness])
            cube([cubewidth, cubedepth, cubewidth]);
            translate([-case[0]/2 + thickness, pcb_thickness + 0.5, case[2]/2 - thickness - cubewidth])
            cube([cubewidth, cubedepth, cubewidth]);
            translate([case[0]/2 - thickness - cubewidth, pcb_thickness + 0.5, case[2]/2 - thickness - cubewidth])
            cube([cubewidth, cubedepth, cubewidth]);
        }
        color("Red") {
            // PCB screw holes
            translate([-front_pcb_screw[0]/2, pcb_thickness, -front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=cubedepth+thickness, d=front_pcb_screw[2], $fn=20);
            translate([front_pcb_screw[0]/2, pcb_thickness, -front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=cubedepth+thickness, d=front_pcb_screw[2], $fn=20);
            translate([-front_pcb_screw[0]/2, pcb_thickness, front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=cubedepth+thickness, d=front_pcb_screw[2], $fn=20);
            translate([front_pcb_screw[0]/2, pcb_thickness, front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=cubedepth+thickness, d=front_pcb_screw[2], $fn=20);
        }
        color("Yellow") {
            // PCB screw holes
            translate([-front_pcb_screw[0]/2, pcb_thickness, -front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=3, d=front_pcb_screw[3], $fn=6);
            translate([front_pcb_screw[0]/2, pcb_thickness, -front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=3, d=front_pcb_screw[3], $fn=6);
            translate([-front_pcb_screw[0]/2, pcb_thickness, front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=3, d=front_pcb_screw[3], $fn=6);
            translate([front_pcb_screw[0]/2, pcb_thickness, front_pcb_screw[1]/2])
            rotate([-90]) cylinder(h=3, d=front_pcb_screw[3], $fn=6);
        }
    }
    
    feets();
}

difference() {
	case(case);
    power_holes();
}
