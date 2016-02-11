declare module WebReports.Model.Infographics {
    /**
     * Виджет - круговой показатель.
     */
    export interface RingWidget extends D3Control {
        /** Высота компонента в пикселях. */
        height: number;
        /** Имя столбца с плановым значением. */
        planColumn: string;
        /** Имя столбца с фактическим значением. */
        factColumn: string;
        /** Цвет внутреннего круга */
        innerColor: string;
        /** Подсказка. */
        text: Text;
        /** радиус внутреннего круга */
        innerRadius: number;
        /** Цвет внешнего круга */
        outerColor: string;
        /** Цвет заливки показателя */
        gaugeColor: string;
        /** Колонка значения для показателя */
        gaugeColumn: string;
        /** Направление показателя по часовой стрелке */
        clockwise: boolean;
        /** Сдвиг текста по горизонтали. */
        textLeftPadding: number;
        /** Сдвиг текста по вертикали. */
        textTopPadding: number;
        /** Сдвиг виджета по горизонтали */
        leftPadding: number;
        /** Использовать подпись с линией */
        useConnector: boolean;
        /** Центральная иконка */
        icon: Model.Versioning;
        /** иконка паттерна. */
        patternImg: Model.Versioning;
    }
}

module WebReports.Controls.Infographics {
    export class RingWidget extends D3Control implements IContextProvider {
        private svg: SvgElement;
        private defs: SvgElement;
        private mainGroup: D3.Selection;
        /** Высота виджета. */
        private svgHeight: number;
        /** Ширина виджета. */
        private svgWidth: number;
        private contextProvider: IExpressionContextProvider;
        private sectionContext: IExpressionContext;
        private tooltipContext: any;
        /** Подпись. */
        private tooltip: D3.Selection;
        /** Стиль подписи. */
        private dataLabelStyle: any = (<any>Highcharts.getOptions()).tooltip.style;

        constructor(public model: Model.Infographics.RingWidget, args: any[]) {
            super(model);
            this.contextProvider = <IExpressionContextProvider>args[0];
            if (!this.sectionContext) {
                this.sectionContext = this.contextProvider.getExpressionContext();
            }
        }

        public render(container: HTMLElement) {
            super.render(container);
        }

