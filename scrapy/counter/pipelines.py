# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from time import sleep
from itemadapter import ItemAdapter
from pythonosc.udp_client import SimpleUDPClient

class OscPipeline:
    def __init__(self):
        # self.client = SimpleUDPClient("127.0.0.1", 57120)
        self.client = SimpleUDPClient("169.254.42.234", 57120)

    def process_item(self, item, spider):
        word = item.get('word', '')
        counts = item.get('letter_counts', {})
        msg = []
        for letter, count in counts.items():
            # self.client.send_message("/fromScrapy", [letter, count])
            msg.append(count)
            print('letter: ' + letter + '\tcount: ' + str(count))
            # sleep(2)
        self.client.send_message("/fromScrapy", msg)

class CounterPipeline:
    def process_item(self, item, spider):
        return item
