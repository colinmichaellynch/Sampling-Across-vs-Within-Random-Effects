clear

tic

y = 10; 
n_max = 12; 
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
