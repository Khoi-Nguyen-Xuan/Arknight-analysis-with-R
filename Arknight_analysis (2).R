
#install.packages("paletteer")
library(tidyverse)
library(ggplot2)
library(paletteer)
library(nord)

#Load dataset
df = read.csv("D:/RStudio/RProjects/data.csv")
View(df)

#Convert into factor
df$class <- as.factor(df$class)
df$stars <- as.factor(df$stars)

### Heatmap : Number of operators per class (grid by position)
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
  facet_grid(vars(position))


### Mutiple bar charts by grid arrange (branch in class)

#install.packages("gridExtra")
library(gridExtra) 
library(grid)


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


g <- grid.arrange(defender,caster, guard, medic, sniper, specialist,
                  supporter, vanguard, nrow=4, 
                  top = textGrob("Branch by class", gp = gpar(fontsize = 20, font = 2)))
  


###Boxplot for comparison of base statistics(with mean, median, count)###

#Function for stat summary 
get_box_stats_hp <- function(y, upper_limit = max(df$base_hp) * 1.15) {
  return(data.frame(
    y = 0.95 * upper_limit,
    label = paste(
      "n =", length(y), "\n",
      "Avg =", round(mean(y), 2), "\n",
      "Med =", round(median(y), 2), "\n"
    )
  ))
}

get_box_stats_atk <- function(y, upper_limit = max(df$base_atk) * 1.15) {
  return(data.frame(
    y = 0.95 * upper_limit,
    label = paste(
      "n =", length(y), "\n",
      "Avg =", round(mean(y), 2), "\n",
      "Med =", round(median(y), 2), "\n"
    )
  ))
}


#Base health with summary
ggplot(df, aes(x = reorder(class,base_hp,mean), y = base_hp))+
  geom_boxplot(aes(fill = class), alpha = 0.7)+
  xlab("Class")+ylab("Base health")+ labs(title = "Base Health", fill = "Class")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold", size = 13),
        plot.margin = unit(c(rep(0.6,4)),"cm"),
        axis.title.x = element_text(vjust = -2),
        axis.title.y = element_text(vjust = 3))+
  scale_y_continuous(limits = c(min(df$base_hp)*1.1, max(df$base_hp)*1.1))+
  stat_summary(fun.data = get_box_stats_hp, geom = "text", hjust = 0.5, vjust = 0.9, size = 3)
  

#Base attack with summary 
ggplot(df, aes(x = reorder(class,base_atk,median), y = base_atk))+
  geom_boxplot(aes(fill = class), alpha = 0.7)+
  xlab("Class")+ylab("Base attack")+ labs(title = "Base Attack", fill = "Class")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold", size = 13),
        plot.margin = unit(c(rep(0.6,4)),"cm"),
        axis.title.x = element_text(vjust = -2),
        axis.title.y = element_text(vjust = 3))+
  scale_y_continuous(limits = c(min(df$base_atk)*1.1, max(df$base_atk)*1.1))+
  stat_summary(fun.data = get_box_stats_atk, geom = "text", hjust = 0.5, vjust = 0.9, size = 3)


### Analysis for deploy cost and time ### 
ggplot(df, aes(x=base_dp_cost))+
  geom_histogram(binwidth = 3, fill = "red", alpha = 0.5)+
  xlab("Deploy cost")+
  labs(title = "Base deploy cost distribution")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2), 
        plot.margin = unit(c(rep(0.5,4)),"cm"))

ggplot(df, aes(x=base_dp_cost))+ 
  geom_freqpoly(aes(color= base_redeploy))



### Using dplyr to sort for outlier ### 

outlier_baseATK_defender <- df %>%
  filter(class == "Defender", base_atk > 400) %>% 
  select(name, class, base_atk)

outlier_baseHP_caster <- df %>% 
  filter(class == "Caster", base_hp >1000) %>% 
  select(name, class, base_hp)

View(outlier_baseATK_defender)

## Using dplyr to find max base_hp, max base_atk
max_baseHP <- df %>% 
  summarise(max_hp = max(base_hp, na.rm = TRUE)) %>%
  pull(max_hp)

max_base_hp <- df %>% 
  filter(base_hp == max_baseHP) %>% 
  select(name, class, base_hp)

