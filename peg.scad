include<configuration.scad>
use <pins.scad>
use <base.scad>

part = 5;

//laid out for printing
if(part == 0)   //peg
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK);
if(part == 1)   //double length peg - good for supporting bigger modules
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK, peg_units=2);
if(part == 2)   //triple length peg - good for supporting bigger modules
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK, peg_units=3);
if(part == 3)   //peg that catches marbles
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) 
        ball_return_peg();
if(part == 4)   //stand for a 12x12 board
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90])
        peg_stand();

if(part == 5)   //stand for a 12x12 board
    translate([0,0,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90])
        peg_stand(height=4, front_drop=2);

if(part == 10){
    //peg for printing
    translate([0,peg_thick,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK);

    //double length peg - good for supporting bigger modules
    translate([0,peg_thick-30,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK, peg_units=2);

    //triple length peg - good for supporting bigger modules
    translate([0,peg_thick-60,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) peg(peg=PEG_HOOK, peg_units=3);

    //peg that catches marbles
    translate([-50,peg_thick,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) 
        ball_return_peg();

    //stand for a 12x12 board
    translate([0,peg_thick+80,-peg_sep/2+peg_rad-1]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90])
        peg_stand();
}

//added the option to make the peg have a locking pin, instead of a hook.
//todo: add an option for a long pin with a screwhole in it
module peg(peg=PEG_HOOK, peg_units=1, lower_peg_thick = peg_thick){
    $fn=16;
    
    extra_inset = 2;
    
    peg_angle = 20;
    rear_inset = peg_rad*tan(peg_angle)+extra_inset;
    front_inset = rear_inset+slop-extra_inset;
    
    cutoff=1;
    
    translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
          //top rear
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([90,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad-slop, h=peg_thick+peg_rad-rear_inset);
            translate([0,peg_thick+peg_rad-rear_inset,0]) sphere(r=peg_rad*3/4-slop/2);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) cylinder(r1=peg_rad*3/4-slop/2, r2=peg_rad*3/4-slop, h=peg_thick);
            translate([0,peg_thick+peg_rad-rear_inset,0]) rotate([-peg_angle,0,0]) translate([0,0,peg_thick]) sphere(r=peg_rad*3/4-slop);
			
            //top front
            if(peg==PEG_HOOK){
                translate([0,-wall+.1,0]) rotate([90,0,0]) cylinder(r1=peg_rad, r2=peg_rad*3/4, h=wall+peg_rad-front_inset);
                translate([0,-wall*2-front_inset,0]) sphere(r=peg_rad*3/4);
                translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) cylinder(r1=peg_rad*3/4, r2=peg_rad*3/4-slop, h=wall*2);
                translate([0,-wall*2-front_inset,0]) rotate([peg_angle,0,0]) translate([0,0,wall*2]) sphere(r=peg_rad*3/4-slop);
            }
            if(peg==PEG_PIN){
                //draw a pin connector instead
                rotate([90,0,0]) rotate([0,0,90]) translate([0,0,wall/2])pin_vertical(h=wall*2+wall/2,r=pin_rad,lh=wall,lt=pin_lt,t=pin_tolerance,cut=false);
            }
            
            //connect 'em
            hull(){
                rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
                translate([0,0,-peg_sep*.5-peg_sep*peg_units]) rotate([90,0,0]) cylinder(r=peg_rad, h=wall);
            }
            
            //lower peg
            translate([0,0,-peg_sep*peg_units]) rotate([90,0,0]) translate([0,0,-lower_peg_thick]) cylinder(r2=peg_rad, r1=peg_rad-slop, h=lower_peg_thick+wall);
            translate([0,lower_peg_thick,-peg_sep*peg_units]) sphere(r=peg_rad-slop);
        }
        
        //cut off top and bottom for easier printing
        translate([100+peg_rad-cutoff,0,0]) cube([200,200,200], center=true);
        translate([-100-peg_rad+cutoff,0,0]) cube([200,200,200], center=true);
    }
}

//debated remaking the peg square...
//this is unfinished.  The round peg works well.  The advantage to the square would be a flat surface
//for better wear resistance... but I don't think that's really a big problem.
module square_peg(){
    peg_sq = (peg_rad*2)/sqrt(2);
    
    angle=15;
    
    union(){
        //through the pegboard
        translate([0,-peg_sq/2,0]) cube([peg_sq, peg_thick+peg_sq, peg_sq], center=true);
        //back curve
        intersection(){
            translate([0,peg_thick/2,peg_sq/2]) rotate([0,90,0]) rotate_extrude(angle=90, $fn=30){
                translate([peg_sq/2,0,0]) square([peg_sq, peg_sq], center=true);
            }
            translate([-peg_sq/2,peg_thick/2,peg_sq/2]) rotate([-90-angle,0,0]) cube([peg_sq, peg_thick, peg_sq]);
        }
        //back peg
        translate([-peg_sq/2,peg_thick/2,peg_sq/2]) rotate([-90-angle,0,0]) hull(){
            cube([peg_sq, .1, peg_sq]);
            #translate([0,-4,1]) cube([peg_sq, .1, peg_sq-2]);
        }
        //front curve
        intersection(){
            translate([0,-peg_thick/2-peg_sq,peg_sq/2]) rotate([0,90,0]) rotate_extrude(angle=90, $fn=30){
                translate([peg_sq/2,0,0]) square([peg_sq, peg_sq], center=true);
            }
            translate([-peg_sq/2,-peg_thick/2-peg_sq,peg_sq/2]) rotate([-90-angle,0,0]) cube([peg_sq, peg_thick, peg_sq]);
        }
    }
}

