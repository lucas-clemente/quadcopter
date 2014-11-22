arm_length = 40;
arm_width = 10;
arm_wall_width = 1;
n_seg = 4;

arm_pad_r= 10;
motor_screw_distance = 8.5;
motor_screw_d = 1.5;

plate_width = 50;

h = 2;

module motor_hole(rot) {
	rotate([0, 0, rot])
	translate([motor_screw_distance,0,0])
		circle(d = motor_screw_d, $fn = 10);

}

module arm_seg(l, w) {
	difference() {
		square([l, w], center = true);
		polygon(points = [[l/2, w/2 - arm_wall_width], [l/2, -w/2 + arm_wall_width], [arm_wall_width, w/2 - arm_wall_width]]);
		polygon(points = [[-l/2, w/2 - arm_wall_width], [-l/2, -w/2 + arm_wall_width], [-arm_wall_width, w/2 - arm_wall_width]]);
		polygon(points = [[l/2 - arm_wall_width, -w/2 + arm_wall_width], [-l/2 + arm_wall_width, -w/2 + arm_wall_width], [0, w/2 - arm_wall_width]]);
	}
}

module arm(rot) {
	rotate([0, 0, rot])
	translate([plate_width/2 + arm_length/2, 0, 0]) {
		for (p = [-1, 1]) {
			rotate([90 + 90 * p, 0, 0])
			for (i = [-n_seg/2:n_seg/2-1]) {
				translate([(i + 0.5) * arm_length / n_seg, arm_width/4 - arm_wall_width / 2, 0]) {
					arm_seg(arm_length / n_seg, arm_width / 2);
				}
			}
		}
		translate([arm_length / 2 + arm_pad_r - 2, 0, 0])
		difference() {
			circle(r=arm_pad_r);
			motor_hole(0);
			motor_hole(120);
			motor_hole(240);
		}
	}
}

module body() {
	polygon(points = [
		[-arm_width / 2, plate_width / 2],
		[arm_width / 2, plate_width / 2],
		[plate_width / 2, arm_width / 2],
		[plate_width / 2, -arm_width / 2],
		[arm_width / 2, -plate_width / 2],
		[-arm_width / 2, -plate_width / 2],
		[-plate_width / 2, -arm_width / 2],
		[-plate_width / 2, arm_width / 2]
	]);
}


linear_extrude(height = h) {
	body();
	arm(0);
	arm(90);
	arm(180);
	arm(270);
}
