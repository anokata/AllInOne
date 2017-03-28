declare module WebReports.Model.Infographics {
    export interface Fan extends D3Control {
        /**
         * Ширина контрола.
         * Может устанавливаться в пикселях либо в %. Если единицы измерения явно не указаны, значит
         * считается, что указано в пикселях. Значение в % рассчитывается относительно ширины контейнера.
         * Например: 130, "130", "130px", "80%".
         * В случае если значение ширины не указано, а высота (height) задана, ширина будет рассчитана
         * автоматически, таким образом чтобы соблюсти размерные пропорции при заданной высоте.
         * Если не заданы ни ширина ни высота, тогда ширина принимается равной 100%, а высота рассчитывается
         * автоматически.
         */
        width: any;
        /**
         * Высота контрола.
         * Может устанавливаться в пикселях либо в %. Если единицы измерения явно не указаны, значит
         * считается, что указано в пикселях. Значение в % рассчитывается относительно высоты контейнера.
         * Например: 120, "120", "120px", "70%".
         * В случае если значение высоты не указано, а ширина (width) задана, высота будет рассчитана
         * автоматически, таким образом чтобы соблюсти размерные пропорции при заданной ширине.
         * Если не заданы ни ширина ни высота, тогда ширина принимается равной 100%, а высота рассчитывается
         * автоматически.
         */
        height: any;
        /**
         * Внутренний радиус веера в долях от внешнего радиуса.
         * По умолч. 0.3
         */
        innerRadiusCoeff: number;
        /**
         * Минимальная длина луча в долях от максимально возможной длины.
         * По умолч. 0.1
         */
        rayMinLengthCoeff: number;
        /**
         * Максимальная длина луча в долях от максимально возможной длины.
         * По умолч. 1.0
         */
        rayMaxLengthCoeff: number;
        /**
         * Минимальное значение показателя (это не обязательно должно быть значение из выборки),
         * которое будет соответствовать минимальной длине луча.
         * Если не указано, берется минимальное значение из выборки
         */
        minValue: any;
        /**
         * Максимальное значение показателя (это не обязательно должно быть значение из выборки),
         * которое будет соответствовать максимальной длине луча.
         * Если не указано, берется максимальное значение из выборки
         */
        maxValue: any;
        /** Столбец данных, значения которого будут участвовать в выборке. */
        dataColumn: string;
        /** Столбец наименований для легенды. */
        nameColumn: string;
        code: string;
        /** Столбец реальных данных. */
        realDataColumn: string;
        /** Столбец данных, значения которого будут использоваться для установки цвета соответствующего луча */
        rayColorColumn: string;
        /**
         * Порядок лучей. Если не задан, лучи будут расположены согласно порядку задающих их данных.
         * При установке в пустое значение {} или true, сортировка лучей будет производиться со значениями dataColumn и desc,
         * взятыми по умолчанию.
         */
        rayOrder: {
            /**
             * Столбец данных, по значениям которого будут сортироваться лучи (по умолч. берется значение
             * из поля dataColumn модели)
             */
            dataColumn: any;
            /** Вид сортировки: true - по убыванию, false - по возрастанию (по умолч. false /по возрастанию/). */
            desc: boolean;
        };
        /** Название. Располагается под диаграммой. */
        title: Text;
        /** Текст тултипа. */
        tooltipText: Text;
        /** Время (в секундах) показа тултипа. По умолч. 15 сек. */
        tooltipTimeout: number;
        /** Индикатор картинки. */
        imageIndicator: any;
        /** Индикатор перехода на другой отчет или внешний ресурс. */
        linkIndicator: any;
        /** Общие настройки картинок, расположенных напротив лучей. */
        image: {
            /**
             * Размер картинки.
             * Может устанавливаться в пикселях (постоянная величина) либо в % (относительная). В последнем случае
             * процент считается от длины хорды, соединяющей две крайние точки сектора луча. Если единицы измерения
             * явно не указаны, значит считается, что указано в пикселях.
             * Примеры: 100, "100", "100px", "100%".
             * По умолч. "80%"
             */
            size: any;
            /**
             * Максимальный размер картинки. Полезная настройка, если размер картинки (size) указан в процентах.
             * Указывается в пикселях (постоянная величина). Если единицы измерения явно не указаны, считается,
             * что указано в пикселях.
             * Примеры: 230, "230", "230px".
             * По умолч. Infinity
             */
            maxSize: any;
            /**
             * Радиальное смещение изображения от внешней окружности каркаса веера. Считается до границы окружности,
             * описанной вокруг площади рисунка. Может устанавливаться в пикселях (постоянная величина) либо в %
             * (относительная). В последнем случае процент считается от размера картинки (size). Если единицы измерения
             * явно не указаны, значит считается, что указано в пикселях.
             * Примеры: 14, "14", "14px", "8%".
             * По умолч. "15%"
             */
            radialOffset: any;
            /**
             * Диаметр окружности, появляющейся вокруг картинки при выделении соотвествующего луча. Может устанавливаться
             * в пикселях (постоянная величина) либо в % (относительная). В последнем случае процент считается от диаметра
             * окружности, описанной вокруг периметра картинки. Если единицы измерения явно не указаны, значит считается,
             * что указано в пикселях.
             * Примеры: 110, "110", "110px", "120%".
             * По умолч. "105%"
             */
            selectionDiameter: any;
            /**
             * Цвет окружности выделения картинки. Задается так же, как цвета в CSS.
             * Примеры: "#4faa90", "rgb(123,0,76)".
             * По умолч. "red"
             */
            selectionColor: string;

            circleSize: any;
        };
        /* Цвета. */
        colors: string[];
        /**
         * Ассоциативный массив идентификаторов иконок.
         * Индекс является идентификатором записи в данных.
         * Значение - индекс иконки.
         */
        ids: number[];
        /**
         * Пользовательские данные. После установки они будут доступны из контекста шаблонов.
         * Например, задаем: "customData": {"totalValue": "4 862 29", "year": 2014}. Теперь
         * обратиться в шаблоне можно так: {{customData.totalValue}}
         */
        customData: any;
        /** */
        legend: {
            enabled: boolean;
            legendLeft: number;
            legendTop: number;
            legendInColumn: number;
            legendPadding: number;
            legendNameLeft: number;
            legendDataLeft: number;
        };
    }
}

