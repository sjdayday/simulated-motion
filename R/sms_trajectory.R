# create data from sms files
build_trajectorydf <- function()
{
  library(plyr)
  library(readr)
  smsdir <- "../test/logs"
  smsfiles <- list.files(path=smsdir, pattern="*.dat", full.names=TRUE)
  trajectorydf <- ldply(smsfiles, read_csv)
  trajectorydf
}
build_pointsdf <- function(trajectorydf)
{
  lastx = 0
  lasty = 0
  lastsimx = 0
  lastsimy = 0
  trajectorydf <- cbind(trajectorydf, lastx, lasty, lastsimx, lastsimy)
  trajectorydf$lastx[1] <- trajectorydf$x[1]
  trajectorydf$lasty[1] <- trajectorydf$y[1]
  trajectorydf$lastsimx[1] <- trajectorydf$simx[1]
  trajectorydf$lastsimy[1] <- trajectorydf$simy[1]
  for(i in 1:(nrow(trajectorydf)-1)) {
    trajectorydf$lastx[i+1] <- trajectorydf$x[i]
    trajectorydf$lasty[i+1] <- trajectorydf$y[i]
    trajectorydf$lastsimx[i+1] <- trajectorydf$simx[i]
    trajectorydf$lastsimy[i+1] <- trajectorydf$simy[i]
  }
  trajectorydf
}
graph_segments <- function(trajectorydf)
{
   offset = 0.25
   plot.new()
   polygon(c(offset, offset, 0.5+offset, 0.5+offset), c(offset, 0.5+offset, 0.5+offset, offset),lwd=1)
   simulated = FALSE
   for (i in 1:nrow(trajectorydf))
   {
      if ((trajectorydf$x[i] ==  trajectorydf$simx[i]) && (trajectorydf$y[i] ==  trajectorydf$simy[i])) {
         simulated = FALSE
      } else {
         simulated = TRUE
      }
      if (simulated) {
         segments(trajectorydf$lastsimx[i]/4+offset, trajectorydf$lastsimy[i]/4+offset, trajectorydf$simx[i]/4+offset, trajectorydf$simy[i]/4+offset, lwd=5, col="gray")
      } else {
         segments(trajectorydf$lastx[i]/4+offset, trajectorydf$lasty[i]/4+offset, trajectorydf$x[i]/4+offset, trajectorydf$y[i]/4+offset, lwd=2, col="cornflowerblue")
      }
   }
}

create_graph <- function(x1,p_ext_v,x2,b_ext_v,x3,p_max_v,x4,b_max_v,x5,static_eq_v,x6,eq_v,x7,limit_v,thrive,survive,x_eq_pay,y_eq_pay,title_text)
{
  colors <- c("cornflowerblue","rosybrown","lightblue","peachpuff2","forestgreen","palegreen","darkgray")
  plot(c(.5),c(0),type="p",xlim=c(.5,.95),ylim=c(0.0,0.6),xlab="Gamma for protection function",ylab="X for protection proportion",pch=24,col="white",bg="white")
  title(main=title_text)
  abline(thrive,0,col="darkgreen",lwd=1.5)
  abline(survive,0,col="darkgray",lwd=1.5)
  points(x1,p_ext_v,pch=25,col="cornflowerblue",bg="cornflowerblue")
  points(x2,b_ext_v,pch=25,col="rosybrown",bg="rosybrown")
  points(x3,p_max_v,pch=24,col="lightblue",bg="lightblue")
  points(x4,b_max_v,pch=24,col="peachpuff2",bg="peachpuff2")
  points(x7,limit_v,pch=22,col="darkgray",bg="darkgray")
  points(x6,eq_v,pch=21,col="palegreen",bg="palegreen")
  points(x5,static_eq_v,pch=21,col="forestgreen",bg="forestgreen")
  points(x_eq_pay,y_eq_pay,pch=3,col="darkgray")
  legend("topright", inset = 0.02, c("Peasants extinct", "Bandits extinct", "Peasants exceeded max", "Bandits exceeded max", "Static equilibrium", "Expanding equilibrium", "No end state reached"), col=colors,cex=0.7, pch=c(25,25,24,24,21,21,22))
  legend("bottomright", inset = 0.02, c("Thrive threshold", "Survive threshold", "Avg payoff at static equilibrium"), lty=c(1,1,0), pch=c(NA, NA, 3), col=c("darkgreen","darkgray","darkgray"),cex=0.7, merge=TRUE)
}

create_graph <- function(x1,p_ext_v,x2,b_ext_v,x3,p_max_v,x4,b_max_v,x5,static_eq_v,x6,eq_v,x7,limit_v,thrive,survive,x_eq_pay,y_eq_pay,title_text)
{
  colors <- c("cornflowerblue","rosybrown","lightblue","peachpuff2","forestgreen","palegreen","darkgray")
  plot(c(.5),c(0),type="p",xlim=c(.5,.95),ylim=c(0.0,0.6),xlab="Gamma for protection function",ylab="X for protection proportion",pch=24,col="white",bg="white")
  title(main=title_text)
  abline(thrive,0,col="darkgreen",lwd=1.5)
  abline(survive,0,col="darkgray",lwd=1.5)
  points(x1,p_ext_v,pch=25,col="cornflowerblue",bg="cornflowerblue")
  points(x2,b_ext_v,pch=25,col="rosybrown",bg="rosybrown")
  points(x3,p_max_v,pch=24,col="lightblue",bg="lightblue")
  points(x4,b_max_v,pch=24,col="peachpuff2",bg="peachpuff2")
  points(x7,limit_v,pch=22,col="darkgray",bg="darkgray")
  points(x6,eq_v,pch=21,col="palegreen",bg="palegreen")
  points(x5,static_eq_v,pch=21,col="forestgreen",bg="forestgreen")
  points(x_eq_pay,y_eq_pay,pch=3,col="darkgray")
  legend("topright", inset = 0.02, c("Peasants extinct", "Bandits extinct", "Peasants exceeded max", "Bandits exceeded max", "Static equilibrium", "Expanding equilibrium", "No end state reached"), col=colors,cex=0.7, pch=c(25,25,24,24,21,21,22))
  legend("bottomright", inset = 0.02, c("Thrive threshold", "Survive threshold", "Avg payoff at static equilibrium"), lty=c(1,1,0), pch=c(NA, NA, 3), col=c("darkgreen","darkgray","darkgray"),cex=0.7, merge=TRUE)
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
