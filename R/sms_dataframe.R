# create data from sms files
build_smsdf <- function()
{
  library(plyr)
  library(readr)
  smsdir <- "../test/logs"
  smsfiles <- list.files(path=smsdir, pattern="*.csv", full.names=TRUE)
  smsdf <- ldply(smsfiles, read_csv)
  smsdf
}
build_retracedf <- function(smsdf)
{
  library(dplyr)
  retracedf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, seed, turnRun, simulated, retracedTrajectory, successfulRetrace, saturationPercent, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  filter(simulated == 0, turnRun == 2, retracedTrajectory == 1) %>%
  group_by(sparsePlaceId, ripples, grids, headDirectionCells, seed) %>%
  summarise(retracedTotal = sum(retracedTrajectory), successfulTotal = sum(successfulRetrace), successfulPercent = successfulTotal / retracedTotal, steps = max(step), saturationPercent = last(saturationPercent))

  retracedf
}
build_explorationline <- function(smsdf)
{
  library(dplyr)
  exploredf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, gridSquarePercent) %>%
  group_by(step) %>%
  summarise(meanPercent = mean(gridSquarePercent), sdPercent = sd(gridSquarePercent))

  exploredf
}
build_saturationline <- function(smsdf)
{
  library(dplyr)
  saturationdf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, saturationPercent) %>%
  group_by(step) %>%
  summarise(meanPercent = mean(saturationPercent), sdPercent = sd(saturationPercent))

  saturationdf
}
plot_exploration <- function(exploredf)
{
   require(tidyr)
   require(ggplot2)
   exploredf$lowersd = exploredf$meanPercent-exploredf$sdPercent
   exploredf$uppersd = exploredf$meanPercent+exploredf$sdPercent
   ggplot(exploredf, aes(x=step, y=meanPercent)) + geom_line(size=1, alpha=0.8) +
    geom_ribbon(aes(ymin=lowersd, ymax=uppersd) ,fill="blue", alpha=0.2) + theme_light(base_size = 16) + xlab("Time step") + ggtitle("Percentage of grid squares explored") + scale_y_continuous(name="Grid square percentage", breaks=c(0.8, 0.9), limits=c(0.0, 1.0))
   ggsave("gridSquarePercentage.pdf")
}
plot_saturation <- function(saturationdf)
{
   require(tidyr)
   require(ggplot2)
   saturationdf$lowersd = saturationdf$meanPercent-saturationdf$sdPercent
   saturationdf$uppersd = saturationdf$meanPercent+saturationdf$sdPercent
   ggplot(saturationdf, aes(x=step, y=meanPercent)) + geom_line(size=1, alpha=0.8) +
    geom_ribbon(aes(ymin=lowersd, ymax=uppersd) ,fill="blue", alpha=0.2) + theme_light(base_size = 16) + xlab("Time step") + ggtitle("Saturation percentage") + scale_y_continuous(name="Saturation percentage", limits=c(0.0, 0.5))
   ggsave("saturationPercentage.pdf")
}
build_retraceModel <- function(retracedf)
{
  fitretrace <- lm(successfulPercent ~ sparsePlaceId + ripples + grids + headDirectionCells, data=retracedf)
  summary(fitretrace)
  fitretrace
}
build_retraceModel2 <- function(retracedf)
{
  fitretrace2 <- lm(successfulPercent ~ sparsePlaceId + ripples + grids + headDirectionCells + steps, data=retracedf)
  summary(fitretrace2)
  fitretrace2
}
build_retraceModel3 <- function(retracedf)
{
  fitretrace3 <- lm(successfulPercent ~ sparsePlaceId + ripples + grids + headDirectionCells + steps + saturationPercent, data=retracedf)
  summary(fitretrace3)
  fitretrace3
}
build_gridSquarePercent_df <- function(smsdf, percent)
{
  smsleveldf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, seed, turnRun, simulated, gridSquarePercent, saturationPercent, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  filter(simulated == 0, gridSquarePercent < percent) %>%
  group_by(sparsePlaceId, ripples, grids, headDirectionCells, seed) %>%
  summarise(steps = last(step), energy = n(), gridSquarePercent = last(gridSquarePercent), saturationPercent = last(saturationPercent))

  smsleveldf
}
build_subthreshold_df <- function(smsdf, percent)
{
  alldf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, seed, turnRun, simulated, gridSquarePercent, saturationPercent, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  group_by(sparsePlaceId, ripples, grids, headDirectionCells, seed) %>%
  summarise(steps = last(step), gridSquarePercent = last(gridSquarePercent), saturationPercent = last(saturationPercent))

  subthresholddf = alldf %>%
  select(steps, seed, gridSquarePercent, saturationPercent, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  filter(gridSquarePercent < percent)

  subthresholddf
}
build_sms90df <- function(smsdf)
{
  sms90df = build_gridSquarePercent_df(smsdf, 0.91)
  sms90df
}
build_sms80df <- function(smsdf)
{
  sms80df = build_gridSquarePercent_df(smsdf, 0.81)
  sms80df
}
build_energyModel90 <- function(sms90df)
{
  fitenergy90 <- lm(energy ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms90df)
  summary(fitenergy90)
  fitenergy90
}
build_energyModel902 <- function(sms90df)
{
  fitenergy902 <- lm(energy ~ steps + sparsePlaceId + ripples + grids + headDirectionCells + saturationPercent, data=sms90df)
  summary(fitenergy902)
  fitenergy902
}
build_energyModel80 <- function(sms80df)
{
  fitenergy80 <- lm(energy ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms80df)
  summary(fitenergy80)
  fitenergy80
}
build_energyModel802 <- function(sms80df)
{
  fitenergy802 <- lm(energy ~ steps + sparsePlaceId + ripples + grids + headDirectionCells + saturationPercent, data=sms80df)
  summary(fitenergy802)
  fitenergy802
}
build_saturationModel90 <- function(sms90df)
{
  fitsaturation90 <- lm(saturationPercent ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms90df)
  summary(fitsaturation90)
  fitsaturation90
}
build_saturationModel80 <- function(sms80df)
{
  fitsaturation80 <- lm(saturationPercent ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms80df)
  summary(fitsaturation80)
  fitsaturation80
}


save_df <- function(df, fname)
{
  write.csv(df,file=fname,quote=TRUE,eol="\r")
}
