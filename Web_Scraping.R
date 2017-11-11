#Loading the rvest package.
library(rvest)

# Url for website to be scrapped.
url = 'http://www.imdb.com/title/tt2193021/reviews?filter=chrono;filter=chrono;start=0'

# Reading the HTML code from the website
webpage = read_html(url)

# This is what to be extracted fro the website.
# Show:        Show name.
# Date:        Date of review.
# Description: Review text by user.
# Rating:      Rating by user.

#===============================================
# Get show's name
#===============================================
show_name = html_text(html_nodes(webpage,'.main'))

# Preprocess
show_name = gsub("[^[:alnum:][:blank:]+?&/\\-]","",show_name)
show_name

#===============================================
# Get date of review
#===============================================
date = html_text(html_nodes(webpage,'#tn15content div small'))

# Preprocess
date = as.Date(date,format = "%d %B %Y")
date = na.omit(date)
date

#===============================================
# Get review
#===============================================
review = html_text(html_nodes(webpage,'#tn15content > p'))

# Remove Last blank value
review = review[-length(review)]

# Preprocess
review = gsub("\n"," ",review)
review = gsub("\""," ",review)
review

#===============================================
# Get rating
#===============================================
rating = html_attr(html_nodes(webpage,'#tn15content > div > img'),"alt")

# Preprocess
rating = as.numeric(gsub("/.*","",rating))
rating = as.factor(rating)
rating

#===============================================
# Check length of all
#===============================================
length(show_name) # 1
length(date) # 10
length(review) # 10
length(rating) # 10

#===============================================
# Combining all in a data frame
#===============================================
show.df = data.frame(Show = show_name, Date = date,
                     Review = review, Rating = rating)

# View Data frame
View(show.df)

# Get todays Date.
now = Sys.Date()

# Save file with show name from site
write.csv(show.df,paste("output/",show_name,"_",now,".csv",sep = ""),row.names = FALSE)