module ball_return_peg(){
    $fn=30;
    dowel_rad = (3/8)/2*in;
    
    thick = peg_rad*2-2;
    separation = -12.85;
    
    //climb
    climb_angle = 45;
    
    %cube([1,in*2*2.5,1], center=true);
    
    %translate([in/2,-in/2,in]) sphere(r=ball_rad);
    difference(){
        union(){
            peg(peg=PEG_HOOK);
            
            translate([in/2,-wall*3/4-dowel_rad,in/2+2]){
            rotate([0,90,0]) intersection(){
                cylinder(r=dowel_rad+wall, h=thick, center=true);
                translate([dowel_rad+wall/2,0,0]) cube([(dowel_rad+wall)*2,(dowel_rad+wall)*2,(dowel_rad+wall)*2], center=true);
                translate([0,-wall/2,0]) cube([(dowel_rad+wall)*2,(dowel_rad+wall)*2,(dowel_rad+wall)*2], center=true);
            }
            
            translate([0,-6,-1.65]) rotate([-climb_angle,0,0]) cube([thick,wall,wall*1.75], center=true);
            
            translate([0,separation,0]) rotate([-climb_angle,0,0]){
                for(i=[0:3]) translate([0,separation*i,0]) rotate([0,90,0]) intersection(){
                    cylinder(r=dowel_rad+wall,    h=thick, center=true);
                    translate([dowel_rad+wall/2,0,0]) cube([(dowel_rad+wall)*2,(dowel_rad+wall)*2,(dowel_rad+wall)*2], center=true);
                }
            }
        }
        }
        
        //the rods
        #translate([in/2,-wall*3/4-dowel_rad,in/2+2]){
            rotate([0,90,0]) cylinder(r=dowel_rad, h=wall*3, center=true);
            translate([0,separation,0]) rotate([-climb_angle,0,0]){
                for(i=[0:3]) translate([0,separation*i,0]) rotate([0,90,0]) cylinder(r=dowel_rad,    h=wall*3, center=true);
            }
        }
    }
}

module peg_stand(peg_units = 1, thick = in*.6, height=3, front_drop=1, base_length = in*4){
    cutoff=1;
    
    
    brace_height = peg_sep*1.25;
    
    translate([peg_sep/2,0,peg_sep*1.5]) 
    difference(){
        union(){
            translate([-peg_sep/2,0,-peg_sep*1.5]) peg(peg=NONE, peg_units=peg_units, lower_peg_thick=-wall);
            
            //stiffen the spine
            hull(){
                translate([0,0,peg_rad-thick/2]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall*2);
                translate([0,0,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall*4);
            }
            
            //front brace
            translate([0,wall+in/4,0]) hull(){
                translate([0,0,peg_rad-thick/2-peg_sep*front_drop]) 
                rotate([90,0,0]) cylinder(r=thick/2, h=wall);
                translate([0,0,-peg_sep*height]) rotate([90,0,0]) cylinder(r=thick/2, h=wall);
            }
            
            //peg in the front brace
            translate([0,0,-peg_sep*front_drop]){
                rotate([90,0,0]) translate([0,0,-wall-in/4]) cylinder(r1=peg_rad, r2=peg_rad-slop, h=peg_thick-.333);
                translate([0,wall+in/4-peg_thick+.333,0]) sphere(r=peg_rad-slop);
            }
            
            //base
            translate([0,(wall+in/4)/2-wall/2,0])
            for(i=[0:1]) mirror([0,i,0]) translate([0,0,-peg_sep*height]) difference(){
                union(){
                    rotate([90,0,0]) cube([thick, thick, peg_sep], center=true);
                    hull(){ //bottom
                        translate([0,-base_length/2,0]) 
                        rotate([90,0,0]) translate([-thick/2,-thick/2,0])cube([thick, thick, wall]);
                        translate([0,-(wall+in/4)/2,0]) rotate([90,0,0]) translate([-thick/2,-thick/2,0]) cube([thick, thick, wall]);
                        translate([0,-(wall+in/4)/2,brace_height]) rotate([90,0,0]) translate([-thick/2,-thick/2,0]) cube([thick, thick, wall]);
                    }
                }
                translate([0,-base_length/2-wall,brace_height+thick/2]) scale([1,(base_length-wall*2)/in,(2*brace_height+thick)/in]) rotate([0,90,0]) cylinder(r=in/2, h=20, center=true, $fn=60);
            }
        }
        
        
        //cut off side for easier printing
        translate([-100-peg_rad+cutoff,0,0]) cube([200,200,200], center=true);
        
        //cut off bottom so it can standor easier printing
        translate([-100-peg_rad+cutoff,0,0]) cube([200,200,200], center=true);
    }
}
