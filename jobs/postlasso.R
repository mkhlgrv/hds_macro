source('~/investment_forecasting/lib.R')
source('~/investment_forecasting/fun.R')

out_postlasso <-
  expand.grid(startdt = c(as.Date('1996-01-01'), as.Date('2000-01-01')),
              enddt = seq(as.Date('2012-10-01'), as.Date('2018-10-01'), by = 'quarter'),
              lag = c(0L),
                      h=c(0L:8L), 
                      model = c('postlasso')
) %T>% 
  (function(x) {assign('N', nrow(x), envir = globalenv())}) %>%
  split(seq(1:nrow(.))) %>%
  
  imap(function(x, i){
    train.model(startdt=x$startdt,
                enddt=x$enddt,
                model = x$model,
                lag=x$lag,
                h=x$h,
                i = i,
                N = N
    )
  })

save(out_postlasso,
     file = 'out/full/out_postlasso.RData')

short_postlasso <- out_postlasso %>%
  map_dfr(function(x){
    data.frame(model=x$model,
               lag = x$lag,
               startdt= x$startdt,
               enddt= x$enddt,
               h = x$h,
               date = x$date,
               pred=x$pred) 
    
  })
save(short_postlasso, file = 'out/short_postlasso.RData')

