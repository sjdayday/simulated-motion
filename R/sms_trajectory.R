# create data from sms files
# awklog 2020-03-17--20-19-55_diary.txt > position-1-6-6-60.dat
# (sparseness = 1, ripples = 6, grids = 6, head direction cells = 60)
# build_one_pdf("position-1-6-6-60")
build_one_pdf <- function(filename)
{
   trajectorydf <- build_trajectorydf(filename)
   trajectorydf <- build_pointsdf(trajectorydf)
   fullpdfname <- paste(filename,".pdf",sep="")
   pdf(fullpdfname)
   graph_segments(trajectorydf)
   dev.off()
}
build_trajectorydf <- function(filename)
{
  library(plyr)
  library(readr)
  smsdir <- "../test/logs"
  fullfilename <- paste(filename,".dat",sep="")
  smsfiles <- list.files(path=smsdir, pattern=fullfilename, full.names=TRUE)
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
