import scrapy
from counter.items import CounterItem
from collections import OrderedDict

class CounterSpiderSpider(scrapy.Spider):
    name = "counter_spider"
    allowed_domains = ["wikipedia.org"]
    start_urls = ["https://de.wikipedia.org/wiki/"]
    # custom_word = "hallo"

    def __init__(self, search_word='hallo', *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.search_word = search_word
        self.url = self.start_urls[0] + search_word
    
    def start_requests(self):
        yield  scrapy.http.Request(url=self.url, callback=self.parse, method='GET')

    def parse(self, response):
        texts = response.xpath('//text()').getall()
        text_content = ''.join(texts).lower()
        word = self.search_word.lower()
        letter_counts = OrderedDict()
        for char in word:
            letter_counts[char] = text_content.count(char)
        # print('\n\n')
        yield CounterItem(word=word, letter_counts=letter_counts)
