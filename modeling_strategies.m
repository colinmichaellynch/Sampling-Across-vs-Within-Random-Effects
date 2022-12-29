function    [var_value,...
            false_neg_rate, true_pos_rate, false_pos_rate,...
            true_neg_rate, false_neg_rate_type2, true_pos_rate_type2,...
            false_pos_rate_type2, true_neg_rate_type2,...
            within_colony_std_treat_a, between_colony_std_treat_a,...
            within_colony_std_treat_b, between_colony_std_treat_b,...
            within_colony_std_treat_b_type_2, between_colony_std_treat_b_type_2,...
            accuracy, accuracy_type2, balanced_accuracy, ...
            balanced_accuracy_type2, full_colony] ...
            = modeling_strategies(inter_var, intra_var, delta, sims_accuracy,...
            lower_delta_val, within_colony_rep, between_colony_rep, alpha, y)

   counter = 1;
while counter < 100
    counter = counter + 1
        colony_treatment_a = []; 
        colony_treatment_b = []; 
        full_colony = [];
        colony_difference_treat_a = [];
        colony_difference_treat_b = [];
        colony_difference_treat_a_type_2 = []; 
        colony_difference_treat_b_type_2 = []; 
        colony_treatment_b_type_2 = []; 
        ants_in_colony_treat_a_mean = []; 
        ants_in_colony_treat_b_mean = []; 
        ants_in_colony_treat_b_type_2_mean = []; 
        ants_in_colony_a = [];
        ants_in_colony_b = [];
        ants_in_colony_b_type_2 = []; 

       for k = 1:between_colony_rep

           ants_in_colony_a = normrnd(y, intra_var, 1, within_colony_rep); 
           ants_in_colony_treat_a_mean(k) = std(ants_in_colony_a); 
           colony_difference_treat_a(k) = normrnd(0, inter_var); 
           colony_treatment_a = [colony_treatment_a ants_in_colony_a + colony_difference_treat_a(k)];

           ants_in_colony_b = normrnd(y+delta, intra_var, 1, within_colony_rep); 
           ants_in_colony_treat_b_mean(k) = std(ants_in_colony_b); 
           colony_difference_treat_b(k) = normrnd(0, inter_var); 
           colony_treatment_b = [colony_treatment_b ants_in_colony_b + colony_difference_treat_b(k)];

           ants_in_colony_b_type_2 = ants_in_colony_b; 
           ants_in_colony_treat_b_type_2_mean(k) = std(ants_in_colony_b_type_2); 
           colony_difference_treat_b_type_2(k) = colony_difference_treat_a(k);   
           colony_treatment_b_type_2 = [colony_treatment_b_type_2 (ants_in_colony_b_type_2 + colony_difference_treat_b_type_2(k) + .0001)];

       end

       within_colony_std_treat_a = mean(ants_in_colony_treat_a_mean); 
       between_colony_std_treat_a = std(colony_difference_treat_a); 
       within_colony_std_treat_b = mean(ants_in_colony_treat_b_mean); 
       between_colony_std_treat_b = std(colony_difference_treat_b); 
       within_colony_std_treat_b_type_2 = mean(ants_in_colony_treat_b_type_2_mean); 
       between_colony_std_treat_b_type_2 = std(colony_difference_treat_b_type_2);  
       
       full_colony = [colony_treatment_a colony_treatment_b]; 
       var_value = var(full_colony); 

       false_pos_counter = 0;
       true_pos_counter = 0; 
       false_neg_counter = 0; 
       true_neg_counter = 0; 
       false_pos_counter_type2 = 0;
       true_pos_counter_type2 = 0; 
       false_neg_counter_type2 = 0; 
       true_neg_counter_type2 = 0; 

       for l = 1:sims_accuracy

           treatment = [];
           colony_1 = [];
           colony_2 = [];
           colony_2_type_2 = [];
           colonies_type_1 = [];
           colonies_type_2 = [];
           data_type_1 = [];
           data_type_2 = [];
           tbl = [];
           tbl2 = [];
           colony_treatment_a = []; 
           colony_treatment_b = []; 
           colony_treatment_b_type_2 = []; 

           for k = 1:between_colony_rep

               colony_variation = normrnd(0, inter_var); 
               colony_treatment_a = [colony_treatment_a normrnd(y, intra_var, 1, within_colony_rep) + colony_variation]; 
               colony_treatment_b = [colony_treatment_b normrnd(y+delta, intra_var, 1, within_colony_rep) + normrnd(0, inter_var)]; 
               colony_treatment_b_type_2 = [colony_treatment_b_type_2 (normrnd(y+delta, intra_var, 1, within_colony_rep) + colony_variation)]; 

           end

           treatment = repelem([{'a'}, {'b'}], [between_colony_rep*within_colony_rep]);
           colony_1 = string(1:between_colony_rep); 
           colony_2 = string(between_colony_rep+1:(2*between_colony_rep)); 
           colony_2_type_2 = colony_1; 
           colonies_type_1 = [repelem(colony_1, within_colony_rep) repelem(colony_2, within_colony_rep)];
           colonies_type_2 = [repelem(colony_1, within_colony_rep) repelem(colony_1, within_colony_rep)];
           data_type_1 = [colony_treatment_a colony_treatment_b+.01]; 
           data_type_2 = [colony_treatment_a colony_treatment_b_type_2+.01]; 

           tbl = table(data_type_1', treatment', colonies_type_1', 'VariableNames', {'Measurement', 'Treatment', 'Colony'});
           lme = fitlme(tbl,'Measurement~Treatment+(1|Colony)');

           tbl2 = table(data_type_2', treatment', colonies_type_2', 'VariableNames', {'Measurement', 'Treatment', 'Colony'});
           lme2 = fitlme(tbl2,'Measurement~Treatment+(1|Colony)');                   

           if delta > lower_delta_val
               if lme.Coefficients.pValue(2) <= alpha
                   true_pos_counter = true_pos_counter + 1;
               else
                   false_neg_counter = false_neg_counter + 1;
               end
           else
               if lme.Coefficients.pValue(2) <= alpha
                   false_pos_counter = false_pos_counter + 1;
               else
                   true_neg_counter = true_neg_counter + 1;
               end
           end

           if delta > lower_delta_val
               if lme2.Coefficients.pValue(2) <= alpha
                   true_pos_counter_type2 = true_pos_counter_type2 + 1;
               else
                   false_neg_counter_type2 = false_neg_counter_type2 + 1;
               end
           else
               if lme2.Coefficients.pValue(2) <= alpha
                   false_pos_counter_type2 = false_pos_counter_type2 + 1;
               else
                   true_neg_counter_type2 = true_neg_counter_type2 + 1;
               end
           end

       end

       false_neg_rate = false_neg_counter; 
       true_pos_rate = true_pos_counter; 
       false_pos_rate = false_pos_counter; 
       true_neg_rate = true_neg_counter; 

       false_neg_rate_type2 = false_neg_counter_type2; 
       true_pos_rate_type2 = true_pos_counter_type2; 
       false_pos_rate_type2 = false_pos_counter_type2; 
       true_neg_rate_type2 = true_neg_counter_type2; 

       accuracy = (true_pos_counter+true_neg_counter)/(false_neg_counter+true_pos_counter+false_pos_counter+true_neg_counter); 
       accuracy_type2 = (true_pos_counter_type2+true_neg_counter_type2)/(false_neg_counter_type2+true_pos_counter_type2+false_pos_counter_type2+true_neg_counter_type2); 

       tpr = (true_pos_counter/(true_pos_counter+false_neg_counter)); 
       tnr = (true_neg_counter/(true_neg_counter+false_pos_counter)); 

       if isnan(tpr)
           tpr = 1; 
       end

       if isnan(tnr)
           tnr = 1; 
       end

       tpr_type2 = (true_pos_counter_type2/(true_pos_counter_type2+false_neg_counter_type2)); 
       tnr_type2 = (true_neg_counter_type2/(true_neg_counter_type2+false_pos_counter_type2)); 

       if isnan(tpr_type2)
           tpr_type2 = 1; 
       end

       if isnan(tnr_type2)
           tnr_type2 = 1; 
       end

       balanced_accuracy = (tpr+tnr)/2; 
       balanced_accuracy_type2 = (tpr_type2+tnr_type2)/2; 

       colony_difference_treat_a = [];
       colony_difference_treat_b = []; 
       colony_difference_treat_b_type_2 = []; 
               
end

%end
            