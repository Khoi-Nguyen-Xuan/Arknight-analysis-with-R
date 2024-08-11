
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

#Heatmap : Number of operators per class (grid by position)
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


#Mutiple bar charts by grid arrange (branch in class)

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
  

 

