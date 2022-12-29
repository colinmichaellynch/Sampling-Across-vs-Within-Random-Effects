#Clear workspace
rm(list = ls())

#Set the working directory
setwd("C:/Users/user/Documents/colonty duplicate sampling/Literature Review")

# Load packages:
library(ggplot2)
library(ggpubr)
library(ggsignif)
library(rstatix)

#Load data
SocInsectSampSize = read.csv("SocInsectSampSize.csv")
SocInsectSampSize = na.omit(SocInsectSampSize)

for(i in 1:nrow(SocInsectSampSize)){
  if(SocInsectSampSize$Type.of.Experiment[i] == "Full factorial"){
    SocInsectSampSize$Type.of.Experiment[i] = "Crossed"}
  if(SocInsectSampSize$Type.of.search[i] == "BS "){
    SocInsectSampSize$Type.of.search[i] = "BS"}
  }

shapiro.test(SocInsectSampSize$Within.Colony.Samples)
shapiro.test(SocInsectSampSize$Across.Colony.Samples)

p1 = ggplot(SocInsectSampSize, aes(x = Within.Colony.Samples, fill = Type.of.Experiment)) + geom_histogram(alpha = .5) + theme_classic() + xlab("Sample Size") + ylab("Count") + ggtitle("A") + theme(legend.position = "none",panel.border = element_rect(colour = "black", fill=NA)) 
p2 = ggplot(SocInsectSampSize, aes(x = Across.Colony.Samples, fill = Type.of.Experiment)) + geom_histogram(alpha = .5) + theme_classic()+ xlab("Sample Size") + ylab("Count") + ggtitle("B") + labs(fill = "Type of Experiment") + theme(legend.position = c(0.7, 0.8), panel.border = element_rect(colour = "black", fill=NA))

ggarrange(p1, p2, nrow = 1, ncol = 2)

ggplot(SocInsectSampSize, aes(x = Type.of.Experiment, y = Within.Colony.Samples)) + geom_boxplot() + theme_bw() + geom_signif(comparisons = list(c("versicolor", "virginica")), map_signif_level=TRUE)
ggplot(SocInsectSampSize, aes(x = Type.of.Experiment, y = Across.Colony.Samples)) + geom_boxplot() + theme_bw()

successes = length(SocInsectSampSize$Type.of.search[SocInsectSampSize$Type.of.search=="DS"])
total = nrow(SocInsectSampSize)

binom.test(successes, total, p = 0.5)

within_samples = quantile(SocInsectSampSize$Within.Colony.Samples, probs = c(.25, .5, .75))
across_samples = quantile(SocInsectSampSize$Across.Colony.Samples, probs = c(.25, .5, .75))

data_nested = subset(SocInsectSampSize, Type.of.Experiment == "Nested")
data_factorial = subset(SocInsectSampSize, Type.of.Experiment == "Crossed")

within_samples_nested = quantile(data_nested$Within.Colony.Samples, probs = c(.25, .5, .75))
across_samples_nested = quantile(data_nested$Across.Colony.Samples, probs = c(.25, .5, .75))

within_samples_factorial = quantile(data_factorial$Within.Colony.Samples, probs = c(.25, .5, .75))
across_samples_factorial = quantile(data_factorial$Across.Colony.Samples, probs = c(.25, .5, .75))

wilcox.test(data_nested$Within.Colony.Samples, data_factorial$Within.Colony.Samples, alternative = "two.sided")
wilcox.test(data_nested$Across.Colony.Samples, data_factorial$Across.Colony.Samples, alternative = "two.sided")
wilcox.test(SocInsectSampSize$Within.Colony.Samples, SocInsectSampSize$Across.Colony.Samples, alternative = "two.sided")

dsData = subset(SocInsectSampSize, Type.of.search == "DC")
bsData = subset(SocInsectSampSize, Type.of.search == "BC")

ds_samples = quantile(dsData$Within.Colony.Samples, probs = c(.25, .5, .75))
ds_samples2 = quantile(dsData$Across.Colony.Samples, probs = c(.25, .5, .75))
bs_samples = quantile(bsData$Within.Colony.Samples, probs = c(.25, .5, .75))
bs_samples2 = quantile(bsData$Across.Colony.Samples, probs = c(.25, .5, .75))

wilcox.test(dsData$Within.Colony.Samples, bsData$Within.Colony.Samples, alternative = "two.sided")
wilcox.test(dsData$Across.Colony.Samples, bsData$Across.Colony.Samples, alternative = "two.sided")
wilcox.test(SocInsectSampSize$Within.Colony.Samples, SocInsectSampSize$Across.Colony.Samples, alternative = "two.sided")

wilcox.test(data_nested$Total.number.of.measurements, data_factorial$Total.number.of.measurements, alternative = "two.sided")
wilcox.test(SocInsectSampSize$Within.Colony.Samples, SocInsectSampSize$Across.Colony.Samples, alternative = "two.sided")

###Combine dataset

