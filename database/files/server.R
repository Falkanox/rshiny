library(shiny) #librarie de base
library(shinydashboard) #librarie pour les dashboard (non utilisé)
library(ggplot2)#librarie pour les graphiques
library(RSQLite) #librairie pour se connecter � la bdd

db <- dbConnect(SQLite(), db = "database.db")
df <- dbGetQuery(db, "SELECT * FROM Films INNER JOIN Rating ON Films.id_rating = Rating.id_rating INNER JOIN liste ON Films.id_listed_in = liste.id_listed_in")

shinyServer(function(input, output) {
  
  output$firstGraph <- renderPlot({ #fonction du rendu visuel du premier graphique
    
    a = df[df$rating == input$firstFilter, ] #on regarde si le filtre est le meme que la valeur de rating
    b = a[order(a$view, decreasing = TRUE),] #on trie par ordre décroissant
    filtre = b[c(1:3),] #on prend les 3 premiers éléments

    ggplot(filtre, aes(x=title, y=view)) + 
      geom_bar(stat = "identity") +
      coord_flip() + ggtitle("Vues par film") + labs(x = "Titre", y ="Vues") #on créé un graphique en barre
    
  })
  
  firstGraph <- reactive({ #même code qu'au dessus mais pour exporter en image besoin d'un reactive
    
    a = df[df$rating == input$firstFilter, ] 
    b = a[order(a$view, decreasing = TRUE),]
    filtre = b[c(1:3),]
    
    ggplot(filtre, aes(x=title, y=view)) + 
      geom_bar(stat = "identity") +
      coord_flip() + ggtitle("Vues par film") + labs(x = "Titre", y ="Vues")
    
  })
  
  output$downloadTopTen <- downloadHandler( #fonction pour télécharger le fichier avec le type png et la graphique firstGraph
    filename = 'top3.png',
    content = function(file){
      ggsave(file, firstGraph())
     
   }
    
  )
  
  output$firstTable <- renderTable({ #fonction du rendu visuel du premier tableau
    
    a = df[df$rating == input$firstFilter, ]
    b = a[order(a$view, decreasing = TRUE),]
    filtre = b[c(1:15),] #même chose qu'au dessus
    filtre2 = filtre[,c(4,14,13,15,6)] #on prend les colonnes 4, 14...
    
    if(anyNA(filtre2$view)){
      
      filtre2 = filtre2[c(1:3),] #les valeurs avec les na sont toujours au nombre de 3, donc on prend a chaque fois les 3 premieres valeurs
      
    }
    
    print(filtre2) #affiche le tableau
    
  })
  
  output$secondGraph <- renderPlot({  #fonction du rendu visuel du premier graphique
    
    a = df[df$type == input$secondFilter,] #on regarde si le filtre est le meme que la valeur de type
    b = a[a$marks == input$secondSecondFilter,] #on regarde si le filtre est le meme que la valeur de marks
    c = b[b$release_year >= 2010,] #on prend seulement les valeurs de 2010 ou plus sinon trop de valeurs et graphique illisible
    
    ggplot(c, aes(x = release_year)) + labs(x = "Annees", y ="Nombre de films") +
      geom_bar() + ggtitle("Nombre de films par annees") #on créé un graphique en barre
    
  })
  
  secondGraph <- reactive({ #même code qu'au dessus mais pour exporter en image besoin d'un reactive
    
    a = df[df$type == input$secondFilter,]
    b = a[a$marks == input$secondSecondFilter,]
    c = b[b$release_year >= 2010,]
    
    ggplot(c, aes(x = release_year)) + labs(x = "Annees", y ="Nombre de films") +
      geom_bar() + ggtitle("Nombre de films par annees")
    
  })
  
  output$downloadPerYear <- downloadHandler( #fonction pour télécharger le fichier avec le type png et la graphique firstGraph
    filename = 'year.png',
    content = function(file){
      ggsave(file, secondGraph())
      
    }
    
  )
  
  output$thirdGraph <- renderPlot({ #fonction du rendu visuel du premier graphique
    
    a = df[df$rating == input$thirdFilter, ] #on regarde si le filtre est le meme que la valeur de rating
    
    ggplot(a, aes(x=type, y = marks)) + labs(x = "Type audiovisuel", y ="Note") + geom_count() + ggtitle("Note par type audiovisuel") #on créé un graphique en point
    
  })
  
  thirdGraph <- reactive({ #même code qu'au dessus mais pour exporter en image besoin d'un reactive
    
    a = df[df$rating == input$thirdFilter, ]
    
    ggplot(a, aes(x=type, y = marks)) + labs(x = "Type audiovisuel", y ="Note") + geom_count() + ggtitle("Note par type audiovisuel")
    
  })
  
  output$downloadMarks <- downloadHandler(#fonction pour télécharger le fichier avec le type png et la graphique firstGraph
    filename = 'notes.png',
    content = function(file){
      ggsave(file, thirdGraph())
      
    }
    
  )
  
  output$secondTable <- renderTable({ #fonction du rendu visuel du deuxième tableau
    
    a = df[df$rating == input$thirdFilter, ]
    b = a[order(a$marks, decreasing = TRUE),] #on trie les meileures notes
    c = b[c(1:10),] #on prend les 10 meilleures
    d = c[, c(4,7,6,13,15)] #on prend certaines colonnes qui nous intéressents
    
    print(d) #on affiche le tableau
    
  })
  
})
