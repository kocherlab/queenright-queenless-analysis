# Creating Big DataSheet ----------------------------------------
library(lme4)
library(tidyverse)
library(dplyr)
library(stringr)
library("wesanderson")
library(ggnewscale)
library("corrr")
library("ggcorrplot")
library("FactoMineR")
library("factoextra")

setwd("~/Downloads/QueenModel_052624")
prefixes <- c("RooibosTea_QR_1216_1646", "RooibosTea_QL_1216_1646", "MexHotChoc_QR_1216_1646", "MexHotChoc_QL_1216_1646", "20230213_1745_AlmdudlerGspritzt_C1", "20230213_1745_AlmdudlerGspritzt_C0", "20221209_1613_QR", "20221209_1613_QL", "20221123_1543_AmericanoLatte_QR", "20221123_1543_AmericanoLatte_QL")
Day <- 1
Days <- list()
Start <- 0
# Total Degree
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "Head_to_Head_False_Centralities.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "Head_to_Head_False_Centralities.csv", sep = "_"))
      Deg$Node <- sub("\\.0", "", Deg$X)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$Node, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$Node, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalDeg <- rbind(TotalDeg, Deg)
      }
      if (Start == 0) {
        TotalDeg <- Deg
        Start <- 1
      }
    }
  }
}
names(TotalDeg)[names(TotalDeg) == "degree"] <- "Degree"
names(TotalDeg)[names(TotalDeg) == "between"] <- "Between"
names(TotalDeg)[names(TotalDeg) == "close"] <- "Close"
names(TotalDeg)[names(TotalDeg) == "eigen"] <- "Eigen"

# Bout Degree

Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "Head_to_Head_True_Centralities.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "Head_to_Head_True_Centralities.csv", sep = "_"))
      Deg$Node <- sub("\\.0", "", Deg$X)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$Node, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$Node, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalBout <- rbind(TotalBout, Deg)
      }
      if (Start == 0) {
        TotalBout <- Deg
        Start <- 1
      }
    }
  }
}

TotalBoutSubset <- TotalBout[, c("ID", "degree", "between", "close", "eigen")]
names(TotalBoutSubset)[names(TotalBoutSubset) == "degree"] <- "boutDegree"
names(TotalBoutSubset)[names(TotalBoutSubset) == "between"] <- "boutBetween"
names(TotalBoutSubset)[names(TotalBoutSubset) == "close"] <- "boutClose"
names(TotalBoutSubset)[names(TotalBoutSubset) == "eigen"] <- "boutEigen"
BigDataSheet <- merge(TotalDeg, TotalBoutSubset, by = "ID")

# Body Degree

Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "Head_to_Body_False_Centralities.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "Head_to_Body_False_Centralities.csv", sep = "_"))
      Deg$Node <- sub("\\.0", "", Deg$X)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$Node, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$Node, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalBody <- rbind(TotalBody, Deg)
      }
      if (Start == 0) {
        TotalBody <- Deg
        Start <- 1
      }
    }
  }
}

TotalBodySubset <- TotalBody[, c("ID", "degree", "between", "close", "eigen")]
names(TotalBodySubset)[names(TotalBodySubset) == "degree"] <- "bodyDegree"
names(TotalBodySubset)[names(TotalBodySubset) == "between"] <- "bodyBetween"
names(TotalBodySubset)[names(TotalBodySubset) == "close"] <- "bodyClose"
names(TotalBodySubset)[names(TotalBodySubset) == "eigen"] <- "bodyEigen"
BigDataSheet <- merge(BigDataSheet, TotalBodySubset, by = "ID")

# Bout Length
BigDataSheet$AverageBoutLength <- BigDataSheet$Degree / BigDataSheet$bodyDegree


# Ovary Measurements
Ovaries <- read.csv("OvaryMeasurements.csv")
Ovaries$AverageOvaryLength <- (Ovaries$LongestOocyteLength1..mm. + Ovaries$LongestOocyteLength2..mm.) / 2
Ovaries$AverageOvaryWidth <- (Ovaries$LongestOocyteWidth1..mm. + Ovaries$LongestOocyteWidth2..mm.) / 2
Ovaries$Bee <- paste(Ovaries$ColonyID, "_ArUcoTag#", Ovaries$Tag, sep = "")
BigDataSheet <- merge(BigDataSheet, Ovaries[, c("Bee", "AverageOvaryLength", "AverageOvaryWidth")], by = "Bee", all.x = TRUE)

