//micro quad
//include <Libs.scad>
INCH = 25.4;

propDH = [3*INCH,5];

motorCenters= [1.8*INCH,1.7*INCH]; //45.2,40.64
motorDH=[10,14];
motorWeigth=2;

motorPropTrust=36;

rxSize=[21,14,2];
rxWeight=2;

gyroSize=[20.32,15,4];
gyroWeight=2;

arduinoSize=[34,1.8,18];
arduinoWeight=3;

fcSize=[0,0,0];
fcWeigth=0;

escSize=[3.4,12.9,11.6];
escWeigth=.6; //0.36; j'ajoute le poids des fils ici

batSize=[24,43,9];
batWeigth=19;

echo ("diametre des hélices : ", propDH[0], "mm");

printSize = [motorDH[0]+2*motorCenters[0], motorDH[0]+2*motorCenters[1], 60];
echo ("class : " , 2*sqrt(pow(motorCenters[0],2)+pow(motorCenters[1],2)));
echo ("Lxlxh moteur a moteur : ", printSize, "mm" );
*%cube(printSize,center=true);

globalSize = [propDH[0]+2*motorCenters[0], propDH[0]+2*motorCenters[1], propDH[1]+motorDH[1]];
echo ("Lxlxh hors tout : ", globalSize, "mm");
translate([0,0,(propDH[1]-motorDH[1])/2])
*%cube(globalSize, center=true);

echo ("poids total : ", 4*motorWeigth + 4*escWeigth + fcWeigth + batWeigth, "g");
echo ("poids limite : ", 4/3*motorPropTrust, "g");
echo ("trust total : ", 4*motorPropTrust, "g");


for(x = [-1,1],y=[-1,1]){
	translate([x*motorCenters[0], y*motorCenters[1], propDH[1]/2])
	%color("red")cylinder(r=propDH[0]/2, h=propDH[1], center=true);

	translate([x*motorCenters[0], y*motorCenters[1], -motorDH[1]/2])
	cylinder(r=motorDH[0]/2, h=motorDH[1],center=true);	
}

cube(fcSize, center=true);

translate([0,-batSize[1]/2-arduinoSize[1]/2-1,-arduinoSize[2]/3])cube(arduinoSize,center=true);
translate([0,0,0])cube(gyroSize,center=true);
translate([0,rxSize[1]/2+gyroSize[1]/2+1,0])cube(rxSize,center=true);


translate([0,0,-batSize[2]])
cube(batSize,center=true);

for(x = [-1,1],y=[-1,1]){
	translate([x*(batSize[0]+escSize[0]+2)/2, y*(batSize[1]/2-escSize[1]), -batSize[2]])
	cube(escSize,center=true);
}


//tmp futur micro 2g

module arm(){
	cylinder(r=1.75, h=9,$fn=20);
	translate([0,0,9])cylinder(r=5, h=4.8,$fn=40);

}
translate([100,0 ,0 ]){
arm();
}