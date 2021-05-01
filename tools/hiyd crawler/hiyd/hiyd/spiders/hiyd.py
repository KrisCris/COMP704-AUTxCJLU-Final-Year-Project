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

        'https://m.food.hiyd.com/detail-mifan_zheng.html'
        , 'https://m.food.hiyd.com/detail-rishimanyufan.html'
        , 'https://m.food.hiyd.com/detail-yangrouzhuafan_er.html'
        , 'https://m.food.hiyd.com/detail-jiajiahehikalijiroufanhitaocan.html'
        , 'https://m.food.hiyd.com/detail-quanjiaFamilyMarthuadanhouqiez.html'
        , 'https://m.food.hiyd.com/detail-riqinghimeiweibaohirishikalini.html'
        , 'https://m.food.hiyd.com/detail-shousi.html'
        , 'https://m.food.hiyd.com/detail-guangzhiliangpinhigaifanbianda19.html'
        , 'https://m.food.hiyd.com/detail-shijinchaofan.html'
        , 'https://m.food.hiyd.com/detail-tianfuluo.html'
        , 'https://m.food.hiyd.com/detail-hanshishiguobanfan.html'
        , 'https://m.food.hiyd.com/detail-danmaifengweitusimianbao.html'
        , 'https://m.food.hiyd.com/detail-jinganmianbaofangyangjiaomianb.html'
        , 'https://m.food.hiyd.com/detail-zishumianbaojuan.html'
        , 'https://m.food.hiyd.com/detail-fd73a28e.html'
        , 'https://m.food.hiyd.com/detail-zhishihuotuidansanmingzhi.html'
        , 'https://m.food.hiyd.com/detail-hanbaobao_putongxing_jiaroubing_jiadiaoliaojiangheshucai.html'
        , 'https://m.food.hiyd.com/detail-rishipisa.html'
        , 'https://m.food.hiyd.com/detail-xingbakeHamSwissSandwich.html'
        , 'https://m.food.hiyd.com/detail-yitianmianguanhiwudongmian.html'
        , 'https://m.food.hiyd.com/detail-tianfuluoqiaomaimian.html'
        , 'https://m.food.hiyd.com/detail-jiandansumian_tangmian.html'
        , 'https://m.food.hiyd.com/detail-riqingshizujitanglamian.html'
        , 'https://m.food.hiyd.com/detail-niuroumian.html'
        , 'https://m.food.hiyd.com/detail-youpomian.html'
        , 'https://m.food.hiyd.com/detail-jiangyouchaomian.html'
        , 'https://m.food.hiyd.com/detail-dizhiyidalimian.html'
        , 'https://m.food.hiyd.com/detail-fd160eaf.html'
        , 'https://m.food.hiyd.com/detail-baiaijiahizhangyuwanzi.html'
        , 'https://m.food.hiyd.com/detail-baodihilijikaorou.html'
        , 'https://m.food.hiyd.com/detail-chaoshucaisi.html'
        , 'https://m.food.hiyd.com/detail-ganzhawanzi.html'
        , 'https://m.food.hiyd.com/detail-suanweikaoqiezi.html'
        , 'https://m.food.hiyd.com/detail-qingchaobocai_shaoyou.html'
        , 'https://m.food.hiyd.com/detail-shishutianfuluo.html'
        , 'https://m.food.hiyd.com/detail-TOPVALUhijishiweizengtang.html'
        , 'https://m.food.hiyd.com/detail-naiyoumogutang.html'
        , 'https://m.food.hiyd.com/detail-xiangchang.html'
        , 'https://m.food.hiyd.com/detail-fdebdfac.html'
        , 'https://m.food.hiyd.com/detail-xibanyayanlie.html'
        , 'https://m.food.hiyd.com/detail-KFChishangxiaojikuai.html'
        , 'https://m.food.hiyd.com/detail-sinianbeifangjiachangshuijiao_zhuroujiucai.html'
        , 'https://m.food.hiyd.com/detail-luobodunniurou.html'
        , 'https://m.food.hiyd.com/detail-kaoyu.html'
        , 'https://m.food.hiyd.com/detail-songzhayutiao.html'
        , 'https://m.food.hiyd.com/detail-basanwenyu.html'
        , 'https://m.food.hiyd.com/detail-yankaosanwenyu.html'
        , 'https://m.food.hiyd.com/detail-yuzhiyuhikaoxiangyupian.html'
        , 'https://m.food.hiyd.com/detail-fd718418.html'
        , 'https://m.food.hiyd.com/detail-qiubihihihishaohihisushishouxi.html'
        , 'https://m.food.hiyd.com/detail-tangcugulurou.html'
        , 'https://m.food.hiyd.com/detail-congyoukaoyu.html'
        , 'https://m.food.hiyd.com/detail-qingzhengjidangeng.html'
        , 'https://m.food.hiyd.com/detail-tianfuluo.html'
        , 'https://m.food.hiyd.com/detail-pijiuhezhaji.html'
        , 'https://m.food.hiyd.com/detail-xiangzharoupai.html'
        , 'https://m.food.hiyd.com/detail-songzhajitiao.html'
        , 'https://m.food.hiyd.com/detail-shuizhuyupian.html'
        , 'https://m.food.hiyd.com/detail-kalitudouniurou.html'
        , 'https://m.food.hiyd.com/detail-hanbaoroubing_junzhiban.html'
        , 'https://m.food.hiyd.com/detail-ganjianniupai.html'
        , 'https://m.food.hiyd.com/detail-zengyizengfengganyu.html'
        , 'https://m.food.hiyd.com/detail-yidianxinhixiezizhuroushaomai.html'
        , 'https://m.food.hiyd.com/detail-mapodoufu.html'
        , 'https://m.food.hiyd.com/detail-kaojirouchuan.html'
        , 'https://m.food.hiyd.com/detail-Frenzeljuanxincairoujuan.html'
        , 'https://m.food.hiyd.com/detail-jianjidan.html'
        , 'https://m.food.hiyd.com/detail-jianjidan.html'
        , 'https://m.food.hiyd.com/detail-hihihinadou.html'
        , 'https://m.food.hiyd.com/detail-zhonghuanendoufu.html'
        , 'https://m.food.hiyd.com/detail-jidanjuan.html'
        , 'https://m.food.hiyd.com/detail-liangmian.html'
        , 'https://m.food.hiyd.com/detail-qingjiaochaoniurou.html'
        , 'https://m.food.hiyd.com/detail-lurou.html'
        , 'https://m.food.hiyd.com/detail-yanshuizhujizhen.html'
        , 'https://m.food.hiyd.com/detail-yuzhiyuhikaoxiangyupian.html'
        , 'https://m.food.hiyd.com/detail-shousi.html'
        , 'https://m.food.hiyd.com/detail-yubing.html'
        , 'https://m.food.hiyd.com/detail-xianglaxia.html'
        , 'https://m.food.hiyd.com/detail-dawukaoji.html'
        , 'https://m.food.hiyd.com/detail-supiroujiao.html'
        , 'https://m.food.hiyd.com/detail-danchaofan.html'
        , 'https://m.food.hiyd.com/detail-jiqihixiangsuroupai.html'
        , 'https://m.food.hiyd.com/detail-fanqieroujiangyidalimian_1renf.html'
        , 'https://m.food.hiyd.com/detail-chaoxiaren.html'
        , 'https://m.food.hiyd.com/detail-rishitudoushala.html'
        , 'https://m.food.hiyd.com/detail-quanjiaxinshucaishala.html'
        , 'https://m.food.hiyd.com/detail-fdd076fd.html'
        , 'https://m.food.hiyd.com/detail-jinggonghishucaitang.html'
        , 'https://m.food.hiyd.com/detail-hongzaogouqidunzhuroutang.html'
        , 'https://m.food.hiyd.com/detail-yutoudoufutang.html'
        , 'https://m.food.hiyd.com/detail-hanshikaoniurou.html'
        , 'https://m.food.hiyd.com/detail-xiaochaoniurou.html'
        , 'https://m.food.hiyd.com/detail-haitaijipaifantuan.html'
        , 'https://m.food.hiyd.com/detail-quanjiaFamilyMartkaojiugongfan3.html'
        , 'https://m.food.hiyd.com/detail-tadahizhanshuimian.html'
        , 'https://m.food.hiyd.com/detail-regou_yuanwei.html'
        , 'https://m.food.hiyd.com/detail-shutiao_kendeji.html'
        , 'https://m.food.hiyd.com/detail-shijinchaofan.html'
        , 'https://m.food.hiyd.com/detail-xiangchaokugua.html'
        , 'https://m.food.hiyd.com/detail-sukali.html'
        , 'https://m.food.hiyd.com/detail-zizhiqiaomaimian.html'
        , 'https://m.food.hiyd.com/detail-guodingwumangguobuding.html'
        , 'https://m.food.hiyd.com/detail-cangwanggaoyuannongyuanhiguodo3.html'
        , 'https://m.food.hiyd.com/detail-fd64cff9.html'
        , 'https://m.food.hiyd.com/detail-jingcongtiebanniuliu.html'
        , 'https://m.food.hiyd.com/detail-guiguankalijirouchaofan.html'
        , 'https://m.food.hiyd.com/detail-shanzhichuhimalajiroufan.html'
        , 'https://m.food.hiyd.com/detail-gaolicaichaomifen.html'
        , 'https://m.food.hiyd.com/detail-danchaofan.html'
        , 'https://m.food.hiyd.com/detail-dongjinglamianhizhurouyishilao.html'
        , 'https://m.food.hiyd.com/detail-tianfuluo.html'
        , 'https://m.food.hiyd.com/detail-kalitudouniurou.html'
        , 'https://m.food.hiyd.com/detail-zaliangjianbing.html'
        , 'https://m.food.hiyd.com/detail-dongjinglamianhizhurouyishilao.html'
        , 'https://m.food.hiyd.com/detail-lianggongfangmeiguihua.html'
        , 'https://m.food.hiyd.com/detail-tilamisu_Tiramisu.html'
        , 'https://m.food.hiyd.com/detail-zizhisongbing.html'
        , 'https://m.food.hiyd.com/detail-nailaodangao.html'
        , 'https://m.food.hiyd.com/detail-silangguorensubinggan.html'
        , 'https://m.food.hiyd.com/detail-shaguozasui.html'
        , 'https://m.food.hiyd.com/detail-chuanweihuiguorou.html'
        , 'https://m.food.hiyd.com/detail-naiyoumogutang.html'
        , 'https://m.food.hiyd.com/detail-candou7.html'
        , 'https://m.food.hiyd.com/detail-yaxuefensitang.html'
        , 'https://m.food.hiyd.com/detail-yuanweitusi.html'
        , 'https://m.food.hiyd.com/detail-jinfenbocaimian.html'
        , 'https://m.food.hiyd.com/detail-fdadf13b.html'
        , 'https://m.food.hiyd.com/detail-dadunrou.html'
        , 'https://m.food.hiyd.com/detail-KFChishangxiaojikuai.html'
        , 'https://m.food.hiyd.com/detail-douchiyu.html'
        , 'https://m.food.hiyd.com/detail-mianbaojibanfashimianbao.html'
        , 'https://m.food.hiyd.com/detail-xiaomizhou.html'
        , 'https://m.food.hiyd.com/detail-mingzhukaomanpian.html'
        , 'https://m.food.hiyd.com/detail-shuangguaqingtang.html'
        , 'https://m.food.hiyd.com/detail-yudoufu.html'
        , 'https://m.food.hiyd.com/detail-facai_gan.html'
        , 'https://m.food.hiyd.com/detail-zicaifantuanzi.html'
        , 'https://m.food.hiyd.com/detail-zhazhupai_yi.html'
        , 'https://m.food.hiyd.com/detail-kaolijirou.html'
        , 'https://m.food.hiyd.com/detail-suanlayejipian.html'
        , 'https://m.food.hiyd.com/detail-jinhuahuotui.html'
        , 'https://m.food.hiyd.com/detail-bairoupian.html'
        , 'https://m.food.hiyd.com/detail-marou.html'
        , 'https://m.food.hiyd.com/detail-fdd75a33.html'
        , 'https://m.food.hiyd.com/detail-duomo.html'
        , 'https://m.food.hiyd.com/detail-laoyumibing.html'
        , 'https://m.food.hiyd.com/detail-xiangjianyumibing.html'
        , 'https://m.food.hiyd.com/detail-Doritoshiduoliduozihiyumipian.html'
        , 'https://m.food.hiyd.com/detail-roubing.html'
        , 'https://m.food.hiyd.com/detail-meishichaodan.html'
        , 'https://m.food.hiyd.com/detail-zhishixianshuxueyufan.html'
        , 'https://m.food.hiyd.com/detail-nanguaqiancengmianjuan.html'
        , 'https://m.food.hiyd.com/detail-kaisashala.html'
        , 'https://m.food.hiyd.com/detail-yanmaipian.html'
        , 'https://m.food.hiyd.com/detail-doushatangyuan.html'
        , 'https://m.food.hiyd.com/detail-baicainiangaotang.html'
        , 'https://m.food.hiyd.com/detail-yingshisongbing.html'
        , 'https://m.food.hiyd.com/detail-hanguobaomihua.html'
        , 'https://m.food.hiyd.com/detail-naiyoupaofu.html'
        , 'https://m.food.hiyd.com/detail-Viktoriaweikeduoliyaquanmaimianquanbing.html'
        , 'https://m.food.hiyd.com/detail-jianhipingguopai.html'
        , 'https://m.food.hiyd.com/detail-yizhiduocaomeixuemeiniangdongg.html'
        , 'https://m.food.hiyd.com/detail-guobaorou2.html'
        , 'https://m.food.hiyd.com/detail-yangrouchuan_kao.html'
        , 'https://m.food.hiyd.com/detail-qingjiaotudousi.html'
        , 'https://m.food.hiyd.com/detail-beijingkaoya.html'
        , 'https://m.food.hiyd.com/detail-fd03567c.html'
        , 'https://m.food.hiyd.com/detail-yidahiwuhuarou.html'
        , 'https://m.food.hiyd.com/detail-zhurouqincaixiaolongbao.html'
        , 'https://m.food.hiyd.com/detail-yuebing_danhuang.html'
        , 'https://m.food.hiyd.com/detail-danta.html'
        , 'https://m.food.hiyd.com/detail-zhengzonglanzhouniuroulamian.html'
        , 'https://m.food.hiyd.com/detail-aisenhixiangsuzhupai.html'
        , 'https://m.food.hiyd.com/detail-luroufan.html'
        , 'https://m.food.hiyd.com/detail-yuwantang.html'
        , 'https://m.food.hiyd.com/detail-mulizhou.html'
        , 'https://m.food.hiyd.com/detail-xiangguyoufan.html'
        , 'https://m.food.hiyd.com/detail-zhengluobogao.html'
        , 'https://m.food.hiyd.com/detail-youzhadoufu_choudoufu.html'
        , 'https://m.food.hiyd.com/detail-ningmengaiyudong.html'
        , 'https://m.food.hiyd.com/detail-dongyingongtang.html'
        , 'https://m.food.hiyd.com/detail-dongyingongtang.html'
        , 'https://m.food.hiyd.com/detail-suannaimuguashala.html'
        , 'https://m.food.hiyd.com/detail-qiongbaohainanwenchangji.html'
        , 'https://m.food.hiyd.com/detail-suanlayutiao.html'
        , 'https://m.food.hiyd.com/detail-baifuqinhisudongshucai_shijins.html'
        , 'https://m.food.hiyd.com/detail-zhenziweihihaoyouniuliu.html'
        , 'https://m.food.hiyd.com/detail-jinshuoniurougan_shadiawei.html'
        , 'https://m.food.hiyd.com/detail-fdb11636.html'
        , 'https://m.food.hiyd.com/detail-fd0b91db.html'
        , 'https://m.food.hiyd.com/detail-qingcairousimian.html'
        , 'https://m.food.hiyd.com/detail-zhurou_feishou.html'
        , 'https://m.food.hiyd.com/detail-hongshaozhuti.html'
        , 'https://m.food.hiyd.com/detail-shunshundedehiazhichuanshaozhu.html'
        , 'https://m.food.hiyd.com/detail-yibei_xian.html'
        , 'https://m.food.hiyd.com/detail-fd642a72.html'
        , 'https://m.food.hiyd.com/detail-hongshaorou.html'
        , 'https://m.food.hiyd.com/detail-shanzhichuhimalajiroufan.html'
        , 'https://m.food.hiyd.com/detail-hongsurou.html'
        , 'https://m.food.hiyd.com/detail-shucaiyuntuntang.html'
        , 'https://m.food.hiyd.com/detail-jiajiahehikalijiroufanhitaocan.html'
        , 'https://m.food.hiyd.com/detail-chaomian2.html'
        , 'https://m.food.hiyd.com/detail-jiajiahehikalijiroufanhitaocan.html'
        , 'https://m.food.hiyd.com/detail-yezijiqiutang.html'
        , 'https://m.food.hiyd.com/detail-chaoshanwanzitanghefen_hantang.html'
        , 'https://m.food.hiyd.com/detail-dalumifen_hantang.html'
        , 'https://m.food.hiyd.com/detail-yingyangdehaixianmian.html'
        , 'https://m.food.hiyd.com/detail-chunjuan3.html'
        , 'https://m.food.hiyd.com/detail-zhuchangfen.html'
        , 'https://m.food.hiyd.com/detail-jianshaoxiabing.html'
        , 'https://m.food.hiyd.com/detail-roujiamo.html'
        , 'https://m.food.hiyd.com/detail-jianmenniuroubing.html'
        , 'https://m.food.hiyd.com/detail-nanguagao.html'
        , 'https://m.food.hiyd.com/detail-doushatangyuan.html'
        , 'https://m.food.hiyd.com/detail-hehegugongbaojidingfan.html'
        , 'https://m.food.hiyd.com/detail-hongdoubuding.html'
        , 'https://m.food.hiyd.com/detail-yuanweitiantianquan.html'
        , 'https://m.food.hiyd.com/detail-qingzhengheyeyu.html'
        , 'https://m.food.hiyd.com/detail-changxiangyihigancaikouroufant.html'
        , 'https://m.food.hiyd.com/detail-Lampbellihijinbaohiniuweitang.html'
        , 'https://m.food.hiyd.com/detail-qiangjihitaiwanlurou.html'
        , 'https://m.food.hiyd.com/detail-chunjuan3.html'
        , 'https://m.food.hiyd.com/detail-fdbede49.html'
        , 'https://m.food.hiyd.com/detail-nanxiangyoutiao.html'
        , 'https://m.food.hiyd.com/detail-lvrunshijincai.html'
        , 'https://m.food.hiyd.com/detail-shijinchaofan.html'
        , 'https://m.food.hiyd.com/detail-zhajitui.html'
        , 'https://m.food.hiyd.com/detail-dawukaoji.html'
        , 'https://m.food.hiyd.com/detail-zhoudaozhoudaogangshijirouzhou.html'
        , 'https://m.food.hiyd.com/detail-rishikalitudoujikuai.html'
        , 'https://m.food.hiyd.com/detail-zizhicongyoubanmian.html'
        , 'https://m.food.hiyd.com/detail-Erascojiroumiantiao.html'
        , 'https://m.food.hiyd.com/detail-chaomian2.html'
        , 'https://m.food.hiyd.com/detail-shijinchaofan.html'
        , 'https://m.food.hiyd.com/detail-hanshishiguobanfan.html'
        , 'https://m.food.hiyd.com/detail-xianmifan_zheng.html'
        , 'https://m.food.hiyd.com/detail-shengkaoruzhurou.html'
        , 'https://m.food.hiyd.com/detail-mankedunxiangnongtusimianbao.html'
        , 'https://m.food.hiyd.com/detail-A1hirouguchamian.html'
        , 'https://m.food.hiyd.com/detail-haigehisupipaofu.html'
        , 'https://m.food.hiyd.com/detail-wangwanghilangweichaomian.html'
        , 'https://m.food.hiyd.com/detail-laobeijingzhajiangmian.html'
        , 'https://m.food.hiyd.com/detail-gongbaojiding2.html'
        , 'https://m.food.hiyd.com/detail-fengpeihishanghaicongyoujianbi.html'
        , 'https://m.food.hiyd.com/detail-shaoqiezi.html'
        , 'https://m.food.hiyd.com/detail-sanbeiji.html'
        , 'https://m.food.hiyd.com/detail-jiachangdoufu.html'
        , 'https://m.food.hiyd.com/detail-aisenhiqingchaohexiaren.html'
        , 'https://m.food.hiyd.com/detail-kaoguiyu.html'
        , 'https://m.food.hiyd.com/detail-baicaidoufudunrou.html'
        , 'https://m.food.hiyd.com/detail-sanxiandongguatang.html'
        , 'https://m.food.hiyd.com/detail-chizhizhengpaigu_jiulou.html'
        , 'https://m.food.hiyd.com/detail-tenongnanguapai.html'
        , 'https://m.food.hiyd.com/detail-babaofan.html'
        , 'https://m.food.hiyd.com/detail-fd64cff9.html'
        , 'https://m.food.hiyd.com/detail-xigua_zhengzhousanhao.html'
        , 'https://m.food.hiyd.com/detail-xiangjiao.html'
        , 'https://m.food.hiyd.com/detail-mantou_junzhi.html'
        , 'https://m.food.hiyd.com/detail-caomei.html'
        , 'https://m.food.hiyd.com/detail-suannai_guoli.html'
        , 'https://m.food.hiyd.com/detail-xuebi_qingshuangningmengwei.html'
        , 'https://m.food.hiyd.com/detail-putao_junzhi.html'
        , 'https://m.food.hiyd.com/detail-pingguo_junzhi.html'
        , 'https://m.food.hiyd.com/detail-yumi_xian.html'
        , 'https://m.food.hiyd.com/detail-DQbingxuehuanghoumochaxingren.html'
        , 'https://m.food.hiyd.com/detail-puzibinggan.html'
        , 'https://m.food.hiyd.com/detail-chayedan.html'
        , 'https://m.food.hiyd.com/detail-xiaomizhou.html'
        , 'https://m.food.hiyd.com/detail-hongshaoniuroufangbianmian_mianbingdiaoweiliaoshucairoujiang.html'
        , 'https://m.food.hiyd.com/detail-miantiao_xiarongmian.html'
        , 'https://m.food.hiyd.com/detail-guangmingchunxianniunai.html'
        , 'https://m.food.hiyd.com/detail-heiyingtao.html'
        , 'https://m.food.hiyd.com/detail-jieganzi.html'
        , 'https://m.food.hiyd.com/detail-dangao_junzhi.html'
        , 'https://m.food.hiyd.com/detail-doujiang_tian.html'
        , 'https://m.food.hiyd.com/detail-xianrouxiaohuntun.html'
        , 'https://m.food.hiyd.com/detail-haitailiguorouguozhiyinliao.html'
        , 'https://m.food.hiyd.com/detail-maisiweieryuanweikafei.html'
        , 'https://m.food.hiyd.com/detail-baishikele.html'
        , 'https://m.food.hiyd.com/detail-li_junzhi.html'
        , 'https://m.food.hiyd.com/detail-jindibeikeli_chunnongheiqiaoke.html'

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
        b64 = str(base64.b64encode(BytesIO(response.content).read()))
        return b64[2:-1]
        # print(b64)
