# Overview

This program is designed to serve three functions. 

The first function is to use data (either imported through an Excel file or a CSV file) to create a linear regression model and to give the linear regression formula for the chosen data. For this, you may also use the file (defaultTestData.csv) provided in the directory.

The second function is a series of manipulations of a integer provided by the user to create a complex number and show the properties of said complex number.

The third function is a "Magic Number Game." This game is a fun way to see how many steps you can get before coming to the magic number (4). It uses the number of characters in the string name of the number to calculate the next number, and on and on until coming to the magic number.

-----

My purpose in writing this software is to increase my knowledge of both R and Shiny. In using all the datatypes, data frames, lists, and vectors, etc., I have been able to understand the full potential of the R programming language.

[Software Demo Video](https://www.loom.com/share/b3f8f3684c8648d4bfad9f334bb49911?sid=6cf761bb-1dc3-42ab-a5e2-fbb971053f48)

# Development Environment

I primarily used RStudio as I wrote this, since I found it easier to use than VSCode. RStudio seemed to react better to the ShinyApp that I used. It also reacted better to svDialogs.

This program was written in R, a language that specializes in mathematics and statistical analysis. The libraries I used were as follows: 
1. Bolstad; I used this to do linear regression and statistical analysis.
2. tidyverse; I used this to visualize and manipulate data.
3. svDialogs; I used this to interact with the user with simple message and dialogue boxes.
4. ggplot2; I used this to help plot the data.
5. shiny; I used this to create a window for the user to customize the data input.
6. DT; This helped create the interactive data table for the Shiny app.
7. rio; This helps me read and write files (Excel and CSV in this program).

# Useful Websites

- [Using Complex Numbers in R](https://www.johnmyleswhite.com/notebook/2009/12/18/using-complex-numbers-in-r/)
- [How to find the length of a string in R](https://stackoverflow.com/questions/11134812/how-to-find-the-length-of-a-string-in-r)
- [How to Round Numbers in R (5 Examples)](https://www.statology.org/round-in-r/)
- [R Data Types](https://www.w3schools.com/r/r_data_types.asp)
- [R Data Frames](https://www.w3schools.com/r/r_data_frames.asp)
- [Generate a Pop-up box in R](https://stackoverflow.com/questions/35873261/generate-a-pop-up-box-in-r)
- [Linear Regression in R | A Step-by-Step Guide & Examples](https://www.scribbr.com/statistics/linear-regression-in-r/)
- [Dialog Boxes under Windows](https://www.math.ucla.edu/~anderson/rw1001/library/base/html/winDialog.html)
- [R For Loop](https://www.w3schools.com/r/r_for_loop.asp)
- [Execution Pause for X Seconds in R (Example)](https://statisticsglobe.com/execution-pause-for-x-seconds-in-r)
- [How to Import CSV Files into R (Step-by-Step)](https://www.statology.org/import-csv-into-r/)
- [Check If a String in R ends with Another String](https://datascienceparichay.com/article/check-if-a-string-in-r-ends-with-another-string/)
- [Importing Data](https://intro2r.com/importing-data.html)
- [How to Get Column Names in R](https://www.statology.org/r-get-column-names/)
- [Adding a regression line on a ggplot](https://stackoverflow.com/questions/15633714/adding-a-regression-line-on-a-ggplot)
- [text: Add Text to a Plot](https://rdocumentation.org/packages/graphics/versions/3.6.2/topics/text)
- [Shiny](https://shiny.posit.co/)
- [Shiny: Reactives and Observers](https://shiny.posit.co/r/getstarted/build-an-app/reactivity-essentials/reactives-observers.html)
- [How to make datatable editable in R shiny](https://stackoverflow.com/questions/70155520/how-to-make-datatable-editable-in-r-shiny)
- [Making Tables Shiny: DT, formattable, and reactable](https://clarewest.github.io/blog/post/making-tables-shiny/)
- [Initializing data.frames()](https://stackoverflow.com/questions/4868903/initializing-data-frames)
- [How to set the current file location as the default working directory in R programming?](https://stackoverflow.com/questions/35074911/how-to-set-the-current-file-location-as-the-default-working-directory-in-r-progr)
- [Progress bars in R using winProgressBar](https://www.programmingr.com/content/progress-bars-in-r-using-winprogressbar/)
- [Statistics Notebook : Linear Regression](https://byuistats.github.io/Statistics-Notebook/LinearRegression.html)
- [Access a URL and read Data with R](https://stackoverflow.com/questions/6299220/access-a-url-and-read-data-with-r)
- [Display a modal message box](https://www.sciviews.org/svDialogs/reference/dlg_message.html)
- [Modify axis, legend, and plot labels](https://ggplot2.tidyverse.org/reference/labs.html)
- [How to Use length() Function in R](https://www.statology.org/length-function-in-r/)
- [Count the number of integer digits](https://stackoverflow.com/questions/47190693/count-the-number-of-integer-digits)
- [R: splitting a numeric string](https://stackoverflow.com/questions/10871525/r-splitting-a-numeric-string)
- [Creating a List in R](https://www.datacamp.com/tutorial/creating-lists-r)

# Future Work

- Expand the Magic Number Game to include numbers beyond 10.
- Finding the problem in the Shiny App and fixing it so that it always works.
- Optimize and fix errors on the "Online" and "On Computer" CSV and Excel document uploading process.
