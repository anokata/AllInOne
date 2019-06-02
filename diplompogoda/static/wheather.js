// Список городов
cities_names = [];
// Список дополнительных городов
cities_names_add = [];

// Подпрограмма отображения погодных данных 
function view(wheather_data) {
    console.log(wheather_data);
    // Получение названия города
    city = wheather_data["city"] || Object.keys(wheather_data)[0];

	$("#city_name").text(city);
	$("#country_name").text(wheather_data[city].cname);
	$("#time").text(timeConverter(wheather_data[city]["time"]));
	$("#temp").text(human_temp(wheather_data[city]["temp"]) + "°C");
	$("#feel").text(human_temp(wheather_data[city]["feels_like"]) + "°C");
	$("#wind").text(human_wind(wheather_data[city]["wind_dir"], wheather_data[city]["wind_speed"]));
	$("#pressure").text(wheather_data[city]["pressure_mm"] + " мм рт. ст.");
	$("#condition").text(human_condition(wheather_data[city]["condition"]));
	$("#humidity").text(wheather_data[city]["humidity"] + "%")
    // Если есть данные температуры воды
    if (wheather_data[city]["temp_water"]) {
        $("#temp_water").parent().css("display", "table-row");
		$("#temp_water").text(human_temp(wheather_data[city]["temp_water"]) + "°");
	} else {
        $("#temp_water").parent().css("display", "none");
		$("#temp_water_tr").css("display", "none");
	}
    // Если не полярные день/ночь
    if (!wheather_data[city].forecasts[0].parts.day.polar) {
        if (wheather_data[city]["forecasts"][0]["sunrise"]) {
            $("#rise").text(wheather_data[city]["forecasts"][0]["sunrise"]);
        }
        if (wheather_data[city]["forecasts"][0]["sunset"]) {
            $("#sunset").text(wheather_data[city]["forecasts"][0]["sunset"]);
            $("#day_long").text(daylong(wheather_data[city]["forecasts"][0]["sunrise"], wheather_data[city]["forecasts"][0]["sunset"]));
        $("#rise").parent().show();
        $("#sunset").parent().show();
        $("#day_long").siblings().first().next().text("Долгота дня");
        }
    } else {
        // В случае полядного дня/ночи прячем элементы с восходом и закатом
        $("#rise").parent().hide();
        $("#sunset").parent().hide();
        $("#day_long").text("");
        if (wheather_data[city].forecasts[0].parts.day.daytime == "n") {
            $("#day_long").siblings().first().next().text("Полярная ночь");
        } else {
            $("#day_long").siblings().first().next().text("Полярный день");
        }
    }

	$("#moon").text(human_moon(wheather_data[city]["forecasts"][0]["moon_text"]));
	$("#icon img").attr("src", make_icon(wheather_data[city]["icon"]));
	$("#uv_index").text(human_uv(wheather_data[city].forecasts[0].parts.day.uv_index));

    // С текущего часа 12 часов, с учётом пересечения дня, учитывая часовой пояс
    var datetz = moment.tz(new Date(), wheather_data[city].zone);
    var hour = Number(datetz.format("H"));
    console.log("ZONE", wheather_data[city].zone, datetz.format("H"));
	
    var j = 1;
    for (var i = hour; i < hour + 13; i++) {
        var h = i % 24;
        $("#hour_" + j + "_time").text(h + ":00");
        $("#hour_" + j).text(human_temp_grad(wheather_data[city].forecasts[0].hours[h].temp));
        $("#hour_" + j + "_icon").attr("src", make_icon(wheather_data[city].forecasts[0].hours[h].icon));
        j++;
    }
    for (var i = 0; i < 6; i++) {
        var date = new Date(wheather_data[city].forecasts[i].date);
        var date_str = make_human_date(wheather_data[city].forecasts[i].date)
        var weekday = upper_first(date.toLocaleString('ru-ru', { weekday: 'short' }));
        $("#day_" + i).text(date_str);
        $("#day_" + i + "_week").text(weekday);
        // TODO с какой части дня брать условия
        var part = wheather_data[city].forecasts[i].parts.day;
        $("#day_" + i + "_img" + " img").attr("src", make_icon(part.icon));
        $("#day_" + i + "_cond").text(human_condition(part.condition));
        $("#day_" + i + "_temp").text(human_temp_grad(part.temp_min) + "..." + human_temp_grad(part.temp_max));
    }
	
	show_part_wheather(0);
}

function make_human_date(date) {
    var date = new Date(date);
    return date.getDate() + " " + date.toLocaleString('ru-ru', { month: 'long' });
}

