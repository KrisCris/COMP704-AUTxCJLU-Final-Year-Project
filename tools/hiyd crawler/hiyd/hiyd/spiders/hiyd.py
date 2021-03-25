import scrapy
from hiyd.items import FoodCrawlerItem
import requests as req
from PIL import Image
import os, base64
from io import BytesIO


class HiydSpider(scrapy.Spider):
    name = 'hiyd'
    allowed_domains = ['hiyd.com']
    start_urls = [
        # 'https://m.food.hiyd.com/list-1-html/',
        # 'https://m.food.hiyd.com/list-2-html',
        # 'https://m.food.hiyd.com/list-3-html'
        # 'https://m.food.hiyd.com/list-4-html'
        # 'https://m.food.hiyd.com/list-5-html'
        # 'https://m.food.hiyd.com/list-6-html'
        # 'https://m.food.hiyd.com/list-9-html'
        # 'https://m.food.hiyd.com/list-132-html'

        'https://m.food.hiyd.com/detail-mifan_zheng.html',
        'https://m.food.hiyd.com/detail-rishimanyufan.html',
        'https://m.food.hiyd.com/detail-fd4de4f9.html',
        'https://m.food.hiyd.com/detail-guangzhiliangpinhigaifanbianda19.html',
        'https://m.food.hiyd.com/detail-gaijiaofan_dahun.html',
        'https://m.food.hiyd.com/detail-suboniuroukali.html',
        'https://m.food.hiyd.com/detail-sanwenyushousi.html',
        'https://m.food.hiyd.com/detail-guangzhiliangpinhigaifanbianda19.html',
        'https://m.food.hiyd.com/detail-shijinchaofan.html',
        'https://m.food.hiyd.com/detail-tianfuluoqiaomaimian.html',
        'https://m.food.hiyd.com/detail-hanshishiguobanfan.html',
        'https://m.food.hiyd.com/detail-jinhongweidamaitusi.html',
        'https://m.food.hiyd.com/detail-fd66516e.html',
        'https://m.food.hiyd.com/detail-fd232a52.html',
        'https://m.food.hiyd.com/detail-fdead5a0.html',
        'https://m.food.hiyd.com/detail-andishiqiabadajirousanmingzhi.html',
        'https://m.food.hiyd.com/detail-fdfcb44d.html',
        'https://m.food.hiyd.com/detail-fd86d8f6.html',
        'https://m.food.hiyd.com/detail-fd67a10a.html',
        'https://m.food.hiyd.com/detail-fd7ec0b2.html',
        'https://m.food.hiyd.com/detail-tianfuluoqiaomaimian.html',
        'https://m.food.hiyd.com/detail-dingweiqiaomaimian.html',
        'https://m.food.hiyd.com/detail-jiangnandiyijiadoufupi.html',
        'https://m.food.hiyd.com/detail-fd6cc5eb.html',
        'https://m.food.hiyd.com/detail-Ciriohiqieyioupaihiqupifanqie.html',
        'https://m.food.hiyd.com/detail-fd9fa07c.html',
        'https://m.food.hiyd.com/detail-anyigaogaidizhiniunaiyinpin.html',
        'https://m.food.hiyd.com/detail-sanhuangjiehixianluyachun.html',
        'https://m.food.hiyd.com/detail-fdc99c8e.html',
        'https://m.food.hiyd.com/detail-laiyifensangrengan.html',
        'https://m.food.hiyd.com/detail-yangdujun.html',
        'https://m.food.hiyd.com/detail-quanzhitiannaifen_yilipai.html',
        'https://m.food.hiyd.com/detail-zhangfeichuanlaniurou.html',
        'https://m.food.hiyd.com/detail-huierkangguo10bingtangxueliyin.html',
        'https://m.food.hiyd.com/detail-jidilengdongjiucaishuijiao.html',
        'https://m.food.hiyd.com/detail-kongfuganjiexiaohimanfutangguo3.html',
        'https://m.food.hiyd.com/detail-quechaoqiqiaobing.html',
        'https://m.food.hiyd.com/detail-yuanweizhenghoutougu.html',
        'https://m.food.hiyd.com/detail-houlishuanghibibashuanghouruan.html',
        'https://m.food.hiyd.com/detail-bayuankehuxie.html',
        'https://m.food.hiyd.com/detail-fdc44b0c.html',
        'https://m.food.hiyd.com/detail-yashiliyouyinvshipeifangnaifen.html',
        'https://m.food.hiyd.com/detail-fdb2f55b.html',
        'https://m.food.hiyd.com/detail-taiyeji.html',
        'https://m.food.hiyd.com/detail-zhentianbibazhi.html',
        'https://m.food.hiyd.com/detail-huashengmeidoubaozhugujijiaota.html',
        'https://m.food.hiyd.com/detail-maodouchaodoufu.html',
        'https://m.food.hiyd.com/detail-fda44952.html',
        'https://m.food.hiyd.com/detail-liangfenghiqianghuamairujing.html',
        'https://m.food.hiyd.com/detail-oudunhiyuba_xinaoerliangfengwe.html',
        'https://m.food.hiyd.com/detail-fd0af632.html',
        'https://m.food.hiyd.com/detail-chenguanghuashenghetaozhiwudan.html',
        'https://m.food.hiyd.com/detail-yangmeiyuanzi.html',
        'https://m.food.hiyd.com/detail-huiguorou.html',
        'https://m.food.hiyd.com/detail-jiujiechangbainaicha.html',
        'https://m.food.hiyd.com/detail-fd1d2633.html',
        'https://m.food.hiyd.com/detail-jiajiakangniurouhuotuiqiepian.html',
        'https://m.food.hiyd.com/detail-fd953d9e.html',
        'https://m.food.hiyd.com/detail-fdf5dd27.html',
        'https://m.food.hiyd.com/detail-shuanghuieshikaoxiangchang_zhu.html',
        'https://m.food.hiyd.com/detail-huashenglao.html',
        'https://m.food.hiyd.com/detail-fd8a4b5e.html',
        'https://m.food.hiyd.com/detail-mengniuzhenguoli_luhuili.html',
        'https://m.food.hiyd.com/detail-zizhijiucaixiapixianbing.html',
        'https://m.food.hiyd.com/detail-sansiqiaoyu.html',
        'https://m.food.hiyd.com/detail-fdbab586.html',
        'https://m.food.hiyd.com/detail-fdbff892.html',
        'https://m.food.hiyd.com/detail-fdf5dd76.html',
        'https://m.food.hiyd.com/detail-linshengjihiheidounai.html',
        'https://m.food.hiyd.com/detail-fd049d1f.html',
        'https://m.food.hiyd.com/detail-songchuanwujiemoqingdou2.html',
        'https://m.food.hiyd.com/detail-linglingshixiangpitang_suansha.html',
        'https://m.food.hiyd.com/detail-merryshinehimeisihijiaoyuandan.html',
        'https://m.food.hiyd.com/detail-hongshuzhou.html',
        'https://m.food.hiyd.com/detail-fd1cd22d.html',
        'https://m.food.hiyd.com/detail-linuositianguamangguonailao.html',
        'https://m.food.hiyd.com/detail-fd691133.html',
        'https://m.food.hiyd.com/detail-fd112162.html',
        'https://m.food.hiyd.com/detail-Lemnoshilannuosihijianzhizaizh.html',
        'https://m.food.hiyd.com/detail-hemeiershibangwucanrouqingdank.html',
        'https://m.food.hiyd.com/detail-fd067e69.html',
        'https://m.food.hiyd.com/detail-kirklandhialmondshixingren.html',
        'https://m.food.hiyd.com/detail-yadanhuang.html',
        'https://m.food.hiyd.com/detail-guxiangyuanhipangsaojianbing.html',
        'https://m.food.hiyd.com/detail-congzhenchuanweizhangchabanya.html',
        'https://m.food.hiyd.com/detail-fd788d89.html',
        'https://m.food.hiyd.com/detail-fddb76da.html',
        'https://m.food.hiyd.com/detail-fd9456b1.html',
        'https://m.food.hiyd.com/detail-taiyangpaihishougongmianxian.html',
        'https://m.food.hiyd.com/detail-Elelenhijiaoyuandanbaikoufuye.html',
        'https://m.food.hiyd.com/detail-fd3ad41b.html',
        'https://m.food.hiyd.com/detail-gaoyuanzhibaohiquanzhimaoniuna.html',
        'https://m.food.hiyd.com/detail-peiyarousongbao.html',
        'https://m.food.hiyd.com/detail-fdca7fbb.html',
        'https://m.food.hiyd.com/detail-mengniuliduonongsuanniunai_hongdouyeguo.html',
        'https://m.food.hiyd.com/detail-kekoukelefenda_chengweiqishui.html',
        'https://m.food.hiyd.com/detail-fd6873c1.html',
        'https://m.food.hiyd.com/detail-fdd22028.html',
        'https://m.food.hiyd.com/detail-zhongpinhiwucanhuotui.html',
        'https://m.food.hiyd.com/detail-quechaotuozhisuannai_yingtaowei.html',
        'https://m.food.hiyd.com/detail-fd326835.html',
        'https://m.food.hiyd.com/detail-huanglaotailaliji.html',
        'https://m.food.hiyd.com/detail-dounaifen_weiweipai.html',
        'https://m.food.hiyd.com/detail-jianchangfen.html',
        'https://m.food.hiyd.com/detail-liangbandoufu.html',
        'https://m.food.hiyd.com/detail-maiweimianbao.html',
        'https://m.food.hiyd.com/detail-fd4d3d46.html',
        'https://m.food.hiyd.com/detail-moserrothheiqiaokeli.html',
        'https://m.food.hiyd.com/detail-shinikanpuweishengsumaipian.html',
        'https://m.food.hiyd.com/detail-fd501fd8.html',
        'https://m.food.hiyd.com/detail-fd317aef.html',
        'https://m.food.hiyd.com/detail-mingwuhimuguaniunai.html',
        'https://m.food.hiyd.com/detail-baizhaojihiyikousu.html',
        'https://m.food.hiyd.com/detail-wandoucaihua.html',
        'https://m.food.hiyd.com/detail-xianhenghixiangsumeiguifuru.html',
        'https://m.food.hiyd.com/detail-jiaozi_jiroumoguxian.html',
        'https://m.food.hiyd.com/detail-fd7bdd4b.html',
        'https://m.food.hiyd.com/detail-zaohuacunhupingzao.html',
        'https://m.food.hiyd.com/detail-xibuyuehantunnayu_ningmengheya.html',
        'https://m.food.hiyd.com/detail-ougeniyoujixingrenlu.html',
        'https://m.food.hiyd.com/detail-sanyuanaiyinvshinaifen.html',
        'https://m.food.hiyd.com/detail-tangculiuliji.html',
        'https://m.food.hiyd.com/detail-fd743589.html',
        'https://m.food.hiyd.com/detail-jinzidougan.html',
        'https://m.food.hiyd.com/detail-xingbakeVIApaikeshichanghongbe.html',
        'https://m.food.hiyd.com/detail-ganzhaxiatong.html',
        'https://m.food.hiyd.com/detail-fd9ca82b.html',
        'https://m.food.hiyd.com/detail-fdc9d06d.html',
        'https://m.food.hiyd.com/detail-taoliputaoganmianbaoqiepian.html',
        'https://m.food.hiyd.com/detail-fd9c38b6.html',
        'https://m.food.hiyd.com/detail-fda42577.html',
        'https://m.food.hiyd.com/detail-youguluchangneishipin_caomeisu.html',
        'https://m.food.hiyd.com/detail-kaladuohiquanmaishoushenjuan.html',
        'https://m.food.hiyd.com/detail-fdd42e46.html',
        'https://m.food.hiyd.com/detail-fd423d8d.html',
        'https://m.food.hiyd.com/detail-fde5fa86.html',
        'https://m.food.hiyd.com/detail-tiancaiye.html',
        'https://m.food.hiyd.com/detail-guolianshuichanhibaizhuoxia.html',
        'https://m.food.hiyd.com/detail-fd921efa.html',
        'https://m.food.hiyd.com/detail-sizhouganli_xinbaozhuang.html',
        'https://m.food.hiyd.com/detail-fd33e860.html',
        'https://m.food.hiyd.com/detail-ningmengsuannaibudingta.html',
        'https://m.food.hiyd.com/detail-bocaidantang.html',
        'https://m.food.hiyd.com/detail-fd445f67.html',
        'https://m.food.hiyd.com/detail-wufengnaihuangbao.html',
        'https://m.food.hiyd.com/detail-jiabaohiGerberhihunhemeiziweis.html',
        'https://m.food.hiyd.com/detail-quanshiwurijimanyuemeigan.html',
        'https://m.food.hiyd.com/detail-huangweihiguihuaoufen.html',
        'https://m.food.hiyd.com/detail-JahiToasthinailao.html',
        'https://m.food.hiyd.com/detail-duoweiqiezini.html',
        'https://m.food.hiyd.com/detail-DELVERDEhidiweidahijuantongxin.html',
        'https://m.food.hiyd.com/detail-qingyuhijuandoufu.html',
        'https://m.food.hiyd.com/detail-suzhiduhiyanmaifen.html',
        'https://m.food.hiyd.com/detail-fenglihuijixin.html',
        'https://m.food.hiyd.com/detail-tianjiaochaorousi.html',
        'https://m.food.hiyd.com/detail-zhongmeitaiwanxiangchang.html',
        'https://m.food.hiyd.com/detail-guangminglaosuannaiyuanlaosuan.html',
        'https://m.food.hiyd.com/detail-huxiangyuanyehiyubioujia.html',
        'https://m.food.hiyd.com/detail-tudoudunpaigu.html',
        'https://m.food.hiyd.com/detail-fd6d6e3e.html',
        'https://m.food.hiyd.com/detail-fdbfb6ac.html',
        'https://m.food.hiyd.com/detail-fd9b1edd.html',
        'https://m.food.hiyd.com/detail-talahiejihiADrugainaibei.html',
        'https://m.food.hiyd.com/detail-fdd89503.html',
        'https://m.food.hiyd.com/detail-fd74a251.html',
        'https://m.food.hiyd.com/detail-fd05255b.html',
        'https://m.food.hiyd.com/detail-fdd9d849.html',
        'https://m.food.hiyd.com/detail-guangjihihuangjinmanteningkafe.html',
        'https://m.food.hiyd.com/detail-fd6a9699.html',
        'https://m.food.hiyd.com/detail-fd8afd3e.html',
        'https://m.food.hiyd.com/detail-fd4d85d4.html',
        'https://m.food.hiyd.com/detail-niurouguotie.html',
        'https://m.food.hiyd.com/detail-junlebao0zhetangsuanniunai.html',
        'https://m.food.hiyd.com/detail-fd33486a.html',
        'https://m.food.hiyd.com/detail-fd310000.html',
        'https://m.food.hiyd.com/detail-yanlvqiaomianfangbianmian.html',
        'https://m.food.hiyd.com/detail-fudianhizhuroudanjuanguantou.html',
        'https://m.food.hiyd.com/detail-quechaoxiangjiaoweichongyinfen.html',
        'https://m.food.hiyd.com/detail-fd2cdfe5.html',
        'https://m.food.hiyd.com/detail-fd4f86c6.html',
        'https://m.food.hiyd.com/detail-fd814366.html',
        'https://m.food.hiyd.com/detail-jiemoyouyu.html',
        'https://m.food.hiyd.com/detail-fd61c9f1.html',
        'https://m.food.hiyd.com/detail-roujiangdoufu.html',
        'https://m.food.hiyd.com/detail-cityhisuperhiyingguoyuanchanni.html',
        'https://m.food.hiyd.com/detail-jitucong_gan.html',
        'https://m.food.hiyd.com/detail-haoyouhiheihujiaoweibinggan.html',
        'https://m.food.hiyd.com/detail-jincaidihuotuichagan.html',
        'https://m.food.hiyd.com/detail-fdb9f095.html',
        'https://m.food.hiyd.com/detail-meilinsixiwanziguantou.html',
        'https://m.food.hiyd.com/detail-jianyikekoukele.html',
        'https://m.food.hiyd.com/detail-fdd63e1c.html',
        'https://m.food.hiyd.com/detail-fdb4ce94.html',
        'https://m.food.hiyd.com/detail-fd528644.html',
        'https://m.food.hiyd.com/detail-suancaizhengdoufu.html',
        'https://m.food.hiyd.com/detail-yurunhihongpeigen.html',
        'https://m.food.hiyd.com/detail-tangcuwoju.html',
        'https://m.food.hiyd.com/detail-nongxiehimijieguozhiyinliao_ha.html',
        'https://m.food.hiyd.com/detail-xiongjinbabameishikafei.html',
        'https://m.food.hiyd.com/detail-fd9f2f9d.html',
        'https://m.food.hiyd.com/detail-fd555d66.html',
        'https://m.food.hiyd.com/detail-duyijiafengganniurougan_yuanwe.html',
        'https://m.food.hiyd.com/detail-fdf81e23.html',
        'https://m.food.hiyd.com/detail-exianxiangcongwangbinggan.html',
        'https://m.food.hiyd.com/detail-fengsusuyipindansu.html',
        'https://m.food.hiyd.com/detail-CaffeBenelanmeizhanfangBlueber.html',
        'https://m.food.hiyd.com/detail-fubaocaomijuan_danhuangkouwei.html',
        'https://m.food.hiyd.com/detail-fd4190f2.html',
        'https://m.food.hiyd.com/detail-Banwshibanwahichaojijinzhuangc.html',
        'https://m.food.hiyd.com/detail-fd732576.html',
        'https://m.food.hiyd.com/detail-yexianghuolongguomusi.html',
        'https://m.food.hiyd.com/detail-dizhiniunaibingqilin.html',
        'https://m.food.hiyd.com/detail-heluxueqicaixuanzhiboluoqingpi.html',
        'https://m.food.hiyd.com/detail-fd8b69f5.html',
        'https://m.food.hiyd.com/detail-leyu.html',
        'https://m.food.hiyd.com/detail-tangshisanchaoshiziruangao.html',
        'https://m.food.hiyd.com/detail-senfengyuanduanshuyuanmi.html',
        'https://m.food.hiyd.com/detail-fdec1807.html',
        'https://m.food.hiyd.com/detail-jingleipaijingleisun.html',
        'https://m.food.hiyd.com/detail-fdaa9ec3.html',
        'https://m.food.hiyd.com/detail-guangmingdizhigaogainai.html',
        'https://m.food.hiyd.com/detail-fdfd854c.html',
        'https://m.food.hiyd.com/detail-EssentialhiEverydayhiToastedhi.html',
        'https://m.food.hiyd.com/detail-falizimochaquqi.html',
        'https://m.food.hiyd.com/detail-baixiangguobingjiling.html',
        'https://m.food.hiyd.com/detail-fangzhongshanhulatanghaidainiu.html',
        'https://m.food.hiyd.com/detail-meilijianxiaoboshiertongxianni.html',
        'https://m.food.hiyd.com/detail-jiemofenpi.html',
        'https://m.food.hiyd.com/detail-zhangyuzihuixiangchang.html',
        'https://m.food.hiyd.com/detail-fd97dddd.html',
        'https://m.food.hiyd.com/detail-fdb42b22.html',
        'https://m.food.hiyd.com/detail-majiangroupi2.html',
        'https://m.food.hiyd.com/detail-fd7dea52.html',
        'https://m.food.hiyd.com/detail-yingkeyuanhijiankangyusi.html',
        'https://m.food.hiyd.com/detail-Gerberhijiabaohi100himangguobo.html',
        'https://m.food.hiyd.com/detail-mozhouhuhiyingeryinyongshui.html',
        'https://m.food.hiyd.com/detail-fd4facd2.html',
        'https://m.food.hiyd.com/detail-fd75175a.html',
        'https://m.food.hiyd.com/detail-fd44869b.html',
        'https://m.food.hiyd.com/detail-xinzehiniujinwan.html',
        'https://m.food.hiyd.com/detail-DIVINEhiCLASSIChibuding.html',
        'https://m.food.hiyd.com/detail-yilihinaichunnaiyoubangbing.html',
        'https://m.food.hiyd.com/detail-fd492991.html',
        'https://m.food.hiyd.com/detail-leshihijiadeweidaohixianbing_n.html',
        'https://m.food.hiyd.com/detail-fdca355c.html',
        'https://m.food.hiyd.com/detail-lajiangroumoshaohaidai.html',
        'https://m.food.hiyd.com/detail-DHCdouruyinliao_suannaiwei.html',
        'https://m.food.hiyd.com/detail-luosennaiyouruishijuan.html',
        'https://m.food.hiyd.com/detail-zhaigonghilvchaqiaomaiganmian.html',
        'https://m.food.hiyd.com/detail-xinnonghiniudu_xianglawei.html',
        'https://m.food.hiyd.com/detail-fengweimingxia.html',
        'https://m.food.hiyd.com/detail-fd742c53.html',
        'https://m.food.hiyd.com/detail-zicaihuangguatang.html',
        'https://m.food.hiyd.com/detail-xigua_junzhi.html',
        'https://m.food.hiyd.com/detail-xiangjiao.html',
        'https://m.food.hiyd.com/detail-kaomopian.html',
        'https://m.food.hiyd.com/detail-caomei.html',
        'https://m.food.hiyd.com/detail-suannai_zhongzhi.html',
        'https://m.food.hiyd.com/detail-kekoukelexuebi_ningmeng.html',
        'https://m.food.hiyd.com/detail-putao_junzhi.html',
        'https://m.food.hiyd.com/detail-pingguo_junzhi.html',
        'https://m.food.hiyd.com/detail-fda0b238.html',
        'https://m.food.hiyd.com/detail-zixuegao.html',
        'https://m.food.hiyd.com/detail-annajuzijiangweibinggan.html',
        'https://m.food.hiyd.com/detail-fd0c655e.html',
        'https://m.food.hiyd.com/detail-wugupidanzhou.html',
        'https://m.food.hiyd.com/detail-beijingfangbianmian.html',
        'https://m.food.hiyd.com/detail-tangmianhilamian.html',
        'https://m.food.hiyd.com/detail-baolituozhiniunai.html',
        'https://m.food.hiyd.com/detail-yingtao.html',
        'https://m.food.hiyd.com/detail-cheng.html',
        'https://m.food.hiyd.com/detail-maihuadangao.html',
        'https://m.food.hiyd.com/detail-zizhihuashengdoujiang.html',
        'https://m.food.hiyd.com/detail-suayihaiweisanxianxiaohuntun.html',
        'https://m.food.hiyd.com/detail-CCLemon.html',
        'https://m.food.hiyd.com/detail-kafumaisiweieryuanweikafei.html',
        'https://m.food.hiyd.com/detail-kekoukeleqishui.html',
        'https://m.food.hiyd.com/detail-jingbaili.html',
        'https://m.food.hiyd.com/detail-defuchunheiqiaokeli.html',

    ]

    def parse(self, response):
        img_obj = FoodCrawlerItem()

        food_url = response.request.url
        print(food_url)
        img_obj['food_url'] = food_url

        img_url = response.xpath('//div[@class="img-wrap"]/img/@src').get()
        img_b64 = ''
        if img_url:
            img_url = img_url.strip()
            img_b64 = self.imgurl2b64(img_url)
        img_obj['img'] = img_b64

        yield img_obj

    # original
    # def parse(self, response):
    #     selector = response.xpath('//ul[@id="foodList"]/li')
    #
    #     for food in selector:
    #
    #         food_obj = FoodCrawlerItem()
    #         # cate_name = response.xpath('//div[@class="box"]/div[@class="box-hd"]/h2/text()').get().strip()
    #         # food_obj['cate_name'] = cate_name
    #
    #         food_name = food.xpath('a/div[@class="cont"]/h3/text()').get()
    #         if food_name:
    #             food_name = food_name.strip()
    #         food_obj['food_name'] = food_name
    #
    #         food_url = food.xpath('a/@href').get().strip()
    #         if food_url:
    #             food_url = response.urljoin(food_url)
    #         food_obj['food_url'] = food_url
    #         # print('food_url', food_url)
    #
    #         if food_url:
    #             yield scrapy.Request(url=food_url, meta={'item': food_obj}, callback=self.parse_detail)
    #
    #     next_page_url = response.xpath('//div[@id="hiyd_loader"]/a/@href').get()
    #     # print(next_page_url)
    #     if next_page_url:
    #         next_url = response.urljoin(next_page_url)
    #         print('next url: ', next_url)
    #         yield scrapy.Request(url=next_url, callback=self.parse, dont_filter=False)
    #     else:
    #         print('退出')
    #
    # def parse_detail(self, response):
    #     food_obj = response.meta['item']
    #
    #     img_url = response.xpath('//div[@class="img-wrap"]/img/@src').get()
    #     img_b64 = ''
    #     if img_url:
    #         img_url = img_url.strip()
    #         img_b64 = self.imgurl2b64(img_url)
    #     food_obj['img'] = img_b64
    #
    #     cate_name = response.xpath('//div[@class="cont"]/p/a/text()').get().strip()
    #     food_obj['cate_name'] = cate_name
    #
    #     # selector = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul')
    #
    #     # for response in selector:
    #     normal_weight = response.xpath('//div[@class="info-unit"]/div[@class="box-bd"]/ul/li[2]/p[1]/text()').get()
    #     if normal_weight:
    #         normal_weight = normal_weight.strip()
    #     food_obj['normal_weight'] = normal_weight
    #
    #     normal_calories = response.xpath('//div[@class="info-unit"]/div[@class="box-bd"]/ul/li[2]/p[2]/text()').get()
    #     if normal_calories:
    #         normal_calories = normal_calories.strip()
    #     food_obj['normal_calories'] = normal_calories
    #
    #     calories = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[2]/p[2]/text()').get().strip()
    #     food_obj['calories'] = calories
    #
    #     fat = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[3]/p[2]/text()').get().strip()
    #     food_obj['fat'] = fat
    #
    #     carbohydrate = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[4]/p[2]/text()').get().strip()
    #     food_obj['carbohydrate'] = carbohydrate
    #
    #     protein = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[5]/p[2]/text()').get().strip()
    #     food_obj['protein'] = protein
    #
    #     cholesterol = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[1]/li[6]/p[2]/text()').get().strip()
    #     food_obj['cholesterol'] = cholesterol
    #
    #     cellulose = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[2]/p[2]/text()').get().strip()
    #     food_obj['cellulose'] = cellulose
    #
    #     v_a = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[3]/p[2]/text()').get().strip()
    #     food_obj['v_a'] = v_a
    #
    #     v_c = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[4]/p[2]/text()').get().strip()
    #     food_obj['v_c'] = v_c
    #
    #     v_e = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[5]/p[2]/text()').get().strip()
    #     food_obj['v_e'] = v_e
    #
    #     carotene = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[6]/p[2]/text()').get().strip()
    #     food_obj['carotene'] = carotene
    #
    #     thiamine = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[7]/p[2]/text()').get().strip()
    #     food_obj['thiamine'] = thiamine
    #
    #     riboflavin = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[8]/p[2]/text()').get().strip()
    #     food_obj['riboflavin'] = riboflavin
    #
    #     niacin = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[2]/li[9]/p[2]/text()').get().strip()
    #     food_obj['niacin'] = niacin
    #
    #     magnesium = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[2]/p[2]/text()').get().strip()
    #     food_obj['magnesium'] = magnesium
    #
    #     calcium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[3]/p[2]/text()').get().strip()
    #     food_obj['calcium'] = calcium
    #
    #     iron = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[4]/p[2]/text()').get().strip()
    #     food_obj['iron'] = iron
    #
    #     zinc = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[5]/p[2]/text()').get().strip()
    #     food_obj['zinc'] = zinc
    #
    #     copper = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[6]/p[2]/text()').get().strip()
    #     food_obj['copper'] = copper
    #
    #     manganese = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[7]/p[2]/text()').get().strip()
    #     food_obj['manganese'] = manganese
    #
    #     potassium = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[8]/p[2]/text()').get().strip()
    #     food_obj['potassium'] = potassium
    #
    #     phosphorus = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[9]/p[2]/text()').get().strip()
    #     food_obj['phosphorus'] = phosphorus
    #
    #     sodium = response.xpath('//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[10]/p[2]/text()').get().strip()
    #     food_obj['sodium'] = sodium
    #
    #     selenium = response.xpath(
    #         '//div[@class="info-nurt"]/div[@class="box-bd"]/ul[3]/li[11]/p[2]/text()').get().strip()
    #     food_obj['selenium'] = selenium
    #
    #     yield food_obj

    def imgurl2b64(self, url):
        response = req.get(url)
        image = Image.open(BytesIO(response.content))
        b64 = base64.b64encode(BytesIO(response.content).read())
        return b64
        # print(b64)
