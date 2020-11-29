/**
 * @description d3 그래프를 정의한 라이브러리
 * @descriptor 김용현
 * @date 2020.08.19
 */

if (!OM) var OM = {};

OM.Chart = {

	Graph : function() {
		var container = null;
		var name = 'Graph';
		var F = function(arg) {
			name = arg;
		};

		F.prototype = {
			draw : function() {},
			remove : function() {},
			redraw : function() {},
			update : function() {},
			whoami : function() {
				console.log(name);
			}
		}

		return F;
	}(),

	Util : function() {
		var F = function(arg) {
		};

		F.prototype = {}

		return F;
	}(),

	/**
	 * @description 툴팁 function 기반 클래스 
	 */
	Tooltip : function() {
		var tooltip = null;
		var options = null;

		var F = function(arg) {

			if (!d3.select('.tooltip').empty()) {
				tooltip = d3.select('.tooltip');
				return;
			}

			tooltip = d3.select('body').append("div")
			.attr("class", "tooltip")
			.style("opacity", 0)
			.html([ 
				'<div class="container">', 
					'<div class="header">',
						'<div class="title">TITLE</div>', 
					'</div>',
					'<div class="data">', 
						'<div class="block">',
							'<div class="name">name</div>',
							'<div class="value">value</div>', 
						'</div>',
					'</div>', 
				'</div>' 
				].join(''));
		};

		F.prototype = {
			draw : function() {},

			remove : function() {
				tooltip.remove();
			},

			open : function(data) {

				if (!data) return;

				var title = data.tooltip['title'] ? data.tooltip['title'] : '';
				var dataArr = data.tooltip['data'] ? data.tooltip['data'] : [];
				var color = data.tooltip['color'] ? data.tooltip['color'] : '#ff0000';
				var toolTipWidth = Number(tooltip.style("width").replace("px", "")); // tooltip 너비
				var toolTipHeight = Number(tooltip.style("height").replace("px", "")); // tooltip 높이
				var x = event.clientX - toolTipWidth / 2; // tooltip 정가운데
				var y = event.clientY - toolTipHeight - 15; // tooltip 가장자리
				
				// tooltip 위치 변경
				tooltip.style({
					left : x + "px",
					top : y + "px",
					opacity : 1
				});
				

				tooltip.select('.title').style('color', color);
				tooltip.select('.title').text(title);
				
				var html = [];
				
				dataArr.map(function(d, i) {
					html.push('<div class="block">');
					if(i > 0) html.push('<div class="seperator"></div>');
					
					var name = d['name'] ? d['name'] : '';
					var value = d['value'] ? d['value'] : '';
					var nameColor = d['color'] ? d['color'] : '#000';
					
					html.push('<div class="name" style="color:' + nameColor + ';">' + name + '</div>');
					html.push('<div class="value">' + value + '</div>');
					html.push('</div>');
				});
				
				$(tooltip.select('.data')[0]).empty();
				$(tooltip.select('.data')[0]).append(html.join(''));
			},

			close : function() {
				tooltip.style({
					opacity : 0,
					top : '100%',
					left : 0
				})
			},

			get : function() {
				return tooltip;
			},

			set : function(arg) {
				// tooptip = arg;
			}
		};

		return F;
	}(),


	drawLegend : function(container, options) {

		if (container.empty())
			return;

		if (!options)
			return;

		// 범례 생성
		var LEGEND_BOX_SIZE = 50;
		var LEGEND_PADDING = 20;
		var type = options['type'] ? options['type'] : 'text';
		var tooltip = {};
		var svg = container.select('svg');
		var INNER_WIDTH = Number(svg.attr('inner-width'));
		var INNER_HEIGHT = Number(svg.attr('inner-height'));
		var legend = svg.select('.svg-container').append("g").attr("class",
				"legend").attr("transform", 'translate(0,0)');

		tooltip = new this.Tooltip(container);

		if (type === 'image') {
			drawLegendImage();
		} else {
			drawLegendText();
		}

		// 범례 이미지 생성
		function drawLegendImage() {

			legend.selectAll("image").data(options['data']).enter().append(
					"svg:image").attr('class', 'rect').attr(
					"transform",
					function(d, i) {

						var startPosition = (INNER_WIDTH / 2);

						if (i === 0) {
							startPosition = startPosition
									- (LEGEND_BOX_SIZE + LEGEND_PADDING);
						} else {
							startPosition = startPosition + LEGEND_PADDING;
						}

						return 'translate(' + startPosition + ','
								+ (INNER_HEIGHT + 30) + ")";
					}).attr("width", LEGEND_BOX_SIZE).attr("height",
					LEGEND_BOX_SIZE).attr('xlink:href', function(d) {
				return d['icon'];
			}).on('mousemove', tooltip.open).on('mouseout', tooltip.close);
		}

		// 범례 텍스트 생성
		function drawLegendText() {
			var legendGroup = legend
					.selectAll(".rect")
					.data(options['data'])
					.enter()
					.append('g')
					.attr('class', 'rect')
					.on('mousemove', tooltip.open)
					.on('mouseout', tooltip.close)
					.attr(
							"transform",
							function(d, i) {

								var startPosition = (INNER_WIDTH / 2);

								if (i === 0) {
									startPosition = startPosition
											- (LEGEND_BOX_SIZE + LEGEND_PADDING);
								} else {
									startPosition = startPosition
											+ LEGEND_PADDING;
								}

								return 'translate(' + startPosition + ','
										+ (INNER_HEIGHT + 30) + ")";
							});

			legendGroup.append("rect").attr("width", LEGEND_BOX_SIZE).attr(
					"height", LEGEND_BOX_SIZE).style('fill', function(d) {
				return d['color'];
			})

			legendGroup[0].map(function(group, i) {

				var texts = options.data[i]['text'];

				if (!texts || texts.length === 0)
					return;

				var legendText = d3.select(group).append('text').attr("x", 0)
						.attr("y", 0);

				texts.split(' ').map(
						function(text) {
							legendText.append('tspan').text(text).attr('x',
									LEGEND_BOX_SIZE / 2).attr('text-anchor',
									'middle').attr("dy",
									LEGEND_BOX_SIZE / 2 - 5);
						})
			})
		}
	},

	/**
	 * @description Default 설정값 가져옴
	 */
	getConfig : function(custom) {

		var config = {
			title : 'Graph',
			ticks : 4,
			margin : {
				top : 30,
				right : 20,
				bottom : 30,
				left : 100
			},
			colors : [ "#2e6695", "#ff8166", "#828282", "#d3d3d3" ],
			xAxis : {
				"rotate" : 0,
				"textAnchor" : "middle"
			},
			background : '#fff',
			barWidth: 27
		};

		if (custom)
			config = $.extend(config, custom, {});

		return config;
	},

	/**
	 * @description d3인스턴스 넓이, 높이 가져옴
	 */
	getSize : function(container) {

		if (container.empty())
			return;

		return [ Number(container.style('WIDTH').replace("px", "")),
				Number(container.style('HEIGHT').replace("px", "")) ]
	},

	/**
	 * @description grouped-bar
	 * @param options
	 * @param data
	 * @returns
	 */
	groupedBarV1 : function(data, options) {

		if (!Array.isArray(data)) return;
		if (data.length === 0) return;

		var domId = options['domId'];
		var chartId = options['chartId'];
		var config = this.getConfig(options);
		var container = d3.select('#' + domId).select('.' + chartId);

		if (container.empty()) return;

		container.html("");

		var MARGIN = config['margin'];
		var WIDTH = this.getSize(container)[0];
		var HEIGHT = this.getSize(container)[1];
		var INNER_WIDTH = WIDTH - MARGIN.left - MARGIN.right;
		var INNER_HEIGHT = HEIGHT - MARGIN.top - MARGIN.bottom;
		var color = d3.scale.ordinal().range(config['colors']);
		var BAR_WIDTH = config['barWidth'] ? config['barWidth'] : 25;

		// data를 group 값을 기준으로 그룹 지정
		var nested = null;
		nested = d3.nest().key(function(d) {
			return d.group
		}).entries(data);

		// 그룹명(json 데이터에서 group 값)만 추출
		var group_name = nested.map(function(d) {
			return d.key
		});

		// data를 column 값을 기준으로 그룹 지정
		nested = d3.nest().key(function(d) {
			return d.column
		}).entries(data);

		// 그룹내 column명만 추출
		var group_bar = nested.map(function(d) {
			return d.key
		});

		// 각 그룹의 위치를 결정하는 scale 함수
		// 그룹 수에 맞게 막대 그룹 개수 설정
		// rangeRoundBands([interval], padding)의 형태로 사용
		// padding의 값은 0과 1 사이의 값이 들어가는데 0.5일 때 막대의 너비와 막대 사이의 간격이 같음
		var x_scale_group = d3.scale.ordinal().domain(group_name)
				.rangeRoundBands([ 0, INNER_WIDTH ]);

		// 그룹 내에서 막대의 위치를 결정하는 scale 함수
		var x_scale_bar = d3.scale.ordinal()
		.domain(group_bar)
		.rangeRoundBands([ 0, x_scale_group.rangeBand()]);

		// 막대의 높이를 결정하는 scale 함수
		// y축의 값이 위에는 높은값, 아래에는 0이 있어야 한다. 그렇기 때문에 range에 들어가는 배열에서 값의 순서가
		// 변경
		var y_scale = d3.scale.linear().domain([ 0, d3.max(data, function(d) {
			return d.value;
		}) ]).range([ INNER_HEIGHT, 0 ])

		// x축을 생성
		var xAxis = d3.svg.axis().scale(x_scale_group).orient("bottom")
				.outerTickSize(1).innerTickSize(-INNER_HEIGHT).tickPadding(10);

		// y축을 생성
		// 막대 뒤에 선을 표시하기 위해서 innerTickSize에 -chart_size.width 값을 부여
		// 원래는 y축 눈금을 만드는 함수인데 -값을 주면 반대방향(차트 안쪽)으로 눈금이 길어짐
		var yAxis = d3.svg.axis().scale(y_scale).orient("left")
				.outerTickSize(0).innerTickSize(-INNER_WIDTH).tickPadding(10)
				.tickFormat(config['tickFormat']).ticks(options['ticks'])

		// tooltips
		var tooltip = new this.Tooltip(container);

		var svg = container.append("svg")
		.attr('class', 'groupedBarV1')
		.attr("width", WIDTH)
		.attr("height", HEIGHT)
		.attr("inner-width", INNER_WIDTH)
		.attr("inner-height", INNER_HEIGHT)
		.append("g")
		.attr('class', 'svg-container')
		.attr("transform", "translate(" + MARGIN['left'] + "," + MARGIN['top'] + ")");

		// TITLE 생성
		svg.append("text")
		.attr('class', 'title')
		.attr("x", (INNER_WIDTH / 2))
		.attr("y", 0 - (MARGIN.top / 2))
		.attr("text-anchor", "middle")
		.text(config['title']);

		// x축 생성
		// 그냥 만들면 (0,0) 위치 (화면 좌측 상단)에 생기기 때문에 margin.left 만큼 x축을 이동시키고 차트의
		// 높이만큼 아래로 이동
		svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + INNER_HEIGHT + ")")
		.call(xAxis)
		.selectAll("text")
		.style("text-anchor", config.xAxis.textAnchor)
		.attr("transform", "rotate(" + config.xAxis.rotate + ")");

		// y축을 생성
		// margin.left만큼 우측으로 평행이동
		svg.append("g").attr("class", "y axis").call(yAxis);

		// 막대를 생성하기 위해서 data를 연결
		var bars = svg.append("g").selectAll(".bar").data(data);

		// 새로 생성되는 부분(enter)에 대한 코드
		// 막대의 x축 위치는 x_scale_group으로 생성되는 그룹 위치와 x_scale_bar로 생성되는 막대 위치를
		// 더하고 margin.left를 더함
		// 막대의 y축 위치(막대가 시작되는 좌표)는 일반 막대그래프와 마찬가지로 value값을 y_scale로 변형
		// width의 값은 x_scale_bar.rangeBand()값을 사용
		// 막대의 높이는 y_scale(d.value)부터 시작해서 y축의 0 위치까지 와야 함
		// 따라서 막대가 시작되는 지점의 y좌표와 막대의 길이를 더하면 차트의 높이
		// y의 값이 y_scale(d.value) 이니까 height값은 chart_size.height -
		// y_scale(d.value)
		bars.enter()
		.append("rect")
		.attr('class', 'bar')
		.attr("x", function(d, i) {
			if(i % 2 === 0) return x_scale_group(d.group) + x_scale_bar.rangeBand() - BAR_WIDTH;
			else return x_scale_group(d.group) + x_scale_bar(d.column);
		})
		.attr("y", function(d) {
			return y_scale(d.value);
		})
		.attr("width", BAR_WIDTH)
		.attr("height", function(d) {
			return INNER_HEIGHT - y_scale(d.value);
		})
		.style("fill", function(d) {
			return color(d.column);
		})
		.on('mousemove', tooltip.open)
		.on('mouseout', tooltip.close);

		OM.Chart.drawLegend(container, config['legend']);
	},

	/**
	 * group bar chart
	 * 
	 * @param chartData
	 *            표현할 data
	 * @param id
	 *            그래프 그릴 div 의 id
	 * @param attributes[]
	 *            group별 색상 맵핑 배열
	 * @param timeArr[]
	 *            x축의 값
	 * @param label{}
	 *            x축, y축의 제목
	 * @param bColor
	 *            background color
	 */
	groupedBarV2 : function(data, options) {

		if (!Array.isArray(data))
			return;
		if (data.length === 0)
			return;

		var domId = options['domId'];
		var chartId = options['chartId'];
		var config = this.getConfig(options);
		var container = d3.select('#' + domId).select('.' + chartId);

		if (container.empty())
			return;

		var background = config['background'];
		var color = d3.scale.ordinal().range(config['colors']);
		var title = config['title'];
		// data를 column 값을 기준으로 그룹 지정
		var nested = d3.nest().key(function(d) {
			return d.column
		}).entries(data);

		// 그룹내 column명만 추출
		// #ff8166, #d3d3d3
		var attributes = nested.map(function(d, i) {
			return {
				column : d.key,
				hex : color(i)
			}
		});

		var visualization = d3plus.viz().container(container).data(data)
				.background('transparent')
				.height({
					"small" : 100
				})
				.type("bar")
				.id("column")
				.x({
					"value" : "group",
					"label" : false
				})
				.y({
					"value" : "value",
					"label" : false
				})
				.attrs(attributes)
				.format({
					"number" : function(number, params) {
						return number.toFixed(1) + "%";
					}
				})
				.font({
					"size" : 12
				})
				.labels({
					"font" : {
						"size" : 12
					}
				})
				.order({
					"value" : "group",
					"sort" : "asc"
				})
				.color("hex")
				.legend({
					"size" : 50,
					"order" : {
						"sort" : "desc"
					}
				})
				.title(title)
				.svgTitle(['abcdcd']) 
				.draw();
	},

	/**
	 * @description grouped-bar with line
	 * @param options
	 * @param data
	 * @returns
	 */
	groupedBarLine : function() {
		return {
			svg : null,
			bar_data : null,
			line_data : null,
			x_scale_group : null,
			x_scale_bar : null,
			y_scale : null,
			select : null,
			config : null,
			HEIGHT : null,
			INNER_HEIGHT : null,
			container : null,

			update : function(selectValue) {

				var that = this;
				var x_scale_group = that.x_scale_group;
				var x_scale_bar = that.x_scale_bar;
				var y_scale = that.y_scale;
				var svg = that.svg;
				var MARGIN = that.config['margin'];
				var HEIGHT = that.HEIGHT
				var INNER_HEIGHT = that.INNER_HEIGHT;
				var container = that.container;
				var tooltip = new OM.Chart.Tooltip(container);

				if (container.empty()) return;

				container.select('.selected').remove();

				var selectArr1 = that.line_data.filter(function(item) {
					return item['group'] === selectValue;
				});
				var selectArr2 = that.bar_data.filter(function(item) {
					return item['group'] === selectValue;
				});
				
				if(selectArr1.length === 0 && selectArr2.length === 0) return;

				var tooltipObj = {
					title: '',
					color: null,
					data: [{
						name: selectArr1[0].tooltip['title'],
						value: selectArr1[0].tooltip.data[0]['value'],
						color: selectArr1[0].tooltip.data[0]['color']
					}]
				};
				
				selectArr2.map(function(d) {
					tooltipObj.data.push({
						name: d.tooltip['title'],
						value: d.tooltip.data[0]['value'],
						color: d.tooltip['color']
					})
				});
				
				var tempObj = [$.extend({}, selectArr1[0], {tooltip: tooltipObj})];
				var select = svg.append("g").attr('class', 'selected').selectAll(".selected").data(tempObj);

				select.enter()
				.append("rect")
				.attr('class', 'box')
				.attr("x", function(d) { return x_scale_group(d['group']); })
				.attr("y", 0)
				.attr("width", x_scale_bar.rangeBand() * 2)
				.attr("height", function(d) { return INNER_HEIGHT; })
				.on('mousemove', tooltip.open)
				.on('mouseout', tooltip.close);

				select.enter().append("circle").attr('class', 'dot').attr("r",
						3).attr(
						"cx",
						function(d) {
							return x_scale_group(d.group)
									+ x_scale_group.rangeBand() / 2;
						}).attr("cy", function(d) {
					return y_scale(d.value);
				});
			},

			remove : function() {
				this.svg.remove();
			},

			draw : function(data, options) {

				var domId = options['domId'];
				var chartId = options['chartId'];
				var config = OM.Chart.getConfig(options);
				var container = d3.select('#' + domId).select('.' + chartId);

				if (container.empty())
					return;

				container.html("");

				var MARGIN = config['margin'];
				var WIDTH = OM.Chart.getSize(container)[0];
				var HEIGHT = OM.Chart.getSize(container)[1];
				var INNER_WIDTH = WIDTH - MARGIN.left - MARGIN.right;
				var INNER_HEIGHT = HEIGHT - MARGIN.top - MARGIN.bottom;
				var color = d3.scale.ordinal().range(config['colors']);
				var selectValue = config['selectValue'];
				var bar_data = data['bar_data'];
				var line_data = data['line_data'];
				var BAR_WIDTH = config['barWidth'] ? config['barWidth'] : 27;

				if (!bar_data || bar_data.length === 0) return;
				if (!line_data || line_data.length === 0) return;

				// data를 group 값을 기준으로 그룹 지정
				// 그룹명(json 데이터에서 group 값)만 추출
				var nested = null;
				nested = d3.nest().key(function(d) {
					return d.group
				}).entries(bar_data);
				var group_name = nested.map(function(d) {
					return d.key
				});

				// data를 column 값을 기준으로 그룹 지정
				// 그룹내 column명만 추출
				nested = d3.nest().key(function(d) {
					return d.column
				}).entries(bar_data);
				var group_bar = nested.map(function(d) {
					return d.key
				});

				nested = d3.nest().key(function(d) {
					return d.group
				}).entries(line_data);
				var group_line = nested.map(function(d) {
					return d.key
				});

				// 각 그룹의 위치를 결정하는 scale 함수
				// 그룹 수에 맞게 막대 그룹 개수 설정
				// rangeRoundBands([interval], padding)의 형태로 사용
				// padding의 값은 0과 1 사이의 값이 들어가는데 0.5일 때 막대의 너비와 막대 사이의 간격이
				// 같음
				var x_scale_group = d3.scale.ordinal().domain(group_name)
						.rangeRoundBands([ 0, INNER_WIDTH ], 0.1);

				// 그룹 내에서 막대의 위치를 결정하는 scale 함수
				var x_scale_bar = d3.scale.ordinal().domain(group_bar)
						.rangeRoundBands([ 0, x_scale_group.rangeBand() ]);

				// 막대의 높이를 결정하는 scale 함수
				// y축의 값이 위에는 높은값, 아래에는 0이 있어야 한다. 그렇기 때문에 range에 들어가는 배열에서
				// 값의 순서가 변경
				var y_scale = d3.scale.linear().range([ INNER_HEIGHT, 0 ])

				// x축을 생성
				var xAxis = d3.svg.axis().scale(x_scale_group)
				.orient("bottom")
				.outerTickSize(1)
				.innerTickSize(-INNER_HEIGHT)
				.tickPadding(10)
				.tickFormat(config['xFormat']);

				// y축을 생성
				// 막대 뒤에 선을 표시하기 위해서 innerTickSize에 -chart_size.width 값을 부여
				// 원래는 y축 눈금을 만드는 함수인데 -값을 주면 반대방향(차트 안쪽)으로 눈금이 길어짐
				var yAxis = d3.svg.axis().scale(y_scale)
				.orient("left")
				.outerTickSize(0)
				.innerTickSize(-INNER_WIDTH)
				.tickPadding(10)
				.tickFormat(config['yFormat'])
				.ticks(options['ticks'])

				// tooltips
				var tooltip = new OM.Chart.Tooltip(container);

				var y_max = d3.max(line_data, function(d) {
					return d.value;
				});
				y_scale.domain([ 0, y_max + y_max / 10 ])

				var svg = container.append("svg").attr('class',
						'groupedBarLine').attr("width", WIDTH).attr("height",
						HEIGHT).attr("inner-width", INNER_WIDTH).attr(
						"inner-height", INNER_HEIGHT).append("g").attr('class',
						'svg-container').attr(
						"transform",
						"translate(" + MARGIN['left'] + "," + MARGIN['top']
								+ ")");

				// TITLE 생성
				// svg.append("text")
				// .attr("x", (INNER_WIDTH / 2))
				// .attr("y", 0 - (MARGIN.top / 2))
				// .attr("text-anchor", "middle")
				// .style("font-size", "16px")
				// .text(config['title']);

				// x축 생성
				// 그냥 만들면 (0,0) 위치 (화면 좌측 상단)에 생기기 때문에 margin.left 만큼 x축을
				// 이동시키고 차트의 높이만큼 아래로 이동
				svg.append("g").attr("class", "x axis").attr("transform",
						"translate(0," + INNER_HEIGHT + ")").call(xAxis)
						.selectAll("text").style("text-anchor",
								config.xAxis.textAnchor).attr("transform",
								"rotate(" + config.xAxis.rotate + ")");

				// y축을 생성
				// margin.left만큼 우측으로 평행이동
				svg.append("g").attr("class", "y axis").call(yAxis);

				
				// 막대 그래프
				// 막대를 생성하기 위해서 data를 연결
				x_scale_group.domain(group_name);
				var bars = svg.append("g").selectAll(".bar").data(bar_data);

				// 새로 생성되는 부분(enter)에 대한 코드
				// 막대의 x축 위치는 x_scale_group으로 생성되는 그룹 위치와 x_scale_bar로 생성되는
				// 막대 위치를 더하고 margin.left를 더함
				// 막대의 y축 위치(막대가 시작되는 좌표)는 일반 막대그래프와 마찬가지로 value값을 y_scale로
				// 변형
				// width의 값은 x_scale_bar.rangeBand()값을 사용
				// 막대의 높이는 y_scale(d.value)부터 시작해서 y축의 0 위치까지 와야 함
				// 따라서 막대가 시작되는 지점의 y좌표와 막대의 길이를 더하면 차트의 높이
				// y의 값이 y_scale(d.value) 이니까 height값은 chart_size.height -
				// y_scale(d.value)
				bars.enter().append("rect")
				.attr('class', 'bar')
				.attr("x", function(d, i) {
					if(i % 2 === 0) return x_scale_group(d.group) + x_scale_bar.rangeBand() - BAR_WIDTH;
					else return x_scale_group(d.group) + x_scale_bar(d.column);
				})
				.attr("y", function(d) {
					return y_scale(d.value);
				})
				.attr("width", BAR_WIDTH)
				.attr("height", function(d) {
							return INNER_HEIGHT - y_scale(d.value);
				})
				.style("fill", function(d) {
					return color(d.column);
				})
				.on('mousemove', tooltip.open)
				.on('mouseout', tooltip.close);
				
				
				
				// 라인 그래프
				var d3line = d3.svg.line().interpolate('linear').x(
						function(d) {
							return x_scale_group(d.group)
									+ x_scale_group.rangeBand() / 2;
						}).y(function(d) {
					return y_scale(d.value);
				});

				svg.append("path") // Add the valueline2 path.
				.attr('class', 'line')
				.attr("d", d3line(line_data));

				// 점 그래프
				svg.selectAll("dot")
				.data(line_data)
				.enter()
				.append("circle")
				.attr('class', 'dot real')
				.attr("r", 3)
				.attr("cx", function(d) {
					return x_scale_group(d.group) + x_scale_group.rangeBand() / 2;
				})
				.attr("cy", function(d) {
					return y_scale(d.value);
				});
				
				svg.selectAll("dot")
				.data(line_data)
				.enter()
				.append("circle")
				.attr('class', 'dot fake')
				.attr("r", 6)
				.attr("cx", function(d) {
					return x_scale_group(d.group) + x_scale_group.rangeBand() / 2;
				})
				.attr("cy", function(d) {
					return y_scale(d.value);
				})
				.on('mouseover', function(d) {
					var fakeLeft = this.getClientRects()[0]['left'];
					var fakeTop = this.getClientRects()[0]['top'];
					var fakeRadius = 6;
					var tooltipDOM = tooltip.get()[0][0];
					var tooltipWidth = tooltipDOM['clientWidth']; 
					var tooltipHeight = tooltipDOM['clientHeight'];
					
					tooltip.open(d);
					tooltipDOM.style.cssText = [
						'left:' + (fakeLeft + fakeRadius - tooltipWidth / 2) + "px;",
						'top:' + (fakeTop - fakeRadius - tooltipHeight) + "px;"
					].join('');
				})
				.on('mouseout', tooltip.close);

				this.bar_data = bar_data;
				this.line_data = line_data;
				this.x_scale_group = x_scale_group;
				this.x_scale_bar = x_scale_bar;
				this.y_scale = y_scale;
				this.svg = svg;
				this.config = config;
				this.MARGIN = MARGIN;
				this.HEIGHT = HEIGHT;
				this.INNER_HEIGHT = INNER_HEIGHT;
				this.container = container;

				

				OM.Chart.drawLegend(container, config['legend']);
				
				this.update(selectValue);
			}
		}
	},

	treemap : function(data, options) {

		if (!Array.isArray(data))
			return;
		if (data.length === 0)
			return;

		var domId = options['domId'];
		var chartId = options['chartId'];
		var config = this.getConfig(options);
		var container = d3.select('#' + domId).select('.' + chartId);

		if (container.empty())
			return;

		container.html("");

		var background = config['background'];
		var color = d3.scale.ordinal().range(config['colors']);

		var visualization = d3plus.viz()
		.container(container)
		.data(data)
		.type("tree_map")
		.height({ "small" : 100 })
		.background(background)
		.color(
				{
					"scale" : [ '#2e6695', '#72f5c4', '#17c0c0', '#ff8166',
							'#ffd3a6', '#777' ],
					"value" : "color"
				}).id({
			"value" : [ "code", "name" ],
			"grouping" : true
		}).format(
				{
					"number" : function(number, params) {
						if (params.key == 'value') {
							var tCnt = Math.floor(1e-12 + Math.log(number)
									/ Math.LN10);
							return OM.Comm.numToKR(number).join('') + "원";
						} else if (params.key == 'share') {
							return number.toFixed(1) + "%";
						}
					}
				}).depth(1).size("value").labels({
			"align" : "left",
			"valign" : "top"
		}).legend({
			"size" : 50,
			"order" : {
				"sort" : "desc",
				"value" : "size"
			}
		}).tooltip({
			"stacked" : false
		}).draw();
	},

	/**
	 * 수평 바 chart
	 * 
	 * @param chartData
	 *            표현할 data
	 * @param id
	 *            그래프 그릴 div 의 id
	 * @param label{}
	 *            x축, y축의 제목
	 * @param ticks
	 * @param bColor
	 *            background color
	 * @param unit{}
	 *            단위
	 */
	horizontalBar : function(data, options) {

		if (!Array.isArray(data))
			return;
		if (data.length === 0)
			return;

		var domId = options['domId'];
		var chartId = options['chartId'];
		var config = this.getConfig(options);
		var container = d3.select('#' + domId).select('.' + chartId);

		if (container.empty())
			return;

		container.html("");

		var background = config['background'];
		var color = d3.scale.ordinal().range(config['colors']);
		var label = config['label'];
		var format = config['format'];

		var visualization = d3plus.viz().container(container).data(data)
				.height({
					"small" : 100
				})
				.type("bar")
				.id("name")
				.margin( "0 0 0 20" )
				.background(background)
				.x({
					"value" : "value",
					"label" : label.x
				})
				.y({
					"scale" : "discrete",
					"value" : "name",
					"grid" : false,
					"label" : false
				})
				.format({
					"number" : function(number, params) { return format(number); }
				})
				.order({
					"value" : "value",
					"sort" : "asc"
				})
				.color("hex").draw();
	},

	multiLine : function(data, options) {

		if (!Array.isArray(data))
			return;
		if (data.length === 0)
			return;

		var domId = options['domId'];
		var chartId = options['chartId'];
		var config = this.getConfig(options);
		var container = d3.select('#' + domId).select('.' + chartId);

		if (container.empty()) return;

		container.html("");

		var background = config['background'];
		var color = d3.scale.ordinal().range(config['colors']);
		var label = config['label'];
		var attributes = config['attributes'];
		
		var visualization = d3plus.viz().container(container).data(data)
				.height({
					"small" : 100
				})
				.background(background)
				.type("line")
				.id("name")
				.margin( "0 0 0 0" )
				.y({
					"value" : "value",
					"label" : false
				})
				.size(2)
				.x({
					"value" : "date",
					"label" : label.x
				})
				.format({
					"number" : function(number, params) {
						return OM.Comm.numToKR(number).join('');
					}
				})
				.font({
					"size" : 12
				})
				.labels({
					"font" : {
						"size" : 12
					}
				})
				.legend({
					"size" : 50,
					"data" : false,
					"order" : {
						"value" : "color",
						"sort" : "asc"
					}
				})
				.attrs(attributes)
				.color("hex")
				.order({
					"value" : "order",
					"sort" : "asc"
				})
				.draw();
	}
}

