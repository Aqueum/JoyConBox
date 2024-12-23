# JoyConBox
- Christmas 2024 present for Grace
- A 3d printed box (with illuminated lid) to contain a pair of Joy Cons in charging grips with powerbank, cables & LEDs
- Martin Currie with an awful lot of help from ChatGPT
## 01 initial prompt 
Please produce a support-free OpenSCAD file to 3D print a box in PETG.  
We need the box to contain:
A 3D printed insert that makes it perfect to hold:
2x Nintendo Switch controllers each housed in a charging comfort grip handle (2Pcs Switch Joy Con Grip Compatible with Nintendo Switch/Switch OLED, Comfort Grip Holder Gaming Controller Gamepad with Charging Function for Switch Joy-Con Controller (Red and Blue)
 https://amzn.eu/d/bO8TaR5), sat on top of an Anchor 321 power bank (98x46x23mm [Anker Power Bank, Ultra-Compact 5,200mAh Portable Charger, PowerCore 5K Battery Pack
https://amzn.eu/d/], plus an allowance to have a USB A plug connected - the USB A is ~9mm from one edge to 24mm from the other).  I think the controller should be facing each other, but angled away from each other so the buttons don't collide.
In this configuration (when sat on the power bank) combined they take:
98mm x 151mm  
108mm highBetween the power bank and the underside of the controllers we can fit two Nintendo Switch straps (if we cross them over diagonally) they each measure 101x15x14mm but also have a flexible ~3.5mm diameter nylon rope strap at each end)
I would like to be able to get a 2-1 USB C cable to charge both controllers simultaneously with the box lid closed.
For now the priority is that we can include a “Daymeet Motion Sensor Under Bed Lights, 3M RGB Motion Activated LED Strip Lights with Automatic Shut Off Timer App Control Cabinet Night Light Closet (https://amzn.eu/d/0tixqe9)
The insert should be removable so that the box can be easily repurposed so it can contain things other than Joy Cons.
The lid of the box should have a permanent 3mm thick white acrylic sheet that the light can shine through, then on top of that an interchangeable black PETG lid attached using 6x3mm magnets.  The first lid design should incorporate the graphics from an attached STL file.

GPT4o refined the above prompt as:	
1.	Box Functionality:
	•	Must hold Nintendo Switch controllers in charging grips.
	•	Controllers are facing each other but angled away to avoid button collisions.
	•	Controllers and power bank sit on top of each other with space for straps beneath.
	•	Space for USB-A plug connection.
	•	Include Daymeet LED strip for under-lighting.
	•	Lid must support white acrylic sheet for light diffusion.
	2.	Components:
	•	Controllers with charging grips: 98mm x 151mm x 108mm.
	•	Power bank: 98mm x 46mm x 23mm, with additional plug space.
	•	Nintendo Switch straps: 101mm x 15mm x 14mm, flexible straps noted.
	•	Removable insert to make box repurposable.
	•	Interchangeable black PETG lid attached via 6x3mm magnets.
	•	First lid design incorporates graphics from an attached STL file.
	3.	Priorities:
	•	Ensure compatibility with Daymeet LED strip.
	•	Enable charging of controllers while closed using a 2-1 USB-C cable.
	•	Design to be support-free for efficient 3D printing.
	•	Material: PETG for the box, acrylic for the light panel.If these disagree, or any other critical information is unavailable please ask for confirmation, otherwise please now produce the OpenSCAD file.
 
 ## O1 initial output (after remming out the non-main-box elements):

`////////////////////////////////////////////////////////////
// Parametric Box for Switch Joy-Con Grips, Power Bank, etc.
////////////////////////////////////////////////////////////

// Overall box parameters
boxWallThickness = 3;
floorThickness   = 3;
boxInnerX        = 140; // internal width
boxInnerY        = 190; // internal depth
boxInnerZ        = 130; // internal height

// Magnets
magnetDiameter   = 6;
magnetThickness  = 3;
magnetInset      = 10; // distance from edge

// Insert: approximate placeholders for Joy Cons + grips, power bank, straps
controllerBlockX = 49;  // half of 98
controllerBlockY = 75.5; // half of 151
controllerBlockZ = 108;
powerBankX       = 98;
powerBankY       = 46;
powerBankZ       = 23;
strapX           = 101;
strapY           = 15;
strapZ           = 14;
cableClearance   = 15; // approximate for USB plug & cable

// Acrylic panel thickness
acrylicThickness = 3;

// Quick offset to ensure parts fit
clearance = 0.8;

// Outer box dimensions
boxOuterX = boxInnerX + 2*boxWallThickness;
boxOuterY = boxInnerY + 2*boxWallThickness;
boxOuterZ = boxInnerZ + floorThickness; // box body only (lid separate)

// LED channel (optional perimeter notch)
ledChannelDepth  = 5;
ledChannelHeight = 5;

////////////////////////
// Main modules
////////////////////////

module box_body() {
    difference() {
        // Outer walls
        cube([boxOuterX, boxOuterY, boxOuterZ]);
        
        // Hollow interior
        translate([boxWallThickness, boxWallThickness, floorThickness])
        cube([boxInnerX, boxInnerY, boxInnerZ]);
        
        /*
        // Optional LED strip channel around inside perimeter
        // Carve a small channel near bottom
        translate([boxWallThickness, boxWallThickness, 0])
        cube([boxInnerX, ledChannelDepth, ledChannelHeight]);

        translate([boxWallThickness, boxInnerY - ledChannelDepth, 0])
        cube([boxInnerX, ledChannelDepth, ledChannelHeight]);

        translate([boxWallThickness, boxWallThickness, 0])
        cube([ledChannelDepth, boxInnerY - 2*boxWallThickness, ledChannelHeight]);

        translate([boxInnerX - ledChannelDepth + boxWallThickness, boxWallThickness, 0])
        cube([ledChannelDepth, boxInnerY - 2*boxWallThickness, ledChannelHeight]);
        */
        // Magnet holes in top edge (four corners + 2 along edges)
        for(i=[0,boxOuterX/2,boxOuterX], j=[0,boxOuterY]) {
            if(!(i==0 && j==0) && !(i==0 && j==boxOuterY) && !(i==boxOuterX && j==0) && !(i==boxOuterX && j==boxOuterY)) {
                translate([i, j, boxOuterZ - magnetThickness - 1])
                    cylinder(d=magnetDiameter, h=magnetThickness+2, center=false);
            }
        }
    }
}
/*
module removable_insert() {
    // Simple shape that holds two angled controllers above power bank + straps
    // (Placeholder geometry -- refine as needed)
    difference() {
        cube([boxInnerX - 2*clearance, 
              boxInnerY - 2*clearance, 
              boxInnerZ * 0.75]); // partial height insert

        // Cut spaces for controllers (angled away)
        translate([ (boxInnerX/2) - controllerBlockX, (boxInnerY/2) - controllerBlockY, 0 ])
        rotate([0,0, 10])  // slight angle
        cube([controllerBlockX, controllerBlockY, controllerBlockZ + 10]);

        translate([ (boxInnerX/2), (boxInnerY/2) - controllerBlockY, 0 ])
        rotate([0,0,-10])
        cube([controllerBlockX, controllerBlockY, controllerBlockZ + 10]);

        // Power bank slot below
        translate([ (boxInnerX - powerBankX)/2, clearance, 0 ])
        cube([powerBankX, powerBankY + cableClearance, powerBankZ + 5]);
        
        // Space for straps (under controllers)
        translate([clearance, boxInnerY - strapY - 2*clearance, 0])
        rotate([0,0,45])
        cube([strapX+10, strapY+10, strapZ+10]);
    }
}
*//*
module lid_and_acrylic() {
    // Acrylic piece + black PETG top with magnet recesses & optional STL graphic
    difference() {
        union() {
            // Acrylic diffuser (bottom layer of lid, 3mm thick)
            translate([0, 0, 0])
            cube([boxOuterX, boxOuterY, acrylicThickness]);

            // Black PETG top (another 3mm, attached with magnets)
            translate([0,0,acrylicThickness])
            cube([boxOuterX, boxOuterY, magnetThickness]); 
        }

        // Magnet holes in black PETG layer
        for(i=[0,boxOuterX/2,boxOuterX], j=[0,boxOuterY]) {
            if(!(i==0 && j==0) && !(i==0 && j==boxOuterY) && !(i==boxOuterX && j==0) && !(i==boxOuterX && j==boxOuterY)) {
                translate([i, j, acrylicThickness])
                    cylinder(d=magnetDiameter, h=magnetThickness+1, center=false);
            }
        }

        // Optional graphic from an external STL file, subtract/engrave or union
        // import("<PATH_TO_GRAPHICS.stl>");
        // Example: subtract a shallow engraving

        translate([boxOuterX/4, boxOuterY/4, acrylicThickness])
        difference() {
            cube([boxOuterX/2, boxOuterY/2, 1]);
            import("<PATH_TO_GRAPHICS.stl>");
        }
    }
}
*/
////////////////////////////////////////
// Combine or comment out as needed
////////////////////////////////////////
module full_assembly() {
    box_body();
    translate([clearance, clearance, floorThickness])
        removable_insert();
    translate([0,0,boxOuterZ])
        lid_and_acrylic();
}

////////////////////////////////////////
// Render the final assembly
////////////////////////////////////////
full_assembly();`

 ## Code after much work with 4o:

////////////////////////////////////////////////////////////
// Parametric Box for Switch Joy-Con Grips, Power Bank, etc.
////////////////////////////////////////////////////////////

// Overall box parameters
boxWallThickness = 3;
floorThickness   = 3;
boxInnerX        = 140; // internal width
boxInnerY        = 190; // internal depth
boxInnerZ        = 130; // internal height

// Magnets
magnetDiameter   = 6;
magnetThickness  = 3;
magnetInset      = 10; // distance from edge

// Insert: approximate placeholders for Joy Cons + grips, power bank, straps
controllerBlockX = 49;  // half of 98
controllerBlockY = 75.5; // half of 151
controllerBlockZ = 108;
powerBankX       = 98;
powerBankY       = 46;
powerBankZ       = 23;
strapX           = 101;
strapY           = 15;
strapZ           = 14;
cableClearance   = 15; // approximate for USB plug & cable

// Acrylic panel thickness
acrylicThickness = 3;

// Quick offset to ensure parts fit
clearance = 0.8;

// Outer box dimensions
boxOuterX = boxInnerX + 2*boxWallThickness;
boxOuterY = boxInnerY + 2*boxWallThickness;
boxOuterZ = boxInnerZ + floorThickness; // box body only (lid separate)

// LED channel (optional perimeter notch)
ledChannelDepth  = 5;
ledChannelHeight = 5;

////////////////////////
// Main modules
////////////////////////

module corner_reinforcements() {
    // Tapered corner reinforcements for magnets
    for (x = [0, boxOuterX - boxWallThickness])
    for (y = [0, boxOuterY - boxWallThickness]) {
        translate([x, y, boxOuterZ - 15]) // Align to box corners, adjust height
            linear_extrude(height=15) {  // Extrusion height matches taper
                polygon(points=[
                    [0, 0],                  // Start at the corner
                    [15, 0],                 // Extend outward along X
                    [15, 15],                // Extend outward along Y
                    [0, 15],                 // Back to origin along Y
                    [7.5, 7.5]               // Taper inward to the center
                ], paths=[[0, 1, 2, 3, 4]]);
            }
    }
}

module magnet_holes() {
    // Place magnets inside corner reinforcements
    translate([magnetInset, magnetInset, boxOuterZ - magnetThickness - 1])
        cylinder(d=magnetDiameter, h=magnetThickness + 2, center=false);
    translate([boxOuterX - magnetInset - magnetDiameter, magnetInset, boxOuterZ - magnetThickness - 1])
        cylinder(d=magnetDiameter, h=magnetThickness + 2, center=false);
    translate([magnetInset, boxOuterY - magnetInset - magnetDiameter, boxOuterZ - magnetThickness - 1])
        cylinder(d=magnetDiameter, h=magnetThickness + 2, center=false);
    translate([boxOuterX - magnetInset - magnetDiameter, boxOuterY - magnetInset - magnetDiameter, boxOuterZ - magnetThickness - 1])
        cylinder(d=magnetDiameter, h=magnetThickness + 2, center=false);
}

module box_body() {
    difference() {
        // Outer walls
        cube([boxOuterX, boxOuterY, boxOuterZ]);

        // Hollow interior
        translate([boxWallThickness, boxWallThickness, floorThickness])
            cube([boxInnerX, boxInnerY, boxInnerZ]);

        // Add tapered corner reinforcements
        corner_reinforcements();

        // Subtract magnet holes
        magnet_holes();
    }
}
/*
module removable_insert() {
    // Simple shape that holds two angled controllers above power bank + straps
    // (Placeholder geometry -- refine as needed)
    difference() {
        cube([boxInnerX - 2*clearance, 
              boxInnerY - 2*clearance, 
              boxInnerZ * 0.75]); // partial height insert

        // Cut spaces for controllers (angled away)
        translate([ (boxInnerX/2) - controllerBlockX, (boxInnerY/2) - controllerBlockY, 0 ])
        rotate([0,0, 10])  // slight angle
        cube([controllerBlockX, controllerBlockY, controllerBlockZ + 10]);

        translate([ (boxInnerX/2), (boxInnerY/2) - controllerBlockY, 0 ])
        rotate([0,0,-10])
        cube([controllerBlockX, controllerBlockY, controllerBlockZ + 10]);

        // Power bank slot below
        translate([ (boxInnerX - powerBankX)/2, clearance, 0 ])
        cube([powerBankX, powerBankY + cableClearance, powerBankZ + 5]);
        
        // Space for straps (under controllers)
        translate([clearance, boxInnerY - strapY - 2*clearance, 0])
        rotate([0,0,45])
        cube([strapX+10, strapY+10, strapZ+10]);
    }
}
*//*
module lid_and_acrylic() {
    // Acrylic piece + black PETG top with magnet recesses & optional STL graphic
    difference() {
        union() {
            // Acrylic diffuser (bottom layer of lid, 3mm thick)
            translate([0, 0, 0])
            cube([boxOuterX, boxOuterY, acrylicThickness]);

            // Black PETG top (another 3mm, attached with magnets)
            translate([0,0,acrylicThickness])
            cube([boxOuterX, boxOuterY, magnetThickness]); 
        }

        // Magnet holes in black PETG layer
        for(i=[0,boxOuterX/2,boxOuterX], j=[0,boxOuterY]) {
            if(!(i==0 && j==0) && !(i==0 && j==boxOuterY) && !(i==boxOuterX && j==0) && !(i==boxOuterX && j==boxOuterY)) {
                translate([i, j, acrylicThickness])
                    cylinder(d=magnetDiameter, h=magnetThickness+1, center=false);
            }
        }

        // Optional graphic from an external STL file, subtract/engrave or union
        // import("<PATH_TO_GRAPHICS.stl>");
        // Example: subtract a shallow engraving

        translate([boxOuterX/4, boxOuterY/4, acrylicThickness])
        difference() {
            cube([boxOuterX/2, boxOuterY/2, 1]);
            import("<PATH_TO_GRAPHICS.stl>");
        }
    }
}
*/
////////////////////////////////////////
// Combine or comment out as needed
////////////////////////////////////////
module full_assembly() {
    box_body();
    translate([clearance, clearance, floorThickness])
        removable_insert();
    translate([0,0,boxOuterZ])
        lid_and_acrylic();
}

////////////////////////////////////////
// Render the final assembly
////////////////////////////////////////
full_assembly();