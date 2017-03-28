declare module WebReports.Model.Infographics {
    export interface IMosaicD3 extends D3Control {
        // Значение
        value: string;
        // Процент
        valuePercent: string;
        // Имя
        name: string;
        // Имя иконки
        icon: string;
        // Цвет прямоугольника
        color: string;
        // Текст тултипа
        tooltipText: Text;
        // Индикатор-иконка
        iconIndicator: Model.Indicators.Indicator;
        /** Индикатор перехода на другой отчет или внешний ресурс */
        linkIndicator: any;
        /** Имя столбца с кодом для передачи в параметр. */
        code: string;

    }
}

module WebReports.Controls.Infographics {
    var dataLabelStyle: any = Highcharts.getOptions().subtitle.style;
    var labelStyle: any = (<any>Highcharts.getOptions()).yAxis.labels.style;
    var tooltipStyle: any = Highcharts.getOptions().tooltip.style;

    export class MosaicD3 extends D3Control {
        private expressionContextProvider : IExpressionContextProvider;
        private expressionContext: IExpressionContext;
        private tooltipContext: any;

        private svg: SvgElement;
        private defs: SvgElement;
        // Размеры контейнера svg
        private svgWidth: number;
        private svgHeight: number;

        private tooltip: D3.Selection;
        private tooltipText: D3.Selection;

        constructor(public model: Model.Infographics.IMosaicD3, args: any[]) {
            super(model);
            this.expressionContextProvider = <IExpressionContextProvider>args[0];
            if (!this.expressionContext) {
                this.expressionContext = this.expressionContextProvider.getExpressionContext();
            }
            this.svgWidth = this.model.width;
            this.svgHeight = this.model.height;
        }

        public render(container: HTMLElement) {
            super.render(container);

            $(window).bind("resize", () => {
                this.refresh(container);
            });
        }

