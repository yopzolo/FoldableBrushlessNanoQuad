include <constants.scad>

*arduinoMock();
*motorMock();
*gyroMock();


// Main Arduino pro micro
arduinoSize = [34,2.3,18]; //[34,2.3,18]; ok values

module arduinoMock(){
		translate([0,0,arduinoSize[2]/2])cube(arduinoSize,center = true);	

		for (x = [0:12], y=[-1,1]) {
			*%translate([-arduinoSize[0]/2+(x+3/4)*INCH/10, 0, arduinoSize[2]/2+y*(arduinoSize[2]/2-INCH/20)])rotate([90,0,0])cylinder(r=INCH/30, h=arduinoSize[1]+.2,center = true);
		}
}

module arduinoHull(){
	clipThickness = .9;
	
	intersection() {
		translate([-arduinoSize[0]/2-strongThicknessHV[0],-arduinoSize[1]/2-strongThicknessHV[1],0])cube([arduinoSize[0]+2*strongThicknessHV[0], 2*strongThicknessHV[1]+arduinoSize[1], clipThickness]);
		translate([0,0,-arduinoSize[1]+2*clipThickness])rotate([0, 90, 0])cylinder(r=arduinoSize[1], h=arduinoSize[0]+2*strongThicknessHV[1]-.001,center = true);
	}

	//TODO remove after test print
	*translate([INCH/10,-arduinoSize[1]/2-minimumThicknessHV[0],0])cube([3/10*INCH,2*minimumThicknessHV[0]+arduinoSize[1],INCH/10]);
}

// gyro / acc

gyroSize=[20.5,16,1.8];
gyroFullThickness = 2.4;
gyroHolePadding=1.5;
gyroHoleRad = 1.25;

module gyroMock(){
	difference(){
		union() {
			translate([0,0,gyroFullThickness/2])cube(gyroSize+[0,0,gyroFullThickness-gyroSize[2]],center = true);

			

			for (x = [0:7]) {
				%translate([-gyroSize[0]/2+(x+1/2)*INCH/10, gyroSize[1]/2-INCH/20, gyroSize[2]/2])cylinder(r=INCH/30, h=gyroSize[2]+.2,center = true);
			}
		}
		for (i = [-1,1]) {
			translate([-i*(gyroSize[0]/2-gyroHoleRad-gyroHolePadding),-gyroSize[1]/2+gyroHoleRad+gyroHolePadding,0])cylinder(r=gyroHoleRad, h=gyroFullThickness+.1);
			translate([-i*(gyroSize[0]/2-gyroHoleRad),-gyroSize[1]/2+gyroHoleRad/2+gyroHolePadding,gyroFullThickness/2+gyroSize[2]/2])cube([gyroHoleRad+gyroHolePadding,gyroHoleRad+gyroHolePadding,gyroFullThickness-gyroSize[2]],center = true);
			translate([-i*(gyroSize[0]/2-gyroHoleRad/2-gyroHolePadding),-gyroSize[1]/2-gyroHoleRad/2+gyroHolePadding,gyroFullThickness/2+gyroSize[2]/2])cube([gyroHoleRad+gyroHolePadding,gyroHoleRad+gyroHolePadding,gyroFullThickness-gyroSize[2]],center = true);
			translate([-i*(gyroSize[0]/2-gyroHolePadding+gyroHoleRad/2),-gyroSize[1]/2-gyroHoleRad/2+gyroHolePadding,gyroFullThickness/2+gyroSize[2]/2])cube([gyroHoleRad+gyroHolePadding,gyroHoleRad+gyroHolePadding,gyroFullThickness-gyroSize[2]],center = true);

		}
		translate([0,gyroSize[1]/2-INCH/10-INCH/20,gyroFullThickness/2+gyroSize[2]/2])cube([gyroSize[0],INCH/10,gyroFullThickness-gyroSize[2]],center = true);


	}
}

module gyroHull(){
	*translate([0,0,strongThicknessHV[1]/2])cube([25,20,strongThicknessHV[1]], center = true);
		translate([0,0,gyroFullThickness/2-0.01])cube(gyroSize+2*strongThicknessHV[0]*[1,1,0]+[0,0,gyroFullThickness-gyroSize[2]-0.1,1], center = true);
		
		for (i = [-1,1]) {
			translate([-i*(gyroSize[0]/2+i*gyroHoleRad-INCH/20+i*minimumThicknessHV[0]/2),gyroSize[1]/2-gyroHoleRad-INCH/20-minimumThicknessHV[0]/2,gyroSize[2]-0.1])cube([2*gyroHoleRad+minimumThicknessHV[0],2*gyroHoleRad+minimumThicknessHV[0],minimumThicknessHV[1]]);
		}
}


// receiver

