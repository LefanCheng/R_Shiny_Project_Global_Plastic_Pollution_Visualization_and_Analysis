server <-function(input, output){
  
  output$lineplot <- renderPlotly({
    global_plastic_production <- gpp %>% 
      mutate(Tons=round(Tons/1000000,0)) %>% 
      ggplot(aes(x=Year,y=Tons)) +
      geom_line() +
      geom_point(aes(color=Tons)) +
      ylab('Tonnes(million)') +
      ggtitle('Global plastics production from 1950 to 2015')
    ggplotly(global_plastic_production) %>% 
      layout(width="40%")
  })
  
  VDict = reactive({
    f = which(Dict==input$selected, arr.ind=T)
    return(Dict[f[1],1])
  })

  output$map <- renderGvis({
    gvisGeoChart(plastic, "Country", VDict(), #state.name tells this column contains the state name
                 options=list(region="world",
                              displayMode="regions",
                              gvis.editor="Other Charts",
                              projection="kavrayskiy-vii",
                              # width="600px", height="300px",
                              width="100%",height="120%",
                              # height = "[{keepAspectRatio:'TRUE'}]",
                              # width = "[{keepAspectRatio:'TRUE'}]",
                              colorAxis="{colors:['#91BFDB', '#FC8D59']}"))
  })
  
  output$bubbleGDPWastePC <- renderPlotly({
    
    bubble_GDP_WastePC <- plastic %>% 
      mutate(GDP.PC=round(GDP.PC,0)) %>%
      mutate(Ppl=round(Ppl/1000000,2)) %>%
      mutate(PWaste.PC=round(PWaste.PC,2)) %>%
      arrange(desc(Ppl)) %>%
      mutate(Country = factor(Country, Country)) %>%
      mutate(text = paste("Country: ", Country, "\nPopulation (M): ", Ppl, "\nPlastic Waste Per Capita: ", PWaste.PC, "\nGDP per capita: ", GDP.PC, sep="")) %>%
      ggplot(aes(log10(x = GDP.PC), y = PWaste.PC, color = Continent, size = Ppl, text=text),tooltip="text") + 
      geom_point(alpha = 0.5) +
      ylim(0, 0.69) +
      scale_color_manual(values = c("#00AFBB", "#FC4E07", "#E7B800","#CC6666", "#9999CC", "#66CC99","#FF6666")) +
      scale_size(range = c(0.5, 10)) +  # Adjust the range of points size
      xlab('GDP per capita, PPP') + 
      ylab('Per capita plastic waste') +
      ggtitle('Per capita plastic waste vs. GDP per capita, 2010')
    
    ggplotly(bubble_GDP_WastePC, tooltip="text")
  })

  output$bubbleGDPWastePC2 <- renderPlotly({
    
    bubble_GDP_WastePC2 <- plastic %>% 
      mutate(GDP.PC=round(GDP.PC,0)) %>%
      mutate(Ppl=round(Ppl/1000000,2)) %>%
      arrange(desc(Ppl)) %>%
      mutate(Country = factor(Country, Country)) %>%
      mutate(text = paste("Country: ", Country, "\nPopulation (M): ", Ppl, "\nPer Capita Mismanaged Plastic Waste: ", Mismgt.PC, "\nGDP per capita: ", GDP.PC, sep="")) %>%
      ggplot(aes(log10(x = GDP.PC), y = Mismgt.PC, color = Continent, size = Ppl, text=text),tooltip="text") + 
      geom_point(alpha = 0.5) +
      ylim(0, 0.31) +
      scale_color_manual(values = c("#00AFBB", "#FC4E07", "#E7B800","#CC6666", "#9999CC", "#66CC99","#FF6666")) +
      scale_size(range = c(0.5, 10)) +  # Adjust the range of points size
      xlab('GDP per capita, PPP') + 
      ylab('Per capita mismanaged plastic waste') +
      ggtitle('Per capita mismanaged plastic waste vs. GDP per capita, 2010')
    
    ggplotly(bubble_GDP_WastePC2, tooltip="text")
  })
  
  output$bubbleGDPWastePC3 <- renderPlotly({
    
    bubble_GDP_WastePC3 <- plastic %>% 
      mutate(Coastal.Ppl=round(Coastal.Ppl/1000000,2)) %>%
      mutate(Ppl=round(Ppl/1000000,2)) %>%
      arrange(desc(Ppl)) %>%
      mutate(Country = factor(Country, Country)) %>%
      mutate(text = paste("Country: ", Country, "\nPopulation (M): ", Ppl, "\nMismanaged plastic waste: ", Mismanaged, "\nCoastal population: ", Coastal.Ppl, sep="")) %>%
      ggplot(aes(log10(x = Coastal.Ppl), y = log(Mismanaged, base = exp(10)), color = Continent, size = Ppl, text=text),tooltip="text") + 
      geom_point(alpha = 0.5) +
      geom_smooth(method = "lm") +
      ylim(0.40, 1.6) +
      scale_color_manual(values = c("#00AFBB", "#FC4E07", "#E7B800","#CC6666", "#9999CC", "#66CC99","#FF6666")) +
      scale_size(range = c(0.5, 10)) +  # Adjust the range of points size
      xlab('Coastal population') + 
      ylab('Mismanaged plastic waste') +
      ggtitle('Mismanaged plastic waste vs. coastal population, 2010')
    
    ggplotly(bubble_GDP_WastePC3, tooltip="text")
  })

  ####Reactive used by bar chart####
  dataset = reactive({
  if (input$selected == 'Population'){
      plastic %>% 
      select(Country, Ppl) %>% 
      arrange(desc(Ppl)) %>% 
      top_n(8) %>% 
      select(2,1)  
  }else if (input$selected == 'Coastal Population'){
      plastic %>% 
      select(Country, Coastal.Ppl) %>% 
      arrange(desc(Coastal.Ppl)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'GDP Per Capita'){
      plastic %>% 
      select(Country, GDP.PC) %>% 
      arrange(desc(GDP.PC)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Plastic Waste Generation'){
      plastic %>% 
      select(Country, PWaste.G) %>% 
      arrange(desc(PWaste.G)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Plastic Waste Per Capita'){
      plastic %>% 
      select(Country, PWaste.PC) %>% 
      arrange(desc(PWaste.PC)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Mismanaged Plastic Generation'){
      plastic %>% 
      select(Country, Mismanaged) %>% 
      arrange(desc(Mismanaged)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Mismanaged Plastic Per Capita'){
      plastic %>% 
      select(Country, Mismgt.PC) %>% 
      arrange(desc(Mismgt.PC)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Mismanaged Plastic Share'){
      plastic %>% 
      select(Country, Mismgt.S) %>% 
      arrange(desc(Mismgt.S)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == 'Inadequately Managed Plastic Waste Share(Highest Risk)'){
      plastic %>% 
      select(Country, Inade.S) %>% 
      arrange(desc(Inade.S)) %>% 
      top_n(8) %>% 
      select(2,1)
  }else if (input$selected == '2008-2010 Avg GDP Per Capita Growth Rate'){
      plastic %>% 
      select(Country, Avg3Y.GDPG) %>% 
      arrange(desc(Avg3Y.GDPG)) %>% 
      top_n(8)} %>% 
      select(2,1)
  })
  ####bar chart####
  output$barChart1 <- renderPlotly({
    bar_chart_1 <-
      ggplot(data= dataset(),aes_string(x='Country', y=VDict())) +
      geom_col(fill = "#FF6666") +
      coord_flip()
    ggplotly(bar_chart_1) %>%
      layout(autosize = T)
  })
  ####box plot####
  output$boxplot1 <- renderPlotly({
    box_plot_1 <- plastic %>%
      ggplot(aes(x=Land,y=Mismgt.PC,fill=Land)) +
      geom_boxplot() +
      # ylim(0, 3300000) +
      ylab('Per capita mismanaged plastic waste(tones)') +
      xlab('Country geographic feature') +
      ggtitle('Comparsion of mismanaged plastic waste between coastal and landlocked countries')
      ggplotly(box_plot_1) %>%
      layout(width="100%")
  })
  
  output$boxplot2 <- renderPlotly({
    box_plot_2 <- plastic %>%
      ggplot(aes(x=Eco,y=Mismgt.PC,fill=Eco)) +
      geom_boxplot() +
      # ylim(0, 3300000) +
      ylab('Per capita mismanaged plastic waste(tones)') +
      xlab('Economic growh') +
      ggtitle('Comparsion of mismanaged plastic waste between coastal and landlocked countries')
    ggplotly(box_plot_2) %>%
      layout(width="100%")
  })
  
  output$boxplot3 <- renderPlotly({
    box_plot_3 <- plastic %>%
      ggplot(aes(x=Development,y=Mismgt.PC,fill=Development)) +
      geom_boxplot() +
      # ylim(0, 3300000) +
      ylab('Per capita mismanaged plastic waste(tones)') +
      xlab('Development Status of Country') +
      ggtitle('Comparsion of mismanaged plastic waste between developed and developing countries')
    ggplotly(box_plot_3) %>%
      layout(width="100%")
  })
  
  output$boxplot4 <- renderPlotly({
    box_plot_4 <- plastic %>%
      ggplot(aes(x=Development,y=PWaste.PC, fill=Development)) +
      geom_boxplot() +
      ylim(0, 0.7) +
      ylab('Per Capita Plastic Waste(tones)') +
      xlab('Development Status of Country') +
      ggtitle('Comparsion of plastic waste per capita and development status of countries')
    ggplotly(box_plot_4) %>%
      layout(width="100%")
  })
  ####text####
  output$text1 <- renderText({
    text_df[,VDict()]
  })
  ####dataset####
  output$table <- DT::renderDataTable({
    datatable(plastic, rownames=FALSE) %>% 
      formatStyle(VDict(),  
                  background="skyblue", fontWeight='bold')
  })
}