        public refresh(container: HTMLElement) {
            $(container).empty();
            this.onBeforeRender.Trigger(this.getId());
            d3.select(container).style("text-align", "center");
            this.tooltip = d3.select(container).append("div")
                .attr("id", "tooltip");
            this.tooltipText = this.tooltip.append("span")
                .attr("id", "tooltipText")
                .style("font-family", tooltipStyle.fontFamily)
                .style("font-size", tooltipStyle.fontSize);

            // Расчёт ширины.
            var contWidth = $(container).css("width") === "0px" ?
                Number($(document.body).css("width").substr(0, $(document.body).css("width").length - 2))
                : Number($(container).css("width").substr(0, $(container).css("width").length - 2));
            var contHeight = $(container).css("height") === "0px" ?
                Number($(document.body).css("height").substr(0, $(document.body).css("height").length - 2))
                : Number($(container).css("height").substr(0, $(container).css("height").length - 2));
            this.svgWidth = (1 - 0.47 / (1300.5 - contWidth)) * contWidth;
            this.svgHeight = 0.63 * $(document).height();
            // (1 - 47/(1300.5 - contWidth))

            // Основной контейнер элементов
            this.svg = new SvgElement(d3.select(container), "svg")
                .attr("width", this.svgWidth)
                .attr("height", this.svgHeight);
            // Контейнер для градиентов
            this.defs = new SvgElement(this.svg, "svg:defs");
            var dataRows = this.getDataSourceManager().get(this.model.dataSourceRef).getRows();

            // Если нет данных.
            if (dataRows.length === 0) {
                $(container).append("<div class='text-control'>Нет данных</div>");
                this.svg.selection.remove();
                return;
            }

            dataRows.sort((obj1, obj2) => (obj2.get(this.model.value) - obj1.get(this.model.value)));
            dataRows.forEach((item: IDataSourceRow, i: number) => {
                // Рисуем прямоугольник
                this.drawRect(item, i);
                // Пишем в нём текст
                this.setText(item, i);
            });
            this.onAfterRender.Trigger(this.getId());
        }
      /**
       * Рисование одного прямоугольника.
       * @rect  Данные об одном прямоугольнике.
       * @number  Номер прямоугольника.
       */
        private drawRect(rect: IDataSourceRow, i: number): void {
            var box: D3.Selection; // Группа для прямоугльника и подписей
            var name = rect.get(this.model.name); // Имя программмы
            var width: number; // Ширина прямоугольника
            // Проверяем на какой строке находится прямоугольник и из этого настраиваем его параметры.
            // Левая граница каждого прямоугольника - правая граница пердыдущего + 1 пиксель.
            if (i < 2) {
                box = this.svg.append("g")
                    .attr("id", "rectGroup" + i)
                    .attr("cursor", "pointer");
                width = this.svgWidth / 3;
                box.append("rect")
                    .attr("id", "rect" + i)
                    .attr("x", i === 0 ? 0 : parseFloat(d3.select("#rect" +
                    (i - 1)).attr("x")) + parseFloat(d3.select("#rect" +
                        (i - 1)).attr("width")) + 1)
                    .attr("y", 0)
                    .style("fill", rect.get(this.model.color))
                    .attr("width", width + width / 8)
                    .attr("height", this.svgHeight / 4 + 30);
            } else if (i === 2) {
                box = this.svg.append("g")
                    .attr("id", "rectGroup" + i)
                    .attr("cursor", "pointer");
                width = this.svgWidth / 3;
                box.append("rect")
                    .attr("id", "rect" + i)
                    .attr("x", i === 0 ? 0 : parseFloat(d3.select("#rect" +
                    (i - 1)).attr("x")) + parseFloat(d3.select("#rect" +
                        (i - 1)).attr("width")) + 1)
                    .attr("y", 0)
                    .style("fill", rect.get(this.model.color))
                    .attr("width", width - width / 4)
                    .attr("height", this.svgHeight / 4 + 30);
            } else if (i > 2 && i < 7) {
                box = this.svg.append("g")
                    .attr("id", "rectGroup" + i)
                    .attr("cursor", "pointer");
                width = this.svgWidth / 4;
                box.append("rect")
                    .attr("id", "rect" + i)
                    .attr("x", i === 3 ? 0 : parseFloat(d3.select("#rect" + (i - 1)).attr("x")) +
                    parseFloat(d3.select("#rect" + (i - 1)).attr("width")) + 1)
                    .attr("y", parseFloat(d3.select("#rect0").attr("y")) +
                    parseFloat(d3.select("#rect0").attr("height")) + 1)
                    .style("fill", rect.get(this.model.color))
                    .attr("width", i === 6 ? this.svgWidth - (parseFloat(d3.select("#rect5").attr("width")) +
                    parseFloat(d3.select("#rect5").attr("x")))
                    : i === 3 ? width + 40 : width)
                    .attr("height", this.svgHeight / 4 + 10);
            } else if (i > 6 && i < 11) {
                box = this.svg.append("g")
                    .attr("id", "rectGroup" + i)
                    .attr("cursor", "pointer");
                width = this.svgWidth / 4;
                box.append("rect")
                    .attr("id", "rect" + i)
                    .attr("x", i === 7 ? 0 : parseFloat(d3.select("#rect" + (i - 1)).attr("x")) +
                    parseFloat(d3.select("#rect" + (i - 1)).attr("width")) + 1)
                    .attr("y", parseFloat(d3.select("#rect3").attr("y")) + parseFloat(d3.select("#rect3").attr("height")) + 1)
                    .style("fill", rect.get(this.model.color))
                    .attr("width", (i === 10 || i === 9) ? width - width / 4 : width + width / 4)
                    .attr("height", this.svgHeight / 4 - 10);
            } else if (i > 10) {
                box = this.svg.append("g")
                    .attr("id", "rectGroup" + i)
                    .attr("cursor", "pointer");
                width = this.svgWidth / 5;
                box.append("rect")
                    .attr("id", "rect" + i)
                    .attr("x", i === 11 ? 0 : parseFloat(d3.select("#rect" + (i - 1)).attr("x")) +
                    parseFloat(d3.select("#rect" + (i - 1)).attr("width")) + 1)
                    .attr("y", parseFloat(d3.select("#rect7").attr("y")) +
                    parseFloat(d3.select("#rect7").attr("height")) + 1)
                    .style("fill", rect.get(this.model.color))
                    .attr("width", i > 12 ? i !== 15 ? width - width / 7 :
                    this.svgWidth - parseFloat(d3.select("#rect" + (i - 1)).attr("x")) -
                    parseFloat(d3.select("#rect" + (i - 1)).attr("width")) : width + width / 5)
                    .attr("height", this.svgHeight / 4 - 30);
            }
            // Настройки тултипа
            if (this.model.tooltipText && rect.get(this.model.value) !== null) {
                var tooltipContent = (< IUIComponent > ControlFactory.create(this.model.tooltipText, this));
                this.addChildComponent(tooltipContent, this);
                d3.select("#rectGroup" + i)
                    .on("mouseover", () => {
                    this.tooltip.transition().duration(200).style("opacity", 0.95);
                    this.tooltipContext = {
                        category: name
                    };
                    this.tooltip.style("border-color", rect.get(this.model.color));
                    this.tooltip
                        .style("visibility", "visible");
                    this.tooltipText.html(tooltipContent.renderToString());
                })
                    .on("mousemove", () => {
                    this.tooltip
                        .style("top", ((< any > d3.event).pageY + 15) + "px")
                        .style("left", ((< any > d3.event).pageX - 150) + "px");
                })
                    .on("mouseout", () => {
                    this.tooltip.transition().duration(200).style("opacity", 1);
                    this.tooltip
                        .style("visibility", "hidden");
                    this.tooltipText
                        .text("");
                });
            }

            // Если задан набор ссылок на другой документ
            var that = this;
            if (this.model.linkIndicator) {
                var createLinkData = (row: any) => {
                    var linkData = <IIndicatorSvgData>{},
                        vizualizer = new WebReports.Controls.Indicators.Vizualizers.SvgVizualizer(linkData);
                    that.addChildComponent(vizualizer, that);
                    var link = (<IIndicator>WebReports.ControlFactory.create(that.model.linkIndicator));
                    row.row.code = row.get(this.model.code);
                    var ctx = $.extend(that.getExpressionContext(), row, { "code": row.get(this.model.code) });
                    link.apply(row, ctx, vizualizer);
                    return linkData;
                };

                var linkData = createLinkData(rect);
                if (linkData.linkObject) {
                    box.style("cursor", "pointer");
                }
                // Вставляем ссылку на другой документ
                d3.select("#rectGroup" + i).on("click", () => ((row: any) => {
                    var linkData = createLinkData(row);
                    if (linkData.linkObject) {
                        linkData.linkObject.action();
                    }
                })(rect));
            }
        }

