<div align="center">
<img src="https://thathashtagshow.com/wp-content/uploads/2023/09/maxresdefault-1-1280x640.jpg" alt="Arknight cover image"/>
<h1>Arknights operators analysis </h1>
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
<br> 

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

<h3>1. Base check</h3>

```r
base_stats <- df %>% 
  select(base_hp, base_atk, base_def, base_res, base_redeploy, base_dp_cost, base_block, base_block, base_interval)

base_check <- sapply(base_stats, class)

```

![image](https://github.com/user-attachments/assets/bba497f6-256c-4981-a110-b2b4d85a1ca9)

<br>

<p> As you can see, it is strikingly visible that the <b>base_redeploy</b> and <b>base_interval</b> are mistakenly saved as <b>characters</b> values. I will convert it into <b>integers</b> later on. 
  
  Before that, let's have a look at Elite_1, Elite_2, and max statistics to make sure that all these stats are correctly saved as integers. 
</p>

<h3>2. Elite 1 check</h3>

```r
#Check class : elite 1
elite_1_stats <- df %>% 
  select(elite_1_hp, elite_1_atk, elite_1_def, elite_1_res, elite_1_redeploy, elite_1_dp_cost, 
         elite_1_block, elite_1_block, elite_1_interval)

elite_1_check <- sapply(elite_1_stats, class)

```
![image](https://github.com/user-attachments/assets/60d03bf6-55a2-40c8-8ee8-918c1d409d1f)




<h3>3. Elite 2 check</h3>

```r
#Check class : elite 2
elite_2_stats <- df %>% 
  select(elite_2_hp, elite_2_atk, elite_2_def, elite_2_res, elite_2_redeploy, elite_2_dp_cost, 
         elite_2_block, elite_2_block, elite_2_interval)

elite_2_check <- sapply(elite_2_stats, class)

```
![image](https://github.com/user-attachments/assets/ce00ee06-7bbd-4d78-b22a-0d32a233f81d)


<h3>4. Max check</h3>

```r
#Check class : max
max_stats <- df %>% 
  select(max_hp, max_atk, max_def, max_res, max_redeploy, max_dp_cost, 
         max_block, max_block, max_interval)

max_check <- sapply(max_stats, class)
```
![image](https://github.com/user-attachments/assets/ae3ac609-7c7f-4454-8c00-e1fbf6d315be)

<h3>5. Converting data types</h3>
It is clear that while all elite 1 stats are perfectly saved as integers (whooray!), the entire elite 2 stats and max stats are mistakenly saved as characters! Therefore, I will use <b>Dplyr</b> to mutate the data type of these variables. 
<br>

```r
#Variables to convert
conversion_map <- list(
  base_redeploy = "base_redeploy",
  base_interval = "base_interval",
  elite_1_redeploy = "elite_1_redeploy",
  elite_1_interval = "elite_1_interval",
  elite_2_hp = "elite_2_hp",
  elite_2_atk = "elite_2_atk",
  elite_2_def = "elite_2_def",
  elite_2_res = "elite_2_res",
  elite_2_redeploy = "elite_2_redeploy",
  elite_2_interval = "elite_2_interval",
  elite_2_block = "elite_2_block",
  elite_2_dp_cost = "elite_2_dp_cost",
  max_hp = "max_hp",
  max_atk = "max_atk",
  max_def = "max_def",
  max_res = "max_res",
  max_redeploy = "max_redeploy",
  max_interval = "max_interval",
  max_block = "max_block",
  max_dp_cost = "max_dp_cost"
)

#Apply the conversion through mutate() and as.interger() 
df <- df %>%
  mutate(across(
    all_of(names(conversion_map)), 
    ~ as.integer(.)
  ))
```

You can see that the data type of these variables are finally fixed!

![image](https://github.com/user-attachments/assets/2bb0f128-04ff-40fb-8d5c-2b0a8bb2c32c)

<h3> 6. Categorical variable check </h3>
Just like the qualitative variable, I will check some important categorical variables to figure out whether they are saved in the correct data type. 

```r
categorical <- df %>% 
  select(c(name:position, availability, gender:endurance,experience:arts_adaptability ))

categorical_check <- sapply(categorical, class)

View(categorical_check)
```
Fortunately, they are! 
<br></br>
![image](https://github.com/user-attachments/assets/0ba76012-99a5-4633-8453-9ef4f14c9e87)
<br> 

<br></br>
## Heatmap analysis

<h4> 1. Number of operators per class and stars </h4>
In order to see the distribution of operators per class together with stars, I used <b> the heatmap (bin2d) </b> since the task is counting for two categorical variables. 

```r
ggplot(df, aes(x = class, y = stars)) +
  geom_bin2d() +
  labs(title = "Number of operators per class",
       subtitle = "2022 version",
       fill = "Count") +
  xlab("Class") + ylab("Stars") +
  scale_fill_paletteer_c("ggthemes::Blue-Teal")+
  theme(plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 11, face = "italic"),
        axis.title.x = element_text(size = 13, vjust = -1),
        axis.title.y = element_text(size = 13, vjust = 3),
        plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
        panel.spacing = unit(2, "lines"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
```

<div align="center">
<img src="https://github.com/user-attachments/assets/0db6f79f-f9aa-4278-b9a3-9ed47b73fd39" alt="Arknight cover image" width="800" height = "600"/>
</div>


<br></br>
I did also add <b> "position" </b>, which is another categorical variable, through facet_grid() for more comprehensive analysis 

<div align="center">
<img src="https://github.com/user-attachments/assets/c096980c-a895-4df6-b33e-16250d6cfb7e" width="800" height = "600" />
</div>

<br></br> 
## Boxplot comparison 
Boxplots are implemented to compare the qualitative variables (base, elite_1, elite_2, max) among all eight class of operators. 

<h4>1. Base health comparison </h4>
I reorder the order of 8 classes regarding to their mean base_hp, thus the pattern is easier to recognized. 

```r
ggplot(df, aes(x = reorder(class,base_hp,mean), y = base_hp))+
  geom_boxplot(aes(fill = class), alpha = 0.7)+
  xlab("Class")+ylab("Base health")+ labs(title = "Base Health", fill = "Class")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold", size = 13),
        plot.margin = unit(c(rep(0.6,4)),"cm"),
        axis.title.x = element_text(vjust = -2),
        axis.title.y = element_text(vjust = 3))+
  scale_y_continuous(limits = c(min(df$base_hp)*1.1, max(df$base_hp)*1.1))
```

<div align="center">
<img src="https://github.com/user-attachments/assets/7660b7d9-e95b-4230-bec7-56bc078bebc9" width = "900"/>
</div>

It is reasonable that <b>defender</b> and <b>guard</b> are the two classes with highest base_hp. However, there are some striking outliers in the <b>Caster</b> class, which I will point out later on. 

<h4>2. Base attack comparison </h4>
Now, let's take a look at then comparison of base_atk between 8 classes. 

```r
ggplot(df, aes(x = reorder(class,base_atk,median), y = base_atk))+
  geom_boxplot(aes(fill = class), alpha = 0.7)+
  xlab("Class")+ylab("Base attack")+ labs(title = "Base Attack", fill = "Class")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold", size = 13),
        plot.margin = unit(c(rep(0.6,4)),"cm"),
        axis.title.x = element_text(vjust = -2),
        axis.title.y = element_text(vjust = 3))+
  scale_y_continuous(limits = c(min(df$base_atk)*1.1, max(df$base_atk)*1.1))+
  stat_summary(fun.data = get_box_stats_atk, geom = "text", hjust = 0.5, vjust = 0.9, size = 3)
```

<div align="center">
<img src="https://github.com/user-attachments/assets/7b7219eb-3d8c-4bc3-bac0-2998253521ad" width = "900"/>
</div>

<b>Sniper</b>, <b>Specialist</b> and <b> Caster </b> are the three classes with highest base attack, whereas Medic accounts for the lowest figures (quite reasonable!).

Yet, there are several outliers in <b>Defender</b> and <b>Guard</b> class, indicating that Arknights has some tanks that deal tons of damage! 


Let's find out who they are 

```r
outlier_baseATK<- df %>%
  filter(class == "Defender" | class == "Guard", base_atk > 400) %>% 
  select(name, class, base_atk)
```

![image](https://github.com/user-attachments/assets/33963448-e457-43af-81ef-421e4ccd7688)

<br></br>
## Multiple bar charts for branches
<h4> Branch terminology </h4>
Each class in Arknights is divided into several <b> branches </b> (can be seen as subclass), with each branch providing distinct features that cater to different tactical needs. These branches allow operators to evolve into specialized units, enhancing their effectiveness in various scenarios and adding significant strategic depth to the game's gameplay. 
For instance, 
<br></br> 

<h4> Multiple bar charts</h4>

First, I used **dplyr** and** ggplot** to draw seperate individual bar charts for each class. Then, I have implemented the <b>grid.arrange() </b> from <b>gridExtra</b> library to display multiple bar charts in one frame. This give a comprehensive clearer obseravation how each class distribute their branches. 

For instance, the <b>Caster class</b> features two main branches: <b>Core</b> and <b>Splash</b>. The <b>Core</b> branch focuses on high single-target magical damage, excelling in dealing significant damage to individual enemies. In contrast, the <b>Splash</b> branch specializes in area-of-effect (AoE) magic attacks, allowing operators to inflict damage on multiple enemies within a specified area. 

This makes the <b>Core</b> branch ideal for taking down **high-priority** targets, while the **Splash** branch is more suited for managing **large groups of foes**.

```r
defender <- df %>%
  filter(class == "Defender") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#FBB4AE")+
  xlab("Defender")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

caster <- df %>%
  filter(class == "Caster") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#B3CDE3")+
  xlab("Caster")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


guard <- df %>%
  filter(class == "Guard") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#CCEBC5")+
  xlab("Guard")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


medic <- df %>%
  filter(class == "Medic") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#DECBE4")+
  xlab("Medic")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

sniper <- df %>%
  filter(class == "Sniper") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#FED9A6")+
  xlab("Sniper")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

specialist <- df %>%
  filter(class == "Specialist") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#E5D8BD")+
  xlab("Specialist")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

supporter <- df %>%
  filter(class == "Supporter") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#FDDAEC")+
  xlab("Supporter")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

vanguard <- df %>%
  filter(class == "Vanguard") %>%
  ggplot(aes(x = branch))+
  geom_bar(fill = "#9ECAE1")+
  xlab("Vanguard")+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#Combine all 8 bar charts by gridExtra
g <- grid.arrange(defender,caster, guard, medic, sniper, specialist,
                  supporter, vanguard, nrow=4, 
                  top = textGrob("Branch by class", gp = gpar(fontsize = 20, font = 2)))
```

<br> </br>
According to the graph, while <b>Guard</b> and <b>Specialist</b> possess a great number of branches, <b>Medic</b> and <b>Vanguard </b> both only have 4 branches. The number of branches ranges from 4 to 10 among 8 classes. In total, there are 52 branches among 8 classes, which indicates a great variability of possible combination! 

![Rplot](https://github.com/user-attachments/assets/cf759f5b-6793-4a59-9ee9-bff348b468c8)







