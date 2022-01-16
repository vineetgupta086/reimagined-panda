#install.packages("httr"); install.packages("jsonlite")
pacman::p_load(jsonlite,dplyr,stringr)

#emission products to be analysed
product <- c("methane", "carbonmonoxide","ozone","nitrogendioxide")

#World Citites and their geographic coordinates
#source: https://simplemaps.com/data/world-cities
raw_data <-read.csv("https://raw.githubusercontent.com/vineetgupta086/data/main/worldcities.csv"
                    ,sep=",",header = TRUE)

#cities of our interest
cities <-read.csv("https://raw.githubusercontent.com/vineetgupta086/data/main/cities.csv",
                  sep="\n",header = FALSE, col.names = "city_ascii")

#inner join of the above datasets
city_data <- merge(x=cities,y=raw_data,by.x="city_ascii",all.x=TRUE,sort = TRUE)

#restructure data
city_data <- city_data %>%
  select(city_ascii,lng,lat) %>%
  rename(city = city_ascii)

#create checkpoint
city_data_copy = city_data

#remove data that we don't need anymore
rm(raw_data,cities)

#gets coordinates for each city passed as an argument
fetch = function(c){
  value = city_data[city_data$city==c,]
  return (c(value[1,2], value[1,3]))
}

#Empty dataframe: city X product
product_data = data.frame(
  row.names = city_data$city,
  methane=rep(0,20),
  carbonmonoxide=rep(0,20),
  ozone=rep(0,20),
  nitrogendioxide=rep(0,20)
)

#fetching data from api, and storing mean emission throughout the history

for(i in city_data$city){
  coor = fetch(i)
  for(j in product){
    my_url = str_c("https://api.v2.emissions-api.org/api/v2/",j,"/average.json?point=",
                coor[1],"%2C",coor[2],"&offset=0")
    temp = read_json(path = my_url,simplifyVector = T)
    product_data[i,j] = mean(temp$average)
  }
}

#remove objects we don't need anymore
rm(i,j,city_data,city_data_copy,coor,fetch,my_url,temp)

#View product data
View(product_data)

#summary
summary(product_data)

#logistics regression
my_model = glm(formula = methane~carbonmonoxide+ozone+nitrogendioxide,
               family=gaussian,data=product_data)
View(my_model)

#predicting missing value
missing_bool<- as.logical(rowSums(is.na(product_data)))
missing_rows<-product_data[missing_bool,]; print(missing_rows)

coeff = product_data["Mumbai",]*my_model[["coefficients"]]

product_data["Mumbai","methane"] = my_model[["coefficients"]][["(Intercept)"]] + sum(coeff[2:4])
print(product_data["Mumbai","methane"])