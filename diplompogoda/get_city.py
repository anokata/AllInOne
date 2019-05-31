import requests
from requests_toolbelt.utils import dump
import json


cities = [
"Нью-Йорк",
"Tokyo",
"Апиа",
"Веллингтон",
"Канберра",
"Маджуро",
"Нгерулмуд",
"Нукуалофа",
"Паликир",
"Порт",
"Порт",
"Сува",
"Фунафути",
"Хониара",
"Южная",
"Асунсьон",
"Бастер",
"Бельмопан",
"Богота",
"Бразилиа",
"Бриджтаун",
"Буэнос",
"Вашингтон",
"Гавана",
"Гватемала",
"Джорджтаун",
"Каракас",
"Кастри",
"Кингстаун",
"Кингстон",
"Кито",
"Лима",
"Манагуа",
"Мехико",
"Монтевидео",
"Нассау",
"Оттава",
"Панама",
"Парамарибо",
"Порт",
"Порт",
"Розо",
"Сан",
"Сан",
"Санто",
"Сантьяго",
"Сент",
"Сент",
"Сукре",
"Тегусигальпа",
"Абуджа",
"Аддис",
"Аккра",
"Алжир",
"Антананариву",
"Асмэра",
"Бамако",
"Банги",
"Банжул",
"Бисау",
"Браззавиль",
"Виктория",
"Виндхук",
"Габороне",
"Гитега",
"Дакар",
"Джибути",
"Джуба",
"Додома",
"Каир",
"Кампала",
"Кигали",
"Киншаса",
"Конакри",
"Либревиль",
"Лилонгве",
"Ломе",
"Луанда",
"Лусака",
"Малабо",
"Мапуту",
"Масеру",
"Мбабане",
"Могадишо",
"Монровия",
"Морони",
"Найроби",
"Нджамена",
"Ниамей",
"Нуакшот",
"Порт",
"Порто",
"Прая",
"Претория",
"Рабат",
"Сан",
"Триполи",
"Тунис",
"Уагадугу",
"Фритаун",
"Хараре",
"Хартум",
"Ямусукро",
"Яунде",
"Абу",
"Амман",
"Анкара",
"Ашхабад",
"Багдад",
"Баку",
"Бангкок",
"Бандар",
"Бейрут",
"Бишкек",
"Вьентьян",
"Дакка",
"Дамаск",
"Дели",
"Джакарта",
"Дили",
"Доха",
"Душанбе",
"Ереван",
"Иерусалим",
"Исламабад",
"Кабул",
"Катманду",
"Куала",
"Мале",
"Манама",
"Манила",
"Маскат",
"Нейпьидо",
"Никосия",
"Нур",
"Пекин",
"Пномпень",
"Пхеньян",
"Сана",
"Сеул",
"Сингапур",
"Ташкент",
"Тбилиси",
"Тегеран",
"Токио",
"Тхимпху",
"Улан",
"Ханой",
"Шри",
"Эль",
"Эр",
"Амстердам",
"Андорра",
"Афины",
"Белград",
"Берлин",
"Берн",
"Братислава",
"Брюссель",
"Будапешт",
"Бухарест",
"Вадуц",
"Валлетта",
"Варшава",
"Ватикан",
"Вена",
"Вильнюс",
"Дублин",
"Загреб",
"Киев",
"Кишинёв",
"Копенгаген",
"Лиссабон",
"Лондон",
"Любляна",
"Люксембург",
"Мадрид",
"Минск",
"Монако",
"Москва",
"Осло",
"Париж",
"Подгорица",
"Прага",
"Рейкьявик",
"Рига",
"Рим",
"Сан",
"Сараево",
"Скопье",
"София",
"Стокгольм",
"Таллин",
"Тирана",
"Хельсинки",
]

