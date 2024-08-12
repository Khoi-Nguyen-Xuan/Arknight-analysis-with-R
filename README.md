<div align="center">
<img src="https://thathashtagshow.com/wp-content/uploads/2023/09/maxresdefault-1-1280x640.jpg" alt="Arknight cover image"/>
<h1>Arknights analysis </h1>
<p>
  An R program with tidyverse to analyze a dataset of all operators in <strong><a href="https://desired-link.com">Arknights Mobile Game</a></strong>
</p>

<p>
  <h4>
    Archived
  </h4>
</p>
</div>



## Contents

- [About](#about)
- [Motivation](#motivation)
- [Dataset](#dataset)
- [Data preprocessing](#Cleaning) 
- [Heatmap for correlation analysis](#heatmap)
- [Boxplot for comparison](#Boxplot)
- [Multiple bar charts for summary](#BarCharts)
- [Scatterplot for linear relationship analysis](#Scatterplot)
- [References](#references)


## About
This is a **statistical analysis** of an Arknight characters dataset from <strong><a href="https://www.kaggle.com/datasets/victorsoeiro/arknights-operators"> Kaggle </a></strong>. The analysis, conducted through R programming language, includes cleaning the dataset by implementing **dplyr** and graphing features in **ggplot2**.

Arknights has been one of the most popular mobile tower defense games for the past 5 years. This Japanese game combines strategic gameplay with a compelling narrative and a rich roster of unique operators.



## Motivation 
Arknights features a large and diverse roster of operators, each with unique statistics, roles, rarity levels, and even story behind. This variety makes the game complex and dynamic, presenting numerous patterns and distributions among characters.


<div align="center">
<img src="https://static1.srcdn.com/wordpress/wp-content/uploads/2020/08/Operators-and-star-rank-in-Arknights.jpg" alt="Arknight operators"/>
<i><br>Arknights operators</br></i>
</div> 

Therefore, I believe a thorough statistical analysis can reveal these patterns and provide insights into how different operators compare and contribute to gameplay, enhancing our understanding of the game's mechanics and balance.



## Dataset

The dataset (<strong><a href="https://www.kaggle.com/datasets/victorsoeiro/arknights-operators"> Kaggle </a></strong>) used in this analysis is collected from <strong><a href="https://arknights.fandom.com/wiki/Arknights_Wiki"> Arknights Fandom Wiki </a></strong> by Victor Soeiro. In this dataset, Victor listed all operators playable with their features to analyze the data to find interesting facts. 

This dataset contains **235 distinct Operators** with over **60 column of stats** of each Operator. Most of the quantitative variables are the stats (HP, ATK, DEF, RES, REDEPLOY, DP_COST, BLOCK, INTERVAL) on each classification level (BASE, ELITE 1, ELITE 2, MAX). It is important to note that **not all operators** have all three levels of classifications, some only have 2. 


Besides, there are numerous categorical variables: 
- **Name**
- **Class**: Caster, Defender, Guard, Medic, Sniper, Specialist, Supporter, Vanguard 
- **Branch**: Each class has different branches)
- **Availability**: Recruitment, Starting Operator, Headhunting, TR-4, Shop Vouchers Store, Credit Store, Guiding Ahead (Missions of Notaries), ...
- **Race**
- **Birthday, place of birth**
- **Faction**
- **Stars**: Rarity level (1,2,3,4,5,6)
- **Position**: Melee or Ranged 
- **Gender**: Male or Female 
- **Height**: Measured in cm 
- **Experience**: Measured in years
- **Endurance, Combat skill, tactical acumen**: Flawed, Standard, Normal, Excellence
- **Mobility**: Flawed, Standard, Normal, Excellence 
- **Infection status**

## Data preprocessing 

First of all, I want to make sure that **all** statistics (HP,ATK,DEF, REDEPLOY, DP_COST, BLOCK, INTERVAL) are **INTEGERS** (quantitative variables), as well as **all** categorical variables (class, branch, availability, race, stars, position, gender, ...) are **CHARACTERS**. 

```r
base_stats <- df %>% 
  select(base_hp, base_atk, base_def, base_res, base_redeploy, base_dp_cost, base_block, base_block, base_interval)

base_check <- sapply(base_stats, class)
View(base_check)
```





