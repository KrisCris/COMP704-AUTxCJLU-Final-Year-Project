import xml.etree.ElementTree as ET
import pickle
import os
from os import listdir, getcwd
from os.path import join

sets = ['train', 'test', 'val']
classes = ['rice', 'eels on rice', 'pilaf', "chicken-'n'-egg on rice", 'pork cutlet on rice', 'beef curry', 'sushi',
           'chicken rice', 'fried rice', 'tempura bowl', 'bibimbap', 'toast', 'croissant', 'roll bread',
           'raisin bread', 'chip butty', 'hamburger', 'pizza', 'sandwiches', 'udon noodle', 'tempura udon',
           'soba noodle', 'ramen noodle', 'beef noodle', 'tensin noodle', 'fried noodle', 'spaghetti',
           'Japanese-style pancake', 'takoyaki', 'gratin', 'sauteed vegetables', 'croquette', 'grilled eggplant',
           'sauteed spinach', 'vegetable tempura', 'miso soup', 'potage', 'sausage', 'oden', 'omelet', 'ganmodoki',
           'jiaozi', 'stew', 'teriyaki grilled fish', 'fried fish', 'grilled salmon', 'salmon meuniere', 'sashimi',
           'grilled pacific saury', 'sukiyaki', 'sweet and sour pork', 'lightly roasted fish',
           'steamed egg hotchpotch', 'tempura', 'fried chicken', 'sirloin cutlet', 'nanbanzuke', 'boiled fish',
           'seasoned beef with potatoes', 'hambarg steak', 'steak', 'dried fish', 'ginger pork saute',
           'spicy chili-flavored tofu', 'yakitori', 'cabbage roll', 'omelet', 'egg sunny-side up', 'natto',
           'cold tofu', 'egg roll', 'chilled noodle', 'stir-fried beef and peppers', 'simmered pork',
           'boiled chicken and vegetables', 'sashimi bowl', 'sushi bowl', 'fish-shaped pancake with bean jam',
           'shrimp with chill source', 'roast chicken', 'steamed meat dumpling', 'omelet with fried rice',
           'cutlet curry', 'spaghetti meat sauce', 'fried shrimp', 'potato salad', 'green salad', 'macaroni salad',
           'Japanese tofu and vegetable chowder', 'pork miso soup', 'chinese soup', 'beef bowl',
           'kinpira-style sauteed burdock', 'rice ball', 'pizza toast', 'dipping noodles', 'hot dog', 'french fries',
           'mixed rice', 'goya chanpuru', 'green curry', 'okinawa soba', 'mango pudding', 'almond jelly', 'jjigae',
           'dak galbi', 'dry curry', 'kamameshi', 'rice vermicelli', 'paella', 'tanmen', 'kushikatu', 'yellow curry',
           'pancake', 'champon', 'crape', 'tiramisu', 'waffle', 'rare cheese cake', 'shortcake', 'chop suey',
           'twice cooked pork', 'mushroom risotto', 'samul', 'zoni', 'french toast', 'fine white noodles',
           'minestrone', 'pot au feu', 'chicken nugget', 'namero', 'french bread', 'rice gruel', 'broiled eel bowl',
           'clear soup', 'yudofu', 'mozuku', 'inarizushi', 'pork loin cutlet', 'pork fillet cutlet', 'chicken cutlet',
           'ham cutlet', 'minced meat cutlet', 'thinly sliced raw horsemeat', 'bagel', 'scone', 'tortilla', 'tacos',
           'nachos', 'meat loaf', 'scrambled egg', 'rice gratin', 'lasagna', 'Caesar salad', 'oatmeal',
           'fried pork dumplings served in soup', 'oshiruko', 'muffin', 'popcorn', 'cream puff', 'doughnut',
           'apple pie', 'parfait', 'fried pork in scoop', 'lamb kebabs',
           'dish consisting of stir-fried potato, eggplant and green pepper', 'roast duck', 'hot pot', 'pork belly',
           'xiao long bao', 'moon cake', 'custard tart', 'beef noodle soup', 'pork cutlet', 'minced pork rice',
           'fish ball soup', 'oyster omelette', 'glutinous oil rice', 'trunip pudding', 'stinky tofu',
           'lemon fig jelly', 'khao soi', 'Sour prawn soup', 'Thai papaya salad',
           'boned, sliced Hainan-style chicken with marinated rice', 'hot and sour, fish and vegetable ragout',
           'stir-fried mixed vegetables', 'beef in oyster sauce', 'pork satay', 'spicy chicken salad',
           'noodles with fish curry', 'Pork Sticky Noodles', 'Pork with lemon', 'stewed pork leg',
           'charcoal-boiled pork neck', 'fried mussel pancakes', 'Deep Fried Chicken Wing',
           'Barbecued red pork in sauce with rice', 'Rice with roast duck', 'Rice crispy pork', 'Wonton soup',
           'Chicken Rice Curry With Coconut', 'Crispy Noodles', 'Egg Noodle In Chicken Yellow Curry',
           'coconut milk soup', 'pho', 'Hue beef rice vermicelli soup', 'Vermicelli noodles with snails',
           'Fried spring rolls', 'Steamed rice roll', 'Shrimp patties', 'ball shaped bun with pork',
           'Coconut milk-flavored crepes with shrimp and beef', 'Small steamed savory rice pancake',
           'Glutinous Rice Balls', 'loco moco', 'haupia', 'malasada', 'laulau', 'spam musubi', 'oxtail soup', 'adobo',
           'lumpia', 'brownie', 'churro', 'jambalaya', 'nasi goreng', 'ayam goreng', 'ayam bakar', 'bubur ayam',
           'gulai', 'laksa', 'mie ayam', 'mie goreng', 'nasi campur', 'nasi padang', 'nasi uduk', 'babi guling',
           'kaya toast', 'bak kut teh', 'curry puff', 'chow mein', 'zha jiang mian', 'kung pao chicken', 'crullers',
           'eggplant with garlic sauce', 'three cup chicken', 'bean curd family style',
           'salt & pepper fried shrimp with shell', 'baked salmon', 'braised pork meat ball with napa cabbage',
           'winter melon soup', 'steamed spareribs', 'chinese pumpkin pie', 'eight treasure rice', 'hot & sour soup',
           '西瓜','香蕉','馒头','草莓','酸奶','雪碧','葡萄','苹果','玉米','冰淇淋','饼干','茶叶蛋','汉堡','米饭','粥','小笼包','方便面','面包','面条','牛奶','水饺','车厘子','橙子','蛋糕','豆浆','馄饨',
           '鸡翅','荷包蛋','三明治','果汁','咖啡','可乐','梨','巧克力','薯条']