cities = [
"Ватикан",
"Сан-Марино",
"Вадуц",
"Лобамба",
"Люксембург",
"Паликир",
"Маджуро",
"Фунафути",
"Мелекеок",
"Бир-Лелу",
"Монако",
"Тарава",
"Морони",
"Андорра-ла-Велья",
"Порт-оф-Спейн",
"Кигали",
"Мбабане",
"Джуба",
"Гаага",
"Любляна",
"Братислава",
"Доха",
"Подгорица",
"Шри-Джаяварденепура-Котте",
"Багио",
"Додома",
"Берн",
"Эль-Аюн",
"Приштина",
"Розо",
"Джибути",
"Путраджая",
"Киото",
"Банжул",
"Скопье",
"Бриджтаун",
"Порто-Ново",
"Бужумбура",
"Кингстаун",
"Кастри",
"Бастер",
"Порт-Луи",
"Сент-Джорджес",
"Манама",
"Сент-Джонс",
"Монтевидео",
"Ломе",
"Тунис",
"Абу-Даби",
"Ашхабад",
"Лусака",
"Хараре",
"Дили",
"Порт-Вила",
"Тегусигальпа",
"Джорджтаун",
"Рейкьявик",
"Порт-о-Пренс",
"Кампала",
"Парамарибо",
"Ниамей",
"Душанбе",
"Асунсьон",
"Манагуа",
"Фритаун",
"Исламабад",
"Катманду",
"Блумфонтейн",
"Претория",
"Порт-Морсби",
"Хониара",
"Панама",
"Рабат",
"Кишинёв",
"Мапуту",
"Могадишо",
"Маскат",
"Коломбо",
"Улан-Батор",
"Виндхук",
"Абуджа",
"Бисау",
"Амман",
"Вильнюс",
"Рига",
"Бишкек",
"Масеру",
"Антананариву",
"Кито",
"Сан-Хосе",
"Сан-Сальвадор",
"Кингстон",
"Нджамена",
"Малабо",
"Асмэра",
"Загреб",
"Таллин",
"Лилонгве",
"Гватемала",
"Либревиль",
"Сува",
"Вальпараисо",
"Нуакшот",
"Бамако",
"Бейрут",
"Тбилиси",
"Астана",
"Вьентьян",
"Браззавиль",
"Конакри",
"Ямусукро",
"Оттава",
"Белград",
"Бандар-Сери-Бегаван",
"Сукре",
"Бельмопан",
"Банги",
"Яунде",
"Тирана",
"Ереван",
"Баку",
"Пномпень",
"Ла-Пас",
"Котону",
"София",
"Минск",
"Тхимпху",
"Габороне",
"Канберра",
"Уагадугу",
"Сараево",
"Нейпьидо",
"Нукуалофа",
"Харгейса",
"Виктория",
"Сан-Томе",
"Апиа",
"Валлетта",
"Мале",
"Иерусалим",
"Прая",
"Нассау",
"Никосия",
"Веллингтон",
"Ханой",
"Анкара",
"Будапешт",
"Сана",
"Бухарест",
"Дамаск",
"Лиссабон",
"Хартум",
"Осло",
"Варшава",
"Пхеньян",
"Дар-эс-Салам",
"Дублин",
"Монровия",
"Куала-Лумпур",
"Гавана",
"Прага",
"Эль-Кувейт",
"Санто-Доминго",
"Аккра",
"Триполи",
"Тель-Авив",
"Хельсинки",
"Копенгаген",
"Абиджан",
"Бразилиа",
"Брюссель",
"Дакка",
"Луанда",
"Алжир",
"Янгон",
"Сан-Франциско",
"Денвер",
"Хьюстон",
"Майами",
"Атланта",
"Чикаго",
"Каракас",
"Киев",
"Дубай",
"Ташкент",
"Мадрид",
"Женева",
"Стокгольм",
"Бангкок",
"Лима",
"Дакар",
"Йоханнесбург",
"Амстердам",
"Касабланка",
"Сеул",
"Манила",
"Монтеррей",
"Берлин",
"Урумчи",
"Чэнду",
"Осака",
"Киншаса",
"Нью-Дели",
"Бангалор",
"Афины",
"Багдад",
"Аддис-Абеба",
"Тегеран",
"Ванкувер",
"Торонто",
"Буэнос-Айрес",
"Кабул",
"Вена",
"Мельбурн",
"Тайбэй",
"Окленд",
"Лос-Анджелес",
"Вашингтон",
"Нью-Йорк",
"Лондон",
"Стамбул",
"Эр-Рияд",
"Кейптаун",
"Москва",
"Мехико",
"Лагос",
"Рим",
"Пекин",
"Найроби",
"Джакарта",
"Богота",
"Каир",
"Шанхай",
"Токио",
"Мумбаи",
"Париж",
"Сантьяго",
"Калькутта",
"Рио-де-Жанейро",
"Сан-Паулу",
"Сидней",
"Сингапур",
"Гонконг"
        ]