dataSamp = data.frame(SampleSize = c(SocInsectSampSize$Within.Colony.Samples, SocInsectSampSize$Across.Colony.Samples), SampleType = c(rep("Within Colony Samples", nrow(SocInsectSampSize)), rep("Between Colony Samples", nrow(SocInsectSampSize))), ExperimentType = c(SocInsectSampSize$Type.of.Experiment, SocInsectSampSize$Type.of.Experiment), SearchType = c(SocInsectSampSize$Type.of.search, SocInsectSampSize$Type.of.search)) 

P1 = ggplot(dataSamp, aes(x = SearchType, y = SampleSize, fill = SampleType)) + theme_classic() + geom_boxplot()

graphData = data.frame(x=c(0.875, 1.875), xend=c(1.125, 2.125), y=c(100, 520), annotation=c(".", "*"), ExperimentType = c("Crossed",  "Nested"), SearchType = c("DS", "BS"))

ggplot(dataSamp, aes(x = SampleType, y = SampleSize, fill = ExperimentType, group = SearchType)) + geom_boxplot() + theme_classic() + labs() + labs(y = "Sample Size", fill = "Experimental Design", x = "Type of Sample") + geom_signif(stat="identity", data=graphData, aes(x=x,xend=xend, y=y, yend=y, annotation=annotation)) + geom_signif(comparisons = list(c("Between Colony Samples", "Within Colony Samples")), map_signif_level=TRUE, y_position = 585) + ylim(0, 600) + annotation_custom(ggplotGrob(p2), xmin = 1, xmax = 3, ymin = -0.3, ymax = 0.6)

### Choose best model

test1 = lm(SampleSize~ExperimentType*SampleType*SearchType, data = dataSamp)
summary(test1)

dataSamp %>%
  group_by(ExperimentType, SampleType, SearchType) %>%
  get_summary_stats(SampleSize, type = "median_iqr")
#get_summary_stats(SampleSize, type = "mean_sd")

ggboxplot(
  dataSamp, x = "ExperimentType", y = "SampleSize", 
  fill = "SearchType", palette = "Dark2", facet.by = "SampleType", ylab = "Sample Size", xlab = "Experimental Design"
) + labs(fill = "Collection Type") 

outliers = dataSamp %>%
  group_by(ExperimentType, SampleType, SearchType) %>%
  identify_outliers(SampleSize)

dataSamp %>%
  group_by(ExperimentType, SampleType, SearchType)%>%
  shapiro_test(SampleSize)

dataSamp %>% levene_test(SampleSize ~ ExperimentType*SampleType*SearchType)
dataSamp %>% anova_test(SampleSize ~ ExperimentType*SampleType*SearchType)

dataSampNoOut = dataSamp

for(i in 1:nrow(dataSamp)){
  tempData = dataSamp[i,]
  for(j in 1:nrow(outliers)){
    tempOutlier = outliers[j,]
    if(tempData$SampleSize == tempOutlier$SampleSize & tempData$ExperimentType == tempOutlier$ExperimentType & tempData$SampleType == tempOutlier$SampleType & tempData$SearchType == tempOutlier$SearchType){
      dataSampNoOut$SampleSize[i] = NA
    }
  }
}

dataSampNoOut = na.omit(dataSampNoOut)

test2 = lm(SampleSize~ExperimentType*SampleType*SearchType, data = dataSampNoOut)
summary(test2)

dataSamp %>% levene_test(SampleSize ~ ExperimentType*SampleType*SearchType)
dataSamp %>% anova_test(SampleSize ~ ExperimentType*SampleType*SearchType)

ggqqplot(residuals(test2))
shapiro_test(residuals(test2))

#As a short cut, you could always rank the observations after an ascending sort, and input the ranks into 3-way ANOVA. Sure, there are assumptions about doing this, but we have done it for publications before.
#You can bootstrap 

dataSamp$SampSizeRank = rank(dataSamp$SampleSize)

test1 = lm(SampSizeRank~ExperimentType*SampleType*SearchType, data = dataSamp)
summary(test1)

dataSamp %>%
  group_by(ExperimentType, SampleType, SearchType) %>%
  #get_summary_stats(SampSizeRank, type = "median_iqr")
  get_summary_stats(SampSizeRank, type = "mean_sd")

ggboxplot(
  dataSamp, x = "ExperimentType", y = "SampSizeRank", 
  fill = "SearchType", palette = "Dark2", facet.by = "SampleType", ylab = "Sample Size", xlab = "Experimental Design"
) + labs(fill = "Collection Type")

dataSamp %>%
  group_by(ExperimentType, SampleType, SearchType)%>%
  shapiro_test(SampSizeRank)

dataSamp %>% levene_test(SampSizeRank ~ ExperimentType*SampleType*SearchType)
dataSamp %>% anova_test(SampSizeRank ~ ExperimentType*SampleType*SearchType)

ggqqplot(residuals(test1))
shapiro_test(residuals(test1))

###find prop less than 20

vec = c(SocInsectSampSize$Within.Colony.Samples, SocInsectSampSize$Across.Colony.Samples)
length(vec[vec<21])/length(vec)
