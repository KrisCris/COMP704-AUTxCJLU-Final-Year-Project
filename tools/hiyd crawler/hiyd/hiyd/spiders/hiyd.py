import scrapy
from hiyd.items import FoodCrawlerItem


class HiydSpider(scrapy.Spider):
    name = 'hiyd'
    allowed_domains = ['hiyd.com']
    start_urls = ['https://m.food.hiyd.com/list-1-html/']

    def parse(self, response):
        selector = response.xpath('//ul[@id="foodList"]/li')

        for food in selector:

            food_obj = FoodCrawlerItem()
            # cate_name = response.xpath('//div[@class="box"]/div[@class="box-hd"]/h2/text()').get().strip()
            # food_obj['cate_name'] = cate_name

            food_name = food.xpath('a/div[@class="cont"]/h3/text()').get()
            if food_name:
                food_name = food_name.strip()
            food_obj['food_name'] = food_name

            food_url = food.xpath('a/@href').get().strip()
            if food_url:
                food_url = response.urljoin(food_url)
            food_obj['food_url'] = food_url
            # print('food_url', food_url)

            if food_url:
                yield scrapy.Request(url=food_url, meta={'item': food_obj}, callback=self.parse_detail)

        next_page_url = response.xpath('//div[@id="hiyd_loader"]/a/@href').get()
        # print(next_page_url)
        if next_page_url:
            next_url = response.urljoin(next_page_url)
            print('next url: ', next_url)
            yield scrapy.Request(url=next_url, callback=self.parse, dont_filter=False)
        else:
            print('退出')

    def parse_detail(self, response):
        food_obj = response.meta['item']

        cate_name = response.xpath('//div[@class="cont"]/p/a/text()').get().strip()
        food_obj['cate_name'] = cate_name

        # selector = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul')

        # for response in selector:
        calories = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[2]/p[2]/text()').get().strip()
        food_obj['calories'] = calories

        fat = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[3]/p[2]/text()').get().strip()
        food_obj['fat'] = fat

        carbohydrate = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[4]/p[2]/text()').get().strip()
        food_obj['carbohydrate'] = carbohydrate

        protein = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[5]/p[2]/text()').get().strip()
        food_obj['protein'] = protein

        cholesterol = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[6]/p[2]/text()').get().strip()
        food_obj['cholesterol'] = cholesterol

        cellulose = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[2]/p[2]/text()').get().strip()
        food_obj['cellulose'] = cellulose

        v_a = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[3]/p[2]/text()').get().strip()
        food_obj['v_a'] = v_a

        v_c = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[4]/p[2]/text()').get().strip()
        food_obj['v_c'] = v_c

        v_e = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[5]/p[2]/text()').get().strip()
        food_obj['v_e'] = v_e

        carotene = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[6]/p[2]/text()').get().strip()
        food_obj['carotene'] = carotene

        thiamine = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[7]/p[2]/text()').get().strip()
        food_obj['thiamine'] = thiamine

        riboflavin = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[8]/p[2]/text()').get().strip()
        food_obj['riboflavin'] = riboflavin

        niacin = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[9]/p[2]/text()').get().strip()
        food_obj['niacin'] = niacin

        magnesium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[2]/p[2]/text()').get().strip()
        food_obj['magnesium'] = magnesium

        calcium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[3]/p[2]/text()').get().strip()
        food_obj['calcium'] = calcium

        iron = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[4]/p[2]/text()').get().strip()
        food_obj['iron'] = iron

        zinc = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[5]/p[2]/text()').get().strip()
        food_obj['zinc'] = zinc

        copper = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[6]/p[2]/text()').get().strip()
        food_obj['copper'] = copper

        manganese = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[7]/p[2]/text()').get().strip()
        food_obj['manganese'] = manganese

        potassium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[8]/p[2]/text()').get().strip()
        food_obj['potassium'] = potassium

        phosphorus = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[9]/p[2]/text()').get().strip()
        food_obj['phosphorus'] = phosphorus

        sodium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[10]/p[2]/text()').get().strip()
        food_obj['sodium'] = sodium

        selenium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[11]/p[2]/text()').get().strip()
        food_obj['selenium'] = selenium

        yield food_obj