# Wing Measurements
Wings <- read.csv("WingMeasurements.csv")
Wings$AverageWingLength <- (Wings$wing_1_mm + Wings$wing_2_mm) / 2
Wings$TagNumber <- str_extract(Wings$ID, "(?<=Tag)\\d+")
Wings$Bee <- paste(Wings$ColonyID, "_ArUcoTag#", Wings$TagNumber, sep = "")
BigDataSheet <- merge(BigDataSheet, Wings[, c("Bee", "AverageWingLength")], by = "Bee", all.x = TRUE)

# Track Presence
Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "8_8_3_1_10_interp_filtered.h5_TrackPresence.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "8_8_3_1_10_interp_filtered.h5_TrackPresence.csv", sep = "_"))
      Deg$track <- sub("\\.0", "", Deg$track)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$track, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$track, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalPresence <- rbind(TotalPresence, Deg)
      }
      if (Start == 0) {
        TotalPresence <- Deg
        Start <- 1
      }
    }
  }
}

TotalPresenceSubset <- TotalPresence[, c("ID", "Presence")]
BigDataSheet <- merge(BigDataSheet, TotalPresenceSubset, by = "ID")

# Antennna Presence
Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "8_8_3_1_10_interp_filtered.h5_TrackPresenceAnt.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "8_8_3_1_10_interp_filtered.h5_TrackPresenceAnt.csv", sep = "_"))
      Deg$track <- sub("\\.0", "", Deg$track)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$track, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$track, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalPresence <- rbind(TotalPresence, Deg)
      }
      if (Start == 0) {
        TotalPresence <- Deg
        Start <- 1
      }
    }
  }
}

TotalPresenceSubset <- TotalPresence[, c("ID", "Presence")]
names(TotalPresenceSubset)[names(TotalPresenceSubset) == "Presence"] <- "AntPresence"
BigDataSheet <- merge(BigDataSheet, TotalPresenceSubset, by = "ID")

# Vels Data
Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "velstrackqueen.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "velstrackqueen.csv", sep = "_"))
      Deg$X <- sub("\\.0", "", Deg$X)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$X, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$X, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalVels <- rbind(TotalVels, Deg)
      }
      if (Start == 0) {
        TotalVels <- Deg
        Start <- 1
      }
    }
  }
}

TotalVelsSubset <- TotalVels[, c("ID", "mean_vel", "move_perc")]
BigDataSheet <- merge(BigDataSheet, TotalVelsSubset, by = "ID")

Start <- 0
for (i in 1:10) {
  if (file.exists(paste(prefixes[i], "096_DispersionMetrics.csv", sep = "_"))) {
    Deg <- read.csv(paste(prefixes[i], "096_DispersionMetrics.csv", sep = "_"))
    Deg$Tag <- sub("\\.0", "", Deg$Tag)
    Deg$Col <- prefixes[i]
    Deg$QR <- i %% 2 == 1
    Deg$Bee <- paste(Deg$Col, Deg$Tag, sep = "_")
    Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
    if (Start == 1) {
      TotalDisp <- rbind(TotalDisp, Deg)
    }
    if (Start == 0) {
      TotalDisp <- Deg
      Start <- 1
    }
  }
}

DispNew <- reshape(TotalDisp, idvar = c("Tag", "Col", "QR", "Bee", "Queen"), timevar = "Day", direction = "wide")

DispSubset <- DispNew[, c("Bee", "N90.Day1", "N90.Day2", "N90.Day3", "N90.Day4", "MRSD.Day1", "MRSD.Day2", "MRSD.Day3", "MRSD.Day4")]
BigDataSheet <- merge(BigDataSheet, DispSubset, by = "Bee", all.x = TRUE)

# Diectional Degree

