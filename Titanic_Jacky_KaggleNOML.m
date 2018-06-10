%Kaggle Titanic Program
%Name: Jacky Chen - z3466229
%Degree: Mechanical Engineering 



[num,txt,all] = xlsread('test.csv');                      %Import Test data
testdata = all;
[num,txt,all] = xlsread('train.csv');                    %Import Train data



%Important variables 
male = 0;
female = 0;
age = 0;
pclass_upper = 0;
pclass_middle = 0;
pclass_lower = 0;


%Code to determine sex values
count = 2;
index = 2;
while (count <= 891 && index <= 891)
    if (all{index,2} == 1);
        if strcmp(all{count,5},'female') == 1;
            female = female + 1;
        else
            male = male + 1;
        end
    end
    
        count = count + 1;
        index = index + 1;
end
%%%%%%%%%%%%%%%%

%code to determine age values
%Average age of survival

count = 2;
index = 2;
survivors = female + male;
while (count <= 891 && index <= 891);
    if (all{index,2} == 1);
        %age_array{count,1} = all{count,6};
        age = age + all{count,6};   
    end
    count = count + 1;
    index = index + 1;
end
age = age/survivors;

%Code to determine infleuntial values of the three different pclasses. 
count = 2;
index = 2;
while (count <= 891 && index <= 891)
    if (all{index,2} == 1);
        if(all{count,3} == 1);
           pclass_upper = pclass_upper + 1; 
        end
        if (all{count,3} == 2);
            pclass_middle = pclass_middle + 1;
        end
        if (all{count,3} == 3);
            pclass_lower = pclass_lower + 1;
        end
    end
        count = count + 1;
        index = index + 1;
end

female_value = 0;
male_value = 0;
pclassupper_value = 0;
pclassmiddle_value = 0;
pclasslower_value = 0;

%Coming up with a value for female & male influential factor
if (female > male);
    female_value = 1;
    male_value = male/female;
end
if (male > female);
    male_value = 1;
    female_value = female/male;
end
if (male == female);
    female_value = 1;
    male_value = 1;
end

%Coming up with a value for pclass influential factor
%Depending on which PCLASS is most common amongst survivors, this pclass
%will contain a value of 1 (highest value of survival probability per
%variable). The other two pclassess will contains values < 1 at their
%respective (pclass value / highest pclass value).
if (pclass_upper > pclass_middle); 
    if (pclass_upper > pclass_lower);
        pclassupper_value = 1;
        pclassmiddle_value = pclass_middle/pclass_upper;
        pclasslower_value = pclass_lower/pclass_upper;
    else 
        pclasslower_value = 1;
        pclassupper_value = pclass_upper/pclass_lower;
        pclassmiddle_value = pclass_middle/pclass_lower;
    end
else
    if (pclass_upper > pclass_lower);
        pclassmiddle_value = 1;
        pclassupper_value = pclass_upper/pclass_middle;
        pclasslower_value = pclass_lower/pclass_middle;
    else
        if (pclass_middle > pclass_lower);
            pclassmiddle_value = 1;
            pclassupper_value = pclass_upper/pclass_middle;
            pclasslower_value = pclass_lower/pclass_middle;
        else
            pclasslower_value = 1;
            pclassupper_value = pclass_upper/pclass_lower;
            pclassmiddle_value = pclass_middle/pclass_lower;
        end
    end
    temp_num = 0;
    
    if (pclass_upper == pclass_middle);
        if (pclass_upper == pclass_lower);
            pclassupper_value = 1;
            pclassmiddle_value = 1;
            pclasslower_value = 1;
        end
        if (pclass_upper > pclass_lower);
            pclassupper_value = 1;
            pclassmiddle_value = 1;
            pclasslower_value = pclass_lower/pclass_upper;
        else
            pclasslower_value = 1;
            pclassupper_value = pclass_upper/pclass_lower;
            pclassmiddle_value = pclass_middle/pclass_lower;
        end
        temp_num = 1;
    end
    if (pclass_lower == pclass_middle && temp_num == 0);
        if (pclass_lower == pclass_upper);
            pclassupper_value = 1;
            pclassmiddle_value = 1;
            pclasslower_value = 1;
        else
            if (pclass_lower > pclass_upper);
                pclasslower_value = 1;
                pclassmiddle_value = 1;
                pclassupper_value = pclass_upper/pclass_lower;
            else
                pclassupper_value = 1;
                pclassmiddle_value = pclass_middle/pclass_upper;
                pclasslower_value = pclass_lower/pclass_upper;
            end
        end
        temp_num = 1;
    end
    if (pclass_lower == pclass_upper && temp_num == 0);
        if (pclass_lower == pclass_middle);
            pclassupper_value = 1;
            pclassmiddle_value = 1;
            pclasslower_value = 1;
        else
            if (pclass_lower > pclass_middle);
                pclasslower_value = 1;
                pclassupper_value = 1;
                pclassmiddle_value = pclass_middle/pclass_lower;
            end
        end
        temp_num = 1;
    end      
