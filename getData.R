# read properties - aka parameters / variables
props <- read.properties("fbHWU-BSL-01.properties")

### Reading in data
# GET data

options(lime_api = props$limeAPI)
options(lime_username = props$limeUser)
options(lime_password = props$limePassword)

### Reading in data

skey <- get_session_key()
if(skey == '') { stop("No connection to database. Is network running OK?")}

## Illustration of call_limer
# svlist <- call_limer(method = "list_surveys")
# call_limer(method = "get_summary", 
#            params = list(iSurveyID = 784141,
#                          sStatname = "completed_responses"))
# usrs <- call_limer(method="list_users")

initData <- get_responses(props$limeSurveyNumber)
# clear session with limesurvey, do not print output of this (via invisible)
invisible(release_session_key())
