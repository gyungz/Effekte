benötigte python Bibliotheken: 
scrapy
pythonosc

Um Daten zu crawlen, geh in den scrapy Ordner rein und führe den scrapy Befehl aus

cd ../EFFEKTE/scrapy  
scrapy crawl counter_spider

dynamisches crawling von wikipedia:
scrapy crawl counter_spider -a search_word=Example

ohne Anführungszeichen einfach das Suchwort eingeben, das gecrawled werden soll
