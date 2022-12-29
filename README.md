# Sampling-Across-vs-Within-Random-Effects
What is the best sampling strategy when your experiment includes random effects like colony ID

## Background

Hello there! My name is Colin Lynch, and I am an animal behavior Ph.D. candidate at Arizona State University. I primarily leverage industrial engineering techniques to design optimal experiments for the study of emergence in complex adaptive systems, and I am looking to use these techniques to aquire a data science internship in R&D. I am specifically interested in reducing research costs by developing methods that minimize sample size while still having a rich enough dataset to perform hypothesis tests and predictive analytics. Here, I demonstrate how one can perform a two-dimensional power analysis (both across and within a random effect) for designing single-factor experiments, although this technique can be extended to other experimental designs. See this manuscript for a full discussion of this method. 

## Methods



## Results 

* Developed back-of-the-envelope equation for estimating the sample size necessary to reconstruct a categorical time series (sample size = 1 / proportion of the rarest state in the time series)

* Introduced novel method of sampling time series data, which can reduce sampling bias by 57% compared to current methods.

* Designed GUI which eases the process of data collection. The time needed to analyze data from a single colony was reduced from 7 hours to 4 hours. 

* Created data pipeline which converts 2 raw measurements to 60+ behavioral features. 

* Used a combination of traditional hypothesis testing and machine learning to show that ants in large colonies tend to be less specialized (and are therefore less efficient) and are more active within the nest. This increase in activity likely increases the metabolic rate of large colonies relative to small colonies. 

## Contact Information

| Contact Method | URL |
| --- | --- |
| Email | cmlynch2@asu.edu |
| LinkedIn | https://www.linkedin.com/in/colinmichaellynch/ |
| Fiverr | https://www.fiverr.com/colinlynch |

## Acknowledgements

This work could not have been done without the support of some fantastic scientists. I would like to thank Dr. Ioulia Bespalova for providing data I used for optimization and her comments on manuscripts, Dr. Xiaohui Guo for providing behavior videos and metabolic measurments, Dr. Jennifer Fewell and Dr. Ted Pavlic for guidance, Cole Busby for helping to develop the MATLAB application, and my undergraduate research assistants Gailan Khanania, Nathaniel Maslanka, Coleen Furey, Mariah Merriam, Tejaswini Nandakumar, and Emma Siebrandt for collecting data and managing ant colonies. Finally, I would like to thank Michaela Starkey for her advice, assistance with math and programming, and much-needed emotional support! 
