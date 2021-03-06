$fs=1;
$fa=10;

include <constants.scad>
include <components.scad>

part = 2; //[0:composed 1:composed folded 2:body, 3:BodyCustomTop, 4:arm, 5:plate]
part(part);


propDH = [3*INCH,5];

socketCenters = [[17,26],[24,-26]]; //[[17,26],[23,-27]];
motorCenters= [2*INCH,1.8*INCH]; //45.2,40.64

globalSize = [propDH[0]+2*motorCenters[0], propDH[0]+2*motorCenters[1]];
echo ("Lxl hors tout : ", globalSize, "mm");

deltas=[[motorCenters[0]-socketCenters[0][0],motorCenters[1]-socketCenters[0][1]],[motorCenters[0]-socketCenters[1][0],motorCenters[1]+socketCenters[1][1]]];
armLength=floor(max(sqrt(pow(deltas[0][1],2)+pow(deltas[0][0],2)),sqrt(pow(deltas[1][1],2)+pow(deltas[1][0],2))));
armAngles = [atan(deltas[0][1]/deltas[0][0]),-atan(deltas[1][1]/deltas[1][0])];

armAnglesFolded=[-92,87];

module part(part){
	if (part == 0){
		composition(armAngles,true);
	}
	if (part == 1){
		composition(armAnglesFolded,false);
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
	if (part == 5){
		plate();
	}
}

batteryArduinoSpace = 7.5;
bodySize = [gyroSize[0]+2*strongThicknessHV[0],batSize[1]+2*strongThicknessHV[0]+batteryArduinoSpace,arduinoSize[2]+2*strongThicknessHV[1]];

batOffset=0;

module bodyTop(){
	batteryEscSpace = 2;
	//escSpace = 7;
	
	gyroOffset = [0,14,0];
	rxOffset = [0,-10.5,0];
	rxOrientation = [0,0,00];

	translate([0,0,-bodySize[2]/2]){
		difference() {
			union() {

				bodyBase();
				#translate([-bodySize[0]/2,-bodySize[1]/2-batteryArduinoSpace/2+arduinoSize[1],0])cube([bodySize[0],bodySize[1],gyroFullThickness-.05]);

				translate(gyroOffset)gyroHull();
				translate(rxOffset)rotate(rxOrientation)rxHull();
			}

			color("green")translate(gyroOffset+[0,0,gyroFullThickness-0.01])rotate([180,0,0])gyroMock();
			color("green")translate(rxOffset)rotate(rxOrientation)rxMock();

			copy_mirror(vec=[1,0,0]){
				translate([socketCenters[0][0], socketCenters[0][1], 0])
				rotate([0,0,armAnglesFolded[0]])
				translate([armLength,0,-.1]){
					cylinder(r=motorRHTop[0], h=2*strongThicknessHV[1]+.002, center=false);
					translate([0,0,strongThicknessHV[1]+.1])cylinder(r=motorRHTop[0]+strongThicknessHV[0]+minimumThicknessHV[0], h=strongThicknessHV[1]+.002, center=false);
					rotate([0,0,90])translate([0,-motorRHTop[0],0])cube([2*motorRHTop[0],2*motorRHTop[0],2*strongThicknessHV[1]+.002]);
				}
			}
		}
		%translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
		%translate(gyroOffset+[0,0,gyroFullThickness-0.01])rotate([180,0,0])gyroMock();
		%translate(rxOffset)rotate(rxOrientation)rxMock();
	}
}


module bodyBottom(){
	translate([0,0,-bodySize[2]/2]){
//		difference() {
//			union() {
				bodyBase();
	
			//	*translate(-bodySize/2+strongThicknessHV[1]*[0,0,1])box([bodySize[0],bodySize[1],bodySize[2]/2-strongThicknessHV[1]],minimumThicknessHV[0]);

//			}
//			*translate([0, batOffset, 0])
//			copy_mirror([0,1,0]){
//			copy_mirror([1,0,0]){
//					for (x = [0:3*strongThicknessHV[0]:bodySize[0]/2-2*strongThicknessHV[0]]) {
//						translate([x,3/2*strongThicknessHV[0],0]){
//						hull() {
//							cylinder(r=strongThicknessHV[0], h=strongThicknessHV[1],$fn=40);
//							translate([0,bodySize[1]/3,0])cylinder(r=strongThicknessHV[0], h=strongThicknessHV[1],$fn=40);
//						}
//					}
//				}
//				}
//			}
//		}
//		*%color("green")translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();
	}
//	*%translate([-batSize[0]/2,-batSize[1]/2+batOffset,-bodySize[2]/2+strongThicknessHV[1]])cube(batSize);
}

module box(outerSize,thickness){
	difference() {
		cube(outerSize);
		translate([thickness, thickness, thickness])cube(outerSize-thickness*[2,2,-2]);
	}
}

socketLenght = 15;
springLenght = 3;

motorSocketRad = pinRad+strongThicknessHV[0];
armRad = 2.1;

module armSocketHull(){
 translate([0,0,0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=2*strongThicknessHV[1]);
 translate([-socketLenght,-(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),strongThicknessHV[1]]);
}

module armSocket(){