Start <- 0
for (i in 1:10) {
  for (j in 0:97) {
    if (file.exists(paste(prefixes[i], sprintf("%03d", j), "DegDir.csv", sep = "_"))) {
      Deg <- read.csv(paste(prefixes[i], sprintf("%03d", j), "DegDir.csv", sep = "_"))
      Deg$Node <- sub("\\.0", "", Deg$Origin.interactor)
      Deg$Day <- floor((j / 24) + 1)
      Deg$Hour <- sprintf("%03d", j)
      Deg$Col <- prefixes[i]
      Deg$QR <- i %% 2 == 1
      Deg$ID <- paste(Deg$Col, Deg$Node, Deg$Hour, sep = "_")
      Deg$Bee <- paste(Deg$Col, Deg$Node, sep = "_")
      Deg$Mod <- "Head_Head"
      Deg$Trial <- str_extract(Deg$Col, ".+?(?=_)")
      Deg$Queen <- Deg$Bee %in% c("RooibosTea_QR_1216_1646_ArUcoTag#52", "MexHotChoc_QR_1216_1646_ArUcoTag#13", "20230213_1745_AlmdudlerGspritzt_C1_ArUcoTag#24", "20221209_1613_QR_ArUcoTag#47", "20221123_1543_AmericanoLatte_QR_ArUcoTag#43")
      if (Start == 1) {
        TotalDir <- rbind(TotalDir, Deg)
      }
      if (Start == 0) {
        TotalDir <- Deg
        Start <- 1
      }
    }
  }
}

DirSubset <- TotalDir[, c("ID", "count_ori", "count_des", "Initiation.Freq")]
BigDataSheet <- merge(BigDataSheet, DirSubset, by = "ID")

### Analyzing the Sheet: Means (Use 2 until I straighten out a bit of code)-----
BDSMeans <- aggregate(cbind(Degree, Close, Eigen, Between, QR, Queen, boutDegree, boutBetween, boutClose, boutEigen, bodyDegree, bodyBetween, bodyClose, bodyEigen, AverageBoutLength, AverageOvaryWidth, AverageWingLength, Presence, AntPresence, mean_vel, move_perc, N90.Day4, MRSD.Day4, Initiation.Freq) ~ Bee, BigDataSheet, mean)
BDSMeans$Trial <- str_extract(BDSMeans$Bee, ".+?(?=_)")
BDSMeans$Col <- str_extract(BDSMeans$Bee, ".+?(?=#)")
### Analyzing the Sheet: Presence vs. Degree.  Presence Standardized:-----

ggplot(BDSMeans, aes(x = AverageOvaryWidth, y = Degree)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7,
    aes(color = factor(QR))
  ) +
  theme_classic() +
  labs(title = "Avg Length vs Avg Width") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  ) +
  facet_wrap(~QR, nrow = 2) # Made this before, but it's a good sanity check

ggplot(BigDataSheet, aes(x = Presence, y = Degree)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7
  ) +
  theme_classic() +
  labs(title = "Presence vs Degree") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  )
cor.test(BigDataSheet$Presence, BigDataSheet$Degree, method = "spearm", alternative = "g")


ggplot(BigDataSheet, aes(x = AntPresence, y = Degree)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7
  ) +
  theme_classic() +
  labs(title = "Antennal Presence vs Degree") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  )
cor.test(BigDataSheet$AntPresence, BigDataSheet$Degree, method = "spearm", alternative = "g")
### AnalyzingTheSheet: Top 10s-----

Top10 <- BDSMeans %>%
  group_by(Col) %>%
  top_n(10, Degree)

Bottom10 <- BDSMeans %>%
  group_by(Col) %>%
  top_n(10, Degree)

ggplot(BDSMeans, aes(x = QR, y = Degree)) +
  geom_line(aes(group = Trial), color = "darkgray") +
  geom_point(aes(color = Trial), size = 5) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  xlab("") +
  labs(color = "Source Colony") +
  ylab("Degree") + # Adjust axis labels
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    # legend.position = "none",
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", linewidth = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", linewidth = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  guides(color = guide_legend(title.position = "top", title.hjust = 0.5))



### AnalyzingTheSheet: OvaryIndex
BDSMeans$OvaryIndex <- BDSMeans$AverageOvaryWidth / BDSMeans$AverageWingLength
ggplot(BDSMeans, aes(x = OvaryIndex, y = boutBetween)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7,
    aes(color = factor(QR))
  ) +
  theme_classic() +
  labs(title = "Avg Length vs Avg Width") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  ) +
  facet_wrap(~QR, nrow = 2) # Made this before, but it's a good sanity check


### Figures:ReconstructionScottsFigures-----

ggplot(BigDataSheet, aes(x = Hour, y = Degree, group = Col)) +
  geom_jitter(aes(color = interaction(QR, Queen), alpha = Queen)) +
  geom_smooth(aes(group = interaction(QR, Queen), color = interaction(QR, Queen))) +
  theme_classic() +
  labs(title = "Degree Cent in Queens, Queenless Workers, Queenright Workers") +
  scale_alpha_discrete(range = c(0.1, 0.4)) +
  scale_color_manual(
    name = "Bee",
    labels = c("QL Worker", "QR Worker", "Queen"),
    values = c("#161414", "#629CC0", "#7851A9")
  )

