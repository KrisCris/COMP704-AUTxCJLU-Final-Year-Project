import scrapy
from hiyd.items import FoodCrawlerItem


class HiydSpider(scrapy.Spider):
    name = 'hiyd'
    allowed_domains = ['food.hiyd.com']
    start_urls = ['https://food.hiyd.com/list-1-html']

    def parse(self, response):
        selector = response.xpath('//div[@class="box-bd"]/ul/li')

        for food in selector:

            food_obj = FoodCrawlerItem()
            cate_name = response.xpath('//div[@class="box"]/div[@class="box-hd"]/h2/text()').get().strip()
            food_obj['cate_name'] = cate_name

            food_name = food.xpath('a/div[@class="cont"]/h3/text()').get().strip()
            food_obj['food_name'] = food_name

            food_url = food.xpath('a/@href').get().strip()
            food_obj['food_url'] = food_url
            print('food_url', food_url)

            if food_url:
                yield scrapy.Request(url=food_url, meta={'item': food_obj}, callback=self.parse_detail)

        next_page_url = response.xpath('//a[@title="下一页"]/@href').get()
        # print(next_page_url)
        if next_page_url:
            next_url = response.urljoin(next_page_url)
            print('next url: ', next_url)
            yield scrapy.Request(url=next_url, callback=self.parse, dont_filter=False)
        else:
            print('退出')

    def parse_detail(self, response):
        food_obj = response.meta['item']

        selector = response.xpath('//div[@class="nurt-list"]')

        for food_detail in selector:
            calories = food_detail.xpath('ul[not(@class="no-margin")]/li[2]').get().strip()
            food_obj['calories'] = calories

            fat = food_detail.xpath('ul[not(@class="no-margin")]/li[3]').get().strip()
            food_obj['fat'] = fat

            carbohydrate = food_detail.xpath('ul[not(@class="no-margin")]/li[4]').get().strip()
            food_obj['carbohydrate'] = carbohydrate

            protein = food_detail.xpath('ul[not(@class="no-margin")]/li[5]').get().strip()
            food_obj['protein'] = protein

            cholesterol = food_detail.xpath('ul[not(@class="no-margin")]/li[6]').get().strip()
            food_obj['cholesterol'] = cholesterol

            cellulose = food_detail.xpath('ul[not(@class="no-margin")]/li[8]').get().strip()
            food_obj['cellulose'] = cellulose

            v_a = food_detail.xpath('ul[not(@class="no-margin")]/li[9]').get().strip()
            food_obj['v_a'] = v_a

            v_c = food_detail.xpath('ul[not(@class="no-margin")]/li[10]').get().strip()
            food_obj['v_c'] = v_c

            v_e = food_detail.xpath('ul[not(@class="no-margin")]/li[11]').get().strip()
            food_obj['v_e'] = v_e

            carotene = food_detail.xpath('ul[not(@class="no-margin")]/li[12]').get().strip()
            food_obj['carotene'] = carotene

            thiamine = food_detail.xpath('ul[not(@class="no-margin")]/li[13]').get().strip()
            food_obj['thiamine'] = thiamine

            riboflavin = food_detail.xpath('ul[not(@class="no-margin")]/li[14]').get().strip()
            food_obj['riboflavin'] = riboflavin

            niacin = food_detail.xpath('ul[not(@class="no-margin")]/li[15]').get().strip()
            food_obj['niacin'] = niacin

            magnesium = food_detail.xpath('ul[contains(@class,"no-margin")]/li[2]').get().strip()
            food_obj['magnesium'] = magnesium

            calcium = food_detail.xpath('ul[contains(@class,"no-margin")]/li[3]').get().strip()
            food_obj['calcium'] = calcium

            iron = food_detail.xpath('ul[contains(@class,"no-margin")]/li[4]').get().strip()
            food_obj['iron'] = iron

            zinc = food_detail.xpath('ul[contains(@class,"no-margin")]/li[5]').get().strip()
            food_obj['zinc'] = zinc

            copper = food_detail.xpath('ul[contains(@class,"no-margin")]/li[6]').get().strip()
            food_obj['copper'] = copper

            manganese = food_detail.xpath('ul[contains(@class,"no-margin")]/li[7]').get().strip()
            food_obj['manganese'] = manganese

            potassium = food_detail.xpath('ul[contains(@class,"no-margin")]/li[8]').get().strip()
            food_obj['potassium'] = potassium

            phosphorus = food_detail.xpath('ul[contains(@class,"no-margin")]/li[9]').get().strip()
            food_obj['phosphorus'] = phosphorus

            sodium = food_detail.xpath('ul[contains(@class,"no-margin")]/li[10]').get().strip()
            food_obj['sodium'] = sodium

            selenium = food_detail.xpath('ul[contains(@class,"no-margin")]/li[11]').get().strip()
            food_obj['selenium'] = selenium

        yield food_obj