            // Функция получения свойств браузера
        private getBrowserInfo() {
        var ua = navigator.userAgent, tem, m = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
        if (/trident/i.test(m[1])) {
            tem = /\brv[ :]+(\d+)/g.exec(ua) || [];
            return { name: "IE ", version: (tem[1] || "") };
        }
        if (m[1] === "Chrome") {
            tem = ua.match(/\bOPR\/(\d+)/);
            if (tem != null) {
                return { name: "Opera", version: tem[1] };
            }
        }
        m = m[2] ? [m[1], m[2]] : [navigator.appName, navigator.appVersion, "-?"];
        if ((tem = ua.match(/version\/(\d+)/i)) != null) {
            m.splice(1, 1, tem[1]);
        }
        return {
            name: m[0],
            version: m[1]
        };
        }

        // Количество строк
        private getLinesCount(text, max) {
        var regex = new RegExp(".{0," + max + "}(?:\\s|$)", "g");
        var lines = [];
        var line;
        while ((line = regex.exec(text)).toString() !== "") {
            lines.push(line);
        }
        return lines.length;
    }

        private getRandomInt(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        /**
         * Текст на прямоугольнике.
         * @rect Данные об одном прямоугольнике.
         * @number Номер прямоугольника.
         */
        private setText(rect: IDataSourceRow, i: number): void {
            var svg = new SvgElement(d3.select("#rectGroup" + i), "g"); // Получаем группу по айдишнику
            var rectangle = d3.select("#rect" + i); // Получаем svg прямоугольника
            var maxLength = parseFloat(d3.select("#rect" + i).attr("width")); // максимальная ширина для имени программы
            var bigger = i === 0 || i === 1; // Гигантские прямогольники
            dataLabelStyle.fontSize = this.setFontSize(rect.get(this.model.name), bigger, i);
            // Заголовок программы
            var linesCount = Utils.Common.getLinesCount(rect.get(this.model.name), Math.round(maxLength / 8 - 2));
            var paddingTop = linesCount === 1 ? bigger ? -15 : -20 : linesCount === 2 ? -10 : 2;
            var text = new Text(svg, dataLabelStyle, "left")
                .setWrapText(rect.get(this.model.name), paddingTop, Math.round(maxLength / 8 - 2), 12)
                .style("text-anchor", "middle")
                .style("font-weight", "bold")
                .style("fill", "white")
                .translate(parseFloat(rectangle.attr("x")) + parseFloat(rectangle.attr("width")) / 2, parseFloat(rectangle.attr("y")) + 30);
            var childElementCount = text.selection[0][0].childElementCount;
            // Высота картинки - с какой точки она начинается относиткльно прямоугольника
            var imageY = childElementCount === 1 ? 35 : childElementCount === 2 ? 40 : 45;
            // Размер картинки относительно высоты прямоугольника
            var imageSize = childElementCount === 1 ? 50 : childElementCount === 2 ? 55 : 65;
            // Получаем ссылку на иконку
            if (this.model.iconIndicator) {
                var data = <IIndicatorSvgData>{};
                var vizualizer = new Controls.Indicators.Vizualizers.SvgVizualizer(data);
                (<IIndicator>ControlFactory.create(this.model.iconIndicator)).apply(rect, this.expressionContext, vizualizer);

                if (data.url) {
                    var imgX = parseFloat(rectangle.attr("x")) + 5;
                    var imgY = parseFloat(rectangle.attr("y")) + imageY;
                    new Image(svg, imgX, imgY, parseFloat(rectangle.attr("height")) -
                        imageSize, parseFloat(rectangle.attr("height")) - imageSize)
                        .setUrl(data.url)
                        .attr("id", "image" + i)
                        .attr("image-rendering", "optimizeQuality")
                        .style("pointer-events", "none");
                }
            }
            var big = parseFloat(rectangle.attr("width")) > 250; // Большие прямоугольники
            // Пишем значение. Размер шрифта зависит от ширины прямоугольника
            var value = new Text(svg, labelStyle, "left")
                .setText("План: ")
                .attr("id", "value" + i)
                .style("font-size", big ? bigger ? "18px" : "15px" : "13px")
                .style("fill", "white")
                .translate(parseFloat(rectangle.attr("x")) +
                parseFloat(rectangle.attr("height")) - imageSize + 10, parseFloat(d3.select("#image" + i).attr("y")) + 20);
            value.append("tspan")
                .attr("x", big ? (bigger ? 40 : 38) : 30)
                .attr("y", 0)
                .style("font-size", big ? bigger ? "18px" : "15px" : "13px")
                .style("font-weight", "bold")
                .text(numeral(rect.get(this.model.value)).format("0,0"));
            // : x для млн.руб
            var valueX: number;
            valueX = this.getValue(value, big);
            value.append("tspan")
                .attr("x", (bigger ? valueX + 2 : valueX))
                .attr("y", 0)
                .style("font-weight", "normal")
                .style("font-size", big ? bigger ? "18px" : "15px" : "13px")
                .text("млн. руб.");
            // : x для процентов
            var percentX: number;
            percentX = parseFloat(rectangle.attr("x")) + parseFloat(rectangle.attr("height")) - imageSize + 10;
            new Text(svg, labelStyle, "left")
                .setText(numeral(rect.get(this.model.valuePercent)).format("0,0.0%"))
                .style("font-size", big ? bigger ? "18px" : "15px" : "13px")
                .style("fill", "white")
                .style("font-weight", "bold")
                .translate(percentX, parseFloat(d3.select("#image" + i).attr("y")) + (bigger ? 40 : 35));
            // : x для от программных расходов
            var x: number;
            var xTemp = percentX + numeral(rect.get(this.model.valuePercent)).format("0,0.0%").toString().length * 8;
            x = big ? xTemp : xTemp - 5;
            var textLength = Math.round(parseFloat(rectangle.attr("width")) / 14);
            new Text(svg, labelStyle, "left")
                .setWrapText("от программных расходов", 1, textLength, 16)
                .style("font-size", big ? bigger ? "18px" : "15px" : "13px")
                .style("fill", "white")
                .translate((bigger ? x + 5 : x), textLength > 23 ? parseFloat(d3.select("#image" + i).attr("y")) +
                (bigger ? 47 : 42) : parseFloat(d3.select("#image" + i).attr("y")) + 50);
        }
        /**
         * Разные размеры шрифтов.
         * @name Имя на пярмоугольнике.
         * @bigger Большой ли это прямоугльник.
         * @i Номер программы.
         */
        private setFontSize(name: string, bigger: boolean, i: number): string {
            if (i > 10) {
                 return "13px";
            } else if (bigger) {
                return "20px";
            } else {
                if (name.length > 20) {
                    return "14px";
                } else {
                    return "15px";
                }
            }
        }

        getExpressionContext(): IExpressionContext {
            return $.extend(this.expressionContext, this.tooltipContext);
        }
        /**
         * Проверка на браузер.
         * @value Элемент.
         * @big Большой ли это прямоугльник.
         */
        private getValue(value: SvgElement, big: boolean): number {
          var width = parseFloat(value.selection[0][0].childNodes[1].getBoundingClientRect().width);
            if (Ext.isChrome) {
                return width;
            }else if (Ext.isIE) {
                return big ?
                   78 + width :
                   55 + width;
            }else if (Ext.isSafari) {
                return big ?
                    78 + width :
                    52 + width;
            }else if (Ext.isOpera) {
                return big ?
                    width - 5 :
                    width - 4;
            }else {
                return big ?
                    40 + width :
                    35 + width;
                  }
        }
    }
}
