INCH = 25.4;

tightFitThickness = .3; //space between to parts that must assemble

minimumThicknessHV = [.5,.3]; // minimal Wall,Floor thickness recommend to use [extrusion_width,layer_height]
strongThicknessHV = [2*minimumThicknessHV[0],5*minimumThicknessHV[1]]; // Wall,Floor thickness for strong parts recommend 2 walls, 5 layers

pinRad = 1.30; //radiant of the filament used to attach the arms. tested for 1.75 filament on reprap huxley
