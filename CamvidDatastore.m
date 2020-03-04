function datastore = CamvidDatastore(downloadDir)
    arguments
        downloadDir string = tempdir
    end
    % Returns a combined datastore of an Image Datastore and a PixelLabelDatastore
    imageURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/files/701_StillsRaw_full.zip';
    labelURL = 'http://web4.cs.ucl.ac.uk/staff/g.brostow/MotionSegRecData/data/LabeledApproved_full.zip';

    outputFolder = fullfile(downloadDir,'CamVid'); 
    labelsZip = fullfile(outputFolder,'labels.zip');
    imagesZip = fullfile(outputFolder,'images.zip');

    if ~exist(labelsZip, 'file') || ~exist(imagesZip,'file')   
        mkdir(outputFolder)
        
        disp('Downloading 16 MB CamVid dataset labels...'); 
        websave(labelsZip, labelURL);
        unzip(labelsZip, fullfile(outputFolder,'labels'));
        
        disp('Downloading 557 MB CamVid dataset images...');  
        websave(imagesZip, imageURL);       
        unzip(imagesZip, fullfile(outputFolder,'images'));
        disp('Finished downloading and unzipping the dataset');    
    end

    imgDir = fullfile(outputFolder,'images','701_StillsRaw_full');
    imds = imageDatastore(imgDir);

    labelIDs = camvidPixelLabelIDs();
    labelDir = fullfile(outputFolder,'labels');
    
    classes = ["Sky", "Building", "Pole","Road","Pavement","Tree","SignSymbol","Fence","Car","Pedestrian","Bicyclist"];
    pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

    datastore = combine(imds, pxds);
end

function labelIDs = camvidPixelLabelIDs()
    % Return the label IDs corresponding to each class.
    %
    % The CamVid dataset has 32 classes. Group them into 11 classes following
    % the original SegNet training methodology [1].
    %
    % The 11 classes are:
    %   "Sky" "Building", "Pole", "Road", "Pavement", "Tree", "SignSymbol",
    %   "Fence", "Car", "Pedestrian",  and "Bicyclist".
    %
    % CamVid pixel label IDs are provided as RGB color values. Group them into
    % 11 classes and return them as a cell array of M-by-3 matrices. The
    % original CamVid class names are listed alongside each RGB value. Note
    % that the Other/Void class are excluded below.
    labelIDs = { ...
        
        % "Sky"
        [
        128 128 128; ... % "Sky"
        ]
        
        % "Building" 
        [
        000 128 064; ... % "Bridge"
        128 000 000; ... % "Building"
        064 192 000; ... % "Wall"
        064 000 064; ... % "Tunnel"
        192 000 128; ... % "Archway"
        ]
        
        % "Pole"
        [
        192 192 128; ... % "Column_Pole"
        000 000 064; ... % "TrafficCone"
        ]
        
        % Road
        [
        128 064 128; ... % "Road"
        128 000 192; ... % "LaneMkgsDriv"
        192 000 064; ... % "LaneMkgsNonDriv"
        ]
        
        % "Pavement"
        [
        000 000 192; ... % "Sidewalk" 
        064 192 128; ... % "ParkingBlock"
        128 128 192; ... % "RoadShoulder"
        ]
            
        % "Tree"
        [
        128 128 000; ... % "Tree"
        192 192 000; ... % "VegetationMisc"
        ]
        
        % "SignSymbol"
        [
        192 128 128; ... % "SignSymbol"
        128 128 064; ... % "Misc_Text"
        000 064 064; ... % "TrafficLight"
        ]
        
        % "Fence"
        [
        064 064 128; ... % "Fence"
        ]
        
        % "Car"
        [
        064 000 128; ... % "Car"
        064 128 192; ... % "SUVPickupTruck"
        192 128 192; ... % "Truck_Bus"
        192 064 128; ... % "Train"
        128 064 064; ... % "OtherMoving"
        ]
        
        % "Pedestrian"
        [
        064 064 000; ... % "Pedestrian"
        192 128 064; ... % "Child"
        064 000 192; ... % "CartLuggagePram"
        064 128 064; ... % "Animal"
        ]
        
        % "Bicyclist"
        [
        000 128 192; ... % "Bicyclist"
        192 000 192; ... % "MotorcycleScooter"
        ]
        
        };
end