def convert(size, box):
    dw = 1. / size[0]
    dh = 1. / size[1]
    x = (box[0] + box[1]) / 2.0
    y = (box[2] + box[3]) / 2.0
    w = box[1] - box[0]
    h = box[3] - box[2]
    x = x * dw
    w = w * dw
    y = y * dh
    h = h * dh
    return (x, y, w, h)


def convert_annotation(image_id):
    in_file = open('/media/data_disk/dataset/voc/Annotations/%s.xml' % (image_id))
    out_file = open('/media/data_disk/dataset/voc/labels/%s.txt' % (image_id), 'w')
    tree = ET.parse(in_file)
    root = tree.getroot()
    size = root.find('size')
    w = int(size.find('width').text)
    h = int(size.find('height').text)
    for obj in root.iter('object'):
        difficult = obj.find('difficult')
        if difficult:
            difficult = difficult.text
        else:
            difficult = 0
        cls = obj.find('name').text
        if cls not in classes or int(difficult) == 1:
            continue
        cls_id = classes.index(cls)
        xmlbox = obj.find('bndbox')
        b = (float(xmlbox.find('xmin').text), float(xmlbox.find('xmax').text), float(xmlbox.find('ymin').text),
             float(xmlbox.find('ymax').text))
        b1, b2, b3, b4 = b
        # 标注越界修正
        if b2 > w:
            b2 = w
        if b4 > h:
            b4 = h
        b = (b1, b2, b3, b4)
        bb = convert((w, h), b)
        out_file.write(str(cls_id) + " " + " ".join([str(a) for a in bb]) + '\n')


wd = getcwd()
print(wd)
for image_set in sets:
    if not os.path.exists('/media/data_disk/dataset/voc/labels/'):
        os.makedirs('/media/data_disk/dataset/voc/labels/')
    image_ids = open('/media/data_disk/dataset/voc/ImageSets/Main/%s.txt' % (image_set)).read().strip().split()
    list_file = open('/media/data_disk/dataset/voc/%s.txt' % (image_set), 'w')
    for image_id in image_ids:
        list_file.write('/media/data_disk/dataset/voc/images/%s.jpg\n' % (image_id))
        convert_annotation(image_id)
    list_file.close()