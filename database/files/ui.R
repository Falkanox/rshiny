library(shiny) #librarie de base
library(shinydashboard) #librarie pour les dashboard (non utilisé)
library(RSQLite) #librairie pour se connecter � la bdd

database <- dbConnect(SQLite(), db = "database.db")
df <- dbGetQuery(database, "SELECT * FROM Films INNER JOIN Rating ON Films.id_rating = Rating.id_rating INNER JOIN liste ON Films.id_listed_in = liste.id_listed_in")

shinyUI(fluidPage(includeCSS("slate.min.css"), #ajout de code css pour le thème du shiny
                  
                  fluidRow(
                    
                    tabsetPanel(
                      tabPanel("Top 3 de films", #ajout d'un onglet
                               
                               sidebarLayout(
                                 sidebarPanel(
                                   
                                   selectInput("firstFilter", "Filtre (signaletique americaine)", choices = c("TV-14", "PG-13", "PG", "TV-PG", "TV-MA", "TV-Y", "TV-Y7", "R", "TV-G", "G", "NC-17", "NR", "TV-Y7-FV", "UR"), selected = 1), #ajout des filtres et les valeurs qu'ils peuvent prendre
                                   
                                   downloadButton("downloadTopTen", label = "Telecharger le graphique"), #ajout du bouton de téléchargement
                                   
                                   br(), br(), br(), br(), br(), br(), br(), #espace pour pas que les éléments soient collés
                                   
                                   
                                   tableOutput("firstTable")), #ajout de l'output du tableau
                                   
                                   mainPanel(plotOutput("firstGraph", width = "100%", height = "800px"),) #ajout de l'output du graphique, avec sa taille
                                   
                                  )
                               
                               ),
                               
                               tabPanel("Nombre de films par années", #ajout d'un onglet
                                        
                                        sidebarLayout(
                                          sidebarPanel(
                                            selectInput("secondFilter", "Filtre (type audiovisuel)", choices = c("Movie", "TV Show"), selected = 1), #ajout des filtres et les valeurs qu'ils peuvent prendre
                                            selectInput("secondSecondFilter", "Filtre (note)", choices = c(0, 1, 2, 3, 4, 5), selected = 1),
                                            
                                            downloadButton("downloadPerYear", label = "Telecharger le graphique"), #ajout du bouton de téléchargement
                                            
                                          ),
                                            
                                          mainPanel(
                                            plotOutput("secondGraph", width = "100%", height = "800px"), #ajout de l'output du graphique, avec sa taille
                                          )
                                        )
                                        
                                        ),
                                        
                                        tabPanel("Notes de films", #ajout d'un onglet
                                                 
                                                 sidebarLayout(
                                                   sidebarPanel(
                                                     selectInput("thirdFilter", "Filtre (signaletique americaine)", choices = unique(df$rating), selected = 1), #ajout des filtres et les valeurs qu'ils peuvent prendre
                                                     
                                                     downloadButton("downloadMarks", label = "Telecharger le graphique"), #ajout du bouton de téléchargement
                                                     
                                                     br(), br(), br(), br(), br(), br(), br(), #espace pour pas que les éléments soient collés
                                                     
                                                     
                                                     tableOutput("secondTable")), #ajout de l'output du tableau
                                                     
                                                   mainPanel(
                                                     plotOutput("thirdGraph", width = "100%", height = "800px") #ajout de l'output du graphique, avec sa taille
                                                   )
                                                 )
                                        )
                               )
                    
                  )
                  )
)