function show_part_wheather(n) {
    var p = wheather_data[city].forecasts[n].parts;
    $("#part_date").text(make_human_date(wheather_data[city].forecasts[n].date));
    
	$("#morning_icon img").attr("src", make_icon(p.morning.icon));
	$("#morning_temp").text(human_temp_grad(p.morning.temp_avg));
    $("#morning_feel").text(human_temp_grad(p.morning.feels_like));
    $("#morning_hum").text(p.morning.humidity + "%");
    $("#morning_pres").text(p.morning.pressure_mm + " мм рт. ст.");
    $("#morning_wind").text(human_wind(p.morning.wind_dir, p.morning.wind_speed));
	
	$("#day_icon img").attr("src", make_icon(p.day.icon));
	$("#day_temp").text(human_temp_grad(p.day.temp_avg));
    $("#day_feel").text(human_temp_grad(p.day.feels_like));
    $("#day_hum").text(p.day.humidity + "%");
    $("#day_pres").text(p.day.pressure_mm + " мм рт. ст.");
    $("#day_wind").text(human_wind(p.day.wind_dir, p.day.wind_speed));
	
	$("#evening_icon img").attr("src", make_icon(p.evening.icon));
	$("#evening_temp").text(human_temp_grad(p.evening.temp_avg));
    $("#evening_feel").text(human_temp_grad(p.evening.feels_like));
    $("#evening_hum").text(p.evening.humidity + "%");
    $("#evening_pres").text(p.evening.pressure_mm + " мм рт. ст.");
    $("#evening_wind").text(human_wind(p.evening.wind_dir, p.evening.wind_speed));
	
	$("#night_icon img").attr("src", make_icon(p.night.icon));
	$("#night_temp").text(human_temp_grad(p.night.temp_avg));
    $("#night_feel").text(human_temp_grad(p.night.feels_like));
    $("#night_hum").text(p.night.humidity + "%");
    $("#night_pres").text(p.night.pressure_mm + " мм рт. ст.");
    $("#night_wind").text(human_wind(p.night.wind_dir, p.night.wind_speed));
}

function make_icon(code) {
    return "https://yastatic.net/weather/i/icons/blueye/color/svg/" + code + ".svg";
}


// Подпрограмма определения места работы сервера (тестовый или продуктивный)
function where_am_i() {
    if (location.host == "ksilenomen.pythonanywhere.com") return 1;
    if (location.host == "127.0.0.1:5000") return 0;
    return 0;
}

// Подпрограмма отправки API запроса Яндекс.Погоды и обработки результата
function send(wheather_data, city, lat, lon, f) {
    var zone = "";
    if (wheather_data[city]) {
        zone = wheather_data[city]['zone'];
		cname = wheather_data[city]['cname'];
    }
    var query = '';
    // Определение базового URL сервера (тестовый или продуктивный)
    if (where_am_i()) {
        query = 'http://ksilenomen.pythonanywhere.com/pogoda/'
    } else {
        query = 'http://127.0.0.1:5000/pogoda/'
    }
    // Формирование параметров запроса
    //query += lat;
    //query += "/" + lon;
    // Создание объекта для AJAX запроса
    var xhr = new XMLHttpRequest();
    // Конфигурация объекта запроса
    var params = "lat=" + lat + "&lon=" + lon;
    xhr.open('POST', query, true);
    //xhr.open('POST', query, false);
    //xhr.open('GET', query, false);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    
    // Установка функции обработки результата запроса
    xhr.onload = function() {
        // Парсинг ответа в JSON формате
        data = JSON.parse(this.responseText);
		//console.log(data);
        // Формирование результирующих данных на основе ответа
        wheather_data[city] = {
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
        if (f) f(wheather_data);
        //console.log(wheather_data);
        return data;
    }
  
    // Выполение AJAX запроса к Яндекс.Погоде
    xhr.send(params); 
}

function upper_first(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}


function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp * 1000);
  var months = ['Янв','Фев','Мар','Апр','Май','Июн','Июл','Авг','Сен','Окт','Ноя','Дек'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = prec_null(a.getMinutes());
  var sec = prec_null(a.getSeconds());
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

function human_temp(t) {
	if (t > 0) { t = "+" + t; }
	return t;	
}

function human_temp_grad(t) {
	return human_temp(t) + "°";}

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

function prec_null(n) {
	if (n < 10) {
		return "0" + n;
	}
	else return String(n);
}

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
        "11":" (экстремальный)"
    }
    return uv + uv_table[uv] || " (экстремальный)";
}