BDSMeans$Alpha <- ifelse(BDSMeans2$Queen, 0.5, 0.75)
BDSMeans$PointSize <- ifelse(BDSMeans2$Queen, 2, 1)

ggplot(BDSMeans, aes(x = move_perc, y = Degree, group = interaction(QR, Queen))) +
  geom_smooth(
    data = subset(BDSMeans2, Queen == FALSE), # Subset the data to exclude queens
    method = lm, # Change method to lm for linear model
    se = T, # Standard error
    size = .75, # Adjust size to match first plot
    linetype = 1, # Line type
    aes(color = interaction(QR, Queen))
  ) + # Color by treatment
  new_scale_color() +
  geom_point(aes(color = Trial, shape = as.factor(QR)), alpha = 1, size = BDSMeans2$PointSize) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous() + # Use a continuous scale for x
  scale_y_continuous() + # Use a continuous scale for y
  #   labs(title="Total Interaction Count vs Movement Percentage", color = "Treatment") +  # Adjust title and legend title
  xlab("Fraction of Time Spent Moving") +
  ylab("Mean Number of Interactions per Hour") + # Adjust axis labels
  theme_minimal() +
  theme(
    text = element_text(size = 16),
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  xlim(0.2, 1)

ggplot(BDSMeans, aes(x = N90.Day4, y = Between)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7,
    aes(color = factor(QR))
  ) +
  theme_classic() +
  labs(title = "Dispersion vs Degree") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  ) +
  facet_wrap(~QR, nrow = 2)


ggplot(BDSMeans, aes(x = Initiation.Freq, y = Between)) +
  geom_point() +
  geom_smooth(
    method = lm,
    se = T,
    linewidth = 1.5,
    linetype = 1,
    alpha = .7,
    aes(color = factor(QR))
  ) +
  theme_classic() +
  labs(title = "Initiation Frequency vs Degree") +
  scale_color_manual(
    name = "Bee",
    labels = c("QL", "QR"),
    values = c("#161414", "#629CC0")
  ) +
  facet_wrap(~QR, nrow = 2)


### QLQRLoadings-----


numerical_dataQR <- BDSMeans[BDSMeans$QR == TRUE, c(2:5, 8:25)]
numerical_dataQR <- numerical_dataQR[complete.cases(numerical_dataQR), ]
data_normalized <- scale(numerical_dataQR)
data.pca <- princomp(data_normalized)
fviz_eig(data.pca, addlabels = TRUE)
fviz_pca_var(data.pca, col.var = "black")

numerical_dataQL <- BDSMeans[BDSMeans$QR == FALSE, c(2:5, 8:25)]
numerical_dataQL <- numerical_dataQL[complete.cases(numerical_dataQL), ]
data_normalized <- scale(numerical_dataQL)
data.pca <- princomp(data_normalized)
fviz_eig(data.pca, addlabels = TRUE)
fviz_pca_var(data.pca, col.var = "black")






### Finding Worst Queens-----

Queens <- BigDataSheet[BigDataSheet$Queen == TRUE, ]

### Presence Distribution-----
BDSRanked <- aggregate(cbind(Degree, Close, Eigen, Between, QR, Queen, boutDegree, boutBetween, boutClose, boutEigen, bodyDegree, bodyBetween, bodyClose, bodyEigen, AverageBoutLength, Presence, AntPresence, mean_vel, move_perc, N90.Day4, MRSD.Day4, Initiation.Freq) ~ Bee, BigDataSheet, mean)
BDSRanked$Trial <- str_extract(BDSRanked$Bee, ".+?(?=_)")
BDSRanked$Col <- str_extract(BDSRanked$Bee, ".+?(?=#)")
BDSRanked <- BDSRanked %>%
  arrange(Col, AntPresence) %>%
  group_by(Col) %>%
  mutate(Rank = rank(AntPresence))

ggplot(BDSRanked, aes(x = Rank, y = AntPresence)) +
  geom_line(data = subset(BDSRanked, QR == 1), aes(group = Col, color = Col)) +
  geom_point(data = subset(BDSRanked, Queen == 1), color = "purple", size = 3)


### MS:Figure 2a ----------