module WebReports.Controls.Infographics {
    export class Fan extends D3Control implements IContextProvider {
        private fanModel: Model.Infographics.Fan;
        private fanSection: WebReports.Controls.ISection;
        private fanContext: any;
        private contextProvider: IExpressionContextProvider;
        private sectionContext: IExpressionContext;

        private fanGroup: JQuery;
        private svgElem: SvgElement;
        private svg: JQuery;
        private svgSize: Object;
        private defs: SvgElement;

        private vbWidth: number;
        private vbHeight: number;
        private imgThresholdRadius: number;
        private selectionThresholdRadius: number;

        private images: Image[];
        private selectedImgIdx: number;
        private selectedRay: JQuery;
        private d3ImgSelection: D3.Selection;
        private tipPositionCoeffs: any;

        private d3Group: D3.Selection;
        private d3FrameSegments: D3.Selection;
        private d3Rays: D3.Selection;
        private d3Images: D3.Selection;
        private d3ImagesLegend: D3.Selection;
        private svgLegend: SvgElement;

        private d3Circles: D3.Selection;
        private d3LegendCircles: D3.Selection;
        private d3Legend: D3.Selection;

        private imgGroup: Container;
        private fanTip: any;
        private tipTimeoutId: number;

        private fanData: any;
        private rayAngle: number;
        private rayAngles: any;
        private imgParams: any;

        private dataSourceManager: any;

        private static defaults: Object = {
            innerRadiusCoeff: 0.3,
            rayMinLengthCoeff: 0.1,
            rayMaxLengthCoeff: 1.0,
            rayColorColumn: "color",
            rayOrder: false,
            image: {
                size: "80%",
                maxSize: Infinity,
                radialOffset: "15%",
                selectionDiameter: "105%",
                selectionColor: "black"
            },
            tooltipTimeout: 5      // Cекунды
        };

        constructor(model: Model.Infographics.Fan, args: any[]) {
            super(model);
            this.fanModel = Fan._getModelParams(model);
            this.fanSection = args[0];
            this.contextProvider = <IExpressionContextProvider>args[0];
            if (!this.sectionContext) {
                this.sectionContext = this.contextProvider.getExpressionContext();
            }
        }

        public render(container: HTMLElement) {
            this.dataSourceManager = this.getDataSourceManager();

            super.render(container);
        }