rxSize=[15.5,28,1.6];
rxFullThickness = 2.4;
rxAntennaSize=[2,2,rxFullThickness-2*minimumThicknessHV[1]];

module rxMock(){
	//difference() {
		//union() {
			translate([0,0,rxFullThickness/2-0.01])cube(rxSize+[-minimumThicknessHV[0]/2,-minimumThicknessHV[0]/2,rxFullThickness-rxSize[2]],center = true);
			translate([0,0,rxFullThickness-rxSize[2]/2])cube(rxSize,center = true);
		//}
		*translate([0, rxSize[1]/2, rxFullThickness/2-rxSize[2]/2])cube([rxSize[0],1,rxFullThickness-rxSize[2]] , center = true);
		*translate([rxSize[0]/2-5, rxSize[1]/2, rxFullThickness/2-rxSize[2]/2])cube([3, 2, rxFullThickness-rxSize[2]], center= true);
		*translate([rxSize[0]/2-5, -rxSize[1]/2, rxFullThickness/2-rxSize[2]/2])cube([3, 2, rxFullThickness-rxSize[2]], center= true);
//	}
	#translate([rxSize[0]/2-rxAntennaSize[0],rxSize[1]/2+minimumThicknessHV[1]-rxAntennaSize[0],rxFullThickness-rxAntennaSize[2]])cube([2*rxAntennaSize[0],2*rxAntennaSize[0],rxAntennaSize[2]]);
	#translate([-rxSize[0]/2-rxAntennaSize[0],rxSize[1]/2+minimumThicknessHV[1]-2*rxAntennaSize[0],rxFullThickness-rxAntennaSize[2]])cube([2*rxAntennaSize[0],2*rxAntennaSize[0],rxAntennaSize[2]]);

}


module rxHull(){
 	translate([0,0,rxFullThickness/2-0.01])cube(rxSize+[2*strongThicknessHV[1],2*strongThicknessHV[1],rxFullThickness-rxSize[2]-0.01],center = true);
}

// esc's

escSize=[15,3.5,11.8];

// batery

batSize = [24,43,9];

// motors

motorRHTop = [6,5.5];
motorRHMiddle = [3.75,5];
motorRHBottom = [2.10,8];
motorRHPin = [.5,9];

motorRH = [max(motorRHTop[0],motorRHBottom[0]),motorRHBottom[1]+motorRHTop[1]];

module motorMock(){
	union() {
	translate([0,0,0])cylinder(r=motorRHBottom[0], h=motorRHBottom[1]);
	intersection() {
		translate([0,0,motorRHBottom[1]-motorRHMiddle[1]])cylinder(r1=motorRHBottom[0],r2=motorRHMiddle[0], h=motorRHMiddle[1]);
		translate([-motorRHBottom[0]+minimumThicknessHV[0],0,0])cube([2*motorRHBottom[0]-2*minimumThicknessHV[0],motorRHTop[0],motorRH[1]]);
	}
	//difference() {
		translate([0,0,motorRHBottom[1]-strongThicknessHV[0]])cylinder(r=motorRHTop[0], h=motorRHTop[1]+strongThicknessHV[0]+.01);
	//	#translate([0,0,motorRHBottom[1]-strongThicknessHV[0]-.01])cylinder(r=motorRHTop[0]-strongThicknessHV[1], h=strongThicknessHV[0]);	
	//}

	translate([0,0,motorRHBottom[1]+motorRHTop[1]])cylinder(r=motorRHPin[0], h=motorRHPin[1]);
	}
}

module motorHull(){
	ventHoleRad = 2*3.14*motorRH[0]/16-minimumThicknessHV[0];
	union() {
		difference() {
			union() {
				cylinder(r=motorRHBottom[0]+minimumThicknessHV[0], h=motorRHBottom[1]);
				translate([0,0,motorRHBottom[1]-motorRHMiddle[1]-2*strongThicknessHV[0]])cylinder(r1=motorRHBottom[0],r2=motorRH[0]+strongThicknessHV[0], h=motorRH[0]);
				translate([0,0,motorRHBottom[1]-strongThicknessHV[0]])cylinder(r=motorRH[0]+strongThicknessHV[0], h=motorRHTop[1]+strongThicknessHV[0]);
		}
			rotate([0, 0, -90])
			for (a = [45:45:315]) {
					hull() {
						translate([0,0,motorRH[1]])rotate([140, 0, a])cylinder(r1=0,r2=ventHoleRad, h=2*motorRH[0]);	
						translate([0,0,motorRH[1]-strongThicknessHV[1]-ventHoleRad])rotate([90, 0, a])cylinder(r1=0,r2=ventHoleRad, h=2*motorRH[0]);	
					}
			}
		}

		
	}
	
}

// utilities

module unionDiff(){
	difference() {
		union() {
			for (i = [0:$children-2]) {
				children(i);
			}
		}
		children($children-1);
	}
}