BDSMeansNoOv <- aggregate(cbind(Degree, Close, Eigen, Between, QR, Queen, boutDegree, boutBetween, boutClose, boutEigen, bodyDegree, bodyBetween, bodyClose, bodyEigen, AverageBoutLength, Presence, AntPresence, mean_vel, move_perc, N90.Day4, MRSD.Day4, Initiation.Freq) ~ Bee, BigDataSheet, mean)
BDSMeansNoOv$Trial <- str_extract(BDSMeansNoOv$Bee, ".+?(?=_)")

BDSMeansNoOv <- BDSMeansNoOv %>%
  mutate(QR_Queen_Condition = case_when(
    QR == 0 & Queen == 0 ~ "Queenless",
    QR == 1 & Queen == 0 ~ "Queenright",
    Queen == 1 ~ "Queen",
    TRUE ~ NA_character_ # This handles any other case, which shouldn't exist in your scenario
  )) %>%
  mutate(QR_Queen_Condition = factor(QR_Queen_Condition, levels = c("Queenright", "Queenless", "Queen")))

BDSMeansNoOv$ID <- paste(BDSMeansNoOv$Trial, BDSMeansNoOv$QR_Queen_Condition)
BDSMeanOfMean <- aggregate(cbind(Degree, Close, Eigen, Between, QR, Queen, boutDegree, boutBetween, boutClose, boutEigen, bodyDegree, bodyBetween, bodyClose, bodyEigen, AverageBoutLength, Presence, AntPresence, mean_vel, move_perc, N90.Day4, MRSD.Day4, Initiation.Freq) ~ ID, BDSMeansNoOv, mean)
BDSMeanOfMean$Trial <- str_extract(BDSMeanOfMean$ID, ".+?(?= )")

BDSMeanOfMean <- BDSMeanOfMean %>%
  mutate(QR_Queen_Condition = case_when(
    QR == 0 & Queen == 0 ~ "Queenless",
    QR == 1 & Queen == 0 ~ "Queenright",
    Queen == 1 ~ "Queen",
    TRUE ~ NA_character_ # This handles any other case, which shouldn't exist in your scenario
  )) %>%
  mutate(QR_Queen_Condition = factor(QR_Queen_Condition, levels = c("Queenright", "Queenless", "Queen")))

ggplot(BDSMeanOfMean, aes(x = fct_rev(as.factor(QR_Queen_Condition)), y = Degree)) +
  geom_line(aes(group = Trial), color = "darkgray") +
  geom_point(aes(color = Trial), size = 5) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  xlab("") +
  labs(color = "Source Colony") +
  ylab("Mean Number of Interactions per Hour") + # Adjust axis labels
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    text = element_text(size = 16),
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  guides(color = guide_legend(title.position = "top", title.hjust = 0.5))


### MS:Figure 2b-----

BigDataSheetF2 <- BigDataSheet %>%
  mutate(QR_Queen_Condition = case_when(
    !QR & !Queen ~ "Queenless",
    QR & !Queen ~ "Queenright",
    Queen ~ "Queen",
    TRUE ~ NA_character_ # This handles any other case, which shouldn't exist in your scenario
  )) %>%
  mutate(QR_Queen_Condition = factor(QR_Queen_Condition, levels = c("Queenright", "Queenless", "Queen")))

BigDataSheetF2$Alpha <- ifelse(BigDataSheetF2$Queen, .5, 0.005)
BigDataSheetF2 <- BigDataSheetF2[sample(nrow(BigDataSheetF2)), ]
BigDataSheetF2$PointSize <- ifelse(BigDataSheetF2$Queen, .003, .001)

ggplot(BigDataSheetF2, aes(x = as.integer(Hour), y = Degree / 20, group = ID)) +
  geom_jitter(aes(color = QR_Queen_Condition, alpha = Alpha, size = PointSize)) +
  geom_smooth(aes(group = QR_Queen_Condition, color = QR_Queen_Condition)) +
  scale_size(range = c(.001, .2)) +
  scale_color_manual(
    labels = c("Queenright Worker", "Queenless Worker", "Queen"),
    values = c("#429CF0", "#161414", "#7851A9"),
    guide = guide_legend(direction = "horizontal")
  ) +
  scale_x_continuous(breaks = c(0, seq(24, 96, by = 24)), limits = c(0, NA), expand = c(0, 0)) + # Expand limits to include 0
  labs(color = "") +
  xlab("Hour") +
  ylab("Standardized Time Spent Interacting per Hour (s)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = c(1, 1.02), # Move legend to top right
    legend.justification = c(1, 1), # Align legend to top right
    legend.background = element_rect(fill = alpha("white", 1)),
    legend.title = element_text(size = 8, face = "bold"),
    legend.text = element_text(size = 7),
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 10, face = "bold"), # Make facet plot titles larger and bold
    panel.grid = element_blank(),
    panel.border = element_blank()
  ) +
  # scale_y_log10() +
  guides(alpha = "none", size = "none")

