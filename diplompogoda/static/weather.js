const FORECAST_LEN = 7;
// Подпрограмма отправки API запроса получения данных погоды и обработки результата
function send(weather_data, city, lat, lon, f) {
    var zone = "";
    if (weather_data[city]) {
        zone = weather_data[city]['zone'];
		cname = weather_data[city]['cname'];
    }
    var query = '';
    // Определение базового URL сервера (тестовый или продуктивный)
    if (where_am_i()) {
        query = 'http://ksilenomen.pythonanywhere.com/pogoda/'
    } else {
        query = 'http://127.0.0.1:5000/pogoda/'
    }
    // Создание объекта для AJAX запроса
    var xhr = new XMLHttpRequest();
    // Конфигурация объекта запроса
    var params = "lat=" + lat + "&lon=" + lon;
    xhr.open('POST', query, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    
    // Установка функции обработки результата запроса
    xhr.onload = function() {
        // Парсинг ответа в JSON формате
        data = JSON.parse(this.responseText);
        // Формирование результирующих данных на основе ответа
        weather_data[city] = {
			"time": data['fact']['obs_time'],
			"wind_dir": data['fact']['wind_dir'],
            "temp": data['fact']['temp'],
            "condition": data['fact']['condition'],
            "humidity": data['fact']['humidity'],
            "info": data['info']['url'],
            "feels_like": data['fact']['feels_like'],
            "temp_water": data['fact']['temp_water'],
            "wind_speed": data['fact']['wind_speed'],
            "pressure_mm": data['fact']['pressure_mm'],
            "season": data['fact']['season'],
            "forecasts": data['forecasts'],
			"icon": data['fact']['icon'],
			"zone": zone,
			"cname": cname,

        };
        // Вызов функции обработки результата
        if (f) f(weather_data);
        return data;
    }
  
    // Выполение AJAX запроса к серверу предоставляющему данные Яндекс.Погоды
    xhr.send(params); 
}

// Подпрограмма отображения погодных данных 
function view(weather_data) {
    // Получение названия города
    city = weather_data["city"] || Object.keys(weather_data)[0];

/* Вывод данных о погоде в выбранном пункте */
    // В элемент странци с id city_name вставить название города в качестве текста
	$("#city_name").text(city);
	$("#country_name").text(weather_data[city].cname);
	$("#time").text(timetzConverter(moment.tz(time_unix2date(weather_data[city]["time"]), weather_data[city].zone)));
	$("#temp").text(human_temp(weather_data[city]["temp"]) + "°C");
	$("#feel").text(human_temp(weather_data[city]["feels_like"]) + "°C");
	$("#wind").text(human_wind(weather_data[city]["wind_dir"], weather_data[city]["wind_speed"]));
	$("#pressure").text(weather_data[city]["pressure_mm"] + " мм рт. ст.");
	$("#condition").text(human_condition(weather_data[city]["condition"]));
	$("#humidity").text(weather_data[city]["humidity"] + "%")
    // Если есть данные температуры воды
    if (weather_data[city]["temp_water"]) {
        // Отобразить температуру воды
        $("#temp_water").parent().css("display", "table-row");
		$("#temp_water").text(human_temp(weather_data[city]["temp_water"]) + "°");
	} else {
        // Если нет, то скрыть элемент с температурой воды
        $("#temp_water").parent().css("display", "none");
		$("#temp_water_tr").css("display", "none");
	}
    // Если не полярные день/ночь
    if (!weather_data[city].forecasts[0].parts.day.polar) {
        // Вывести время восхода и заката
        if (weather_data[city]["forecasts"][0]["sunrise"]) {
            $("#rise").text(weather_data[city]["forecasts"][0]["sunrise"]);
        }
        if (weather_data[city]["forecasts"][0]["sunset"]) {
            $("#sunset").text(weather_data[city]["forecasts"][0]["sunset"]);
            // Вывести долготу дня
            $("#day_long").text(daylong(weather_data[city]["forecasts"][0]["sunrise"], weather_data[city]["forecasts"][0]["sunset"]));
        $("#rise").parent().show();
        $("#sunset").parent().show();
        }
    } else {
        // В случае полядного дня/ночи прячем элементы с восходом и закатом
        $("#rise").parent().hide();
        $("#sunset").parent().hide();
        $("#day_long").text("");
        if (weather_data[city].forecasts[0].parts.day.daytime == "n") {
            $("#day_long").text("Полярная ночь");
        } else {
            $("#day_long").text("Полярный день");
        }
    }

    // Вывод фазы луны
	$("#moon").text(human_moon(weather_data[city]["forecasts"][0]["moon_text"]));
    // Отображение иконки соответствующей погодным условиям
	$("#icon img").attr("src", make_icon(weather_data[city]["icon"]));
    // Отображение УФ индекса
    let uv = weather_data[city].forecasts[0].parts.day.uv_index;
    if (uv != null && uv != undefined) {
        $("#uv_index").text(human_uv(uv));
        $("#uv_index").parent().show();
    } else {
        $("#uv_index").parent().hide();
    }

    // Вычисление текущего часа с учётом часового пояса
    var datetz = moment.tz(new Date(), weather_data[city].zone);
    var hour = Number(datetz.format("H"));
	
    var j = 1;
    // Вывод почасового прогноза с текущего часа, 12 часов
    for (let i = hour; i < hour + 13; i++) {
        var h = i % 24;
        $("#hour_" + j + "_time").text(h + ":00");
        $("#hour_" + j).text(human_temp_grad(weather_data[city].forecasts[0].hours[h].temp));
        $("#hour_" + j + "_icon").attr("src", make_icon(weather_data[city].forecasts[0].hours[h].icon));
        j++;
    }
    // Отображение краткой сводки погоды на сегодня и 5 дней вперёд
    for (let i = 0; i < FORECAST_LEN; i++) {
        var date = new Date(weather_data[city].forecasts[i].date);
        var date_str = make_human_date(weather_data[city].forecasts[i].date)
        // Формирование дня недели
        var weekday = upper_first(date.toLocaleString('ru-ru', { weekday: 'short' }));
        $("#day_" + i).text(date_str);
        $("#day_" + i + "_week").text(weekday);
        if (date.getDay() % 6 == 0) {
            $("#day_" + i + "_week").addClass("weekends");
        } else {
            $("#day_" + i + "_week").removeClass("weekends");
        }
        var part = weather_data[city].forecasts[i].parts.day;
        $("#day_" + i + "_img" + " img").attr("src", make_icon(part.icon));
        $("#day_" + i + "_cond").text(human_condition(part.condition));
        $("#day_" + i + "_temp").text(human_temp_grad(part.temp_min) + "..." + human_temp_grad(part.temp_max));
    }
	
    // Вывести погоду по времени суток на сегодня
	show_part_weather(0);
    // Настройка графика температуры
    let temp_data = [];
    let hours = [];
    let max_day = 3;
    let i = hour;
    for (let d = 0; d < max_day; d++) {
        let k = hour;
        if (d) k = 0;
        let ek = 24;
        if (d == max_day-1) ek = hour - 2;
        for (; k < ek; k++) {
            temp_data.push({'x': k + d*24,'y': weather_data[city].forecasts[d].hours[k].temp});
            hours.push(i);
            i++;
        }
    }
    let width = 1750; let height = 180;
    let	margin = {top: 30, right: 20, bottom: 30, left: 50};
    // Set the ranges
    var	y = d3.scale.linear().range([height, 0]);
    var	x = d3.scale.linear().range([0, width]);
     
    // Define the axes
    var	xAxis = d3.svg.axis().scale(x)
        .orient("bottom");

    xAxis.ticks(12)
        .tickFormat(function(d, i){
            let h = d % 24;
            //return d3.format('c')(0x26C5) + h + ":00";
            return h + ":00";
            
        })
        .innerTickSize(-height)
        .outerTickSize(0)
        .tickValues(hours)
        .tickPadding(10);

    let ticks = d3.max(temp_data, function(d) { return d.y; }) - d3.min(temp_data, function(d) { return d.y; });
    if (ticks < 3) ticks = 3;
    if (ticks > 12) ticks = 12;
     
    var	yAxis = d3.svg.axis().scale(y)
        .orient("left").ticks(ticks)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(5)
        .tickFormat(function(d, i){
            return human_temp_grad(d);
        });
     
    // Define the line
    var	valueline = d3.svg.line()
        .interpolate("basis")
        .x(function(d) { return x(d.x); })
        .y(function(d) { return y(d.y); });

	// Scale the range of the data
	x.domain([d3.min(temp_data, function(d) { return d.x; }), d3.max(temp_data, function(d) { return d.x; })]);
	y.domain([d3.min(temp_data, function(d) { return d.y; })-5, d3.max(temp_data, function(d) { return d.y; })]);

    // Adds the svg canvas
    d3.select("svg").remove();
    var	svg = d3.select("#temp_chart").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
        .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	// Add the valueline path.
	svg.append("path")	
		.attr("class", "line")
		.attr("d", valueline(temp_data));

	// Add the X Axis
	svg.append("g")		
		.attr("class", "x axis")
		.attr("transform", "translate(0," + (height) + ")")
		.call(xAxis);
 
	// Add the Y Axis
	svg.append("g")		
		.attr("class", "y axis")
		.call(yAxis);
    d3.select('.axis .tick:first-child').remove();
    d3.select('.y.axis .tick').remove();


    //
    d3.select("svg").selectAll(".dot")
        .data(temp_data)
        .enter().append("circle")
          .attr("class", "dot")
          .attr("r", 3)
          .attr("cx", function(d) { return x(d.x); })
          .attr("cy", function(d) { return y(d.y); });
}

// Функция формирования даты в человекочитаемом формате
function make_human_date(date) {
    var date = new Date(date);
    // Число месяца + название месяца
    return date.getDate() + " " + month_name(date.getMonth());
}

// Подпрограмма отображения погоды на день по времени суток
function show_part_weather(n) {
    var p = weather_data[city].forecasts[n].parts;
    var f = weather_data[city].forecasts[n];
    // Вывод даты
    $("#part_date").text(make_human_date(weather_data[city].forecasts[n].date));

    if (!p.day.polar) {
        // Вывести время восхода и заката
        $("#part_rise").text(f.sunrise);
        $("#part_set").text(f.sunset);
        // Вывести долготу дня
        $("#part_daylong").text(daylong(f.sunrise, f.sunset));
        $("#part_rise").show();
        $("#part_set").show();
        $("#part_rise_t").show();
        $("#part_set_t").show();
    } else {
        // В случае полядного дня/ночи прячем элементы с восходом и закатом
        $("#part_rise").hide();
        $("#part_set").hide();
        $("#part_rise_t").hide();
        $("#part_set_t").hide();
        if (p.day.daytime == "n") {
            $("#part_daylong").text("Полярная ночь");
        } else {
            $("#part_daylong").text("Полярный день");
        }
    }
    $("#part_moon").text(human_moon(f.moon_text));

    let uv = p.day.uv_index;
    if (uv != null && uv != undefined) {
        $("#part_uv").text(human_uv(uv));
    } else {
    }
    
    // Прогноз на утро
	$("#morning_icon img").attr("src", make_icon(p.morning.icon));
	$("#morning_temp").text(human_temp_grad(p.morning.temp_avg));
    $("#morning_feel").text(human_temp_grad(p.morning.feels_like));
    $("#morning_hum").text(p.morning.humidity + "%");
    $("#morning_pres").text(human_pressure(p.morning.pressure_mm));
    $("#morning_wind").text(human_wind(p.morning.wind_dir, p.morning.wind_speed));
	$("#morning_perc").text(human_prec(p.morning.prec_mm));
	
    // Прогноз на день
	$("#day_icon img").attr("src", make_icon(p.day.icon));
	$("#day_temp").text(human_temp_grad(p.day.temp_avg));
    $("#day_feel").text(human_temp_grad(p.day.feels_like));
    $("#day_hum").text(p.day.humidity + "%");
    $("#day_pres").text(human_pressure(p.day.pressure_mm));
    $("#day_wind").text(human_wind(p.day.wind_dir, p.day.wind_speed));
	$("#day_perc").text(human_prec(p.day.prec_mm));
	
    // Прогноз на вечер
	$("#evening_icon img").attr("src", make_icon(p.evening.icon));
	$("#evening_temp").text(human_temp_grad(p.evening.temp_avg));
    $("#evening_feel").text(human_temp_grad(p.evening.feels_like));
    $("#evening_hum").text(p.evening.humidity + "%");
    $("#evening_pres").text(human_pressure(p.evening.pressure_mm));
    $("#evening_wind").text(human_wind(p.evening.wind_dir, p.evening.wind_speed));
	$("#evening_perc").text(human_prec(p.evening.prec_mm));
	
    // Прогноз на ночь
	$("#night_icon img").attr("src", make_icon(p.night.icon));
	$("#night_temp").text(human_temp_grad(p.night.temp_avg));
    $("#night_feel").text(human_temp_grad(p.night.feels_like));
    $("#night_hum").text(p.night.humidity + "%");
    $("#night_pres").text(human_pressure(p.night.pressure_mm));
    $("#night_wind").text(human_wind(p.night.wind_dir, p.night.wind_speed));
	$("#night_perc").text(human_prec(p.night.prec_mm));
}

function human_pressure(p) {
	return p;
	//return p + " мм рт. ст.";
}

function human_prec(p) {
	if (!p) return "-";
	return p + " мм";
}

// Функция формирования ссылки на иконку погодных условий
function make_icon(code) {
    return "https://yastatic.net/weather/i/icons/blueye/color/svg/" + code + ".svg";
}

// Подпрограмма определения места работы сервера (тестовый или продуктивный)
function where_am_i() {
    if (location.host == "ksilenomen.pythonanywhere.com") return 1;
    if (location.host == "127.0.0.1:5000") return 0;
    return 0;
}

// Функция преобразования строки для начала с заглавной буквы
function upper_first(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function month_name(m) {
	  var months = ['Января','Февраля','Марта','Апреля','Мая','Июня','Июля','Августа','Сентября','Октября','Ноября','Декабря'];
	  return months[m];
}

// Функция преобразования времени из формата UNIXTIME в дату
function time_unix2date(UNIX_timestamp){
  return new Date(UNIX_timestamp * 1000);
}

// Функция преобразования времени из формата UNIXTIME в строку
function timeConverter(a){
  var year = a.getFullYear();
  var month = month_name(a.getMonth());
  var date = a.getDate();
  var hour = a.getHours();
  var min = prec_null(a.getMinutes());
  var sec = prec_null(a.getSeconds());
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

// Функция преобразования времени в строку
function timetzConverter(a){
  var year = a.year();
  var month = month_name(a.month());
  var date = a.date();
  var hour = a.hours();
  var min = prec_null(a.minutes());
  var sec = prec_null(a.seconds());
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

// Функция форматирования температуры
function human_temp(t) {
	if (t > 0) { t = "+" + t; }
	return t;	
}

// Функция формирования температуры в градусах
function human_temp_grad(t) {
	return human_temp(t) + "°";
}

// Функция форматирования данных ветра
function human_wind(w, val) {
	table =  {
		"nw": "СЗ",
		"n":  "С",
		"ne": "СВ",
		"e":  "В",
		"sw": "ЮЗ",
		"s":  "Ю",
		"se": "ЮВ",
		"w":  "З",
		"с":  "штиль"
		};
		if (w != "c")
			return val  + " м/с, " + table[w];
		return table[w];
}

// Функция расшифровки погодных условий
function human_condition(c) {
	table = {
		"clear": "Ясно",
		"partly-cloudy": "Малооблачно",
		"cloudy": "Облачно с прояснениями",
		"overcast": "Пасмурно",
		"partly-cloudy-and-light-rain": "Небольшой дождь",
		"partly-cloudy-and-rain": "Дождь",
		"overcast-and-rain": "Сильный дождь",
		"overcast-thunderstorms-with-rain": "Сильный дождь, гроза",
		"cloudy-and-light-rain": "Небольшой дождь",
		"overcast-and-light-rain": "Небольшой дождь",
		"cloudy-and-rain": "Дождь",
		"overcast-and-wet-snow": "Дождь со снегом",
		"partly-cloudy-and-light-snow": "Небольшой снег",
		"partly-cloudy-and-snow": "Снег",
		"overcast-and-snow": "Снегопад",
		"cloudy-and-light-snow": "Небольшой снег",
		"overcast-and-light-snow": "Небольшой снег",
		"cloudy-and-snow": "Снег"
		};
		return table[c];
}

// Функция форматирования числа из двух цифр с ведущим нулём
function prec_null(n) {
	if (n < 10) {
		return "0" + n;
	}
	else return String(n);
}

// Функция вычисления долготы дня
function daylong(d1, d2) {
	var d1_m = Number(d1.split(":")[0]) * 60  + Number(d1.split(":")[1]);
	var d2_m = Number(d2.split(":")[0]) * 60  + Number(d2.split(":")[1]);
	if (d2_m > d1_m) {
		var diff = d2_m - d1_m;
	} else {
		var diff = 24*60 - d2_m + d1_m;
	}
	diff = ~~(diff / 60) + ":" + prec_null(diff - ~~(diff / 60)*60);
	return diff;
}

// Функция расшифровки фазы луны
function human_moon(m) {
	moon_phase = {
		"full-moon": "полнолуние",
		"decreasing-moon": "убывающая Луна",
		"last-quarter": "последняя четверть",
		"new-moon": "новолуние",
		"growing-moon": "растущая Луна",
		"first-quarter": "первая четверть",    
	};
	return moon_phase[m];
}

// Функция шкалы уф-индекса
function human_uv(uv) {
    uv_table = {
        "0":" (низкий)",
        "1":" (низкий)",
        "2":" (низкий)",
        "3":" (средний)",
        "4":" (средний)",
        "5":" (средний)",
        "6":" (высокий)",
        "7":" (высокий)",
        "8":" (очень высокий)",
        "9":" (очень высокий)",
        "10":" (очень высокий)",
        "11":" (экстремальный)",
        "12":" (экстремальный)"
    }
    if (uv != null && uv != undefined) {
        return uv + uv_table[uv] || " (экстремальный)";
    } else {
        return "";
    }
}