        public refresh(container: HTMLElement) {
            this.onBeforeRender.Trigger(this.getId());
            var $container = $(container).empty();
            var self = this;
            $(".d3-tip").remove();
            var dataColumn = this.fanModel.dataColumn;

            var startAngle = -90 * Math.PI / 180,    // В радианах
                endAngle = 90 * Math.PI / 180;    // В радианах

            // Определяем функцию для сортировки лучей
            var comparator = null,
                rayOrder = this.fanModel.rayOrder;
            if (rayOrder) {
                var dataCol = rayOrder.dataColumn ? rayOrder.dataColumn : dataColumn;
                comparator = rayOrder.desc ? (d1: any, d2: any) => {
                    if (d1[dataCol] < d2[dataCol]) { return 1; }
                    if (d1[dataCol] > d2[dataCol]) { return -1; }
                    return 0;
                } : (d1: any, d2: any) => {
                        if (d2[dataCol] < d1[dataCol]) { return 1; }
                        if (d2[dataCol] > d1[dataCol]) { return -1; }
                        return 0;
                    };
            };

            var pie = d3.layout.pie()
                .sort(null)
                .value(function (d, i) { return 1; })
                .startAngle(startAngle)
                .endAngle(endAngle);
            var dataSource = this.getDataSourceManager().get(this.fanModel.dataSourceRef),
                rows = dataSource.getRows(),
                rayCnt = rows.length;
            this.fanData = dataSource.getRows().map(
                (item: IDataSourceRow) => { return (<any>item).row.getData(); }),
            this.rayAngle = (endAngle - startAngle) / rayCnt;

            if (rayCnt === 0) {
                $container.append("<div>Нет данных</div>");
                return;
            }

            this.rayAngles = pie(this.fanData);

            this.fanGroup = $("<div class='fan-group'>");
            $container.append(this.fanGroup);

            var svgElem = new SvgElement(d3.select(this.fanGroup[0]), "svg");
            this.svgElem = svgElem;

            var d3Svg = d3.select(".fan-group svg")
                .style("box-sizing", "border-box")
                .style("width", "100%")
                .style("height", "102%");

            this.svg = $container.find("svg");

            if (this.fanModel.width) { this.fanGroup.css("width", this.fanModel.width); };
            if (this.fanModel.height) { this.fanGroup.css("height", this.fanModel.height); };
            if (!this.fanModel.width) { this.fanGroup.width(this.svg.height() * 2); };
            if (!this.fanModel.height) { this.fanGroup.height(this.svg.width() / 2); };

            // Тултип для лучей
            var tip = (<any>d3).tip()
                .attr("class", "d3-tip")
                .offset([0, 0])
                .style("width", "400px")
                .html(function (d) {
                if (self.fanModel.tooltipText) {
                    self.fanContext = d.data;
                    var titleContent = (<IUIComponent>ControlFactory.create(self.fanModel.tooltipText, self));
                    that.addChildComponent(titleContent, self);
                    var titleContentStr = titleContent.renderToString();
                    return titleContentStr;
                }
            });
            tip.oncloseclick = function() { self._hideTooltip(); };

            this.fanTip = tip;
            d3Svg.call(tip);
            if (this.fanTip) { this.fanTip.hide(); };

            // Надпись под веером
            var titleContent = (<IUIComponent>ControlFactory.create(this.fanModel.title, this));
            this.addChildComponent(titleContent, this);
            var titleContentStr = titleContent.renderToString();

            var $title = $("<div class='fan-title'>" + titleContentStr + "</div>").appendTo(this.fanGroup),
                titleHeight = $title.height();
            this.svg.css("padding-bottom", titleHeight);

            $title.css({ "margin-top": - titleHeight, "text-align": "center" });

            var groupElem = new SvgElement(d3Svg, "g")
                .attr("class", "svg-fan-group");
            var d3Group = this.d3Group = d3.select(".svg-fan-group");

            this.svgLegend =  new SvgElement(d3Svg, "g")
                    .attr("class", "svg-fan-legend");
                this.d3Legend = d3.select(".svg-fan-legend");
                var d3Legend = this.d3Legend;

            var that = this;
            this.d3Rays = d3Group.selectAll(".solidArc")
                .data(this.rayAngles)
                .enter().append("path")
                .attr("fill", function (d) { return that.fanModel.colors[that.fanModel.ids[d.data.id]]; } )
                .attr("class", "solidArc")
                .attr("stroke", "lightgray")
                .style("cursor", "pointer")
                .on("mousemove", function (d, i) {
                    self._setImgSelection(i);
                    self.selectedRay = $(this);
                    self._showTooltip(d, i);
                    var $svg = self.svg,
                        svgOffset = $svg.offset(),
                        $tip = $("body > .d3-tip"),
                        tipOffset = $tip.offset();
                        tipOffset.left = tipOffset.left < 0 ? 0 : tipOffset.left;
                    self.tipPositionCoeffs = {
                        width: (tipOffset.left - svgOffset.left) / $svg.width(),
                        height: (tipOffset.top - svgOffset.top) / $svg.height(),
                    };
                })
                .on("mouseleave", function () {
                self._hideTooltip();
                self.selectedImgIdx = undefined;
                self.selectedRay = undefined;
                self._unselectImg();
            })
                .on("mouseout", function () {
                self._hideTooltip();
                self.selectedImgIdx = undefined;
                self.selectedRay = undefined;
                self._unselectImg();
            });

            this.d3FrameSegments = d3Group.selectAll(".outlineArc")
                .data(this.rayAngles)
                .enter().append("path")
                .attr("fill", "none")
                .attr("stroke", "lightgray")
                .attr("class", "outlineArc");

            // Вставляем картинки, соответствующие элементам данных
            if (this.fanModel.imageIndicator) {
                this.images = [];
                for (var i = 0; i < rayCnt; i++) {
                    var row = rows[i];
                    var svgData = <IIndicatorSvgData>{};

                    var vizualizer = new WebReports.Controls.Indicators.Vizualizers.SvgVizualizer(svgData);
                    (<IIndicator>WebReports.ControlFactory.create(this.fanModel.imageIndicator)).apply(row, this, vizualizer);

                    this.d3Circles = this.d3Group
                        .append("circle");
                    if (this.fanModel.legend) {
                        this.d3LegendCircles = this.d3Legend
                            .append("circle");
                    }
                    if (svgData.url) {
                        var imgElem = new Infographics.Image(groupElem, 0, 0, 0, 0)
                            .setUrl(svgData.url)
                            .attr("class", "svg-fan-img");
                        // Второе изображения для легенды.
                        if (this.fanModel.legend && this.fanModel.legend.enabled) {
                            var imgElem2 = new Infographics.Image(<any>d3Legend, 0, 0, 0, 0)
                                .setUrl(svgData.url)
                                .attr("class", "svg-fan-img-legend");
                        }
                        // Если задан набор ссылок на другой документ
                        if (this.fanModel.linkIndicator) {
                            var createLinkData = (row: any) => {
                                var linkData = <IIndicatorSvgData>{},
                                    vizualizer = new WebReports.Controls.Indicators.Vizualizers.SvgVizualizer(linkData);
                                that.addChildComponent(vizualizer, that);
                                var link = (<IIndicator>WebReports.ControlFactory.create(self.fanModel.linkIndicator));
                                row.row.code = row.get((<any>this.model).code);
                                var ctx = $.extend(that.getExpressionContext(), row, { "code": row.get((<any>this.model).code) });
                                link.apply(row, this.getExpressionContext(), vizualizer);
                                return linkData;
                            };

                            var linkData = createLinkData(row);
                            if (linkData.linkObject) {
                                imgElem.style("cursor", "pointer");
                            }
                            // Вставляем ссылку на другой документ
                            imgElem.on("click", ((row: any) => {
                                return (e: any) => {
                                    var linkData = createLinkData(row);
                                    if (linkData.linkObject) {
                                        linkData.linkObject.action();
                                    }
                                };
                            })(row));
                        }

                        this.d3Images = d3Group.selectAll(".svg-fan-img");
                        if (this.fanModel.legend && this.fanModel.legend.enabled) {
                            this.d3ImagesLegend = d3Legend.selectAll(".svg-fan-img-legend");
                            this.d3LegendCircles = d3Legend.selectAll("circle");
                        }
                        this.d3Circles = d3Group.selectAll("circle");
                    }
                }
            }

            $(window).resize(() => { self._onResize(); });
            this._onResize();

            this.onAfterRender.Trigger(this.getId());
        }