### 

max_baseATK <- df %>% 
  summarize(max_atk = max(base_atk, na.rm = TRUE)) %>% 
  pull(max_atk )

max_base_atk <- df %>% 
  filter(base_atk == max_baseATK) %>% 
  select(name,class, base_atk)

max_base_atk


### Using summarize (count, mean,...) with group_by ### 

summary_by_class <- df %>% 
  group_by(class, branch) %>% 
  summarize(
    count = n(),
    .groups = 'drop', 
    mean_baseHP = mean(base_hp, na.rm = TRUE)
    ) %>% 
  filter(class == "Defender")

summary_by_class



### Relationship between base statistics and elite one ###

#Calculate pearson correlation 
correlation <- cor(df$base_hp, df$elite_1_hp, method = "pearson")

#Scatterplot with smooth linear model 
g <- ggplot(df, aes(x= base_hp, y = elite_1_hp))+
  geom_point(aes(color = class), size = 2)+ 
  geom_smooth(method = "lm", se = FALSE, colour = "black", size = 0.7)+
  labs(title = "Health: Base vs elite 1", colour = "Class")+
  xlab("Base health")+ ylab("Elite 1 health")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold", size = 13),
        plot.margin = unit(c(rep(0.6,4)), "cm"), 
        axis.title.x = element_text(vjust=-2),
        axis.title.y = element_text(vjust=2.5))+
  annotate(
    "text", 
    x = Inf, y = Inf, 
    label = paste("Correlation (Pearson):", round(correlation, 2)),
    hjust = 2.3, vjust = 3.3, 
    size = 5, color = "blue"
  )+ 
  scale_x_continuous(
  breaks = seq(0, 3000, by = 300), 
  labels = seq(0, 3000, by = 300)
  ) +
  scale_y_continuous(
    breaks = seq(0, 3000, by = 300),  
    labels = seq(0, 3000, by = 300)  
  ) 

g

#Using dplyr to detect outlier 
outlier <- df %>% 
  filter(
    between(base_hp, 1300, 1500) &
      between(elite_1_hp, 1300, 1500)
  )

outlier

#Highlighting outlier by arrow and text 
g + geom_segment(
    aes(x = 1650, y = 1461, xend = 1500, yend = 1461),  # Arrow from (3,13) to (4,17)
    arrow = arrow(type = "closed", length = unit(0.2, "cm")),
    color = "blue",
    size = 1
  ) +
  annotate(
    "text",
    x = 1680, y = 1461,  # Position of the text
    label = "     12F \n(1461,1461)",
    color = "blue",
    size = 4,
    hjust = 0  
  )



#Adding arrow and rect through annotate()

df$elite_2_hp <- as.integer(df$elite_2_hp)

elite_2 <- df %>% 
  ggplot(aes(x = elite_1_hp, y = elite_2_hp))+ 
  geom_point(aes(color = class))+ 
  labs(x = "Elite 2 health", y = "Elite 1 health", title = "Health : Elite 1 vs Elite 2", col = "Class")+ 
  theme(plot.title = element_text(hjust = 0.5, vjust = 2, face = "bold"),
        plot.margin = unit(c(rep(0.5,4)),"cm"), 
        axis.title.y = element_text(vjust = 3.5),
        axis.title.x = element_text(vjust = -1))+
  scale_x_continuous(breaks = seq(0,3000, by = 500), 
                     labels = seq(0,3000, by = 500))

#Using annotate for text, rect and arrow 
g <- elite_2 + 
  annotate(geom = "text", x = 850, y = 2500, label = "Important data", size = 4, col = "red")+
  annotate("rect", xmin = 1100, xmax = 1900, ymin = 1700, ymax = 2200, alpha = 0.4, col = "black")+
  annotate("curve", x = 1000, y = 2500, xend = 1500, yend = 2230, linewidth = 1, curvature = -0.3, arrow = arrow(length = unit(0.5,'cm')))

#Pearson correlation
df <- df %>% 
  filter(!is.na(elite_2_hp))
correlation = cor(df$elite_1_hp, df$elite_2_hp)


g + 
  annotate("text", x = 950, y = 3350, label = paste("Correlation (Pearson): ", round(correlation,3)), size = 4)