OM.Chart.Timeseries = function() {
	var F = OM.Comm.deepCloneObj(OM.Chart.Graph);
	var name = 'Timeseries';
	var options = {
			domId: null, 
			lineData: [],
			margin: {}, 
			tLength: 0, 
			xFormat: null, 
			yFormat: null, 
			defaultVal: null, 
			timeHandler: null, 
			startDate: null, 
			endDate: null, 
			title: [], 
			standards: {}
	}
	var startSlider = null;
	var endSlider = null;
	var x = null;
	
	var F = function(arg) {
		options = arg;
	};
	
	
	F.prototype['draw'] = function() {
		var $container = $(options['domId']);
		
		$container.html("");
		
		var cwidth = $container.width();
		var cheight = $container.height();
		var width = cwidth - options.margin.left - options.margin.right;
		var height = cheight - options.margin.top - options.margin.bottom;
		var yScaleType1 = d3.scale.linear().range([height, 0]);
		var yScaleType2 = d3.scale.linear().range([height, 0]);
		
		x = d3.time.scale().range([0, width]);
		
		//  전체 시작일과 종료일이 없을 경우
		if(!options['startDate']){
			options['startDate'] = new Date();
		}
		
		if(!options['endDate']){
			options['endDate'] = options['startDate'].addDays(3);
		}
		
		// x값  전체 범위 설정
		x.domain([ options['startDate'] , options['endDate']  ] ) ;
		
		// x축 기준 설정
		var xAxis = d3.svg.axis()
					      .scale(x)
					      .ticks(options['tLength'] )
					      .tickSize(-height);
		// x축 라벨 형식 변경 
		if(options['xFormat']) xAxis.tickFormat(options['xFormat']);
		
		// 좌측 y축 tick 자동설정 후 배열 가져오는 함수
		function getLeftAxisTicks() {
			// y축 최솟값
			var yMinValue = d3.min(options.lineData[0], function(d) { return d['value']; });
			
			// y축 최댓값
			var yMaxValue = d3.max(options.lineData[0], function(d) { return d['value']; });
			
			var yIncreaseValue = (yMaxValue / 4); 
			
			// 백의 자리 이하일 경우
			if(("" + parseInt(yIncreaseValue)).length < 4 ) {
				yIncreaseValue = parseInt(yIncreaseValue);
			// 천의 자리 이상일 경우
			} else {
				yIncreaseValue = Math.round(yIncreaseValue / 1000) * 1000;
			}
			
			yScaleType1.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
			
			var tickValues = [ 0, yIncreaseValue * 1, yIncreaseValue * 2, yIncreaseValue * 3];
			
			/*
			console.log(`
					min~max: ${yMinValue} ~ ${yMaxValue}
					increaseValue: ${yIncreaseValue}
					tickValues: ${tickValues}
			`)
			*/
			
			return tickValues;
			
		}
		
		// 우측 y축 tick 자동설정 후 배열 가져오는 함수
		function getRightAxisTicks() {
			
			// y축 최솟값
			var yMinValue = d3.min(options.lineData[1], function(d) { return d['value']; });
			
			// y축 최댓값
			var yMaxValue = d3.max(options.lineData[1], function(d) { return d['value']; });
			
			var TICK_MIN_WEIGHT = 1;  // tick 최솟값 가중치
			var TICK_MAX_WEIGHT = 1;  // tick 최댓값 가중치
			
			// tick 구간 최솟값(내림)
			var floorMin = Math.floor(
				yMinValue * TICK_MIN_WEIGHT / Math.pow(10, ("" + yMinValue).length - 2)
			) * Math.pow(10, ("" + yMinValue).length - 2);
			
			// tick 구간 최댓값(올림)
//			var ceilMax2 = Math.ceil(
//				yMaxValue / Math.pow(10, ("" + yMaxValue).length - 2)
//			) * Math.pow(10, ("" + yMaxValue).length - 2);
			
			// tick 구간 최댓값(내림)
			var floorMax = Math.floor(
					yMaxValue * TICK_MAX_WEIGHT / Math.pow(10, ("" + yMaxValue).length - 2)
			) * Math.pow(10, ("" + yMaxValue).length - 2);
			
			var section = 3;  // tick 구간범위 수 
			var diff = floorMax - floorMin; // tick 구간별 차이값
			
			// tick 구간 증가값
			var yIncreaseValue = Math.ceil(
					parseInt(diff / section) / 
					Math.pow(10, ("" + parseInt(diff/section)).length - 2)) * 
					Math.pow(10, ("" + parseInt(diff/section)).length - 2);
			
			
//			yScaleType2.domain([0, yMaxValue + (yMaxValue / 8 )]).nice();
//			yScaleType2.domain([0, yMaxValue + (yIncreaseValue / 2)]).nice();
//			yScaleType2.domain([0, floorMax + (yIncreaseValue / yIncreaseValue)]);
//			yScaleType2.domain([0, yMaxValue + (yIncreaseValue * 2)]).clamp(true);
//			yScaleType2.domain([0, yMaxValue + (yIncreaseValue * 2)]);
//			yScaleType2.domain([0, yMaxValue]).nice();
//			yScaleType2.domain([0, floorMax + (yIncreaseValue * 2)]);
			
//			yScaleType2.domain([yMinValue, yMaxValue + (yMaxValue / 8 )]).nice();
//			yScaleType2.domain([yMinValue, yMaxValue + (yIncreaseValue / 2)]).nice();
//			yScaleType2.domain([floorMin, yMaxValue + (yMaxValue / 8)]).nice();
//			yScaleType2.domain([floorMin, floorMax + (yIncreaseValue / yIncreaseValue)]);
//			yScaleType2.domain([yMinValue, yMaxValue + (yIncreaseValue * 2)]).clamp(true);
//			yScaleType2.domain([yMinValue, yMaxValue + (yIncreaseValue * 2)]);
//			yScaleType2.domain([yMinValue, yMaxValue]).nice();
			yScaleType2.domain([floorMin, floorMax + (yIncreaseValue * 2)]);
//			yScaleType2.domain([floorMin, floorMax]);
			
			
//			var tickValues = [
//				0,
//				floorMin,
//				floorMin + yIncreaseValue * 1,
//				floorMin + yIncreaseValue * 2
//			];
			var tickValues = [
				floorMin, 
				floorMin + yIncreaseValue * 1, 
				floorMin + yIncreaseValue * 2, 
				floorMin + yIncreaseValue * 3
			] 
//			
			/*
			console.log(`
					min~max: ${yMinValue} ~ ${yMaxValue}
					min~max(tick): ${floorMin} ~ ${floorMax}
					diff: ${diff}
					increaseValue: ${yIncreaseValue}
					tickValues: ${tickValues}
			`)
			*/
			
			return tickValues;
		}

		// y축 기준 설정 
		var yAxis1 = d3.svg.axis()
		    .scale(yScaleType1)
		    .orient("left")
			.innerTickSize([-(width)])
		    .outerTickSize(0)
		    .tickValues(getLeftAxisTicks())
		    .tickFormat(options['yFormat'])
		    .tickPadding(10);
		
		// y축 기준 설정
		var yAxis2 = d3.svg.axis()
			.scale(yScaleType2)
			.orient("right")
			.innerTickSize([width])
			.outerTickSize(0)
			.tickValues(getRightAxisTicks())
			.tickFormat(options['yFormat'])
			.tickPadding(10);
			
		// 그래프 제목 설정
		
		options['title'].map(function(t, index) {
			var tempT = d3.select(options['domId'])
			.append("text")
			.attr('class', ['title', index === 0 ? 'left' : 'right'].join(' '))
			.text(t)
//			.style("position","absolute")
//			.style("font-size","7px")
//			.style("top","7px");
		});
					   
		// 영역 그래프 설정
		var area = d3.svg.area()
					     .interpolate("monotone")
					     .x(function(d) { return x(d.date); })
					     .y0(height)
					     .y1(function(d) { return yScaleType1(d['value']); });

		// 라인 그래프 설정
		var line1 = d3.svg.line()
					     .interpolate("monotone")
					     .x(function(d) { return x(d.date); })
					     .y(function(d) { return yScaleType1(d['value']); });
		
		// 라인 그래프 설정
		var line2 = d3.svg.line()
							.interpolate("monotone")
							.x(function(d) { return x(d.date); })
							.y(function(d) { return yScaleType2(d['value']);} );

		// 그래프 그리기 시작(그래프 영역 설정)
		var svg = d3.select(options['domId']).append("svg")
							      .attr("width", width + options.margin.left + options.margin.right)
							      .attr("height", height + options.margin.top + options.margin.bottom)
							      .append("g")
							      .attr("transform", "translate(" + options.margin.left + "," + options.margin.top + ")");

		// 실제 화면에 보여질 영역 자르기 (id='clip')
		svg.append("clipPath")
		   .attr("id", "clip")
		   .append("rect")
		   .attr("width", width)
		   .attr("height", height);

		// 실제 시계열 그래프 데이터 바인딩
		svg.datum(options.lineData[0]);
		
		// 아이디 'clip' 영역안에  영역 차트 추가
		svg.append("path")
		   .attr("class", "area")
		   .attr("clip-path", "url(#clip)")
		   .attr("d", area);

		// X축 추가
		var xGr = svg.append("g")
					 .attr("class", "x axis")
	      			 .attr("transform", "translate(0," + height + ")")
//		      		 .attr("transform", "rotate(-90)")
	      			 .call(xAxis);

		xGr.selectAll("text")
		   .attr("dy", ".99em")
		   .style("font-size", "12px");
		
		
		// x축을 덮는 기간 선택 박스가 실제 보여질 영역 자르기 (주황색 선택박스 영역, id='clip2') 
		svg.append("clipPath")
		   .attr("id", "clip2")
		   .append("rect")
		   .attr("class", 'fillRect')
		   .attr("width",200)
		   .attr("x", 100)
		   .attr("y", 0)
		   .attr("height", height+21);
		  
		// x축을 덮는 기간 선택 박스를 아이디 'clip2'영역안에 추가
		svg.append("rect")
		   .attr("class", 'fillRect')
		   .attr("width",0)
		   .attr("x", 0)
		   .attr("y", height)
		   .attr("height", 20)
		   .attr("fill", "#F7941D");

		// 아이디 'clip2'영역안에 새로운 x축 추가
		var xGrWhite = svg.append("g")
						  .attr("class", "x axis")
						  .attr("clip-path", function(d,i) { return "url(#clip2)"; })
						  .attr("transform", "translate(0," + height + ")")
						  .call(xAxis); 
			 
		// 새로운 x축 안에 text 추가	 
		xGrWhite.selectAll("text")
				.attr("dy", ".99em")
				.style("font-size", "12px")
				.attr("fill", "#ffffff");
		  
		// y축 추가  	 
		svg.append("g")
		   .attr("class", "y axis left")
		   .attr("transform", "translate(0,0)")
		   .call(yAxis1);
		
		svg.append("g")
		.attr("class", "y axis right")
		.attr("transform", "translate(0,0)")
		.call(yAxis2);

		// 그리드 스타일 변경 (y축에 대한 그리드 "-----")
		svg.selectAll(".y .tick:not(:first-of-type) line")
		   .attr("stroke", "#777")
		   .attr("stroke-dasharray", "2,2");
		  
		// 라인 그래프 추가
		var linePath = svg.append("path")
						  .attr("class", "line type1")
						  .attr("d", line1);
		
		
		// 실제 시계열 그래프 데이터 바인딩
		svg.datum(options.lineData[1]);
		
		svg.append("path")
		.attr("class", "line type2")
		.attr("d", line2);
		  
		  
		// 슬라이더 손잡이 (startSlider: 왼쪽, endSlider: 오른쪽)
		startSlider = sliderBuilder(x,yScaleType1,options.lineData[0], svg,options['domId'].substr(1),"startSlider",width,moveEndHandler);
		endSlider = sliderBuilder(x,yScaleType1,options.lineData[0],svg,options['domId'].substr(1),"endSlider",width,moveEndHandler);
	  
		// 그래프 위의 선택 영역 박스
		var rect = svg.append("g").append("rect")
					  .attr("class", 'guideRect')
					  .attr("width",0)
					  .attr("x", 0)
					  .attr("height", height)
					  .attr("fill", "#fca65a")
					  .attr('opacity', 0.3)
					  .attr('cursor', "move");
		
		// 왼쪽 슬라이더  handler(선택 최소 혹은 최대 기간 외의 조회 막기)
		startSlider.constrain(function(event, ui) {
			var endSliderDate = x.invert(endSlider.getX());		// 선택한 기간의 종료일 
			ui.position.left = Math.min(ui.position.left, endSlider.getX() + options.margin.left );	//슬라이더 손잡이 위치와 선택한 기간의 종료일 위치 비교
			ui.position.left = Math.max(0, ui.position.left);	// 시작점과 슬라이더 손잡이 위치 비교
				  
			// 경제 24시(시간단위)
			if(options['standards'].time){ //최소 영역 1칸
				endSliderDate.setTime((endSliderDate.getTime() - (1000 *60 * 60 * options['standards'].time)));
				ui.position.left = Math.min(ui.position.left, x(endSliderDate) );
			}
	  
			// 경제트렌드, 이벤트효과(날짜단위)
			// 최소 3일 최대 6개월
			if(options['standards'].month){
				// 최소 삼일이상 선택해야하는 부분 설정
				endSliderDate.setDate(endSliderDate.getDate()-2);	// 최소3일에 대한 기준일 만들기
				ui.position.left = Math.min(ui.position.left, x(endSliderDate));	// 기준일의 위치와 현재 슬라이더 손잡이 위치 비교
				
				// 최대 6개월까지만 선택해야하는 부분 설정
				var startTime = startSlider.value().date.getTime();	// 선택한 기간의 시작일
				var endTime = endSlider.value().date.getTime();	// 선택한 기간의 종료일
				  
				if(startTime < endTime){	
					endSliderDate.setDate(endSliderDate.getDate()+3);	// 위에서 변경한 최소3일에 대한 기준 값 원상복귀
					endSliderDate.setMonth(endSliderDate.getMonth()- Number(options['standards'].month));	// 최대 6개월대한 기준일 만들기
					ui.position.left = Math.max(ui.position.left, x(endSliderDate));	// 기준일의 위치와 현재 슬라이더 손잡이의 위치 비교
				}
			}
		});

		// 오른쪽 슬라이더  handler(선택 최소 혹은 최대 기간 외의 조회 막기)
		endSlider.constrain(function(event, ui) {
			var startSliderDate = x.invert(startSlider.getX());	// 선택한 기간의 시작일
			ui.position.left = Math.max(ui.position.left, startSlider.getX() + options.margin.left);	//슬라이더 손잡이 위치와 선택한 기간의 시작일 비교
			ui.position.left = Math.min(options.margin.left + width, ui.position.left);	// 선택가능한 가장 큰 값과 슬라이더 손잡이 위치 비교
			  
			// 경제 24시(시간단위)
			if(options['standards'].time){
				startSliderDate.setTime((startSliderDate.getTime() + (1000 *60 * 60 * options['standards'].time)));
				ui.position.left = Math.max(ui.position.left, x(startSliderDate) + options.margin.left );
			}
	      
			// 경제트렌드, 이벤트효과(날짜단위)
			if(options['standards'].month){   
				// 최소 삼일이상 선택해야하는 부분 설정
				startSliderDate.setDate(startSliderDate.getDate()+2);	//최소 3일에 대한 기준일 만들기
				ui.position.left = Math.max(ui.position.left, x(startSliderDate) + options.margin.left);	//기준일과 현재 슬라이터 손잡이 위치 비교
				
				// 최대 6개월까지만 선택해야하는 부분 설정
				var endTime = endSlider.value().date.getTime();	// 선택한 기간의 종료일
				var startTime = startSlider.value().date.getTime();	// 선택한 기간의 시작일
				
				if(startTime <= endTime){
					startSliderDate.setMonth(startSliderDate.getMonth() + Number(options['standards'].month));	// 최대 6개월대한 기준일 만들기
					startSliderDate.setDate(startSliderDate.getDate()-3);	// 위에서 변경한 최소3일에 대한 기준 값 원상복귀
					ui.position.left = Math.min(ui.position.left, x(startSliderDate)  +options.margin.left );	// 기준일의 위치와 현재 슬라이더 손잡이의 위치 비교
				}
			}
		});
	      
	    
		// 선택영역 날짜 간격(width)
		var term;
		// 드래그시 이벤트 추가
		var dragBehavior = d3.behavior.drag()
							 .on("dragstart", function(){	// 드래그 시작시
								 term =  x.invert(endSlider.getX())  -   x.invert(startSlider.getX())	// 간격 계산
							 })
							 .on("drag", onSelectionDrag)	// 드래그 중
							 .on("dragend", onSelectionDragEnd); // 드래그 종료시
		
		// 드래그 기능 추가
		rect.call(dragBehavior);
		
		// 드래그 중
		function onSelectionDrag(){
			var $this = d3.select(this),	// 주황색 선택 영역 박스 객체 
			currentX = +$this.attr("x"),	// 주황색 선택 영역 박스 객체의 x값
			sWidth = +$this.attr("width"),	// 주황색 선택 영역 박스 객체의 너비
			newX = currentX + d3.event.dx;	// 주황색 선택 영역 박스 객체의 x값 + 움직인 x값
			
			if (newX < 0 || newX + sWidth > width) return;
			  
			rect.attr("x", newX);	// 주황색 선택영역 박스 위치변경
			startSlider.move(newX);	// 왼쪽 슬라이더 위치변경
			endSlider.move(newX + sWidth);	// 오른쪽 슬라이더 위치변경
		}

	   // 드래그 종료시
		function onSelectionDragEnd(){
			var $this = d3.select(this);	// 주황색 선택 영역 박스 객체 
			var currentX = $this.attr("x");	// 주황색 선택 영역 박스 객체의 x값
			var sWidth = $this.attr("width");	// 주황색 선택 영역 박스 객체의 너비
			var x0 = x.invert(currentX);	// 주황색 선택 영역 박스 왼쪽 x값을 날짜로 변환
			var x1 = new Date(dateRound(x0).getTime() + term);	// 주황색 선택 영역 박스 오른쪽 x값을 날짜로 변환
				  
			startSlider.move(x( dateRound(x0) ));	// 왼쪽 슬라이더 위치변경
			endSlider.move(x( x1 ));	// 오른쪽 슬라이더 위치변경
			moveEndHandler();	//마우스 handler 호출
		}

		var eventManager = $({});	// 마우스 움직임이 끝났을때, 선택한 시간에 대한 처리 함수 호출
		if(options['timeHandler']){
			eventManager.bind(options['domId']+"-moveend" , options['timeHandler']);
		}

		this.update(options['defaultVal'].x0, options['defaultVal'].x1);
		  
		function rectRedraw(){
			startX = startSlider.getX();
			endX = endSlider.getX();
			if(endX-startX < 0)return;
			      
			$(".guideRect").attr("width",(endX-startX));
			$(".guideRect").attr("x", startX);
			
			$(".gslider.startSlider").css("left", startX-1);
			$(".gslider.startSlider").css("margin-left", -$(".gslider.startSlider").outerWidth()+options.margin.left+3);
			$(".gslider.endSlider").css("left", endX+options.margin.left+1);
			  
			$(".gslider.startSlider").html( options['xFormat'](dateRound(x.invert(startX))));
			$(".gslider.endSlider").html(   options['xFormat'](dateRound(x.invert(endX))) );
			  
			$(".fillRect").attr("width",(endX-startX));
			$(".fillRect").attr("x", startX);
			  
		} 
		  
		function moveEndHandler(){
			if(options['domId'] !== undefined && options['domId'] == "#time24Chart"){
				eventManager.trigger(options['domId']+"-moveend" , [startSlider.value() , endSlider.value()]);
			}else{			  
				eventManager.trigger(options['domId']+"-moveend" , [x.invert(startSlider.getX()) , x.invert(endSlider.getX())]);
			}
		}
		 
		// 문자를 잘짜 데이터로 변경 
		function dateRound(x0){
			var nDate = new Date(x0);
			nDate.setHours(nDate.getHours() + Math.round(nDate.getMinutes()/60));
			nDate.setMinutes(0);
			return nDate;
		}
		  
		/**
		 * 슬라이더 생성 함수
		 * @scaleX		x값 계산기
		 * @scaleY		y값 계산기
		 * @silderData	전체 데이터
		 * @canvas		그래프 영역(svg 객체)
		 * @id			"#"
		 * @sliderName	슬라이더 이름(startSlider, endSlider)
		 * @maxWidth		그래프 전체 영역의 width
		 * @moveEndHandler	움직임이 끝났을때의 handler
		 * 
		 */
		function sliderBuilder(scaleX,scaleY,silderData,canvas,id,sliderName ,maxWidth,moveEndHandler) {
			// 슬라이더의 양끝쪽에 라인을 추가할 영역 만들기
			var sliderGroup = canvas.append("g").attr("class", "marker");
			 
			// 슬라이더의 양끝쪽 라인 추가
			var dotLine = sliderGroup.append("line")
									 .attr("class", "guideline")
									 .attr("clip-path", "url(#clip)")
									 .attr("x1", 0)
									 .attr("y1", 0)
									 .attr("x2", 0)
									 .attr("y2", height);
			  
			 // 슬라이더의 양끝쪽 라인 위의 점 추가
			var dot = sliderGroup.append("circle")
								 .attr("class", "dot")
								 .attr("r", 2.5);
			 
			  
			var _selectedData = silderData[0];
			var _sliderDiv = $("#"+id).append("<div class='gslider "+sliderName+"'/>");	// 슬라이더 영역 추가
			var _constrain;
			
			function constrain(dragConstrain) {
				_constrain = dragConstrain;
			}
			  
			$(".gslider."+sliderName).draggable({
				axis: "x",
				start : function() {
				},
				drag: function(event, ui) {
					if (_constrain) {
						_constrain(event, ui);
					}
					var offx = (sliderName == "startSlider") ?  options.margin.left : 0;//왼쪽 slider margin처리
					moveX($(this).position().left + offx - options.margin.left);
				},
				stop : function() {
					var offx = (sliderName == "startSlider") ?  options.margin.left : 0;//왼쪽 slider margin처리
					var tick = getStopTick($(this).position().left + offx - options.margin.left);
					moveX(scaleX(tick));
					moveEndHandler()
				}
			});
	  
			// x좌표를 날짜(도메인)으로 변경
			function getStopTick(xleft){
				var x0 = scaleX.invert(xleft);
				return dateRound(x0);
			}
			
			var posX = 0;
			
			// 주황색 선택영역 움직이기
			function moveX(xxx){		  
				if (xxx < 0 || xxx > maxWidth) return;
					  
				var rWidth = 0;
				var rPosx = 0;
					  
				posX = xxx;
				var x0 = scaleX.invert(posX);	
				var newValue = Math.round(x0);
				var bisectTimeCd = d3.bisector(function(d) { return d.date }).left;
				var i = bisectTimeCd(silderData, x0, 1);
					  
				var d0 = silderData[i - 1];
				var d1 = silderData[i];
				var d = x0.getTime() - d0.date.getTime() > d1.date.getTime() - x0 ? d1 : d0;
				_selectedData = d;
//				var nearYvalue= scaleY(d.total_cnt);	  
				var nearYvalue= scaleY(d.value);	  
					  
				var pathEl = linePath.node();
				var pathLength = pathEl.getTotalLength();
				var beginning = posX, end = pathLength, target;
					  
				while (true) {
					target = Math.floor((beginning + end) / 2);
					pos = pathEl.getPointAtLength(target);
					if ((target === end || target === beginning) && pos.x0 !== x) {
						break;
					}
					if (pos.x > posX)      end = target;
					else if (pos.x < posX) beginning = target;
					else break; //position found
				}
				  
				dot.attr("transform", "translate(" + pos.x + "," + pos.y + ")");
				dotLine.attr("transform", "translate(" + pos.x + ",0)");
				rectRedraw();
			}
					  
			return {
				move:moveX,
				value:function(){return _selectedData;},
				getX:function(){return posX;},
				constrain:constrain
			}
		}
	}
	
	F.prototype['update'] = function(x0, x1) {
		endSlider.move(x(x1));
		startSlider.move(x(x0));	
	}
	
	F.prototype['whoami'] = function() {
		console.log(name);
	}
	
	return F;
}()