        private _onResize() {
            if (!this.fanModel.width) {
                this.fanGroup.width(this.fanGroup.height() * 2);
            } else {
                    if (!this.fanModel.height) {
                        this.fanGroup.height(this.fanGroup.width() / 2);
                    }
            };

            var svgWidth = this.svg.width(),
                svgHeight = this.svg.height(),
                model = this.fanModel,
                imageOpts = model.image,
                imgSize = imageOpts.size,
                imgMaxSize = imageOpts.maxSize,
                imgRadialOffset = imageOpts.radialOffset,
                imgSelectionDiam = imageOpts.selectionDiameter,
                partVal = 0, flgCalcKeySizeForSelection = false,
                // Определяем размер, в который надо вписать половину веера.
                // Он будет являться начальным значением для внешнего радиуса каркаса веера
                basicFanSize = (svgWidth / 2 > svgHeight ? svgHeight : svgWidth / 2) - 2,
                // -2 пикселя на всякий случай, чтобы края рисунка не обрезались
                outerRadius = basicFanSize,
                flgCalcOuterRadiusForSelection = false,
                coeffImgSize = 0,
                coeffImgOffset = 0,
                coeffImgSel = 1;

            this.d3Group.attr("transform", "translate(" + svgWidth / 2 + "," + (outerRadius + 2) + ")");
            if (this.fanModel.legend && this.fanModel.legend.enabled) {
                this.d3Legend.attr("transform", "translate(" + 0 + "," + (outerRadius + 2) + ")");
            }
            // Если размер картинки задан в долях
            if (imgSize < 0) {
                if (!this.imgThresholdRadius) {
                    var imgParams = this._calcImgParams(imgMaxSize / (2 * (-imgSize) * Math.sin(this.rayAngle / 2))),
                        selDelta = imgParams.imgSelectionRadius - imgParams.imgCircleRadius;
                    this.imgThresholdRadius = imgParams.imgCenterRadius + imgParams.imgCircleRadius + (selDelta > 0 ? selDelta : 0);
                }
                // Текущий базовый размер веера больше рассчитанного порогового значения?
                if (basicFanSize > this.imgThresholdRadius) {
                    imgSize = imgMaxSize;
                    // Сразу вычитаем из базового размера диаметр окружности, описанной вокруг картинки
                    outerRadius -= imgSize / Math.sin(Math.PI / 4);
                } else {
                    coeffImgSize = -imgSize;
                }
            // Если размер картинки задан точно
            } else {
                if (imgMaxSize >= 0 && imgSize > imgMaxSize) {
                    imgSize = imgMaxSize;
                }
                // Сразу вычитаем из базового размера диаметр окружности, описанной вокруг картинки
                outerRadius -= imgSize / Math.sin(Math.PI / 4);
            }

            // Если радиальное смещение задано в долях
            if (imgRadialOffset < 0) {
                // Если задан размер картинки точным значением
                if (imgSize >= 0) {
                    // Считаем сразу радиальное смещение и вычитаем из базового размера
                    outerRadius -= -imgRadialOffset * imgSize;
                } else {
                    // То составляем выражение
                    coeffImgOffset = -imgRadialOffset;
                }
            } else {
                // Сразу вычитаем из базового размера
                outerRadius -= imgRadialOffset;
            }
            // Eсли размер картинки изначально задан точно
            if (imgSize >= 0) {
                var imgCircleRadius = imgSize / (2 * Math.sin(Math.PI / 4)),
                    delta = 0;
                // Eсли размер выделения задан в долях
                if (imgSelectionDiam < 0) {
                    // Eсли размер выделения задан большим по размеру, чем окружность, описанная вокруг картинки (< -1.0)
                    if (imgSelectionDiam < -1.0) {
                        delta = (-imgSelectionDiam - 1) * imgCircleRadius;
                    };
                    // Иначе задан точно
                } else {
                    delta = imgSelectionDiam / 2 - imgCircleRadius;
                }
                if (delta > 0) {
                    // Сразу вычитаем из базового размера постоянную величину
                    outerRadius -= delta;
                }
                // Иначе просто никак не учитываем его...
            // Если размер картинки изначально задан в долях
            } else {
                // Если размер выделения задан в долях
                if (imgSelectionDiam < 0) {
                    // Если размер выделения задан большим по размеру, чем окружность, описанная вокруг картинки (< -1.0)
                    if (imgSelectionDiam < -1.0) {
                        coeffImgSel = -imgSelectionDiam;
                    }
                    // Если размер выделения задан точно
                } else {
                    if (!this.selectionThresholdRadius) {
                        imgParams = this._calcImgParams(imgSelectionDiam / 2 * Math.sin(Math.PI / 4) /
                            (coeffImgSize * Math.sin(this.rayAngle / 2)));
                        this.selectionThresholdRadius = imgParams.imgCenterRadius + imgParams.imgCircleRadius;
                    }
                    if (this.selectionThresholdRadius > basicFanSize) {
                        flgCalcOuterRadiusForSelection = true;
                    }
                }
            }

            outerRadius = flgCalcOuterRadiusForSelection ?
                (outerRadius - imgSelectionDiam / 2) / (1 + 2 * coeffImgSize * Math.sin(this.rayAngle / 2)
                    * (coeffImgOffset + 1 / (2 * Math.sin(Math.PI / 4)))) :
                this._calcOuterRadius(outerRadius, coeffImgSize, coeffImgOffset, coeffImgSel);

            // Внутренний радиус каркаса веера
            var innerRadius = this.fanModel.innerRadiusCoeff * outerRadius;
            imgParams = this.imgParams = this._calcImgParams(outerRadius);

            // Рассчитываем параметры, для соотнесения заданных макс. и мин. длин луча к макс. и мин. значениям показателя
            var dataColumn = this.fanModel.dataColumn,
                minVal = this.fanModel.minValue !== undefined ? this.fanModel.minValue :
                d3.min(this.fanData, (d) => { return d[dataColumn]; }),
                maxVal = this.fanModel.maxValue !== undefined ? this.fanModel.maxValue :
                d3.max(this.fanData, (d) => { return d[dataColumn]; }),
                rayMaxAllowableLength = outerRadius - innerRadius,
                rayMinLength = rayMaxAllowableLength * this.fanModel.rayMinLengthCoeff,
                rayMaxLength = rayMaxAllowableLength * this.fanModel.rayMaxLengthCoeff,
                rayLengthValRatio = (rayMaxLength - rayMinLength) / (maxVal - minVal),
                rayRadiusLength = minVal * rayLengthValRatio - rayMinLength - innerRadius;

            // Лучи
            var arc = d3.svg.arc()
                .innerRadius(innerRadius)
                .outerRadius(function (d) {
                    return d.data[dataColumn] * rayLengthValRatio - rayRadiusLength;
                });

            // Каркас без лучей
            var outlineArc = d3.svg.arc()
                .innerRadius(innerRadius)
                .outerRadius(outerRadius);

            this.d3Rays.attr("d", arc);
            this.d3FrameSegments.attr("d", outlineArc);

            var imgPoses = [];
            for (var i = 0, l = this.rayAngles.length; i < l; i++) {
                imgPoses[i] = this._calcImgPosition(this.rayAngles[i]);
            }
            var that = this;
            var radius = this.fanModel.image.circleSize || 34;
            var jsonCircles = [];
            for (i = 0; i < imgPoses.length; i++) {
                jsonCircles.push({
                    "x_axis": imgPoses[i].left + radius - 0,
                    "y_axis": imgPoses[i].top + radius - 0,
                    "radius": radius,
                    "color": that.fanModel.colors[that.fanModel.ids[that.fanData[i].id]]
                });
            };

            this.d3Circles = this.d3Group.selectAll("circle")
                .data(jsonCircles);

           var circleAttributes = this.d3Circles
               .attr("cx", function (d) { return d.x_axis + radius / 1.5; })
               .attr("cy", function (d) { return d.y_axis + radius / 1.5; })
                    .attr("r", function (d) { return d.radius; })
                .style("fill", function (d) { return d.color; });

           var nameColumn = this.fanModel.nameColumn;
           var realDataColumn = this.fanModel.realDataColumn;
        // Настройка легенды
           if (this.fanModel.legend && this.fanModel.legend.enabled) {
               var legendLeft = this.fanModel.legend.legendLeft || 50;
               var legendTop = this.fanModel.legend.legendTop || 50;
               var legendInColumn = this.fanModel.legend.legendInColumn || 7;
               var legendColumn2 = (svgWidth ? svgWidth / 2 : 400);
               var legendPadding = this.fanModel.legend.legendPadding || 23;
               var legendNameLeft = this.fanModel.legend.legendNameLeft || 80;
               var legendDataLeft = this.fanModel.legend.legendDataLeft || 25;
               // Данные для кружков легенды.
               var jsonLegend = [];
               for (i = 0; i < imgPoses.length; i++) {
                   jsonLegend.push({
                       "x_axis": legendLeft + (i > legendInColumn ? legendColumn2 : 0) - 3,
                       "y_axis": (i > legendInColumn ? legendPadding * (i - legendInColumn - 1)
                           + (i - legendInColumn - 1) * radius * 1 + legendTop : legendPadding * i + i * radius * 1 + legendTop) - 3,
                       "radius": radius,
                       "color": that.fanModel.colors[that.fanModel.ids[that.fanData[i].id]]
                   });

                   // Пишем наименование.
                   var text = new Text(this.svgLegend, {}, "left")
                       .setWrapText(that.fanData[i][nameColumn], 10, 48, 15)
                       .style("font-size", "15px")
                       .style("font-weight", "normal")
                       .style("fill", "black")
                       .translate(legendNameLeft + legendLeft + (i > legendInColumn ? legendColumn2 : 0),
                       (i > legendInColumn ? legendPadding * (i - legendInColumn - 1)
                           + (i - legendInColumn - 1) * radius * 1 + legendTop : legendPadding * i + i * radius * 1 + legendTop));
                   // Пишем процент.
                   text = new Text(this.svgLegend, {}, "left")
                   // .setWrapText(gettext(that._data[i][realDataColumn].toFixed(1)) + "%", 20, 20, 20)
                       .setWrapText(numeral(that.fanData[i][realDataColumn] / 100).format("0,0.0%"), 10, 50, 20)
                       .style("font-size", "15px")
                       .style("font-weight", "bold")
                       .style("fill", "black")
                       .translate(legendDataLeft + legendLeft + (i > legendInColumn ? legendColumn2 : 0),
                       (i > legendInColumn ? legendPadding * (i - legendInColumn - 1)
                           + (i - legendInColumn - 1) * radius * 1 + legendTop : legendPadding * i + i * radius * 1 + legendTop));
               };
               // Применим данные кругов легенды.
               this.d3LegendCircles = this.d3Legend.selectAll("circle")
                   .data(jsonLegend);
               // Расставим кружки легенды.
               var circleAttributesLegend = this.d3LegendCircles
                   .attr("cx", function (d) { return d.x_axis; })
                   .attr("cy", function (d) { return d.y_axis; })
                   .attr("r", function (d) { return d.radius / 2; })
                   .style("fill", function (d) { return d.color; });
               // Расставим иконки легенды.
               if (this.d3ImagesLegend) {
                   this.d3ImagesLegend.attr({
                       x: (d: any, i: number) => { return 2 + legendLeft - radius / 2 + (i > legendInColumn ? legendColumn2 : 0); },
                       y: (d: any, i: number) => {
                           return (i > legendInColumn ?
                               legendPadding * (i - legendInColumn - 1) + 2 + (i - legendInColumn - 1) * radius * 1 - radius / 2 + legendTop
                               : legendPadding * i + 2 + i * radius * 1 - radius / 2
                               + legendTop - (i > legendInColumn ? legendInColumn * radius : 0));
                       },
                       width: imgParams.imgSize / 2,
                       height: imgParams.imgSize / 2
                   });
               }
           }
            var self = this;
            if (this.d3Images) {
                this.d3Images.attr({
                    x: (d: any, i: number) => { return imgPoses[i] ? imgPoses[i].left  : 0; },
                    y: (d: any, i: number) => { return imgPoses[i] ? imgPoses[i].top : 0; },
                    width: imgParams.imgSize,
                    height: imgParams.imgSize
                });
            }
            // Если имеется выделенная картинка (окружностью)
            if (this.selectedImgIdx) {
                // Пересчитываем позицию окружности выделения
                this._setImgSelection(this.selectedImgIdx);
            }
        }

