
include <constants.scad>
include <components.scad>

part = 0; //[0:composed 1:plate 2:body, 3:BodyCustomTop, 4:arm]
part(part);


propDH = [3*INCH,5];

socketCenters = [[17,26],[23,-27]];
motorCenters= [2*INCH,1.8*INCH]; //45.2,40.64

globalSize = [propDH[0]+2*motorCenters[0], propDH[0]+2*motorCenters[1]];
echo ("Lxl hors tout : ", globalSize, "mm");

deltas=[[motorCenters[0]-socketCenters[0][0],motorCenters[1]-socketCenters[0][1]],[motorCenters[0]-socketCenters[1][0],motorCenters[1]+socketCenters[1][1]]];
armLength=floor(max(sqrt(pow(deltas[0][1],2)+pow(deltas[0][0],2)),sqrt(pow(deltas[1][1],2)+pow(deltas[1][0],2))));
armAngles = [atan(deltas[0][1]/deltas[0][0]),-atan(deltas[1][1]/deltas[1][0])];

armAnglesFolded=[-94,87];

module part(part){
	if (part == 0){
		composition(armAngles,false);
		*composition(armAnglesFolded,false);
	}
	if (part == 1){
		plate();
	}
	if (part == 2){
		bodyBottom();
	}
	if (part == 3){
		bodyTop();
	}
	if (part == 4){
		arm();
	}
}


batteryArduinoSpace = 4;

bodySize = [batSize[0]+2*strongThicknessHV[0],batSize[1]+2*strongThicknessHV[0]+batteryArduinoSpace,arduinoSize[2]+2*strongThicknessHV[1]];

batOffset=0;

module bodyTop(){
	batteryEscSpace = 2;
	escSpace = 7;
	
	gyroOffset = [0,2,0];
	rxOffset = [0,19,0];

	translate([0,0,-bodySize[2]/2]){
		difference() {
			union() {

				bodyBase();

				*translate(-bodySize/2+strongThicknessHV[1]*[0,0,1])box([bodySize[0],bodySize[1],bodySize[2]/2-strongThicknessHV[1]],minimumThicknessHV[0]);

				translate([-arduinoSize[0]/2,-batSize[1]/2-batteryArduinoSpace-arduinoSize[1]+batOffset,0])cube([arduinoSize[0],10,strongThicknessHV[1]]);
				translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoHull();
				translate(gyroOffset)gyroHull();
				translate(rxOffset)rotate([0,0,90])rxHull();

				translate(rxOffset+[0,rxSize[1]/2-3,strongThicknessHV[1]/2])cube([bodySize[0],2,strongThicknessHV[1]], center = true);
			}

			color("green")translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
			color("green")translate(gyroOffset+[0,0,gyroFullThickness-0.01])rotate([180,0,0])gyroMock();
			color("green")translate(rxOffset)rotate([0,0,90])rxMock();

			copy_mirror(vec=[1,0,0]){
				translate([socketCenters[0][0], socketCenters[0][1], 0])
				rotate([0,0,armAnglesFolded[0]])
				translate([armLength,0,0]){
					cylinder(r=motorRHTop[0], h=2*strongThicknessHV[0], center=false, $fn=40);
					rotate([0,0,90])translate([0,-motorRHTop[0],0])cube([2*motorRHTop[0],2*motorRHTop[0],2*strongThicknessHV[0]]);
				}
			}
		}
		%translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
		%translate(gyroOffset+[0,0,gyroFullThickness-0.01])rotate([180,0,0])gyroMock();
		%translate(rxOffset)rotate([0,0,90])rxMock();
	}
}


module bodyBottom(){
	translate([0,0,-bodySize[2]/2]){
		difference() {
			union() {
				bodyBase();
	
				*translate(-bodySize/2+strongThicknessHV[1]*[0,0,1])box([bodySize[0],bodySize[1],bodySize[2]/2-strongThicknessHV[1]],minimumThicknessHV[0]);

				translate([-arduinoSize[0]/2,-batSize[1]/2-batteryArduinoSpace-arduinoSize[1]+batOffset,0])cube([arduinoSize[0],10,strongThicknessHV[1]]);
				translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoHull();
			}
			color("green")translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
			translate([0, batOffset, 0])
			copy_mirror([0,1,0]){
			copy_mirror([1,0,0]){
					for (x = [0:3*strongThicknessHV[0]:bodySize[0]/2-2*strongThicknessHV[0]]) {
						translate([x,3/2*strongThicknessHV[0],0]){
						#hull() {
							cylinder(r=strongThicknessHV[0], h=strongThicknessHV[1],$fn=40);
							translate([0,bodySize[1]/3,0])cylinder(r=strongThicknessHV[0], h=strongThicknessHV[1],$fn=40);
						}
					}
				}
				}
			}
		}
		*%color("green")translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
	}
	%translate([-batSize[0]/2,-batSize[1]/2+batOffset,-bodySize[2]/2+strongThicknessHV[1]])cube(batSize);
}

