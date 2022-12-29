# Sampling-Across-vs-Within-Random-Effects
What is the best sampling strategy when your experiment includes random effects like colony ID

## Table of Contents 

* Current Draft of Manuscript

* Literature Review Data

* Simulation Data 

* Script to Running Simulations

* Script for Analyzing Literature Review Data 

* Script for Analyzing Simulation Data 

## Background

Hello there! My name is Colin Lynch, and I am an animal behavior Ph.D. candidate at Arizona State University. I primarily leverage industrial engineering techniques to design optimal experiments for the study of emergence in complex adaptive systems, and I am looking to use these techniques to aquire a data science internship in R&D. I am specifically interested in reducing research costs by developing methods that minimize sample size while still having a rich enough dataset to perform hypothesis tests and predictive analytics. Here, I demonstrate how one can perform a two-dimensional power analysis (both across and within a random effect) for designing single-factor, two-leveled experiments, although this technique can be extended to other experimental designs as we generalize the ideas of both power as well as sample size. Tests are performed on a social insect case study, where colony ID is the random effect. See this manuscript for a full discussion of this methodology. 

## Methods

* The sample size of an an experiment with a single factor with two levels and it has a random effect (witherto refered to as 'Colony') is the number of individual ants sampled within a colony times the number of colonies. Sample size can be refered to as the contour line in a two dimensional plot: 

fig 1

* Breadth collection is a strategy where more colonies are sampled than ants within colonies. Depth collection is the opposite. 

* In crossed designs the same colonies are present in both factor levels. In nested designs different colonies are present in each level. 

* I determined that colonies are roughly 3 times harder to sample from than individuals within colonies from a literature review. We can use this to derive a new statistic called effort, which reflects the amount of resources spent collecting those samples. 

* We can calculate false negative and false positive rates (power is 1 - FNR, balanced accuracy is the average of the true positive and negative rates) by simulating experiments where there is a difference between the two factor levels and when there is no difference. 

* We find optimal designs by finding those which minimize effort while maximizing power or balanced accuracy. 

## Results 

* Depth collection strategies maximize power and minimize effort for crossed designs. 

fig 4

* Depth collection strategies does the same for nested designs, but this is misleading as false positive rates are also higher. 

Fig 2 

* Researchers should maximize balanced accuracy instead of power in nested designs, as this takes the false positive rate into account. 

* Maximizing balanced accuracy and minimizing effort yields breadth collection strategies for nested designs. 

* Due to the difficulty of sampling colonies, many social insect papers use depth collection strategies even when they employ nested designs, artificially increasing the false positive rate and making it higher than their chosen alpha. 

* Employing this methodology can help researchers avoid these problematic designs, which could be contributing to the replication crisis across the sciences. 

* In test cases, I found that this methodology can decrease effort by up to 20% while simutaneuosly increasing power/balanced accuracy by 5 - 10%. 

## Contact Information

| Contact Method | URL |
| --- | --- |
| Email | cmlynch2@asu.edu |
| LinkedIn | https://www.linkedin.com/in/colinmichaellynch/ |
| Fiverr | https://www.fiverr.com/colinlynch |

## Acknowledgements

This work could not have been done without the support of some fantastic scientists. I would like to thank Dr. Nobuaki Mizumoto for developing this project and providing program and writing support. I would also like to thank Dr. Ted Pavlic and Dr. Doug Montgomery for guidance and commentary on the manuscript. Finally, I would like to thank Michaela Starkey for solving various math problems and for writing support. 