        public getContext(): IExpressionContext {
            var ctx: any = $.extend(this.fanSection.getExpressionContext(), this.fanContext);
            ctx.customData = this.fanModel.customData;
            return ctx;
        }
        public getExpressionContext(): IExpressionContext {
            // : return $.extend(this.sectionContext, this._context);
            var ctx: any = $.extend(this.sectionContext, this.fanContext);
            ctx.customData = this.fanModel.customData;
            return ctx;
        }

        private _calcOuterRadius(basicFanSize, coeffImgSize, coeffImgOffset, coeffImgSel): number {
            return basicFanSize / (1 + 2 * coeffImgSize * Math.sin(this.rayAngle / 2)
                * ((coeffImgSel + 1) / (2 * Math.sin(Math.PI / 4)) + coeffImgOffset));
        }

        private _showTooltip(datum, datumIdx) {
            this.fanTip.show(datum, datumIdx);
            if (this.tipTimeoutId) {
                clearTimeout(this.tipTimeoutId);
            }
            var self = this;
            // Таймаут для тултипа
            self.tipTimeoutId = setTimeout(() => {
                self.fanTip.hide();
                self.tipTimeoutId = null;
            }, self.fanModel.tooltipTimeout * 1000);
        }

        private _hideTooltip() {
            this.fanTip.hide();
            if (this.tipTimeoutId) {
                clearTimeout(this.tipTimeoutId);
                this.tipTimeoutId = null;
            }
        }

