include <constants.scad>
include <components.scad>

*motorMock();
*motorTest();
*arduinoTest();
*gyroTest();
*rxTest();

allComponents();

module arduinoTest() {
	translate([-arduinoSize[0]/2-strongThicknessHV[0],-arduinoSize[1],0])cube([arduinoSize[0]+2*strongThicknessHV[0], 2*arduinoSize[1], minimumThicknessHV[1]]);
	translate([0, 0, minimumThicknessHV[1]])
	difference() {
		arduinoHull();
		#arduinoMock();
	}
}

module gyroTest(){
	difference() {
		union() {
			translate([0,0,strongThicknessHV[1]/2])cube(gyroSize+[2,2,-gyroSize[2]+strongThicknessHV[1]],center = true);
			gyroHull();
		}
		#translate([0,0,gyroFullThickness-0.01])rotate([180,0,0])gyroMock();
	}
}


module rxTest(){
	rotate([0, 0, 90])
	difference() {
		union() {
			translate([0,0,strongThicknessHV[1]/2])cube(rxSize+[2,2,-rxSize[2]+strongThicknessHV[1]],center = true);
			rxHull();
		}
		#translate([0,0,-0.001])rxMock();
	}
}

module motorTest(){
		difference() {
			union() {
				motorHull();
				cylinder(r=10, h=.3);
			}
			#translate([0,0,0])motorMock();
			cylinder(r=motorRHBottom[0], h=motorRHBottom[1]);
		}
}


// display all

module allComponents(){
	motorTest();
	translate([0,-15,0])arduinoTest();
	translate([0,-30,0])gyroTest();
	translate([0,-50,0])rxTest();
}
