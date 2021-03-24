# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import pymysql


class HiydPipeline:
    def __init__(self):
        self.connect = pymysql.connect(host='localhost', user='root', password='D12346789.p', database='food')
        self.cursor = self.connect.cursor()

    def process_item(self, item, spider):
        self.cursor.execute(
            '''insert into hiyd_detail (cate_name,food_name,food_url,calories,fat,carbohydrate,protein,cholesterol,cellulose,v_a,v_c,v_e,carotene,thiamine,riboflavin,niacin,magnesium,calcium,iron,zinc,copper,manganese,potassium,phosphorus,sodium,selenium,normal_weight,normal_calories) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)''',
            (item['cate_name'], item['food_name'], item['food_url'],
             item['calories'], item['fat'], item['carbohydrate'], item['protein'],
             item['cholesterol'], item['cellulose'],item['v_a'], item['v_c'], item['v_e'],
             item['carotene'], item['thiamine'], item['riboflavin'], item['niacin'],
             item['magnesium'], item['calcium'], item['iron'], item['zinc'],
             item['copper'], item['manganese'], item['potassium'], item['phosphorus'],
             item['sodium'], item['selenium'], item['normal_weight'], item['normal_calories']))
        self.connect.commit()
        return item
