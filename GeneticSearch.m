function [ optRoute ] = GeneticSearch( cities )

iterations = 1000; % Number of iterations
population_size = 100; % Number of chromosomes in population
best = zeros(iterations,2); 

%% generate random population
%randomnly allocate each city only once
population = zeros(population_size,100); 
for i = 1:population_size
    population(i,:) = randperm(100,100);
end
%add extra column for fitness scores
population = [population zeros(population_size,1)];

%% repeat k times; each time generates a new population
for k = 1:iterations
    %% evaluate fitness scores
    for i = 1:population_size
        fit_score = 0;
        for j = 1:99
            fit_score = fit_score + pdist([cities(population(i,j),1),cities(population(i,j),2); ...
                cities(population(i,j+1),1),cities(population(i,j+1),2);],'euclidean'); 
        end
        population(i,101) = fit_score + pdist([cities(100,1),cities(100,2); ...
                cities(1,1),cities(1,2);],'euclidean');
    end
    %% elite, keep best 2
    population = sortrows(population,101);
    population_new = zeros(population_size,100);
    population_new(1:2,:) = population(1:2,1:100);
    population_new_num = 2;
    best(k,1) = k;
    best(k,2) = population(1,101);
    
    %% repeat until new population is full
    while (population_new_num < population_size)
        %% use tournament selection to pick two chromosomes
        contenders_index = randi([1, population_size],1,15);
        contenders = zeros(15,101);
        for i=1:15 
            contenders(i,:) = population(contenders_index(i),:);
        end
        contenders = sortrows(contenders,101);
        temp_chromosome_1 = contenders(1,1:100);
        temp_chromosome_2 = contenders(2,1:100);
        
        %% crossover prob 0.8 and random pick cross point
        if (rand < 0.8)
           
           cross_end = randi([1, 100],1,1);

           donation1 = temp_chromosome_1(1:cross_end);
           donation2 = temp_chromosome_2(1:cross_end);
           
           %crossover to second parent
           temp_chromosome_2 = [setdiff(temp_chromosome_2,donation1,'stable') donation1];
        
           %crossover to first parent
           temp_chromosome_1 = [setdiff(temp_chromosome_1,donation2,'stable') donation2 ];
        end
 
        %% mutation prob 0.2
        %Swap mutation
        if (rand < 0.2)
            pos = randperm(100,2);
            temp_chromosome_1([pos(1) pos(2)]) = temp_chromosome_1 ([pos(2) pos(1)]);
        end
        if (rand < 0.2)
            pos = randperm(100,2);
            temp_chromosome_2([pos(1) pos(2)]) = temp_chromosome_2 ([pos(2) pos(1)]);
        end
        
        %Flip mutation
        if (rand < 0.2)
            flip_start = randi([1, 100],1,1);
            flip_end = randi([flip_start, 100],1,1);
            temp_chromosome_1 = [temp_chromosome_1(1:(flip_start-1))...
                fliplr(temp_chromosome_1(flip_start:flip_end))...
                temp_chromosome_1((flip_end+1):100)];
        end
        
        if (rand < 0.2)
            flip_start = randi([1, 100],1,1);
            flip_end = randi([flip_start, 100],1,1);
            temp_chromosome_2 = [temp_chromosome_2(1:(flip_start-1))...
                fliplr(temp_chromosome_2(flip_start:flip_end))...
                temp_chromosome_2((flip_end+1):100)];
        end
        
        %Slide mutation
        if (rand < 0.2)
            move_from = randi([1, 100],1,1);
            move_to = randi([move_from, 100],1,1);
            
            temp_chromosome_1 = [temp_chromosome_1(1:(move_from-1)) ...
                temp_chromosome_1((move_from+1):move_to) temp_chromosome_1(move_from) ...
                temp_chromosome_1((move_to+1):100)];
        end 
        
        if (rand < 0.2)
            move_from = randi([1, 100],1,1);
            move_to = randi([move_from, 100],1,1);
            
            temp_chromosome_2 = [temp_chromosome_2(1:(move_from-1)) ...
                temp_chromosome_2((move_from+1):move_to) temp_chromosome_2(move_from) ...
                temp_chromosome_2((move_to+1):100)];
        end
        
        %% Add result to new population
        population_new_num = population_new_num + 1;
        population_new(population_new_num,:) = temp_chromosome_1;

        if (population_new_num < population_size)
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = temp_chromosome_2;
        end
    end
    %% replace, last column not updated yet
    population(:,1:100) = population_new;
end

%% evaluate fitness scores and rank them
for i = 1:population_size
    fit_score = 0;
    for j = 1:99
        fit_score = fit_score + pdist([cities(population(i,j),1),cities(population(i,j),2); ...
            cities(population(i,j+1),1),cities(population(i,j+1),2);],'euclidean'); 
    end
    population(i,101) = fit_score + pdist([cities(100,1),cities(100,2); ...
            cities(1,1),cities(1,2);],'euclidean');
end

population = sortrows(population,101);
optRoute = population(1,:);
%optRoute = best;  !!! un-comment to insted output best case for each generation !!!

