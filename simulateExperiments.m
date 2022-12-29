clear

tic

y = 10; 
n_max = 20; 
delta_threshold = .3; 
alpha = .05;
lower_delta_val = .00001; 

sims_number_of_parameters = 10;%8; %the number of values each parameter takes on
sims_iterate_parameters = 3;%4;%4; %the number of simulations run for any particular parameter value 
sims_accuracy = 50;%25;%50; %The number of times sampled for a particular strategy to create confusion matrix 

var_min = 0;
var_max = 3;
var_vector = linspace(var_min, var_max, sims_number_of_parameters); 

delta_min = 0;
delta_max = 3; 
delta_vector = linspace(delta_threshold, delta_max, sims_number_of_parameters-round(delta_threshold*sims_number_of_parameters));
delta_vector = [zeros(1, round(delta_threshold*sims_number_of_parameters)) delta_vector]; 

within_colony_rep_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
between_colony_rep_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
inter_var_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters); 
intra_var_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters); 
delta_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters); 
var_value_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
false_neg_rate_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
true_pos_rate_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
false_pos_rate_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
true_neg_rate_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
false_neg_rate_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
true_pos_rate_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
false_pos_rate_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
true_neg_rate_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
within_colony_std_treat_a_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
between_colony_std_treat_a_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
within_colony_std_treat_b_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
between_colony_std_treat_b_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
within_colony_std_treat_b_type_2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
between_colony_std_treat_b_type_2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
accuracy_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
accuracy_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
balanced_accuracy_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
balanced_accuracy_type2_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters);
full_colony_tens = zeros(n_max, n_max, sims_number_of_parameters, sims_number_of_parameters, sims_number_of_parameters, sims_iterate_parameters, n_max*n_max);

for n = 1:n_max
        
    for j = 1:n_max

        for o = 1:sims_number_of_parameters

            for u = 1:sims_number_of_parameters

                for q = 1:sims_number_of_parameters

                    for i = 1:sims_iterate_parameters
                        
                        if n == 1 && j == 1
                            
                            within_colony_rep_tens(n, j, o, u, q, i) = NaN;
                            between_colony_rep_tens(n, j, o, u, q, i) = NaN;
                            inter_var_tens(n, j, o, u, q, i) = NaN; 
                            intra_var_tens(n, j, o, u, q, i) = NaN; 
                            delta_tens(n, j, o, u, q, i) = NaN; 
                            var_value_tens(n, j, o, u, q, i) = NaN;
                            false_neg_rate_tens(n, j, o, u, q, i) = NaN;
                            true_pos_rate_tens(n, j, o, u, q, i) = NaN;
                            false_pos_rate_tens(n, j, o, u, q, i) = NaN;
                            true_neg_rate_tens(n, j, o, u, q, i) = NaN;
                            false_neg_rate_type2_tens(n, j, o, u, q, i) = NaN;
                            true_pos_rate_type2_tens(n, j, o, u, q, i) = NaN;
                            false_pos_rate_type2_tens(n, j, o, u, q, i) = NaN;
                            true_neg_rate_type2_tens(n, j, o, u, q, i) = NaN;
                            within_colony_std_treat_a_tens(n, j, o, u, q, i) = NaN;
                            between_colony_std_treat_a_tens(n, j, o, u, q, i) = NaN;
                            within_colony_std_treat_b_tens(n, j, o, u, q, i) = NaN;
                            between_colony_std_treat_b_tens(n, j, o, u, q, i) = NaN;
                            within_colony_std_treat_b_type_2_tens(n, j, o, u, q, i) = NaN;
                            between_colony_std_treat_b_type_2_tens(n, j, o, u, q, i) = NaN;
                            accuracy_tens(n, j, o, u, q, i) = NaN;
                            accuracy_type2_tens(n, j, o, u, q, i) = NaN;
                            balanced_accuracy_tens(n, j, o, u, q, i) = NaN;
                            balanced_accuracy_type2_tens(n, j, o, u, q, i) = NaN;
                            full_colony_tens(n, j, o, u, q, i, :) = NaN;
                            
                        else
                             
                            within_colony_rep = j;
                            between_colony_rep = n; 
                            within_colony_rep_tens(n, j, o, u, q, i) = within_colony_rep;
                            between_colony_rep_tens(n, j, o, u, q, i) = between_colony_rep;

                            inter_var = var_vector(o); 
                            inter_var_tens(n, j, o, u, q, i) = inter_var^2; 
                            intra_var = var_vector(u); 
                            intra_var_tens(n, j, o, u, q, i) = intra_var^2; 
                            delta = delta_vector(q); 
                            delta_tens(n, j, o, u, q, i) = delta; 

                            [var_value,...
                            false_neg_rate, true_pos_rate, false_pos_rate,...
                            true_neg_rate, false_neg_rate_type2, true_pos_rate_type2,...
                            false_pos_rate_type2, true_neg_rate_type2,...
                            within_colony_std_treat_a, between_colony_std_treat_a,...
                            within_colony_std_treat_b, between_colony_std_treat_b,...
                            within_colony_std_treat_b_type_2, between_colony_std_treat_b_type_2,...
                            accuracy, accuracy_type2, balanced_accuracy, ...
                            balanced_accuracy_type2, full_colony] ...
                            = modeling_strategies(inter_var, intra_var, delta, sims_accuracy,...
                            lower_delta_val, within_colony_rep, between_colony_rep, alpha, y); 

                            var_value_tens(n, j, o, u, q, i) = var_value;
                            false_neg_rate_tens(n, j, o, u, q, i) = false_neg_rate;
                            true_pos_rate_tens(n, j, o, u, q, i) = true_pos_rate;
                            false_pos_rate_tens(n, j, o, u, q, i) = false_pos_rate;
                            true_neg_rate_tens(n, j, o, u, q, i) = true_neg_rate;
                            false_neg_rate_type2_tens(n, j, o, u, q, i) = false_neg_rate_type2;
                            true_pos_rate_type2_tens(n, j, o, u, q, i) = true_pos_rate_type2;
                            false_pos_rate_type2_tens(n, j, o, u, q, i) = false_pos_rate_type2;
                            true_neg_rate_type2_tens(n, j, o, u, q, i) = true_neg_rate_type2;
                            within_colony_std_treat_a_tens(n, j, o, u, q, i) = within_colony_std_treat_a;
                            between_colony_std_treat_a_tens(n, j, o, u, q, i) = between_colony_std_treat_a;
                            within_colony_std_treat_b_tens(n, j, o, u, q, i) = within_colony_std_treat_b;
                            between_colony_std_treat_b_tens(n, j, o, u, q, i) = between_colony_std_treat_b;
                            within_colony_std_treat_b_type_2_tens(n, j, o, u, q, i) = within_colony_std_treat_b_type_2;
                            between_colony_std_treat_b_type_2_tens(n, j, o, u, q, i) = between_colony_std_treat_b_type_2;
                            accuracy_tens(n, j, o, u, q, i) = accuracy;
                            accuracy_type2_tens(n, j, o, u, q, i) = accuracy_type2;
                            balanced_accuracy_tens(n, j, o, u, q, i) = balanced_accuracy;
                            balanced_accuracy_type2_tens(n, j, o, u, q, i) = balanced_accuracy_type2;
                            full_colony_tens(n, j, o, u, q, i, 1:length(full_colony)) = full_colony;
                            
                        end
                                      
                    end
                   
                end
                
            end
                
        end
            
    end
        