	difference() {
		union() {

			cylinder(r=motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0], h=strongThicknessHV[1]);

			translate([-socketLenght,-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),strongThicknessHV[1]]);
			
			difference() {
				union() {
					translate([0,0,0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=3/2*strongThicknessHV[1]);
					translate([-socketLenght,-(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),0])cube([socketLenght,2*(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),strongThicknessHV[1]]);
					}

				translate([0,0,0])cylinder(r=motorSocketRad+strongThicknessHV[0]+2*minimumThicknessHV[0],h=2*strongThicknessHV[1]+.001);
				translate([-springLenght,-(motorSocketRad+strongThicknessHV[0]+2*minimumThicknessHV[0]),0])cube([springLenght,2*(motorSocketRad+strongThicknessHV[0]+2*minimumThicknessHV[0]),2*strongThicknessHV[1]]);
				translate([-(socketLenght-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0])),-(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),strongThicknessHV[1]])cube([socketLenght-(motorSocketRad+strongThicknessHV[0]+minimumThicknessHV[0]),2*(motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0]),2*strongThicknessHV[1]+.001]);

			}

			translate([0,0,strongThicknessHV[1]])cylinder(r=motorSocketRad, h=strongThicknessHV[1]);
		}
		cylinder(r=pinRad, h=100);

		rotate([0,0,0])translate([armRad+minimumThicknessHV[0],0,armRad+strongThicknessHV[1]+minimumThicknessHV[0]])rotate([0,90,0])cylinder(r=armRad+tightFitThickness,h=armLength);	
		for (z = [-90,90]) {
			rotate([0,0,z])translate([armRad+minimumThicknessHV[0],0,armRad+strongThicknessHV[1]+tightFitThickness])rotate([0,90,0])cylinder(r=armRad+tightFitThickness,h=armLength);	
		}
		
					
	}
}


module bodyBase(){
	baseOffset=2;