### MS:Figure 3------------
numerical_data <- BigDataSheet[, c(4:7, 16:42)]
numerical_data <- numerical_data[complete.cases(numerical_data), ]
data_normalized <- scale(numerical_data)
data.pca <- princomp(data_normalized)
fviz_eig(data.pca, addlabels = TRUE)
fviz_pca_var(data.pca, col.var = "black")
numerical_data$QR <- BigDataSheet[complete.cases(BigDataSheet), ]$QR
numerical_data$Trial <- BigDataSheet[complete.cases(BigDataSheet), ]$Trial


fviz_pca_ind(data.pca,
  label = "none", habillage = numerical_data$QR,
  addEllipses = TRUE, ellipse.level = 0.95, palette = "Dark2"
)
fviz_pca_ind(data.pca,
  label = "none", habillage = numerical_data$Trial,
  addEllipses = TRUE, ellipse.level = 0.95, palette = "Dark2"
)


numerical_data <- BDSMeans[, c(2:5, 8:25, 28)]
numerical_data <- numerical_data[complete.cases(numerical_data), ]
data_normalized <- scale(numerical_data)
data.pca <- princomp(data_normalized)
fviz_eig(data.pca, addlabels = TRUE)
fviz_pca_var(data.pca, col.var = "black")
numerical_data$QR <- BDSMeans[complete.cases(BDSMeans), ]$QR
numerical_data$Trial <- BDSMeans[complete.cases(BDSMeans), ]$Trial
numerical_data$Queen <- BDSMeans[complete.cases(BDSMeans), ]$Queen



fviz_pca_ind(data.pca,
  label = "none", habillage = numerical_data$QR,
  addEllipses = TRUE, ellipse.level = 0.95, palette = "Dark2"
) + theme_minimal()
fviz_pca_ind(data.pca,
  label = "none", habillage = numerical_data$Trial,
  addEllipses = TRUE, ellipse.level = 0.95, palette = "Dark2"
)
fviz_pca_ind(data.pca,
  label = "none", habillage = numerical_data$Queen,
  addEllipses = TRUE, ellipse.level = 0.95, palette = "Dark2"
)
fviz_pca_ind(data.pca,
  col.ind = numerical_data$OvaryIndex, geom = "point",
  legend.title = "OvaryIndex",
  gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)


BDSMeansQR <- BDSMeans[BDSMeans$QR == TRUE, ]
BDSMeansQL <- BDSMeans[BDSMeans$QR == FALSE, ]

cor.test(BDSMeansQR$Between, BDSMeansQR$boutBetween)
cor.test(BDSMeansQL$Between, BDSMeansQL$boutBetween)

### MS:Figure 4-------
BDSMeans$Alpha <- ifelse(BDSMeans$Queen, 0.5, 0.75)
BDSMeans$PointSize <- ifelse(BDSMeans$Queen, 2, 1)