end

time = toc;

counter = 0; 
for n = 1:n_max        
    for j = 1:n_max
        for o = 1:sims_number_of_parameters
            for u = 1:sims_number_of_parameters
                for q = 1:sims_number_of_parameters
                    for i = 1:sims_iterate_parameters
                        counter = counter+1; 
                        full_colony_vec = nonzeros(squeeze(full_colony_tens(n, j, o, u, q, i, :)));
                        halfway_point = round(length(full_colony_vec)/2); 
                        full_colony_a = full_colony_vec(1:halfway_point); 
                        full_colony_b = full_colony_vec(halfway_point+1:end); 
                        delta_estimate_vec(counter) = mean(full_colony_b) - mean(full_colony_a); 
                        
                        if isnan(var(full_colony_vec))
                            best_distribution{counter} = NaN; 
                        else
                            test_cdf1 = makedist('tlocationscale','mu',mean(full_colony_vec),'sigma',var(full_colony_vec)+.0001,'nu',1);
                            test_cdf2 = makedist('Normal','mu',mean(full_colony_vec),'sigma',var(full_colony_vec)+.0001); 
                            [~, ~, ksstat1] = kstest(full_colony_vec,'CDF',test_cdf1); 
                            [~, ~, ksstat2] = kstest(full_colony_vec,'CDF',test_cdf2); 
                            if ksstat1 > ksstat2
                                best_distribution{counter} = "Normal";
                            else
                                best_distribution{counter} = "T";
                            end
                            
                            difference_between_dist(counter) = ksstat2-ksstat1; 
                            
                        end
                    end
                end
            end
        end
    end
end

delta_error = (delta_tens(:) - delta_estimate_vec'); 
delta_estimate_vec=delta_estimate_vec'; 

matrix = [var_value_tens(:), false_neg_rate_tens(:), true_pos_rate_tens(:), false_pos_rate_tens(:), true_neg_rate_tens(:), ...
    false_neg_rate_type2_tens(:), true_pos_rate_type2_tens(:), false_pos_rate_type2_tens(:), true_neg_rate_type2_tens(:),...
    within_colony_std_treat_a_tens(:), between_colony_std_treat_a_tens(:), within_colony_std_treat_b_tens(:), between_colony_std_treat_b_tens(:), within_colony_std_treat_b_type_2_tens(:)...
    between_colony_std_treat_b_type_2_tens(:), accuracy_tens(:), accuracy_type2_tens(:), balanced_accuracy_tens(:), balanced_accuracy_type2_tens(:),...
    within_colony_rep_tens(:), between_colony_rep_tens(:), inter_var_tens(:), intra_var_tens(:), delta_tens(:),...
    delta_estimate_vec, delta_error]; 

headers = {'Variance' 'False_Neg_Rate' 'True_Pos_Rate' 'False_Pos_Rate' 'True_Neg_Rate' 'False_Neg_Rate_Type2' 'True_Pos_Rate_Type2' 'False_Pos_Rate_Type2' 'True_Neg_Rate_Type2'...
    'Within_Colony_std_treat_a' 'Between_Colony_std_treat_a' 'Within_Colony_std_treat_b' 'Between_Colony_std_treat_b' 'Within_Colony_std_treat_b_type2' 'Between_Colony_std_treat_b_type2'...
    'Accuracy', 'Accuracy_Type2','Balanced_Accuracy', 'Balanced_Accuracy_Type2', 'Within_colony_rep', 'between_colony_rep', 'inter_var', 'intra_var', 'delta', 'delta_estimate', 'delta_error'};

colony_sampling_final = [headers;num2cell(matrix)];

%export as csv

fid = fopen('colony_sampling_final.csv', 'w');
fprintf(fid, '%s,', colony_sampling_final{1,1:end-1});
fprintf(fid, '%s\n', colony_sampling_final{1,end});
fclose(fid);
dlmwrite('colony_sampling_final.csv', colony_sampling_final(2:end,:), '-append');
    

