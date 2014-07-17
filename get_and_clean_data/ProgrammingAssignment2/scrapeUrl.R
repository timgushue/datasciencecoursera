# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
# http://biostat.jhsph.edu/~jleek/contact.html 
# (Hint: the nchar() function in R may be helpful)

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)

lines <- c(10, 20, 30, 100)
result <- c()

for (i in lines) {
  result <- append(result, nchar(htmlCode[i]))
}
result