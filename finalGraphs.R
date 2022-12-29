library(ggplot2)
library(TTR)

colony_replicates = colony_replicates[complete.cases(colony_replicates), ]
colony_replicates$total_replicates = colony_replicates$Within_Colony_Rep*colony_replicates$Between_Colony_Rep


###See average variation estimate

average_within_error = aggregate(x = colony_replicates[, 8], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_within_error)[1] = "Total_Replicates"
names(average_within_error)[2] = "Strategy"
names(average_within_error)[3] = "Within_Colony_Variation_Error"

ggplot(data = average_within_error, aes(x = Total_Replicates, y = Within_Colony_Variation_Error, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Within Colony Variation Error")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)


average_between_error = aggregate(x = colony_replicates[, 9], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_between_error)[1] = "Total_Replicates"
names(average_between_error)[2] = "Strategy"
names(average_between_error)[3] = "Between_Colony_Variation_Error"

ggplot(data = average_between_error, aes(x = Total_Replicates, y = Between_Colony_Variation_Error, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Between Colony Variation Error")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)


average_between_error$difference = average_between_error$Between_Colony_Variation_Error-average_within_error$Within_Colony_Variation_Error

ggplot(data = average_between_error, aes(x = Total_Replicates, y = difference, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Between Colony Variation Error - Within Colony Variation Error")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)

average_delta_error = aggregate(x = colony_replicates[, 6], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_delta_error)[1] = "Total_Replicates"
names(average_delta_error)[2] = "Strategy"
names(average_delta_error)[3] = "Delta_Error"

average_delta_error_below = subset(average_delta_error, Total_Replicates <= 15)
average_delta_error_below = aggregate(x = average_delta_error_below[, 3], by = list(average_delta_error_below$Strategy), mean)

average_delta_error_above = subset(average_delta_error, Total_Replicates > 15)
average_delta_error_above = aggregate(x = average_delta_error_above[, 3], by = list(average_delta_error_above$Strategy), mean)

average_delta_error_average = rbind(average_delta_error_below, average_delta_error_above)
names(average_delta_error_average)[1] = "Strategy"
names(average_delta_error_average)[2] = "Delta_Error"

average_delta_error_average$Total_Replicates = c(7.5, 7.5, 7.5, 75, 75, 75)

ggplot(data = average_delta_error, aes(x = Total_Replicates, y = Delta_Error, color = Strategy))+geom_point(size = 2) + theme_bw() + labs(x = "Total Replicates", y = "Delta Error")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)+ geom_hline(yintercept = 0, linetype="solid", color = "black", size=1.25) + geom_line(data = average_delta_error_average, aes(x = Total_Replicates, y = Delta_Error, color = Strategy), size = 1.25)

average_delta_error_bc = subset(average_delta_error, Strategy == "Breadth Collection")
average_delta_error_dc = subset(average_delta_error, Strategy == "Depth Collection")
average_delta_error_ec = subset(average_delta_error, Strategy == "Equal Collection")

average_delta_error_bc$delta_error_smoothed = SMA(average_delta_error_bc$Delta_Error, n = 1)
average_delta_error_dc$delta_error_smoothed = SMA(average_delta_error_dc$Delta_Error, n = 1)
average_delta_error_ec$delta_error_smoothed = SMA(average_delta_error_ec$Delta_Error, n = 1)

average_delta_error$delta_error_smoothed = c(average_delta_error_bc$delta_error_smoothed, average_delta_error_dc$delta_error_smoothed, average_delta_error_ec$delta_error_smoothed)

ggplot(data = average_delta_error, aes(x = Total_Replicates, y = delta_error_smoothed, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Delta Error")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)+ geom_hline(yintercept = 0, linetype="solid", color = "black", size=1.25) 

###False positive vs false neg 

average_false_pos = aggregate(x = colony_replicates[, 19]/50, by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_false_pos)[1] = "Total_Replicates"
names(average_false_pos)[2] = "Strategy"
names(average_false_pos)[3] = "False_Pos_Rate"

ggplot(data = average_false_pos, aes(x = Total_Replicates, y = False_Pos_Rate/50, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "False Pos Rate")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)


average_false_neg = aggregate(x = colony_replicates[, 17]/50, by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_false_neg)[1] = "Total_Replicates"
names(average_false_neg)[2] = "Strategy"
names(average_false_neg)[3] = "False_Neg_Rate"

ggplot(data = average_false_neg, aes(x = Total_Replicates, y = False_Neg_Rate/50, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "False Neg Rate")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)

colony_replicates$total_between_variation_deviation = 2*(sqrt(colony_replicates$Inter_Colony_Variance))-(colony_replicates$Between_Colony_Var_Treat_A+colony_replicates$Between_Colony_Var_Treat_B)
hist(colony_replicates$total_between_variation_deviation)

colony_replicates$total_within_variation_deviation = 2*(sqrt(colony_replicates$Intra_Colony_Variance))-(colony_replicates$Within_Colony_Var_Treat_A+colony_replicates$Within_Colony_Var_Treat_B)
hist(colony_replicates$total_within_variation_deviation)

average_between_var_dev = aggregate(x = colony_replicates[, 22], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_between_var_dev)[1] = "Total_Replicates"
names(average_between_var_dev)[2] = "Strategy"
names(average_between_var_dev)[3] = "Total_Between_Variation_Deviation"

average_within_var_dev = aggregate(x = colony_replicates[, 23], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(average_within_var_dev)[1] = "Total_Replicates"
names(average_within_var_dev)[2] = "Strategy"
names(average_within_var_dev)[3] = "Total_Within_Variation_Deviation"

ggplot(data = average_between_var_dev, aes(x = Total_Replicates, y = Total_Between_Variation_Deviation, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Total Between Variation Deviation")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)

ggplot(data = average_within_var_dev, aes(x = Total_Replicates, y = Total_Within_Variation_Deviation, color = Strategy))+geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Total Within Variation Deviation")+ geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)


#plot(colony_replicates$total_replicates , colony_replicates$total_between_variation_deviation)


t_count <- function(x) {
  length(x[x==1])
}


best_distribution = aggregate(x = colony_replicates[, 21], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), t_count)
names(best_distribution)[1] = "Total_Replicates"
names(best_distribution)[2] = "Strategy"
names(best_distribution)[3] = "Best_Distribution"

ggplot(data = best_distribution, aes(x = Total_Replicates, y = Best_Distribution)) + geom_point(size = 2) + theme_bw() + labs(x = "Total Replicates", y = "Best Distribution = T Count") + geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25) + stat_summary(fun.data= mean_cl_normal) + geom_smooth(method='lm')

ggplot(data = best_distribution, aes(x = Total_Replicates, y = Best_Distribution, color = Strategy)) + geom_line(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Best Distribution = T Count") + geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25)


best_distribution2 = aggregate(x = colony_replicates[, 22], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(best_distribution2)[1] = "Total_Replicates"
names(best_distribution2)[2] = "Strategy"
names(best_distribution2)[3] = "Norm_Minus_T_KS_Dist"

best_distribution2$Norm_Minus_T_KS_Dist_smoothed = SMA(best_distribution2$Norm_Minus_T_KS_Dist, n = 2)
best_distribution2$Norm_Minus_T_KS_Dist_smoothed = SMA(best_distribution2$Norm_Minus_T_KS_Dist, n = 2)
best_distribution2$Norm_Minus_T_KS_Dist_smoothed = SMA(best_distribution2$Norm_Minus_T_KS_Dist, n = 2)

average_delta_error$Norm_Minus_T_KS_Dist_smoothed = c(average_delta_error_bc$Norm_Minus_T_KS_Dist_smoothed, average_delta_error_dc$Norm_Minus_T_KS_Dist_smoothed, average_delta_error_ec$Norm_Minus_T_KS_Dist_smoothed)

ggplot(data = best_distribution2, aes(x = Total_Replicates, y = Norm_Minus_T_KS_Dist, color = Strategy)) + geom_point(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "Normal - T KS Dist") + geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25) 

colony_replicates$p_diff = colony_replicates$P_T-colony_replicates$P_Z

p_diff = aggregate(x = colony_replicates[, 26], by = list(colony_replicates$total_replicates, colony_replicates$Strategy), mean)
names(p_diff)[1] = "Total_Replicates"
names(p_diff)[2] = "Strategy"
names(p_diff)[3] = "P_Diff"

ggplot(data = p_diff, aes(x = Total_Replicates, y = P_Diff, color = Strategy)) + geom_point(size = 1.25) + theme_bw() + labs(x = "Total Replicates", y = "P-Value for T Dist - P-Value for Z Dist") + geom_vline(xintercept = 15, linetype="dashed", color = "black", size=1.25) 

#when is delta estimate negative? 

