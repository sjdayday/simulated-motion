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
  select(step, seed, turnRun, simulated, retracedTrajectory, successfulRetrace, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  filter(simulated == 0, turnRun == 2, retracedTrajectory == 1) %>%
  group_by(sparsePlaceId, ripples, grids, headDirectionCells, seed) %>%
  summarise(retracedTotal = sum(retracedTrajectory), successfulTotal = sum(successfulRetrace), successfulPercent = successfulTotal / retracedTotal)

  retracedf
}
build_retraceModel <- function(retracedf)
{
  fitretrace <- lm(successfulPercent ~ sparsePlaceId + ripples + grids + headDirectionCells, data=retracedf)
  summary(fitretrace)
  fitretrace
}
build_gridSquarePercent_df <- function(smsdf, percent)
{
  smsleveldf = smsdf %>%
  rename(turnRun = "turn/run") %>%
  select(step, seed, turnRun, simulated, gridSquarePercent, saturationPercent, sparsePlaceId, ripples, grids, headDirectionCells) %>%
  filter(simulated == 0, gridSquarePercent < percent) %>%
  group_by(sparsePlaceId, ripples, grids, headDirectionCells, seed) %>%
  summarise(steps = last(step), energy = n(), last(gridSquarePercent), saturation = last(saturationPercent))

  smsleveldf
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
build_energyModel80 <- function(sms80df)
{
  fitenergy80 <- lm(energy ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms80df)
  summary(fitenergy80)
  fitenergy80
}
build_saturationModel90 <- function(sms90df)
{
  fitsaturation90 <- lm(saturation ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms90df)
  summary(fitsaturation90)
  fitsaturation90
}
build_saturationModel80 <- function(sms80df)
{
  fitsaturation80 <- lm(saturation ~ steps + sparsePlaceId + ripples + grids + headDirectionCells, data=sms80df)
  summary(fitsaturation80)
  fitsaturation80
}


save_df <- function(df, fname)
{
  write.csv(df,file=fname,quote=TRUE,eol="\r")
}
