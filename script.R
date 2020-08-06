library(arules)

### Import Dataset

tabular_transaction <- read.transactions(file="data_input/transaksi_dqlab_retail.tsv", format="single", sep="\t", cols=c(1,2), skip=1)
write(tabular_transaction, file="data_input/project_retail_1.txt", sep=",")


### Initial Output: Top 10 Statistics

data_item <- itemFrequency(tabular_transaction, type="absolute")
data_item <- sort(data_item, decreasing = TRUE)
data_item <- data_item[1:10]
data_item <- data.frame("Nama Produk"=names(data_item), "Jumlah"=data_item, row.names=NULL)

#### The results are saved in the `top10_item_retail.txt` file.

write.csv(data_item, file="data_output/top10_item_retail.txt")


### Initial Output: Bottom 10 Statistics

data_item2 <- itemFrequency(tabular_transaction, type="absolute")
data_item2 <- sort(data_item2, decreasing = FALSE)
data_item2 <- data_item2[1:10]
data_item2 <- data.frame("Nama Produk"=names(data_item2), "Jumlah"=data_item2, row.names=NULL)

#### saved in the `bottom10_item_retail.txt` file.

write.csv(data_item2, file="data_output/bottom10_item_retail.txt")


### Get a list of all product package combinations with strong correlations
#### Get interesting product combinations:

apriori_rules <- apriori(tabular_transaction, parameter=list(supp=10/length(tabular_transaction), conf=0.5, minlen=2, maxlen=3))
apriori_rules <- head(sort(apriori_rules, by='lift', decreasing = TRUE),n=10)
inspect(apriori_rules)

#### saved in the `retail_combination.txt` file.

write(apriori_rules, file="data_output/retail_combination.txt")


### Get a list of all product package combinations with specific items
#### Look for Product Packages that can be paired with a Slow-Moving Item

transaction_file <- "data_input/transaksi_dqlab_retail.tsv"
tabular_transaction2 <- read.transactions(
  file = transaction_file, 
  format = "single", 
  sep = "\t", 
  cols = c(1,2), 
  skip = 1
)
transaction_amount <- length(tabular_transaction2)
minimal_appearance_count <- 10

apriori_rules_a <- apriori(
  tabular_transaction2, 
  parameter= list(
    supp=minimal_appearance_count/transaction_amount,
    conf=0.1, 
    minlen=2, 
    maxlen=3)
)

#### Filter
apriori_rules1 <- subset(apriori_rules_a, lift > 1 & rhs %in% "Tas Makeup")
apriori_rules1 <- sort(apriori_rules1, by='lift', decreasing = T)[1:3]

apriori_rules2 <- subset(apriori_rules_a, lift > 1 & rhs %in% "Baju Renang Pria Anak-anak")
apriori_rules2 <- sort(apriori_rules2, by='lift', decreasing = T)[1:3]

apriori_rules_a <- c(apriori_rules1, apriori_rules2)

inspect(apriori_rules_a)

#### The results are saved in the `retail_combination_slow_moving.txt` file.

write(apriori_rules_a,file="data_output/retail_combination_slow_moving.txt")



