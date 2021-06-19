# knitr::opts_knit$set(root.dir = './out/')



uuidColumn <- str_trim(props$uuidColumn)
uuid <- str_trim(props$uuid)

# date filter variables
startDT <- ymd_hm(paste(str_trim(props$dateStart), str_trim(props$timeStart)))
endDT <- ymd_hm(paste(str_trim(props$dateEnd), str_trim(props$timeEnd)))

if (is.na(startDT)) {
    stop('Start date or Time not in the right format in the properties file')
  }  else if (is.na(endDT)) {
    stop('Ending date or Time not in the right format in the properties file')  
}

# remove trailing dot from column names, normalize id column name (on windows 
# due to charset oddities it is not simply called <id> but rather <?..id> )
# and set date datatype on submitdate
names(initData) <- gsub("\\.$", "", names(initData))
initData <- initData %>% rename(id = 1) 
initData <- initData %>% mutate(submitdate = ymd_hms(submitdate))
initData <- initData %>% mutate(date = as_date(submitdate))

# restrict dataframe
# need to use !!as.name() construct to refer to column through variable
 initData <- initData %>% 
  filter(!!as.name(uuidColumn) == uuid) 

# subset to get only id, submitdate and actual survey questions
mainData <- initData %>% 
   select(id,submitdate,matches("^ISQ|^PSQ|^BEQ|^SDQ")) 
 
mainData <- mainData %>% 
  mutate(across(matches("^ISQ"), ~ as.numeric(factor(.,levels = c("not at all","a little","rather","much","very strong"))) -1 )) %>% 
  mutate(across(matches("^BEQ"), ~ as.numeric(factor(.,levels = c("not at all","once","2-3 times","4-6 times","daily or more often"))) -1 ))

# original mutate call was:
# mutate(across(matches("^ISQ|^BEQ"), ~ as.numeric(factor(.,levels = c("not at all","a little","rather","much","very strong"))) -1 ))
# it was due to putting the same labels in questions about internal state and about behaviour
# once the labels for behaviour questions were changed in Limesurvey the downloaded data reflected this uniformly
# a very useful property to know about limesurvey - the answer code is stored 
# and labels get applied only upon data export

