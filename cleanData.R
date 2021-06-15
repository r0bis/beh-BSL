# knitr::opts_knit$set(root.dir = './out/')



uuidColumn <- strtrim(props$uuidColumn)
uuid <- strtrim(props$uuid)

# date filter variables
startDT <- ymd_hm(paste(str_trim(props$dateStart), str_trim(props$timeStart)))
endDT <- ymd_hm(paste(str_trim(props$dateEnd), strtrim(props$timeEnd)))

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
  mutate(across(matches("^ISQ|^BEQ"), ~ as.numeric(factor(.,levels = c("not at all","a little","rather","much","very strong"))) -1 ))

