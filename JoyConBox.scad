////////////////////////////////////////////////////////////
// Parametric Box for Switch Joy-Con Grips, Power Bank, etc.
////////////////////////////////////////////////////////////

// Overall box parameters
nozzle = 0.4; // nozzle diameter for 3D printing
boxWallThickness = 3*nozzle; // wall thickness for main box
minWallThickness = 2*nozzle; // minimum wall thickness for magnet holes
floorThickness   = 4*nozzle;
boxInnerX        = 98; // internal width
boxInnerY        = 151; // internal depth
boxInnerZ        = 108; // internal height

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

module corner_reinforcement() {
    height = -20;  // Height of reinforcement
    width = 15;   // Width and depth of triangle base
    
    polyhedron(
        points = [
            [0,0,0],          // 0: base front left
            [width,0,0],      // 1: base front right
            [0,width,0],      // 2: base back left
            [0,0,height],     // 3: top point
        ],
        faces = [
            [0,1,2],          // bottom
            [0,3,1],          // front
            [1,3,2],          // right
            [2,3,0]           // left
        ]
    );
}

module box_body() {
    magnetOffset = (magnetDiameter/2) + minWallThickness;  // Center position from edge
    
    difference() {

            // Main box
            cube([boxOuterX, boxOuterY, boxOuterZ]);
            
        
        // Interior hollow
        difference() {
            translate([boxWallThickness, boxWallThickness, floorThickness])
                cube([boxInnerX, boxInnerY, boxInnerZ + 1]);

            // Corner reinforcements aligned with magnet positions
            cornerPositions = [
                [magnetOffset - 3*boxWallThickness, magnetOffset - 3*boxWallThickness, 0],          // Front Left
                [boxOuterX - magnetOffset + 3*boxWallThickness, magnetOffset - 3*boxWallThickness, 90],    // Front Right
                [boxOuterX - magnetOffset + 3*boxWallThickness, boxOuterY - magnetOffset + 3*boxWallThickness, 180], // Back Right
                [magnetOffset - 3*boxWallThickness, boxOuterY - magnetOffset + 3*boxWallThickness, 270]    // Back Left
            ];

            for(pos = cornerPositions) {
                translate([pos[0], pos[1], boxOuterZ])
                rotate([0, 0, pos[2]])
                corner_reinforcement();
            }
        }
        
        // Magnet holes precisely in corners
        for(x=[magnetOffset, boxOuterX - magnetOffset])
        for(y=[magnetOffset, boxOuterY - magnetOffset]) {
            translate([x, y, boxOuterZ - magnetThickness])
                cylinder(d=magnetDiameter, h=magnetThickness + 2);
        }
    }
}

// Render just the box body
box_body();
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