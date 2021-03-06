# Line chart

data <- read.csv("../rawData/data.csv", header = TRUE, quote = "\"", dec = ".", fill = TRUE, comment.char = "", na.strings = "-")

# name of the X and Y axis labels
xLabel <- "Year"
yLabel <- "# of primary studies"

# name of the column of interest
columnName <- "Year.of.publication"


# one element for each possible year
yearsInt <- c(min(data[[columnName]]):max(data[[columnName]]))#c("2006","2007","2008","2009","2010", "2011","2012","2013","2014", "2015")
years <- as.factor(yearsInt)

#############################################################################

# twin array of possibleValue storing the values of each possible element
counts <- vector("integer", length(years))
for (i in 1:length(years)) {
  counts[i] <- 0
}

# the labels to be used in the line chart
labels <- ""

# counting the elements for each possible value
for (el in data[[columnName]]) {
  for (i in 1:length(years)) {
    if(grepl(years[i], el)) {
      counts[i] <- as.integer(counts[i]) + 1
    }
  }
}

# lastYear = counts[length(counts)]
# lastYearPercentage = round(lastYear/sum(counts) * 100, 2)

# compute the factor to which elements values must be scaled
#pct <- round(counts/sum(counts) * 100, 1)
#pct[length(pct)] <- pct[length(pct)] + 0.1
# we add the percentages to the labels
#labels <- paste(counts, "\n", pct, "%", sep="") # add percents to labels 
labels <- counts
#labels <- sub("0\n0%", "", labels)

# load the library ggplot2
library(ggplot2)

xSize <- 7.5
ySize <- 3

marginLeft <- 0
marginBottom <- 0
marginTop <- 0
marginRight <- 0

fileName <- "../../paper/figures/YearOfPublication.pdf"

cairo_pdf(fileName, width=xSize, height=ySize)
par(mar=c(marginBottom, marginLeft, marginTop, marginRight))
par(mfrow=c(1, 1))
par(las=1)

# create the dataframe
df.papers <- data.frame(years,counts)

library(cowplot)
# in p now we have the final plot
p =ggplot(data=df.papers, aes(x=years, y=counts, group=1)) +
  geom_text(data=df.papers,aes(x=years,y=counts,label=labels),size=3, alpha=1, lineheight=1, vjust=-1.2,hjust=.5) + 
  labs(x=xLabel, y=yLabel) +
  theme_cowplot() +
  geom_point(size=3) + 
  ylim(0, max(counts) + 10) + 
  #coord_fixed(ratio=.1) + 
  geom_line(data=subset(df.papers, years != "2017")) + 
  geom_line(linetype="dashed", data=subset(df.papers, years = "2017")) +
  theme(axis.line = element_line(color = 'black'), axis.text.y = element_text(size=10), axis.text.x = element_text(size=10))
print(p)
dev.off()
