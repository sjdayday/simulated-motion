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

scen_df50 <- function(scenario_set, file)
{
  path <- "/Users/stevedoubleday/Downloads/Fitnesse-Apr2011/ScenarioSet_"
  path_file <- paste(path,scenario_set,"/",file,sep="")
  df <- read.csv(path_file,header=TRUE,as.is=TRUE)
  names(df)[1] <- "Scen"
  names(df)[2] <- "Code"
  names(df)[3] <- "Period"
  names(df)[4] <- "NumB"
  names(df)[5] <- "NumP"
  names(df)[6] <- "Bar"
  names(df)[7] <- "Par"
  names(df)[8] <- "Bpay"
  names(df)[9] <- "Ppay"
  names(df)[10] <- "Delta"
  names(df)[11] <- "Adj"
  names(df)[12] <- "Aprot"
  names(df)[13] <- "Mprot"
  names(df)[14] <- "Moprot"
  names(df)[15] <- "Aprey"
  names(df)[16] <- "Mprey"
  names(df)[17] <- "Moprey"
  names(df)[18] <- "X0.0n"
  names(df)[19] <- "X0.0pct"
  names(df)[20] <- "X0.05n"
  names(df)[21] <- "X0.05pct"
  names(df)[22] <- "X0.1n"
  names(df)[23] <- "X0.1pct"
  names(df)[24] <- "X0.15n"
  names(df)[25] <- "X0.15pct"
  names(df)[26] <- "X0.2n"
  names(df)[27] <- "X0.2pct"
  names(df)[28] <- "X0.25n"
  names(df)[29] <- "X0.25pct"
  names(df)[30] <- "X0.3n"
  names(df)[31] <- "X0.3pct"
  names(df)[32] <- "X0.35n"
  names(df)[33] <- "X0.35pct"
  names(df)[34] <- "X0.4n"
  names(df)[35] <- "X0.4pct"
  names(df)[36] <- "X0.45n"
  names(df)[37] <- "X0.45pct"
  names(df)[38] <- "X0.5n"
  names(df)[39] <- "X0.5pct"
  names(df)[40] <- "X0.55n"
  names(df)[41] <- "X0.55pct"
  names(df)[42] <- "X0.6n"
  names(df)[43] <- "X0.6pct"
  names(df)[44] <- "X0.65n"
  names(df)[45] <- "X0.65pct"
  names(df)[46] <- "X0.7n"
  names(df)[47] <- "X0.7pct"
  names(df)[48] <- "X0.75n"
  names(df)[49] <- "X0.75pct"
  names(df)[50] <- "X0.8n"
  names(df)[51] <- "X0.8pct"
  names(df)[52] <- "X0.85n"
  names(df)[53] <- "X0.85pct"
  names(df)[54] <- "X0.9n"
  names(df)[55] <- "X0.9pct"
  names(df)[56] <- "X0.95n"
  names(df)[57] <- "X0.95pct"
  names(df)[58] <- "X1.0n"
  names(df)[59] <- "X1.0pct"
  names(df)[60] <- "role"
  names(df)[61] <- "shift"
  names(df)[62] <- "multi"
  names(df)[63] <- "only"
  names(df)[64] <- "runs"
  names(df)[65] <- "maxPop"
  names(df)[66] <- "equil"
  names(df)[67] <- "svive"
  names(df)[68] <- "thrive"
  names(df)[69] <- "tol"
  names(df)[70] <- "lowpct"
  names(df)[71] <- "initP"
  names(df)[72] <- "initB"
  names(df)[73] <- "maxP"
  names(df)[74] <- "cost"
  names(df)[75] <- "match"
  names(df)[76] <- "mexpB"
  names(df)[77] <- "mexpP"
  names(df)[78] <- "mmult"
  names(df)[79] <- "gamma"
  names(df)[80] <- "force2"
  names(df)[81] <- "xlowP"
  names(df)[82] <- "xhighP"
  names(df)[83] <- "lowPn"
  names(df)[84] <- "seed"
  df
}
scen_df23 <- function(scenario_set, file)
{
  path <- "/Users/stevedoubleday/Downloads/Fitnesse-Apr2011/ScenarioSet_"
  path_file <- paste(path,scenario_set,"/",file,sep="")
  df <- read.csv(path_file,header=TRUE,as.is=TRUE)
  names(df)[1] <- "Scen"
  names(df)[2] <- "Code"
  names(df)[3] <- "Period"
  names(df)[4] <- "NumB"
  names(df)[5] <- "NumP"
  names(df)[6] <- "Bar"
  names(df)[7] <- "Par"
  names(df)[8] <- "Bpay"
  names(df)[9] <- "Ppay"
  names(df)[10] <- "Delta"
  names(df)[11] <- "Adj"
  names(df)[12] <- "Aprot"
  names(df)[13] <- "Mprot"
  names(df)[14] <- "Moprot"
  names(df)[15] <- "Aprey"
  names(df)[16] <- "Mprey"
  names(df)[17] <- "Moprey"
  names(df)[18] <- "X0.0n"
  names(df)[19] <- "X0.0pct"
  names(df)[20] <- "X0.05n"
  names(df)[21] <- "X0.05pct"
  names(df)[22] <- "X0.1n"
  names(df)[23] <- "X0.1pct"
  names(df)[24] <- "X0.15n"
  names(df)[25] <- "X0.15pct"
  names(df)[26] <- "X0.2n"
  names(df)[27] <- "X0.2pct"
  names(df)[28] <- "X0.25n"
  names(df)[29] <- "X0.25pct"
  names(df)[30] <- "X0.3n"
  names(df)[31] <- "X0.3pct"
  names(df)[32] <- "X0.35n"
  names(df)[33] <- "X0.35pct"
  names(df)[34] <- "X0.4n"
  names(df)[35] <- "X0.4pct"
  names(df)[36] <- "X0.45n"
  names(df)[37] <- "X0.45pct"
  names(df)[38] <- "X0.5n"
  names(df)[39] <- "X0.5pct"
  names(df)[40] <- "X0.55n"
  names(df)[41] <- "X0.55pct"
  names(df)[42] <- "X0.6n"
  names(df)[43] <- "X0.6pct"
  names(df)[44] <- "X0.65n"
  names(df)[45] <- "X0.65pct"
  names(df)[46] <- "X0.7n"
  names(df)[47] <- "X0.7pct"
  names(df)[48] <- "X0.75n"
  names(df)[49] <- "X0.75pct"
  names(df)[50] <- "X0.8n"
  names(df)[51] <- "X0.8pct"
  names(df)[52] <- "X0.85n"
  names(df)[53] <- "X0.85pct"
  names(df)[54] <- "X0.9n"
  names(df)[55] <- "X0.9pct"
  names(df)[56] <- "X0.95n"
  names(df)[57] <- "X0.95pct"
  names(df)[58] <- "X1.0n"
  names(df)[59] <- "X1.0pct"
  names(df)[60] <- "role"
  names(df)[61] <- "shift"
  names(df)[62] <- "multi"
  names(df)[63] <- "only"
  names(df)[64] <- "runs"
  names(df)[65] <- "maxPop"
  names(df)[66] <- "equil"
  names(df)[67] <- "svive"
  names(df)[68] <- "thrive"
  names(df)[69] <- "tol"
  names(df)[70] <- "lowpct"
  names(df)[71] <- "initP"
  names(df)[72] <- "initB"
  names(df)[73] <- "maxP"
  names(df)[74] <- "cost"
  names(df)[75] <- "match"
  names(df)[76] <- "mexpB"
  names(df)[77] <- "mexpP"
  names(df)[78] <- "mmult"
  names(df)[79] <- "gamma"
  names(df)[80] <- "seed"
  df
}
scen_df2 <- function(scenario_set, file)
{
  path <- "/Users/stevedoubleday/Downloads/Fitnesse-Apr2011/ScenarioSet_"
  path_file <- paste(path,scenario_set,"/",file,sep="")
  df <- read.csv(path_file,header=TRUE,as.is=TRUE)
  names(df)[1] <- "Scen"
  names(df)[2] <- "Code"
  names(df)[3] <- "Period"
  names(df)[4] <- "NumB"
  names(df)[5] <- "NumP"
  names(df)[6] <- "Bar"
  names(df)[7] <- "Par"
  names(df)[8] <- "Bpay"
  names(df)[9] <- "Ppay"
  names(df)[10] <- "Delta"
  names(df)[11] <- "Adj"
  names(df)[12] <- "Aprot"
  names(df)[13] <- "Mprot"
  names(df)[14] <- "Moprot"
  names(df)[15] <- "Aprey"
  names(df)[16] <- "Mprey"
  names(df)[17] <- "Moprey"
  names(df)[18] <- "role"
  names(df)[19] <- "shift"
  names(df)[20] <- "multi"
  names(df)[21] <- "runs"
  names(df)[22] <- "maxPop"
  names(df)[23] <- "equil"
  names(df)[24] <- "svive"
  names(df)[25] <- "thrive"
  names(df)[26] <- "tol"
  names(df)[27] <- "lowpct"
  names(df)[28] <- "initP"
  names(df)[29] <- "initB"
  names(df)[30] <- "maxP"
  names(df)[31] <- "cost"
  names(df)[32] <- "match"
  names(df)[33] <- "mexpB"
  names(df)[34] <- "mexpP"
  names(df)[35] <- "mmult"
  names(df)[36] <- "gamma"
  names(df)[37] <- "seed"
  df
}
scen_df <- function(scenario_set, file)
{
  path <- "/Users/stevedoubleday/Downloads/Fitnesse-Apr2011/ScenarioSet_"
  path_file <- paste(path,scenario_set,"/",file,sep="")
  df <- read.csv(path_file,header=TRUE,as.is=TRUE)
  names(df)[1] <- "Scen"
  names(df)[2] <- "Period"
  names(df)[3] <- "NumB"
  names(df)[4] <- "NumP"
  names(df)[5] <- "Bar"
  names(df)[6] <- "Par"
  names(df)[7] <- "Bpay"
  names(df)[8] <- "Ppay"
  names(df)[9] <- "Delta"
  names(df)[10] <- "Adj"
  names(df)[11] <- "Aprot"
  names(df)[12] <- "Mprot"
  names(df)[13] <- "Moprot"
  names(df)[14] <- "Aprey"
  names(df)[15] <- "Mprey"
  names(df)[16] <- "Moprey"
  names(df)[17] <- "role"
  names(df)[18] <- "shift"
  names(df)[19] <- "multi"
  names(df)[20] <- "runs"
  names(df)[21] <- "maxPop"
  names(df)[22] <- "equil"
  names(df)[23] <- "svive"
  names(df)[24] <- "thrive"
  names(df)[25] <- "tol"
  names(df)[26] <- "lowpct"
  names(df)[27] <- "initP"
  names(df)[28] <- "initB"
  names(df)[29] <- "maxP"
  names(df)[30] <- "cost"
  names(df)[31] <- "match"
  names(df)[32] <- "mexpB"
  names(df)[33] <- "mexpP"
  names(df)[34] <- "mmult"
  names(df)[35] <- "gamma"
  names(df)[36] <- "seed"
  df
}
scen_add50 <- function(df)
{
  df <- add_high_initial(df)
  df <- add_total_initial(df)
  df <- add_total_after(df)
  df <- add_rate_growth_total(df)
  df <- add_rate_growth_bandit(df)
  df <- add_rate_growth_high(df)
  df <- add_rate_growth_low(df)
  df <- add_rate_share_bandit(df)
  df <- add_rate_share_high(df)
  df <- add_rate_share_low(df)
  df
}
scen_add2 <- function(df)
{
  df <- add_pbratio(df)
  df <- add_pbratioi(df)
  df
}
scen_add <- function(df)
{
  df <- scen_add2(df)
  df <- add_equilY(df)
  df
}
add_pbratio <- function(df)
{
  df <- cbind(df,df$Par/df$Bar)
  index <- ncol(df)
  names(df)[index] <- "PBratio"
  for (i in 1:nrow(df))
  {
     if (is.na(df[[i,index]])) {df[[i,index]] <- 0.1}
     if (df[[i,index]] == Inf) {df[[i,index]] <- 500}
     if (df[[i,index]] == 0) {df[[i,index]] <- 0.1}
  }
  df
}
add_pbratioi <- function(df)
{
  df <- cbind(df,df$initP/df$initB)
  index <- ncol(df)
  names(df)[index] <- "PBratioI"
  df
}
add_equilY <- function(df)
{
  df <- cbind(df,0)
  index <- ncol(df)
  names(df)[index] <- "equilY"
  for (i in 1:nrow(df))
  {
     if ((df$Adj[i] == 0) &&
        (df$Par[i] > 0) &&
        (df$Bar[i] > 0))
         {df[[i,index]] <- 1}
  }
  df
}
add_high_initial <- function(df)
{
  df <- cbind(df,df$initP-df$lowPn)
  index <- ncol(df)
  names(df)[index] <- "highPn"
  df
}
add_total_initial <- function(df)
{
  df <- cbind(df,df$initP+df$initB)
  index <- ncol(df)
  names(df)[index] <- "totalI"
  df
}
add_total_after <- function(df)
{
  df <- cbind(df,df$NumB+df$NumP)
  index <- ncol(df)
  names(df)[index] <- "totalA"
  df
}
add_rate_growth_total <- function(df)
{
  df <- cbind(df,(df$totalA-df$totalI)/df$totalI)
  index <- ncol(df)
  names(df)[index] <- "growthT"
  df
}
add_rate_growth_bandit <- function(df)
{
  df <- cbind(df,(df$NumB-df$initB)/df$initB)
  index <- ncol(df)
  names(df)[index] <- "growthB"
  df
}
add_rate_growth_high <- function(df)
{
  df <- cbind(df,(df$X0.7n-df$highPn)/df$highPn)
  index <- ncol(df)
  names(df)[index] <- "growthH"
  df
}
add_rate_growth_low <- function(df)
{
  df <- cbind(df,(df$X0.1n-df$lowPn)/df$lowPn)
  index <- ncol(df)
  names(df)[index] <- "growthL"
  df
}
add_rate_share_bandit <- function(df)
{
  df <- cbind(df,df$growthB-df$growthT)
  index <- ncol(df)
  names(df)[index] <- "shareB"
  df <- clean_nan_share(df,index)
  df
}
add_rate_share_high <- function(df)
{
  df <- cbind(df,df$growthH-df$growthT)
  index <- ncol(df)
  names(df)[index] <- "shareH"
  df <- clean_nan_share(df,index)
  df
}
add_rate_share_low <- function(df)
{
  df <- cbind(df,df$growthL-df$growthT)
  index <- ncol(df)
  names(df)[index] <- "shareL"
  df <- clean_nan_share(df,index)
  df
}
clean_nan_share <- function(df, index)
{
  for (i in 1:nrow(df))
  {
     if (is.na(df[[i,index]])) {df[[i,index]] <- 0}
  }
  df
}
create_frame <- function(df, value, index)
{
  sub_df <- subset(df,df[index]== value)
  sub_df
}
create_frames <- function(df, base, values, index)
{
  frames <- list()
  for (i in 1:length(values))
  {
    sname <- paste(base,values[i],sep="")
    assign(sname,create_frame(df,values[i],index),pos=.GlobalEnv)
    frames[[i]] <- get(sname)
    names(frames)[i] <- sname
  }
  frames
}
create_frames_from_frames <- function(dflist,values,index)
{
  frames <- list()
  k <- 0
  for (i in 1:length(dflist))
  {
     if (nrow(dflist[[i]]) > 0)
     {
       for (j in 1:length(values))
       {
          sname <- paste(names(dflist[i]),".",values[j],sep="")
          assign(sname,create_frame(dflist[[i]],values[j],index),pos=.GlobalEnv)
          if (nrow(get(sname)) > 0)
          {
            k <- k+1
            frames[[k]] <- get(sname)
            names(frames)[k] <- sname
          }
       }
     }
  }
  frames
}
save_df <- function(df, fname)
{
  write.csv(df,file=fname,quote=TRUE,eol="\r")
}
