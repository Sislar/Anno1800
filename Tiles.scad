$fn=30;

// Wall Thickness
gWT = 2;

tile = 41;
tileZ = 2 + 0.2;

tX = 3;
tY = 4;

TotalX = tX * tile + (tX+1) * gWT;
TotalY = tY * tile + (tY+1) * gWT;
//TotalX = 3 * tile + 4* gWT;
//TotalY = 4 * tile + 5* gWT;
TotalZ = 2*tileZ + gWT;

Board = 0;
Lid = 1;

RingOuter = 8;
RingInner = 6;
RingGap = 0.4;

module RCube(x,y,z,ipR=4) {
    translate([-x/2,-y/2,0]) hull(){
      translate([ipR,ipR,ipR]) sphere(ipR);
      translate([x-ipR,ipR,ipR]) sphere(ipR);
      translate([ipR,y-ipR,ipR]) sphere(ipR);
      translate([x-ipR,y-ipR,ipR]) sphere(ipR);
      translate([ipR,ipR,z-ipR]) sphere(ipR);
      translate([x-ipR,ipR,z-ipR]) sphere(ipR);
      translate([ipR,y-ipR,z-ipR]) sphere(ipR);
      translate([x-ipR,y-ipR,z-ipR]) sphere(ipR);
      }  
}

 module regular_polygon(order, r=1){
 	angles=[ for (i = [0:order-1]) i*(360/order) ];
 	coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
 	polygon(coords);
 }

module diamond_lattice(ipX, ipY, DSize, WSize)  {

    lOffset = DSize + WSize;

	difference()  {
		square([ipX, ipY]);
		for (x=[0:lOffset:ipX]) {
            for (y=[0:lOffset:ipY]){
  			   translate([x, y])  regular_polygon(4, r=DSize/2);
			   translate([x+lOffset/2, y+lOffset/2]) regular_polygon(4, r=DSize/2);
		    }
        }        
	}
}

module box(){
    difference() {
        cube([TotalX, TotalY, TotalZ]);
        
        //cutouts
        for (x=[0:1:tX]) 
          for (y=[0:1:tY]) 
          {
            dx = x*(tile+gWT)+gWT;
            dy = y*(tile+gWT)+gWT;
              
            // full cutout  
            translate([dx,dy,gWT])
              cube([tile, tile, 100]);
             
            // popup cutout  
            translate([dx,dy,0])
              cube([tile, tile/3, 100]);
          }     
    }
    
    // four outer rings main
    translate([0,0,0])cylinder(h = TotalZ, r=RingOuter/2);
    translate([TotalX+1,0,0])cylinder(h = TotalZ, r=RingOuter/2);
    translate([0,TotalY+1,0])cylinder(h = TotalZ, r=RingOuter/2);
    translate([TotalX+1,TotalY+1,0])cylinder(h = TotalZ, r=RingOuter/2);
    
    // four outer rings top post
    translate([0,0,TotalZ])cylinder(h = TotalZ-gWT-0.8, r=RingInner/2-RingGap);
    translate([TotalX+1,0,TotalZ])cylinder(h = TotalZ-gWT-0.8, r=RingInner/2-RingGap);
    translate([0,TotalY+1,TotalZ])cylinder(h = TotalZ-gWT-0.8, r=RingInner/2-RingGap);
    translate([TotalX+1,TotalY+1,TotalZ])cylinder(h = TotalZ-gWT-0.8, r=RingInner/2-RingGap);
}

if (Board==1){
    difference(){
        box();
        
        // corner rings
        translate([0,0,0])cylinder(h = TotalZ-gWT, r=RingInner/2);
        translate([TotalX+1,0,0])cylinder(h = TotalZ-gWT, r=RingInner/2);
        translate([0,TotalY+1,0])cylinder(h = TotalZ-gWT, r=RingInner/2);
        translate([TotalX+1,TotalY+1,0])cylinder(h = TotalZ-gWT, r=RingInner/2);
        
        // ring holes
        translate([tile * 0.5 + gWT,10,TotalZ]) rotate([-90,0,0]) hull () {
            translate([5,0,0])cylinder(h = TotalY, r=4); translate([-5,0,0])cylinder(h = TotalY, r=4);}
        translate([tile * 1.5 + 2*gWT,10,TotalZ]) rotate([-90,0,0]) hull () {
            translate([5,0,0])cylinder(h = TotalY, r=4); translate([-5,0,0])cylinder(h = TotalY, r=4);}
        translate([tile * 2.5 + 3*gWT,10,TotalZ]) rotate([-90,0,0]) hull () {
            translate([5,0,0])cylinder(h = TotalY, r=4); translate([-5,0,0])cylinder(h = TotalY, r=4);}

    }
}

if (Lid ==1) {
   LidZ = 2.4; 
    
   difference() {
      union() { 
        translate([TotalX/2,TotalY/2,LidZ/2])difference(){
          cube([TotalX, TotalY,LidZ], center=true);
          cube([TotalX-4, TotalY-4, LidZ], center=true);
        }  
        linear_extrude(height = LidZ) diamond_lattice(TotalX,TotalY,7,2);
        // four outer rings main
        translate([0,0,0])cylinder(h = LidZ, r=RingOuter/2);
        translate([TotalX+1,0,0])cylinder(h = LidZ, r=RingOuter/2);
        translate([0,TotalY+1,0])cylinder(h = LidZ, r=RingOuter/2);
        translate([TotalX+1,TotalY+1,0])cylinder(h = LidZ, r=RingOuter/2);
        }

        // ring holes
        translate([0,0,-1])cylinder(h = LidZ+2, r=RingInner/2);
        translate([TotalX+1,0,-1])cylinder(h = LidZ+2, r=RingInner/2);
        translate([0,TotalY+1,-1])cylinder(h = LidZ+2, r=RingInner/2);
        translate([TotalX+1,TotalY+1,-1])cylinder(h = LidZ+2, r=RingInner/2);

  }

}