cities = [
"Санкт-Петербург", "Калининград", "Саратов", "Казань", "Ростов-на-Дону", "Тула", "Астрахань", "Нижний", "Самара", "Воронеж", "Курск", "Оренбург", "Ярославль", "Орёл", "Краснодар", "Пенза", "Волгоград", "Иваново", "Крым", "Тверь", "Томск", "Новочеркасск", "Иркутск", "Таганрог", "Калуга", "Уфа", "Тамбов", "Елец", "Смоленск", "Рязань", "Пермь", "Владикавказ", "Екатеринбург", "Ульяновск", "Ставрополь", "Кострома", "Омск", "Майкоп", "Керчь", "Благовещенск", "Сызрань", "Серпухов", "Псков", "Тагил", "Тюмень", "Владивосток", "Владимир", "Вологда", "Красноярск", "Белгород", "Великий",
"Рыбинск", "Киров", "Брянск", "Сергиев", "Барнаул", "Архангельск", "Липецк", "Златоуст", "Коломна", "Челябинск", "Пятигорск", "Евпатория", "Бийск", "Новороссийск", "Шахты", "Камышин", "Старый", "Грозный", "Стерлитамак", "Хабаровск", "Дербент", "Саранск", "Ковров", "Орск", "Муром", "Петрозаводск", "Чита", "Ногинск", "Уссурийск", "Арзамас", "Курган", "Махачкала", "Улан-Удэ", "Череповец", "Ачинск", "Якутск", "Тольятти", "Чебоксары", "Сыктывкар", "Подольск", "Новокузнецк", "Йошкар-Ола", "Челны"]
#["Азов", "Александров", "Алексин", "Альметьевск", "Анапа", "Ангарск", "Анжеро-Судженск", "Апатиты", "Арзамас", "Армавир", "Арсеньев", "Артем", "Архангельск", "Асбест", "Астрахань", "Ачинск", "Балаково", "Балахна", "Балашиха", "Балашов", "Барнаул", "Батайск", "Белгород", "Белебей", "Белово", "Белогорск (Амурская область)", "Белорецк", "Белореченск", "Бердск", "Березники", "Березовский (Свердловская область)", "Бийск", "Биробиджан", "Благовещенск (Амурская область)", "Бор", "Борисоглебск", "Боровичи", "Братск", "Брянск", "Бугульма", "Буденновск", "Бузулук", "Буйнакск", "Великие Луки", "Великий Новгород", "Верхняя Пышма", "Видное", "Владивосток", "Владикавказ", "Владимир", "Волгоград", "Волгодонск", "Волжск", "Волжский", "Вологда", "Вольск", "Воркута", "Воронеж", "Воскресенск", "Воткинск", "Всеволожск", "Выборг", "Выкса", "Вязьма", "Гатчина", "Геленджик", "Георгиевск", "Глазов", "Горно-Алтайск", "Грозный", "Губкин", "Гудермес", "Гуково", "Гусь-Хрустальный", "Дербент", "Дзержинск", "Димитровград", "Дмитров", "Долгопрудный", "Домодедово", "Донской", "Дубна", "Евпатория", "Егорьевск", "Ейск", "Екатеринбург", "Елабуга", "Елец", "Ессентуки", "Железногорск (Красноярский край)", "Железногорск (Курская область)", "Жигулевск", "Жуковский", "Заречный", "Зеленогорск", "Зеленодольск", "Златоуст", "Иваново", "Ивантеевка", "Ижевск", "Избербаш", "Иркутск", "Искитим", "Ишим", "Ишимбай", "Йошкар-Ола", "Казань", "Калининград", "Калуга", "Каменск-Уральский", "Каменск-Шахтинский", "Камышин", "Канск", "Каспийск", "Кемерово", "Керчь", "Кинешма", "Кириши", "Киров (Кировская область)", "Кирово-Чепецк", "Киселевск", "Кисловодск", "Клин", "Клинцы", "Ковров", "Когалым", "Коломна", "Комсомольск-на-Амуре", "Копейск", "Королев", "Кострома", "Котлас", "Красногорск", "Краснодар", "Краснокаменск", "Краснокамск", "Краснотурьинск", "Красноярск", "Кропоткин", "Крымск", "Кстово", "Кузнецк", "Кумертау", "Кунгур", "Курган", "Курск", "Кызыл", "Лабинск", "Лениногорск", "Ленинск-Кузнецкий", "Лесосибирск", "Липецк", "Лиски", "Лобня", "Лысьва", "Лыткарино", "Люберцы", "Магадан", "Магнитогорск", "Майкоп", "Махачкала", "Междуреченск", "Мелеуз", "Миасс", "Минеральные Воды", "Минусинск", "Михайловка", "Михайловск (Ставропольский край)", "Мичуринск", "Москва", "Мурманск", "Муром", "Мытищи", "Набережные Челны", "Назарово", "Назрань", "Нальчик", "Наро-Фоминск", "Находка", "Невинномысск", "Нерюнгри", "Нефтекамск", "Нефтеюганск", "Нижневартовск", "Нижнекамск", "Нижний Новгород", "Нижний Тагил", "Новоалтайск", "Новокузнецк", "Новокуйбышевск", "Новомосковск", "Новороссийск", "Новосибирск", "Новотроицк", "Новоуральск", "Новочебоксарск", "Новочеркасск", "Новошахтинск", "Новый Уренгой", "Ногинск", "Норильск", "Ноябрьск", "Нягань", "Обнинск", "Одинцово", "Озерск (Челябинская область)", "Октябрьский", "Омск", "Орел", "Оренбург", "Орехово-Зуево", "Орск", "Павлово", "Павловский Посад", "Пенза", "Первоуральск", "Пермь", "Петрозаводск", "Петропавловск-Камчатский", "Подольск", "Полевской", "Прокопьевск", "Прохладный", "Псков", "Пушкино", "Пятигорск", "Раменское", "Ревда", "Реутов", "Ржев", "Рославль", "Россошь", "Ростов-на-Дону", "Рубцовск", "Рыбинск", "Рязань", "Салават", "Сальск", "Самара", "Санкт-Петербург", "Саранск", "Сарапул", "Саратов", "Саров", "Свободный", "Севастополь", "Северодвинск", "Северск", "Сергиев Посад", "Серов", "Серпухов", "Сертолово", "Сибай", "Симферополь", "Славянск-на-Кубани", "Смоленск", "Соликамск", "Солнечногорск", "Сосновый Бор", "Сочи", "Ставрополь", "Старый Оскол", "Стерлитамак", "Ступино", "Сургут", "Сызрань", "Сыктывкар", "Таганрог", "Тамбов", "Тверь", "Тимашевск", "Тихвин", "Тихорецк", "Тобольск", "Тольятти", "Томск", "Троицк", "Туапсе", "Туймазы", "Тула", "Тюмень", "Узловая", "Улан-Удэ", "Ульяновск", "Урус-Мартан", "Усолье-Сибирское", "Уссурийск", "Усть-Илимск", "Уфа", "Ухта", "Феодосия", "Фрязино", "Хабаровск", "Ханты-Мансийск", "Хасавюрт", "Химки", "Чайковский", "Чапаевск", "Чебоксары", "Челябинск", "Черемхово", "Череповец", "Черкесск", "Черногорск", "Чехов", "Чистополь", "Чита", "Шадринск", "Шали", "Шахты", "Шуя", "Щекино", "Щелково", "Электросталь", "Элиста", "Энгельс", "Южно-Сахалинск", "Юрга", "Якутск", "Ялта", "Ярославль", 
#"Нью-Йорк", "Дели", "Tokyo", "Апиа", "Веллингтон", "Канберра", "Маджуро", "Нгерулмуд", "Нукуалофа", "Паликир", "Порт", "Порт", "Сува", "Фунафути", "Хониара", "Южная", "Асунсьон", "Бастер", "Бельмопан", "Богота", "Бразилиа", "Бриджтаун", "Буэнос", "Вашингтон", "Гавана", "Гватемала", "Джорджтаун", "Каракас", "Кастри", "Кингстаун", "Кингстон", "Кито", "Лима", "Манагуа", "Мехико", "Монтевидео", "Нассау", "Оттава", "Панама", "Парамарибо", "Порт", "Порт", "Розо", "Сан", "Сан", "Санто", "Сантьяго", "Сент", "Сент", "Сукре", "Тегусигальпа", "Абуджа", "Аддис", "Аккра", "Алжир", "Антананариву", "Асмэра", "Бамако", "Банги", "Банжул", "Бисау", "Браззавиль", "Виктория", "Виндхук", "Габороне", "Гитега", "Дакар", "Джибути", "Джуба", "Додома", "Каир", "Кампала", "Кигали", "Киншаса", "Конакри", "Либревиль", "Лилонгве", "Ломе", "Луанда", "Лусака", "Малабо", "Мапуту", "Масеру", "Мбабане", "Могадишо", "Монровия", "Морони", "Найроби", "Нджамена", "Ниамей", "Нуакшот", "Порт", "Порто", "Прая", "Претория", "Рабат", "Сан", "Триполи", "Тунис", "Уагадугу", "Фритаун", "Хараре", "Хартум", "Ямусукро", "Яунде", "Абу", "Амман", "Анкара", "Ашхабад", "Багдад", "Баку", "Бангкок", "Бандар", "Бейрут", "Бишкек", "Вьентьян", "Дакка", "Дамаск", "Дели", "Джакарта", "Дили", "Доха", "Душанбе", "Ереван", "Иерусалим", "Исламабад", "Кабул", "Катманду", "Куала", "Мале", "Манама", "Манила", "Маскат", "Нейпьидо", "Никосия", "Нур", "Пекин", "Пномпень", "Пхеньян", "Сана", "Сеул", "Сингапур", "Ташкент", "Тбилиси", "Тегеран", "Токио", "Тхимпху", "Улан", "Ханой", "Шри", "Эль", "Эр", "Амстердам", "Андорра", "Афины", "Белград", "Берлин", "Берн", "Братислава", "Брюссель", "Будапешт", "Бухарест", "Вадуц", "Валлетта", "Варшава", "Ватикан", "Вена", "Вильнюс", "Дублин", "Загреб", "Киев", "Кишинёв", "Копенгаген", "Лиссабон", "Лондон", "Любляна", "Люксембург", "Мадрид", "Минск", "Монако", "Москва", "Осло", "Париж", "Подгорица", "Прага", "Рейкьявик", "Рига", "Рим", "Сан", "Сараево", "Скопье", "София", "Стокгольм", "Таллин", "Тирана", "Хельсинки", 
#"Ватикан", "Сан-Марино", "Вадуц", "Лобамба", "Люксембург", "Паликир", "Маджуро", "Фунафути", "Мелекеок", "Бир-Лелу", "Монако", "Тарава", "Морони", "Андорра-ла-Велья", "Порт-оф-Спейн", "Кигали", "Мбабане", "Джуба", "Гаага", "Любляна", "Братислава", "Доха", "Подгорица", "Шри-Джаяварденепура-Котте", "Багио", "Додома", "Берн", "Эль-Аюн", "Приштина", "Розо", "Джибути", "Путраджая", "Киото", "Банжул", "Скопье", "Бриджтаун", "Порто-Ново", "Бужумбура", "Кингстаун", "Кастри", "Бастер", "Порт-Луи", "Сент-Джорджес", "Манама", "Сент-Джонс", "Монтевидео", "Ломе", "Тунис", "Абу-Даби", "Ашхабад", "Лусака", "Хараре", "Дили", "Порт-Вила", "Тегусигальпа", "Джорджтаун", "Рейкьявик", "Порт-о-Пренс", "Кампала", "Парамарибо", "Ниамей", "Душанбе", "Асунсьон", "Манагуа", "Фритаун", "Исламабад", "Катманду", "Блумфонтейн", "Претория", "Порт-Морсби", "Хониара", "Панама", "Рабат", "Кишинёв", "Мапуту", "Могадишо", "Маскат", "Коломбо", "Улан-Батор", "Виндхук", "Абуджа", "Бисау", "Амман", "Вильнюс", "Рига", "Бишкек", "Масеру", "Антананариву", "Кито", "Сан-Хосе", "Сан-Сальвадор", "Кингстон", "Нджамена", "Малабо", "Асмэра", "Загреб", "Таллин", "Лилонгве", "Гватемала", "Либревиль", "Сува", "Вальпараисо", "Нуакшот", "Бамако", "Бейрут", "Тбилиси", "Астана", "Вьентьян", "Браззавиль", "Конакри", "Ямусукро", "Оттава", "Белград", "Бандар-Сери-Бегаван", "Сукре", "Бельмопан", "Банги", "Яунде", "Тирана", "Ереван", "Баку", "Пномпень", "Ла-Пас", "Котону", "София", "Минск", "Тхимпху", "Габороне", "Канберра", "Уагадугу", "Сараево", "Нейпьидо", "Нукуалофа", "Харгейса", "Виктория", "Сан-Томе", "Апиа", "Валлетта", "Мале", "Иерусалим", "Прая", "Нассау", "Никосия", "Веллингтон", "Ханой", "Анкара", "Будапешт", "Сана", "Бухарест", "Дамаск", "Лиссабон", "Хартум", "Осло", "Варшава", "Пхеньян", "Дар-эс-Салам", "Дублин", "Монровия", "Куала-Лумпур", "Гавана", "Прага", "Эль-Кувейт", "Санто-Доминго", "Аккра", "Триполи", "Тель-Авив", "Хельсинки", "Копенгаген", "Абиджан", "Бразилиа", "Брюссель", "Дакка", "Луанда", "Алжир", "Янгон", "Сан-Франциско", "Денвер", "Хьюстон", "Майами", "Атланта", "Чикаго", "Каракас", "Киев", "Дубай", "Ташкент", "Мадрид", "Женева", "Стокгольм", "Бангкок", "Лима", "Дакар", "Йоханнесбург", "Амстердам", "Касабланка", "Сеул", "Манила", "Монтеррей", "Берлин", "Урумчи", "Чэнду", "Осака", "Киншаса", "Нью-Дели", "Бангалор", "Афины", "Багдад", "Аддис-Абеба", "Тегеран", "Ванкувер", "Торонто", "Буэнос-Айрес", "Кабул", "Вена", "Мельбурн", "Тайбэй", "Окленд", "Лос-Анджелес", "Вашингтон", "Нью-Йорк", "Лондон", "Стамбул", "Эр-Рияд", "Кейптаун", "Москва", "Мехико", "Лагос", "Рим", "Пекин", "Найроби", "Джакарта", "Богота", "Каир", "Шанхай", "Токио", "Мумбаи", "Париж", "Сантьяго", "Калькутта", "Рио-де-Жанейро", "Сан-Паулу", "Сидней", "Сингапур", "Гонконг" ]; 

def find_coord(j):
    for s in j["suggestions"]:
        if s["data"].get("geo_lon"):
            lon = s["data"]["geo_lon"]
            lat = s["data"]["geo_lat"]
            return (lon, lat)
    return (None, None)


for city in cities:
    url = "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address"
    headers = {
            "Content-Type": "application/json", 
            "Accept": "application/json", 
            "Authorization": "Token a21ae8d8246ebf44e4c99a8dd9e6786d3a56ca0a"}
    data = {
            "query": city, 
            "count":"10",
            "locations": [ { "country": "*" }]
            }
    data = json.dumps(data)
    r = requests.post(url, data=data, params=data, headers=headers)
    data = dump.dump_all(r)
    j = r.json()
    (lon, lat) = find_coord(j)
    if lon is not None:
        print('"{}": ["{}", "{}"],'.format(city, lat, lon))