        private static _getModelParams(model: Model.Infographics.Fan) {
            var imageOpts: any = $.extend({}, (<any>Fan.defaults).image, model.image);
            model = <Model.Infographics.Fan>$.extend({}, Fan.defaults, model);

            if (model.width) {
                model.width = Fan._processCssValue(model.width);
            }
            if (model.height) {
                model.height = Fan._processCssValue(model.height);
            }
            if (!model.width && !model.height) {
                model.width = "100%";
            }
            for (var prop in { "size": 0, "maxSize": 0, "radialOffset": 0, "selectionDiameter": 0 }) {
                if (imageOpts.hasOwnProperty(prop)) {
                    imageOpts[prop] = Fan._processPercentableValue(imageOpts[prop]);
                }
            }
            model.image = imageOpts;
            return model;
        }

        private static _processCssValue(val: any): string {
            if (val == null) { return val; };
            if (typeof val === "number") { return val + "px"; };
            val = val.toString();
            return isNaN(+val) ? val : val + "px";
        }

        private static _processPercentableValue(val: any): number {
            if (val == null) { return val; };
            if (typeof val === "number") { return val; };
            val = val.toString();
            // Определяем, задан ли размер в процентах
            var res = /^(\d*(?:\.\d+)?)%$/.exec(val);
            // Если задан в процентах
            return res && res[1] ?
                // Задаем как доля от 1, и делаем отрицательным, что будет означать, что задано в процентах
                - Number(res[1]) / 100 :
                // Задаем постоянное значение, как задано
                Number(val);
        }

