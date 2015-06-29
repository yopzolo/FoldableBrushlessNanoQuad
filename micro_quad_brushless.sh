#/bin/sh

mkdir export

/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/body.stl micro_quad_brushless.scad -D part=2
/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/body_top.stl micro_quad_brushless.scad -D part=3
/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/arm.stl micro_quad_brushless.scad -D part=4

/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/micro_quad_brushless.stl micro_quad_brushless.scad -D part=0
/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/micro_quad_brushless_folded.stl micro_quad_brushless.scad -D part=1
#/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/plate.stl micro_quad_brushless.scad -D part=5

#/./Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o export/tests.stl componentsTest.scad