end


%Determine average survival rate based off the average age generated from
%train data analysis
%If the age of passenger is within 10% of 50 (average life expectancy
%during 1912), than the passenger recieves the greatest value of survival
%probability that can be associated with one variable, that is, a value of
%1. Otherwise, the value that is added to a passengers total survival
%probability (survival_rate) is the (average_age/passenger's_age).

index = 2;
count = 2;
while (index < 891 && count < 891); %only looking at the passengers that survived
    if (all{index,2} == 1); %Pclass
        if (all{index,3} == 1);
            survival_rate = survival_rate + pclassupper_value;
        else
            if(all{index,3} == 2);
                survival_rate = survival_rate + pclassmiddle_value;
            else
                survival_rate = survival_rate + pclasslower_value;
            end
        end
        if strcmp(all{index,5},'female') == 1; %Gender
            survival_rate = survival_rate + female_value;
        else
            survival_rate = survival_rate + male_value;
        end
        if ((abs(all{index,6})-age) <= ((1/10)*50)); %50y.o = Average life expectancy during 1912
            survival_rate = survival_rate + 1;
        else
            if ((abs(all{index,6}) < age));
                survival_rate = survival_rate + (all{index,6}/age);
            else
                survival_rate = survival_rate + (age/all{index,6});
            end
        end
    end
    
    index = index + 1;
end
survival_rate = survival_rate/survivors;

%Use survival_rate to determine if a passenger survived or not. If total
%survival value of passenger is greater than survival_rate, he/she lived.
%Otherwise, he/she died.


%Testing the test data

passenger_list = zeros(418,2);
index = 1;
survival_test = 0;
count = 2;
while (index <= 418 && count <= 419);
    survival_test = 0;
    passenger_list(index,1) = testdata{count,1};
    if (testdata{count,2} == 1);  %Pclass test
        survival_test = survival_test + pclassupper_value;
    else
        if (testdata{count,2} == 2);
            survival_test = survival_test + pclassmiddle_value;
        else
            if (testdata{count,2} == 3);
                survival_test = survival_test + pclasslower_value;
            end
        end
    end
    if strcmp(testdata{count,4},'female') == 1; %Gender test
        survival_test = survival_test + female_value;
    else
        survival_test = survival_test + male_value;
    end
    
    %Age test
    %Within this test, if the age of the passenger is within 10% of 50 
    %(50 was the Average life expectancy during 1912) of the average
    %survival age,
    %then the passenger will receive a higher value added into his/her
    %survival probability (survival_test).
     if ((abs(testdata{count,5})- age) <= ((1/10)*50)); 
            survival_test = survival_test + 1;
        else
            if ((abs(testdata{count,5}) < age));
                survival_test = survival_test + ((testdata{count,5})/age);
            else
                survival_test = survival_test + (age/(testdata{count,5}));
            end
     end
     
     %If accumalated survival values are greater than the survival rate
     %generated from the train data, then he/she is considered to have
     %survived. 
     if (survival_test >= survival_rate);
         passenger_list(index,2) = 1;
     else
         passenger_list(index,2) = 0;
     end
     index = index + 1;
     count = count + 1;
end

%Create a CSV file of the outputs in the required gender_submission.csv format
output = {'PassengerId', 'Survived'};
filename = 'gender_submission.xlsx';
xlswrite(filename,passenger_list,1,'A2:B419');
xlswrite(filename,output,1, 'A1:B1');
