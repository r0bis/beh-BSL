# knitr::opts_knit$set(root.dir = './out/')

# onePerson
if (props$onePerson=="YES") {
  onePerson <- TRUE
  } else {
    onePerson <- FALSE
}

uuidColumn <- props$uuidColumn

# date filter variables
startDT <- ymd_hm(paste(props$dateStart, props$timeStart))
endDT <- ymd_hm(paste(props$dateEnd, props$timeEnd))

if (is.na(startDT)) {
    stop('Start date or Time not in the right format in the properties file')
  }  else if (is.na(endDT)) {
    stop('Ending date or Time not in the right format in the properties file')  
}

# remove trailing dot from column names and set date datatype on submitdate
names(initData) <- gsub("\\.$", "", names(initData))
initData <- initData %>% mutate(submitdate = ymd_hms(submitdate))
initData <- initData %>% mutate(date = as_date(submitdate))

# restrict dataframe
# need to use !!as.name() construct to refer to column through variable
 initData <- initData %>% 
  filter(!!as.name(uuidColumn) == props$uuid) 

 mainData <- initData %>% 
   select(id,submitdate,matches("^ISQ|^PSQ|^BEQ|^SDQ"))
 
mainData <- mainData %>% 
  mutate(across(matches("^ISQ|^BEQ"), ~ as.numeric(factor(.,levels = c("not at all","a little","rather","much","very strong"))) -1 ))