        private _calcImgPosition(rayAngles) {
            var imgParams = this.imgParams,
                decartAngle = (Math.PI / 2) - (rayAngles.startAngle + rayAngles.endAngle) / 2;
            return {
                left: imgParams.imgCenterRadius * Math.cos(decartAngle) - imgParams.imgSize / 2,
                top: -(imgParams.imgCenterRadius * Math.sin(decartAngle)) - imgParams.imgSize / 2
            };
        }

        private _setImgSelection(imgIdx) {
            if (!this.d3ImgSelection) {
                this.d3ImgSelection = this.d3Group.append("circle")
                    .attr({ fill: "none", stroke: this.fanModel.image.selectionColor });
            }
            var selParams = this._calcSelectionParams(imgIdx);
            this.d3ImgSelection.attr(selParams);
            this.selectedImgIdx = imgIdx;
        }

        private _unselectImg() {
            if (this.d3ImgSelection) {
                this.d3ImgSelection.remove();
                this.d3ImgSelection = undefined;
            }
        }

        private _calcSelectionParams(imgIdx: number) {
            var imgPos = this._calcImgPosition(this.rayAngles[imgIdx]),
                imgSize = this.imgParams.imgSize,
                radius = imgSize / (2 * Math.sin(45 * Math.PI / 180)),
                imgSelectionDiameter = this.fanModel.image.selectionDiameter;
                // Если задано значение в долях
            radius = imgSelectionDiameter < 0 ? -imgSelectionDiameter * radius : imgSelectionDiameter / 2;
            return {
                "cx": imgPos.left + imgSize / 2,
                "cy": imgPos.top + imgSize / 2,
                "r": radius
            };
        }