module box(outerSize,thickness){
	difference() {
		cube(outerSize);
		translate([thickness, thickness, thickness])cube(outerSize-thickness*[2,2,-2]);
	}
}

socketLenght = 20;
springLenght = 5;

motorSocketRad = pinRad+0;
armRad = 2.1;

module armSocketHull(){
 translate([0,0,0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0],h=2*strongThicknessHV[1], $fn=40);
 translate([-socketLenght,-(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),strongThicknessHV[1]]);
}

module armSocket(){
	socketLenght = 20;
	springLenght = 5;

	difference() {
		union() {
			cylinder(r=motorSocketRad+strongThicknessHV[0], h=strongThicknessHV[1], $fn=40);

			translate([-socketLenght,-(motorSocketRad+strongThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+strongThicknessHV[0]),strongThicknessHV[1]]);
			
			difference() {
				union() {
					translate([0,0,0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0],h=3/2*strongThicknessHV[1], $fn=40);
					translate([-socketLenght,-(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),strongThicknessHV[1]]);
					}

				translate([0,0,0])cylinder(r=motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0],h=2*strongThicknessHV[1]+.001, $fn=40);
				translate([-springLenght,-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),0])cube([springLenght,2*(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),2*strongThicknessHV[1]+.001]);
				translate([-(socketLenght-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0])),-(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),strongThicknessHV[1]])cube([socketLenght-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),2*(motorSocketRad+2*strongThicknessHV[0]+minimumThicknessHV[0]),2*strongThicknessHV[1]+.001]);

			}

			translate([0,0,strongThicknessHV[1]])cylinder(r=motorSocketRad-tightFitThickness, h=strongThicknessHV[1], $fn=40);
		}
		cylinder(r=pinRad, h=100, $fn=40);

		for (z = [-90:90:90]) {
			rotate([0,0,z])translate([armRad+minimumThicknessHV[0],0,armRad+strongThicknessHV[1]+tightFitThickness])rotate([0,90,0])cylinder(r=armRad+tightFitThickness,h=armLength,$fn=40);	
		}
		
					
	}
}

module bodyBase(){
	baseOffset=2;

	difference() {
		union(){
			translate([-bodySize[0]/2,-bodySize[1]/2+baseOffset,0])cube([bodySize[0],bodySize[1],strongThicknessHV[1]]);
			
			*#copy_mirror([1,0,0])
				linear_extrude(strongThicknessHV[1])
					import("microQuadShape.dxf");
		}

		copy_mirror(vec=[1,0,0]){
			translate([socketCenters[0][0], socketCenters[0][1], 0])
				rotate([0,0,armAngles[0]]) armSocketHull();

			translate([socketCenters[1][0], socketCenters[1][1], 0])
				rotate([0,0,armAngles[1]]) armSocketHull();
		}
	}

	copy_mirror(vec=[1,0,0]){
		translate([socketCenters[0][0], socketCenters[0][1], 0])
			rotate([0,0,armAngles[0]]) armSocket();

		translate([socketCenters[1][0], socketCenters[1][1], 0])
			rotate([0,0,armAngles[1]]) armSocket();
	}

	
}

echo ("armLength",armLength);

module arm(){

	cablePassRad=armRad-2*minimumThicknessHV[1];
	echo ("cablePassRad : ",cablePassRad);
	escDist=[escSize[0]/2+motorSocketRad+strongThicknessHV[1]+7,0,-1.3];
	cornerRad=bodySize[2]-2*strongThicknessHV[1]-motorRH[1]-armRad;

	corner=[cornerRad+armRad,2*armRad,cornerRad+armRad];
		*%translate([0,-10,-bodySize[2]/2+strongThicknessHV[1]])cube(bodySize-[-20,10,2*strongThicknessHV[1]]);

