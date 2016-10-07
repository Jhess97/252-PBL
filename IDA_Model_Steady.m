function IDA_Model_Steady
Blood_vol = 4.7+(5.5-4.7)*rand % volume of blood in average adult

RBC = (4.32+(5.72-4.32)*rand)*1e10 * Blood_vol/1e10 % # cells*10^10 in blood

Hemoglobin = (135+(175-135)*rand)* Blood_vol % grams of hemo in blood

Oxygen = 1.34*0.5*Hemoglobin %volume(ml)of oxygen in blood.

%each gram of hemoglobin carries 1.34 ml of oxygen. Assuming half the blood
%is oxygenated. We have 1/2 the number.

% we can also use the oxygenation saturation which is 95%/100% for healthy
% individuals. In fact, for anemic individuals, this number doesn't change.
% The Saturation will be the same even though the total ability of oxygen
% storage in hemoglobin has gone down.

%DECISIONS^^^^^

Iron = (60+(170-60)*rand)*Blood_vol

% need only 1-1.5mg of iron per day to replace what is lost
% ~4grams for adult males, 3.5 for females
% 90% of iron is not absorbed

CO2 = 10

cycle_number = 0;

cycle_type = 0;
% cycle_type = 1 then the blood is in the heart-body loop
% cycle_type = 0 then the blood is in the heart-lung loop

anemia = 0
% anemia: no = 0 / yes = 1
% assume no constriction or dilation


input = [RBC Hemoglobin Oxygen Iron CO2 cycle_number cycle_type anemia]

RBC = [RBC]; % vectors to track each product
Hemoglobin = [Hemoglobin];
Oxygen = [Oxygen];
Iron = [Iron];
CO2 = [CO2];
    plot(cycle_number,RBC, '-r')
    hold on
    plot( cycle_number,Hemoglobin, '-g')
    hold on
    plot( cycle_number,Oxygen, '-b')
    hold on
    plot( cycle_number,Iron, '-m')
    hold on
    plot( cycle_number,CO2, '-k')
    hold on
    
max_cycles = 4;
while max(max(cycle_number)) < max_cycles+1
    if input(7) == 0
        input1 = small_intestine(input./4);
        input2 = spleen(input./4);
        input3 = bone_marrow(input./4);
        input4 = input./4;
        input5 = liver(input1+input2);
        input = input3 + input4 + input5;
        input = heart(input);
    elseif input(7) == 1 % if the blood is coming from the body
        input = lungs(input);
        input = heart(input);
        cycle_number = [cycle_number cycle_number(end)+1]; % complete cycle
        RBC = [RBC input(1)]; % update values
        Hemoglobin = [Hemoglobin input(2)];
        Oxygen = [Oxygen input(3)];
        Iron = [Iron input(4)];
        CO2 = [CO2 input(5)];
    end
    plot(cycle_number,RBC, '-r')
    hold on
    plot( cycle_number,Hemoglobin, '-g')
    hold on
    plot( cycle_number,Oxygen, '-b')
    hold on
    plot( cycle_number,Iron, '-m')
    hold on
    plot( cycle_number,CO2, '-k')
    hold on
end
end

function [input] = bone_marrow(input)
 
    if input(end) == 0 % if the anemia factor is turned off
        input(1) = input(1) + 2e6*(30)/1e10; % each cycle (2mil/sec)(30sec) RBCs are added
        %input(2) = input(2) + 2e6*250000000*30;
        %input(4) = input(4) - 4*2e6*250000000*(30); % 4 times the number of hemoglobin of iron are taken out 
        %NO, Fix values^
  
% bone marrow output when anemia is present needed
        
%     elseif input(end) == 1
%         % need to find the anemia numbers for this
%         input(1) = 
%         input(4) = 4*input(1);
%         
%        
    end
end

function [input] = heart(input)
% we aren't losing momentum throughout the loop so does this need to be
% coded?

%change path based on input(7) = cycle_type
% cycle_type = 1 (the blood is coming from the body)
    % send to lungs
% cycle_type = 0 (blood is coming from lungs)
    % send to body
if input(7) == 0
    input(7)= 1;
else
    input(7) = 0;
end
end

function [input] = liver(input)
if input(end) == 0  %if no anemia, operate normally
%iron out as waste
cycles_in_a_day = 24*3600/30;
mg_out_per_cycle = (1+(0.5*rand))/cycles_in_a_day;
input(4) = input(4)-mg_out_per_cycle;


%iron stored
%need to find
else % operate in anemic conditions
    
    
end

end

function [input] = lungs(input)
    input(3) = input(3) + ((250)/(60))*(30);
    input(5) = input(5) - (265 - 175)*rand()*(1/60)*(30);
end

function [input] = small_intestine(input)
    input(4) = input(4) + (1.5)/(24)/(60)/(60)*30;
end

function [input] = spleen(input)
    input(1) = input(1) - 2000000*30/1e10;
end