        private _calcImgParams(outerRadius) {
            // Длина внешней хорды луча
            var rayOuterChordLength = 2 * outerRadius * Math.sin(this.rayAngle / 2),
                model = this.fanModel,
                imgOpts = model.image,
                imgSize = imgOpts.size,
                imgMaxSize = imgOpts.maxSize,
                imgRadialOffset = imgOpts.radialOffset,
                imgSelectionDiam = imgOpts.selectionDiameter;
            // Если задано значение в долях (мы это индицируем как отрицательное значение)
            if (imgSize < 0) {
                imgSize = -imgSize * rayOuterChordLength;
            }
            if (imgMaxSize != null) {
                if (imgMaxSize < 0) {    // если задано значение в долях
                    imgMaxSize = -imgMaxSize * rayOuterChordLength;
                }
                if (imgSize > imgMaxSize) {
                    imgSize = imgMaxSize;
                }
            }
            if (imgRadialOffset < 0) {      // если задано значение в долях
                imgRadialOffset = -imgRadialOffset * imgSize;
            }

<<<<<<< working copy
            //радиус окружности, описанной вокруг картинки
            var imgCircleRadius = 0.25 * imgSize / Math.sin(Math.PI / 4),
                //радиус окружности с центром в центре веера, на которой лежит центр картинки
=======
            // Радиус окружности, описанной вокруг картинки
            var imgCircleRadius = 0.5 * imgSize / Math.sin(Math.PI / 4),
                // Радиус окружности с центром в центре веера, на которой лежит центр картинки
>>>>>>> destination
                imgCenterRadius = outerRadius + imgRadialOffset + imgCircleRadius;

            var imgSelectionRadius = imgSelectionDiam < 0 ? -imgSelectionDiam * imgCircleRadius : imgSelectionDiam / 2;

            return this.imgParams = {
                imgSize: imgSize,
                imgCircleRadius: imgCircleRadius,
                imgCenterRadius: imgCenterRadius,
                imgSelectionRadius: imgSelectionRadius
            };
        }
    }
}
