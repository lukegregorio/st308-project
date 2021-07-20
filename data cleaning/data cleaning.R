library(rvest)
library(dplyr)

get_films <- read.csv(file.choose(), sep = '\t')
get_names <- read.csv(file.choose(), sep = '\t')
get_ratings <- read.csv(file.choose(), sep = '\t')
get_crew <- read.csv(file.choose(), sep = '\t')
get_basics <- read.csv(file.choose(), sep = '\t')
get_akas <- read.csv(file.choose(), sep = '\t')
get_principals <- read.csv(file.choose(), sep = '\t')

#insert your own database of films (I used IMDB pro)
get_my_films <- read.csv(file.choose())

#lets get year into a column

nchar(my_films[1,1])
#ok so no white space can take last 6 characters out, create a function 

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

year <-  gsub('[[:punct:]]', '', year)
my_films$Year <- as.numeric(year)

#now lets remove year from name column

my_films$Name <- substr(my_films$Name, 1, nchar(my_films$Name) - 7)
run.time <- my_films$Run.time 
my_films$Run.time <- as.numeric(gsub('\\D', '', run.time))

#use excel to clean rest by hand, tag on language and country there 

#lets check out genres for each film
get_unique_genre <- rep(0,351)

#loop over each film
for (i in 1:351){
  get_unique_genre[i] <- strsplit(my_films$Genre[i], '[,]')
}

get_unique_genre <- unique(trimws(unlist(get_unique_genre)))

#alrights lets reduce these genres, to easy watch/light, dark/horror/thriler, romance, action as well, drama

#lets go music, musical, family just straight to light
ifelse(grepl('Music|Fam', my_films$Genre) | my_films$Genre == 'Comedy', 'Light', NA)

#lets go western, action to action
ifelse(grepl('West|Act', my_films$Genre), 'Action', NA)

#lets go horror & Noir  all to dark
ifelse(grepl('Horr|Noir', my_films$Genre), 'Dark', NA)

ifelse(ifelse(grepl('Music|Fam', my_films$Genre) | my_films$Genre == 'Comedy', 'Light', ifelse(grepl('Horr|Noir', my_films$Genre), 'Dark', 0)))

genres <- trimws(gsub('NA', '', paste(ifelse(grepl('Music|Fam', my_films$Genre) | my_films$Genre == 'Comedy' | grepl('Comedy&!Dra', my_films$Genre), 'Light', NA), ifelse(grepl('Horr|Noir', my_films$Genre) | grepl('Thri & Myst', my_films$Genre), 'Horror/Thriller', NA), ifelse(grepl('West|Act', my_films$Genre), 'Action', ifelse(grepl('Romance', my_films$Genre), 'Romance', NA )))))
my_films$'Genres' <- genres

#now lets resort out genre anomalies

my_films$Genres[my_films$Genres == 'Horror/Thriller Action'] <- 'Horror/Thriller'
my_films$Genres[my_films$Genres == 'Light  Romance'] <- 'Light'

#lets rename imdb genre column to avoid confusion

colnames(my_films)[4] <- 'IMDB_genre'

library(writexl)

write_xlsx(my_films, 'my films.Rdata')

#

library(stringr)
strsplit(my_films$Top.cast[1], '[,]')
actors.list <- vector(mode = "list", length = 351)

for (i in 1:351){
  actors.list[i] <- strsplit(my_films$Top.cast[i], '[,]')
}

actors.list <- lapply(actors.list, trimws)
actors.list[[1]][2]
lapply(actors.list, actors_fn)
351*3
actor.id <- vector(mode = "list", length = 351)

for (i in 1:351){
  actor.id[[i]] <- subset(get_names, primaryName == actors.list[[i]][1] |  primaryName == actors.list[[i]][2] |  primaryName == actors.list[[i]][3])[1:3,1:2]
}

actor.id <- do.call(rbind.data.frame, actor.id)
#lets get a star dummy now

star.id <- get_names[1:500, 1] 

actor.id$star <- ifelse(actor.id$nconst %in% star.id, 1, 0)

actor.id$'film' <- unlist(as.vector(lapply(my_films$Name, rep, 3)))
actor.id$film <- (as.factor(actor.id$film))

library(dplyr)

get_star <- actor.id %>%
  group_by(film)%>%
  summarise(has.star = max(star))

colnames(get_star)[1] <- 'Name'

my_films <- merge(get_star, my_films, by = 'Name')

#so i need to get each title and their key, alright here we go

subset(get_films, startYear == 1995 & get_films$primaryTitle == 'Before Sunrise')[,1]

#now lets build a function or whatever, lapply probs useful too
database.id <- rep(0, 351)
get_films$runtimeMinutes <- as.numeric(get_films$runtimeMinutes)

for (i in 1:351){
 database.id[i] <- subset(get_films, startYear == my_films$Year[i] & primaryTitle == my_films$Name[i] & runtimeMinutes == my_films$Run.time[i])[1,1]
}


#now lets get languagesfrom excel classification

languages <- ifelse(my_films$Country == 'UK' | my_films$Country == 'AU' | my_films$Country == 'US' | my_films$Country == 'EU' | my_films$Country == 'CA', 'English', 
       ifelse(my_films$Country == 'SP' | my_films$Country == 'WO', 'Spanish',
               ifelse(my_films$Country == 'IT', 'Italian',
                      ifelse(my_films$Country == 'FR', 'French', 
                             ifelse(my_films$Country == 'SK', 'Korean',
                                    ifelse(my_films$Country == 'JA', 'Japanese', 
                                           ifelse(my_films$Country == 'HK', 'Cantonese', 'English')))))))

my_films$Language[which(is.na(my_films$Language))] <- languages[which(is.na(my_films$Language))]

#coerce ratings into numeric

my_films$IMDb.Rating <- as.numeric(substring(my_films$IMDb.Rating, 1,3))

#ok lets mess about with years, try a continous using years since release first, then just group into categories in second, note eras motivated by my own classification roughly