ggplot(BDSMeans, aes(x = move_perc, y = Degree, group = interaction(QR, Queen))) +
  geom_smooth(
    data = subset(BDSMeans, Queen == FALSE), # Subset the data to exclude queens
    method = lm, # Change method to lm for linear model
    se = T, # Standard error
    size = .75, # Adjust size to match first plot
    linetype = 1, # Line type
    aes(color = interaction(QR, Queen))
  ) + # Color by treatment
  new_scale_color() +
  geom_point(aes(color = Trial, shape = as.factor(QR)), alpha = 1, size = BDSMeans$PointSize) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous() + # Use a continuous scale for x
  scale_y_continuous() + # Use a continuous scale for y
  #   labs(title="Total Interaction Count vs Movement Percentage", color = "Treatment") +  # Adjust title and legend title
  xlab("Fraction of Time Spent Moving") +
  ylab("Mean Number of Interactions per Hour") + # Adjust axis labels
  theme_minimal() +
  theme(
    text = element_text(size = 16),
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  xlim(0, 1)

### MS:Figure 5-------
BDSMeans$Alpha <- ifelse(BDSMeans$Queen, 0.5, 0.75)
BDSMeans$PointSize <- ifelse(BDSMeans$Queen, 2, 1)

BDSMeans$OvaryIndex <- BDSMeans$AverageOvaryWidth / BDSMeans$AverageWingLength

ggplot(BDSMeans, aes(x = OvaryIndex, y = Degree, group = interaction(QR, Queen))) +
  geom_smooth(
    data = subset(BDSMeans, Queen == FALSE), # Subset the data to exclude queens
    method = lm, # Change method to lm for linear model
    se = T, # Standard error
    size = .75, # Adjust size to match first plot
    linetype = 1, # Line type
    aes(color = interaction(QR, Queen))
  ) + # Color by treatment
  new_scale_color() +
  geom_point(aes(color = Trial, shape = as.factor(QR)), alpha = 1, size = BDSMeans$PointSize) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  scale_x_continuous() + # Use a continuous scale for x
  scale_y_continuous() + # Use a continuous scale for y
  #   labs(title="Total Interaction Count vs Movement Percentage", color = "Treatment") +  # Adjust title and legend title
  xlab("Ovary Index") +
  ylab("Mean Number of Interactions per Hour") + # Adjust axis labels
  theme_minimal() +
  theme(
    text = element_text(size = 16),
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  xlim(0, 1)


### MS:Supp Figure 2b-----

BigDataSheetF2$StandardizedDegree <- BigDataSheetF2$Degree * BigDataSheetF2$AntPresence

ggplot(BigDataSheetF2, aes(x = as.integer(Hour), y = StandardizedDegree / 20, group = ID)) +
  geom_jitter(aes(color = QR_Queen_Condition, alpha = Alpha, size = PointSize)) +
  geom_smooth(aes(group = QR_Queen_Condition, color = QR_Queen_Condition)) +
  scale_size(range = c(.001, .2)) +
  scale_color_manual(
    labels = c("Queenright Worker", "Queenless Worker", "Queen"),
    values = c("#429CF0", "#161414", "#7851A9"),
    guide = guide_legend(direction = "horizontal")
  ) +
  scale_x_continuous(breaks = c(0, seq(24, 96, by = 24)), limits = c(0, NA), expand = c(0, 0)) + # Expand limits to include 0
  labs(color = "") +
  xlab("Hour") +
  ylab("Standardized Time Spent Interacting per Hour (s)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = c(1, 1.02), # Move legend to top right
    legend.justification = c(1, 1), # Align legend to top right
    legend.background = element_rect(fill = alpha("white", 1)),
    legend.title = element_text(size = 8, face = "bold"),
    legend.text = element_text(size = 7),
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 10, face = "bold"), # Make facet plot titles larger and bold
    panel.grid = element_blank(),
    panel.border = element_blank()
  ) +
  # scale_y_log10() +
  guides(alpha = "none", size = "none")





### MS:SuppFigure
### MS:Supp Figure 5--------
ggplot(BDSMeanOfMean, aes(x = fct_rev(as.factor(QR_Queen_Condition)), y = N90.Day4)) +
  geom_line(aes(group = Trial), color = "darkgray") +
  geom_point(aes(color = Trial), size = 5) +
  scale_color_manual(values = wes_palette("Cavalcanti1")) +
  xlab("") +
  labs(color = "Source Colony") +
  ylab("N90 (Dispersion Measure)") + # Adjust axis labels
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    text = element_text(size = 16),
    panel.grid.major.x = element_line(color = "grey", linetype = "dashed"), # Keep vertical grid lines
    panel.grid.minor.x = element_line(color = "grey", linetype = "dotted"), # Keep vertical grid lines
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    panel.grid.minor.y = element_blank(), # Remove horizontal grid lines
    axis.line.x = element_line(color = "black", size = 0.5), # Add x-axis line
    axis.line.y = element_line(color = "black", size = 0.5), # Add y-axis line
    strip.text = element_text(size = 14, face = "bold"), # Make facet plot titles larger and bold
    axis.text.y.right = element_blank(), # Remove right y-axis text
    axis.ticks.y.right = element_blank(), # Remove right y-axis ticks
    aspect.ratio = 1
  ) +
  guides(color = guide_legend(title.position = "top", title.hjust = 0.5))
