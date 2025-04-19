# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class CounterItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    word = scrapy.Field()
    letter_counts = scrapy.Field()
    div_counts = scrapy.Field()
    link_counts = scrapy.Field()