	difference() {
		union(){

			*hull() {
				copy_mirror([1,0,0])
				translate([socketCenters[0][0], socketCenters[0][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}

			hull() {
				copy_mirror([1,0,0])
				translate([socketCenters[1][0], socketCenters[1][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}

			*#copy_mirror([1,0,0])hull() {
				translate([socketCenters[0][0], socketCenters[0][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);	
				translate([socketCenters[1][0], socketCenters[1][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}
			
			copy_mirror([1,0,0])hull() {
				translate([socketCenters[0][0], socketCenters[0][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);	
				translate([0,socketCenters[0][1]+socketCenters[0][0]*tan(-armAngles[0]),0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}

			copy_mirror([1,0,0])hull() {
				translate([socketCenters[1][0], socketCenters[1][1], 0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);	
				translate([0,socketCenters[1][1]+socketCenters[1][0]*tan(-armAngles[1]),0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}

			hull() {
				translate([0,socketCenters[0][1]+socketCenters[0][0]*tan(-armAngles[0]),0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);	
				translate([0,socketCenters[1][1]+socketCenters[1][0]*tan(-armAngles[1]),0])cylinder(r=motorSocketRad+2*strongThicknessHV[0]+2*minimumThicknessHV[0],h=strongThicknessHV[1]);
			}
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

	difference() {
			translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoHull();
			translate([0,-batSize[1]/2-batteryArduinoSpace+batOffset,strongThicknessHV[1]])arduinoMock();

	}
	
}

echo ("armLength",armLength);

module arm(){

	cablePassRad=armRad-2*minimumThicknessHV[1];
	echo ("cablePassRad : ",cablePassRad);
	escDist=[escSize[0]/2+motorSocketRad+strongThicknessHV[1]+7,0,bodySize[2]/2-escSize[2]/2-2*armRad-strongThicknessHV[1]];
	cornerRad=bodySize[2]-2*strongThicknessHV[1]-motorRH[1]-armRad;

	corner=[cornerRad+armRad,2*armRad,cornerRad+armRad];
		*%translate([0,-10,-bodySize[2]/2+strongThicknessHV[1]])cube(bodySize-[-20,10,2*strongThicknessHV[1]]);

		difference() {
			union() {
				//*translate([armLength,0,0])sphere(armWithCablePass,$fn=40);
				//translate([armLength,0,-3])sphere(2.27,$fn=40);
				cylinder(r=pinRad+strongThicknessHV[0],h=bodySize[2]-2*strongThicknessHV[1], center = true);

				copy_mirror([0,0,1]){
					translate([0,0,bodySize[2]/2-strongThicknessHV[1]-armRad])cylinder(r=motorSocketRad+strongThicknessHV[0]+tightFitThickness,h=armRad);
					translate([0,0,bodySize[2]/2-strongThicknessHV[1]-2*armRad])cylinder(r2=motorSocketRad+strongThicknessHV[0]+tightFitThickness,r1=pinRad+strongThicknessHV[0],h=armRad);
			}
				
				translate([armLength,0,bodySize[2]/2-motorRH[1]-strongThicknessHV[1]])motorHull();
				
				//hull() {
					translate([0,0,bodySize[2]/2-armRad-strongThicknessHV[1]])rotate([0,90,0])cylinder(r=armRad,h=armLength);
					translate([0,0,-bodySize[2]/2+armRad+strongThicknessHV[1]])rotate([0,90,0])cylinder(r=armRad,h=armLength-cornerRad);
					
					translate([armLength-corner[0]+armRad,-corner[1]/2,-bodySize[2]/2+strongThicknessHV[1]])
						intersection() {
							cube(corner);

							translate([0, corner[1]/2, corner[2]])
							rotate([90,0,0])
							rotate_extrude(){
								translate([corner[0]-armRad, 0])
								circle(armRad);
						}
				}

				//}	
			}

			cylinder(r=pinRad,h=100,center=true);
			copy_mirror([0,0,1]){
				translate([0,0,bodySize[2]/2-2*strongThicknessHV[1]+.001])cylinder(r=motorSocketRad+tightFitThickness, h=strongThicknessHV[1]);
				translate([0,0,bodySize[2]/2-4*strongThicknessHV[1]+.002])cylinder(r2=motorSocketRad+tightFitThickness, r1=pinRad, h=2*strongThicknessHV[1]);
			}

			translate(escDist)cube(escSize, center = true);

			translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,90,0])cylinder(r=cablePassRad,h=armLength-corner[0]+armRad-motorSocketRad-strongThicknessHV[0]-escSize[0]/2-escDist[0]);
			translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,90,0])sphere(r=cablePassRad);
			translate([motorSocketRad+strongThicknessHV[0]+escSize[0]/2+escDist[0],0,-bodySize[2]/2+strongThicknessHV[1]+armRad])rotate([0,0,0])cylinder(r=cablePassRad,h=2*strongThicknessHV[1]);
			
			translate([armLength-corner[0]+armRad,-corner[1]/2,-bodySize[2]/2+strongThicknessHV[1]])
				intersection() {
					cube(corner);
					translate([0, corner[1]/2, corner[2]])
					rotate([90,0,0])
					rotate_extrude(){
						translate([corner[0]-armRad, 0])
						circle(cablePassRad);
					}
				}
								
		translate([armLength, 0, bodySize[2]/2-strongThicknessHV[1]-motorRH[1]]){
			motorMock();
			*translate([0, 0, 0])cylinder(r1=cablePassRad,r2=motorRH[0],h=2*strongThicknessHV[1]);	
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
	*%translate([0,0,6])cube(foldedSize,center = true);
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
