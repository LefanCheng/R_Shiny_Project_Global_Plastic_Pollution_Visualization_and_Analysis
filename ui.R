shinyUI(
  dashboardPage(
    #header + skin + sidebar panel#### 
    skin = 'green',
    dashboardHeader(
      title = "Plastic Pollution"
    ),
    #sidebar panel 
    dashboardSidebar(
      sidebarUserPanel("Fred Cheng",
                      image = "https://media.licdn.com/dms/image/C4E03AQF8BIVnKpB-Fg/profile-displayphoto-shrink_200_200/0?e=1568851200&v=beta&t=yYiiVQhqZK5BjjbwjijHibbQ5fW-5xbD9O4J64U6NgQ"),
      sidebarMenu(
        menuItem("Introduction", tabName = "intro", icon = icon("dove")),
        menuItem("Exploration", tabName = "explore", icon = icon("map")),
        menuItem("Analysis", tabName = "analysis", icon = icon("chart-line")),
        menuItem("Conclusion", tabName = "conc", icon = icon("box-open")),
        menuItem("Data", tabName = "data", icon = icon("database")),
        menuItem("Author", tabName = "self", icon = icon("user-graduate"))
        )
    ),
    
    #Introduction####
    dashboardBody(
      tabItems(
        #Intro
        tabItem(
          tabName = 'intro',
          fluidPage(
            box(
              background = 'light-blue',
              h2('Exploratory Data Analysis and Visualization - Discovering relationships between features of countries and plastic pollution.'),
              h3('The global plastic production has mushroomed over the past 70 years'),
              tags$p("In 1950 the world produced only 2 million tonnes per year. Since then, annual production has increased nearly 200-fold, reaching 381 million tonnes in 2015. For context, this is roughly equivalent to the mass of two-thirds of the world population. An estimated 8.3 billion tons of plastic have been produced since the 1950s — that’s equivalent to the weight of more than 800,000 Eiffel Towers. And only 9% of it has been recycled."),
              plotlyOutput("lineplot"),
              h3('Facts about Plastic Pollution We Absolutely Need to Know: '),
              tags$p("- Worldwide, about 2 million plastic bags are used every minute."),
              tags$p("- New Yorkers alone use 23 billion plastic bags every year (from NYCDEC)"),
              tags$p("- The average time that a plastic bag is used for is 12 minutes, while it takes around 500 years to bio-degrade in the ocean!"),
              tags$p("- Plastic is killing more than 1.1 million seabirds and animals every year and suffering astronomical number of animals."),
              tags$p("- The pollution eventually return to us - The average person eats 70,000 microplastics each year."),
              tags$p("- The governance of plastic pollution has become the problems that brook no delay and can be issued starting from ourselves."),
              img(src="https://ourworldindata.org/exports/decomposition-rates-marine-debris_v2_850x600.svg"
                  ,width="50%"),
              h3('You should watch this: Plastic Ocean'),
              tags$iframe(src="https://www.youtube.com/embed/ju_2NuK5O-E",
                          width="653",height="367"),
              h3('Variables of Dataset:'),
              tags$p('Country, Population, Coastal Population, Economic Development, Continent, Geographical Feature, GDP Per Capita, Plastic Waste Generation, Plastic Waste Per Capita, Mismanaged Plastic Generation, Mismanaged Plastic Per Capita, Mismanaged Plastic Share, Inadequately Managed Plastic Waste Share(Highest Risk), 2008-2010 Average GDP Per Capita Growth Rate, 3 Years GDP Growing Status'),
              tags$p("Note: Mismanaged waste: Material that is either littered or inadequately disposed (the sum of littered and inadequately disposed waste), which could eventually enter the ocean via inland waterways, wastewater outflows, and transport by wind or tides and has much higher risk of entering the ocean and contaminating the environment."),
              tags$p("      Inadequately managed waste: Waste is not formally managed and includes disposal in dumps or open, uncontrolled landfills, where it is not fully contained. Inadequately managed waste has high risk of polluting rivers and oceans. This does not include 'littered' plastic waste, which is approximately 2% of total waste."),
              h3('Goal of the analysis: Discovering relationships between features of countries and plastic pollution.'),
              tags$p('<- Click items on the side bar to explore'),
              width = 12
              )
            )
          ),
        #Explore####
        tabItem(tabName = "explore",
                fluidPage(
                  box(
                    background = 'light-blue',
                    h2('Explore Global Plastic Pollution'),
                fluidRow(column(4, 
                                selectizeInput(inputId = "selected", 
                                               label = "Select a variable to explore",
                                               choices = Dict[,2], 
                                               selected = TRUE))),
                fluidRow(column(h3("Observation"),
                                tags$p(textOutput("text1")),
                                    width = 12)), 
                fluidRow(column(7,
                         box(htmlOutput("map"),
                             height = 500,width = 12)),
                column(5,
                         box(title = "Top 8 Countries",
                             plotlyOutput("barChart1"),
                             height = 500, width = 12)
                          
                        ))
                ,width = 12)
                    )
                  ),
        #Analysis####
        tabItem(tabName = "analysis",
                tabsetPanel(type = 'tabs',
                            tabPanel('Analysis about Plastic Waste',
                                     fluidRow(box(
                                              background = 'light-blue',
                                              h2("Plastic waste tends to increase as people and countries get richer"),
                                              tags$p("GDP Per Capita has a positive linear relationship with Plastic Waste Per Capita"),
                                              tags$p("Per capita plastic waste at low-income countries is noticeably smaller"),
                                              plotlyOutput("bubbleGDPWastePC"),
                                              tags$p("Note: x-axis takes log10 as base, which actually ranges from $0 to $100,000 after log"),
                                              tags$p("Note: 0 represents missing value"),
                                              h3("The plastic waste per person in developed countries are significantly greater than developing countries"),
                                              plotlyOutput("boxplot4"),
                                              tags$p("Note: 0 represents missing value"),
                                              width=12))),
                            tabPanel('Analysis about Mismanaged Plastic Waste',
                                     fluidRow(box(
                                              background = 'light-blue',
                                              h2("Mismanaged plastic waste tends to be higher in industrialized middle-income and fast-growing developing countries"),
                                              tags$p("Because their waste management infrastructure has failed to keep pace with their rapid industrial and manufacturing growth."),
                                              tags$p("And they import massive quantities of plastic trashes from developed countries which is also the reason why developed countries have such a small amount of mismanaged plastic waste while having a great amount of plastic waste."),
                                              tags$p("Therefore, development of effective waste management infrastructure in middle-income and growing lower-income countries is crucial to tackling the issue of plastic pollution. And developing countries should reject receiving trashes from developed countries to prompt them to cut down waste and improve recycling"),
                                              plotlyOutput("bubbleGDPWastePC2"),
                                              tags$p("x-axis takes log10 as base, it actually ranges from $0 to $100,000 after log "),
                                              plotlyOutput("boxplot3"),
                                              h2("It seems that fast-growing countries have less mismanaged plastic waste on average"),
                                              tags$p("Might becasue the most of them are either landlocked oil-rich countries or low-income countries whose demand have not surged yet"),
                                              plotlyOutput("boxplot2"),
                                              tags$p("Note: Economic growth here is measured by the average Per Capita GDP growing rate from 2008 to 2010 (financial crisis). When it's greater than 3%: Inflation, greater than 0% and lower than 3%: Normal, and less than 0%: Recession"),
                                              tags$p("Note: 0 represents missing value"),
                                              width=12))),
                            tabPanel('Analysis about Coastal Population and Geographical Feature',
                                     fluidRow(box(
                                              background = 'light-blue',
                                              h2("Costal population has a positive correlation with mismanaged plastic waste across counties."),
                                              tags$p("Because waste generated in coastal region has higher risk of entering the ocean and producing severe environmental damage."),
                                              tags$p("Note: Coastal population measured as the population within 50 kilometres of a coastline"),
                                              plotlyOutput("bubbleGDPWastePC3"),
                                              h2("Coastal countries have much higher mismanaged plastic waste per person than landlocked countries"),
                                              plotlyOutput("boxplot1"),
                                              width=12)
                                              )
                                     )
                            )
                ),
        #Conclusion####
        tabItem(tabName = "conc",
                fluidRow(box(
                  background = 'light-blue',
                  h2("Conclusions"),
                  tags$p("- Plastic waste tends to increase as people and countries get richer"),
                  tags$p(" "),
                  tags$p("- Mismanaged plastic waste tends to be higher in industrialized middle-income and fast-growing developing countries. Because their waste management infrastructure has failed to keep pace with their rapid industrial and manufacturing growth. And they import massive quantities of plastic trashes from developed countries which is also the reason why developed countries have such a small amount of mismanaged plastic waste while having a great amount of plastic waste. Therefore, development of effective waste management infrastructure in middle-income and growing lower-income countries is crucial to tackling the issue of plastic pollution. And developing countries should reject receiving trashes from developed countries to prompt them to cut down waste and improve recycling."),
                  tags$p(" "),
                  tags$p("- Costal population has a positive correlation with mismanaged plastic waste across counties. And coastal countries have much higher mismanaged plastic waste per person than landlocked countries. Because waste generated in coastal region has higher risk of entering the ocean and producing severe environmental damage."),
                  width = 12)
                )
              ),
        #dataset####
        tabItem(tabName = "data",
                fluidRow(box(DT::dataTableOutput("table"),
                             width = 12)
                         ),
                tags$p("reference: http://advances.sciencemag.org/content/3/7/e1700782.full, Data published by Geyer, R., Jambeck, J. R., & Law, K. L. (2017). Production, use, and fate of all plastics ever made. Science Advances, 3(7), e1700782."),
                tags$p("reference: http://science.sciencemag.org/content/347/6223/768/, Data published by	Jambeck, J. R., Geyer, R., Wilcox, C., Siegler, T. R., Perryman, M., Andrady, A., ... & Law, K. L. (2015). Plastic waste inputs from land into the ocean. Science, 347(6223), 768-771."),
                tags$p("reference: https://ourworldindata.org/plastic-pollution#impacts-on-wildlife, Plastic Pollution by Hannah Ritchie and Max Roser, was first published in September 2018.")
                ),
        #self-intro####
        tabItem(tabName = "self",
                fluidRow(
                  column(4,
                    img(src="./FredCheng.jpeg",
                    width=400,
                    height=600)
                    ),
                  column(8,box(
                    background = 'green',
                    h2("Fred(Lefan) Cheng"),
                    tags$p("New York University master graduate student majoring in Management and Systems with a Finance undergraduate degree from a top 50 global university in Hong Kong. I started my own company and I have internship experiences in Venture Capitals and Banking. I’m helping an American company to grow its business. I’m seeking an internship for data science or data analytics position in a fast-growing dynamic company, where I can leverage my data science, financial, marketing, and entrepreneurial knowledge to bring value to your company by enhancing your revenue and customer value. My composite educational background has provided me with a substantial opportunity to discover complex issues through an interdisciplinary lens and solve them.I’m hungry and quick to learn, a good bilingual communicator, and a problem solver who is self-motivated and willing to work hard while managing my productivity. "),
                    tags$a(href = 'https://www.linkedin.com/in/lefancheng/', "Visit Fred's Linkedin"),
                    width = 6,
                    height = 600)))
              )
        )
    )
  )
)