        public refresh(container: HTMLElement) {
            $(container).empty();
            this.onBeforeRender.Trigger(this.getId());

            this.svgHeight = (this.model.height !== undefined ? this.model.height : 100);
            this.svgWidth = this.svgHeight;

            // Левый отступ для подписи значения.
            var leftPadding = this.model.leftPadding || 30;
            // Вычисляем координаты центра.
            var x = leftPadding + this.svgHeight / 2;
            var y = this.svgHeight / 2;
            var pi = Math.PI;
            var dataSource = this.getDataSourceManager().get(this.model.dataSourceRef);

            this.tooltipContext = {};

            this.svg = new SvgElement(d3.select(container), "svg");
            // Настройка элемента svg.
            this.svg
                .attr("width", this.svgWidth + leftPadding)
                .attr("height", this.svgHeight)
            // Предотвращаем выделение текста.
                .style("-webkit-touch-callout", "none")
                .style("-webkit-user-select", "none")
                .style("-khtml-user-select", "none")
                .style("-moz-user-select", "none")
                .style("-ms-user-select", "none")
                .style("user-select", "none");
            this.defs = new SvgElement(this.svg, "svg:defs");
            // Создаём главную группу элементов.
            this.mainGroup = this.svg.append("g");
            // Создаём вспомогательную группу элементов.
            var group = this.mainGroup.append("g")
                .attr("transform", "translate(" + x + "," + y + ")");

            // Вычислим радиусы кругов.
            var oRadius = this.svgHeight / 2 - this.model.innerRadius;
            var iRadius = this.svgHeight / 2;
            var outColor = this.model.patternImg ? this.textureGradient(this.model.outerColor) : this.model.outerColor;
            // Рисуем круги.
            var arc = d3.svg.arc()
                .innerRadius(0)
                .outerRadius(iRadius)
                .startAngle(0)
                .endAngle(2 * pi);

            group.append("path")
                .attr("d", arc)
                .style("fill", outColor);

            arc = d3.svg.arc()
                .innerRadius(0)
                .outerRadius(oRadius)
                .startAngle(0)
                .endAngle(2 * pi);

            group.append("path")
                .attr("d", arc)
                .style("fill", this.model.innerColor);
            // Данные для показателя получим.
            var row = dataSource.getRow(() => {
                return true;
            });
            var prc = row.get(this.model.gaugeColumn);
            var angle = (this.model.clockwise ? 1 : -1) * 2 * pi * prc / 100;
            var gaugeColor = this.model.patternImg ? this.textureGradient(this.model.gaugeColor) : this.model.gaugeColor;
            // Нарисуем дугу показателя.
            arc = d3.svg.arc()
                .innerRadius(oRadius)
                .outerRadius(iRadius)
                .startAngle(0)
                .endAngle(angle);
            group.append("path")
                .attr("d", arc)
                .style("fill", gaugeColor);
            if (this.model.useConnector || this.model.useConnector === undefined) {
                // Добавим подпись значения.
                var textX = - iRadius - leftPadding + iRadius / 10;
                var textY = - (iRadius - leftPadding);
                group.append("text")
                    .text(prc.toFixed(1).toString().replace(".", ",") + "%")
                    .style("font-weight", "bold")
                    .style("font-family", this.dataLabelStyle.fontFamily)
                    .style("font-size", "18px")
                    .attr("x", textX)
                    .attr("y", textY);
                // Добавим линию от подписи до линии показателя.
                var rx = Math.cos(angle / 5 - pi / 2) * (iRadius - 10);
                var ry = Math.sin(angle / 5 - pi / 2) * (iRadius - 10);
                group.append("path")
                    .attr("d", "M " + rx + " " + ry
                    + " L " + (textX + 38) + " " + (textY + 5)
                    + " L " + (textX + 20) + " " + (textY + 5))
                // + " L " + (textX + 20) + " " + textY + "  ")
                    .style("stroke", "#C4C4C4")
                    .style("fill", "none");
            }
            // Добавим стрелку.
            var microGrad = pi / 1000; // Чтобы немного сдвинуть стрелку на линию, иначе видна белая полоска.
            var ax = Math.cos(angle - pi / 2 + microGrad) * oRadius;
            var ay = Math.sin(angle - pi / 2 + microGrad) * oRadius;
            var bx = Math.cos(angle - pi / 2 + microGrad) * iRadius;
            var by = Math.sin(angle - pi / 2 + microGrad) * iRadius;
            var a2x = Math.cos(angle - pi / 2) * oRadius;
            var a2y = Math.sin(angle - pi / 2) * oRadius;
            var b2x = Math.cos(angle - pi / 2) * iRadius;
            var b2y = Math.sin(angle - pi / 2) * iRadius;
            var cx = Math.cos(angle - pi / 2 - pi / 25) * (iRadius + oRadius) / 2;
            var cy = Math.sin(angle - pi / 2 - pi / 25) * (iRadius + oRadius) / 2;
            group.append("path")
                .attr("d", "M " + ax + " " + ay + " L" + a2x + " " + a2y +
                " L" + cx + " " + cy + " L " + bx + " " + by + " L " + b2x + " " + b2y + " Z")
                .style("fill", gaugeColor);
            group.append("path")
                .attr("d", "M " + ax + " " + ay + " L" + bx + " " + by + " Z")
                .style("stroke", gaugeColor);

            // Текст
            this.tooltip = d3.select(container).append("div")
            // .style("display", "inline-block")
                .style("position", "relative")
                .style("width", iRadius + (iRadius - oRadius) + "px")
                .style("text-align", "center")
                .style("margin-left", "5px")
                .style("left", + this.model.textLeftPadding + (iRadius - oRadius) + leftPadding + "px")
                .style("top", + this.model.textTopPadding - iRadius - (iRadius / 2) + "px")
                .style("font-weight", this.dataLabelStyle.fontWeight)
                .style("font-family", this.dataLabelStyle.fontFamily)
                .style("font-size", this.dataLabelStyle.fontSize);
            // Данные для текста.
            var plan = row.get(this.model.planColumn);
            var fact = row.get(this.model.factColumn);
            // Заполняем контекст для вычисления подсказки.
            this.tooltipContext = {
                plan: numeral(plan).format("0,0.0"),
                fact: numeral(fact).format("0,0.0")
            };
            // Рендерим подсказку.
            var tooltipContent = (<IUIComponent>ControlFactory.create(this.model.text, this));
            this.addChildComponent(tooltipContent, this);
            this.tooltip.html(tooltipContent.renderToString());
            if (this.model.icon) {
                var purseImageUrl = WebReports.globals.host.getResourceUrl(this.model.icon);
                new Image(this.svg, x - iRadius / 2, y - iRadius / 2, iRadius - 10, iRadius - 10)
                    .setUrl(purseImageUrl)
                    .attr("image-rendering", "optimizeQuality")
                    .style("pointer-events", "none");
            }
            this.onAfterRender.Trigger(this.getId());
        }

        public getExpressionContext(): IExpressionContext {
            return $.extend(this.sectionContext, this.tooltipContext);
        }
        // текстура
        private textureGradient(color: string): string {
            var imageUrl = WebReports.globals.host.getResourceUrl(this.model.patternImg);
            var pattern = new Pattern(this.defs, this.generateUniqueKey(), 50, 50);
            pattern.setImage(imageUrl, color);
            return pattern.getUrl();
        }
    }
}
