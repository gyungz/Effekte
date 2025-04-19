import scrapy
from counter.items import CounterItem

class CounterSpiderSpider(scrapy.Spider):
    name = "counter_spider"
    allowed_domains = [""]
    start_urls = ["https://hfm-karlsruhe.de"]
    custom_word = "hallo"

    def parse(self, response):
        texts = response.xpath('//text()').getall()
        text_content = ''.join(texts).lower()
        word = self.custom_word.lower()

        letter_counts = {char: text_content.count(char) for char in word}

        yield CounterItem(word=word, letter_counts=letter_counts)