		difference() {
			union() {
				//*translate([armLength,0,0])sphere(armWithCablePass,$fn=40);
				//translate([armLength,0,-3])sphere(2.27,$fn=40);
				
				cylinder(r=motorSocketRad+strongThicknessHV[0],h=bodySize[2]-2*strongThicknessHV[1],$fn=40, center = true);

				translate([armLength,0,bodySize[2]/2-motorRH[1]-strongThicknessHV[1]])motorHull();
				
				//hull() {
					translate([0,0,bodySize[2]/2-armRad-strongThicknessHV[1]])rotate([0,90,0])cylinder(r=armRad,h=armLength,$fn=40);
					translate([0,0,-bodySize[2]/2+armRad+strongThicknessHV[1]])rotate([0,90,0])cylinder(r=armRad,h=armLength-cornerRad,$fn=40);
					
					translate([armLength-corner[0]+armRad,-corner[1]/2,-bodySize[2]/2+strongThicknessHV[1]])
						intersection() {
							cube(corner);

							translate([0, corner[1]/2, corner[2]])
							rotate([90,0,0])
							rotate_extrude($fn=40){
								translate([corner[0]-armRad, 0])
								circle(armRad,$fn=40);
						}
				}

				//}	
			}

			cylinder(r=pinRad,h=100,center=true,$fn=40);
			translate([0,0,bodySize[2]/2-2*strongThicknessHV[1]+.001])cylinder(r=motorSocketRad, h=strongThicknessHV[1],$fn=40);
			translate([0,0,-bodySize[2]/2+strongThicknessHV[1]-.001])cylinder(r=motorSocketRad, h=strongThicknessHV[1],$fn=40);

			translate(escDist)cube(escSize, center = true);

			#translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,90,0])cylinder(r=cablePassRad,h=armLength-corner[0]+armRad-motorSocketRad-strongThicknessHV[0]-escSize[0]/2-escDist[0],$fn=40);
			#translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,90,0])sphere(r=cablePassRad,$fn=40);
			#translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,0,0])cylinder(r=cablePassRad,h=2*strongThicknessHV[1],$fn=40);
			
			#translate([armLength-corner[0]+armRad,-corner[1]/2,-bodySize[2]/2+strongThicknessHV[1]])
				intersection() {
					cube(corner);
					translate([0, corner[1]/2, corner[2]])
					rotate([90,0,0])
					rotate_extrude($fn=40){
						translate([corner[0]-armRad, 0])
						circle(cablePassRad,$fn=40);
					}
				}
								
		translate([armLength, 0, bodySize[2]/2-strongThicknessHV[1]-motorRH[1]]){
			motorMock();
			*translate([0, 0, 0])cylinder(r1=cablePassRad,r2=motorRH[0],h=2*strongThicknessHV[1],$fn=40);	
		}
		

		}

		%translate(escDist)cube(escSize, center = true);
		%translate([armLength, 0, bodySize[2]/2-strongThicknessHV[1]-motorRH[1]])motorMock();
	
	difference() {
		translate([1+motorSocketRad+strongThicknessHV[0],-minimumThicknessHV[0]/2,-bodySize[2]/2+2*armRad+strongThicknessHV[1]-.01])cube([armLength-motorSocketRad-motorRH[0]-3*strongThicknessHV[1],minimumThicknessHV[0],bodySize[2]-3*armRad-2*strongThicknessHV[0]]);
		#translate([escDist[0],minimumThicknessHV[0]/2+.1,-bodySize[2]/2+2*armRad+strongThicknessHV[1]-.1])rotate([90,0,0])linear_extrude(height=minimumThicknessHV[0]+.2)polygon([[-escSize[0]/2,0], [escSize[0]/2,0],[0,escSize[2]-2*strongThicknessHV[1]]]);
	}
}

module composition(armAngles,exploded=false){
	translate([0, 0, exploded ? 2 : 0])rotate([0,180,0])bodyTop();
	translate([0, 0, exploded ? -2 : 0])bodyBottom();	

	copy_mirror(vec=[1,0,0]){
		translate([socketCenters[0][0], socketCenters[0][1], 0])
			rotate([0,0,armAngles[0]])
				arm();

		translate([socketCenters[1][0], socketCenters[1][1], 0])
			rotate([0,0,armAngles[1]])
				arm();
	}

	*for(x = [-1,1],y=[-1,1]){
		translate([x*motorCenters[0], y*motorCenters[1], 0])
		%#cylinder(r=.5, h=50,center=true);	
	}

	foldedSize = [2*socketCenters[1][0]+10,2*socketCenters[0][1]+10,bodySize[2]+12];
	echo ("folded Size Lxlxh : ", foldedSize, "mm");
	%translate([0,0,6])cube(foldedSize,center = true);
}


module plate(){
	*%cube([120,120,.1],center = true);

	translate([-30,0,0])bodyTop();
	translate([30,0,0])bodyBottom();

	for(x = [-1,1],y=[-1,1]){
		translate([-17+x*25, y*40, 0])
			rotate([0,0,0])arm();
	}
}


//utilities

module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
} 
