/** 
 * @description 공통함수를 정의한 라이브러리
 * @descriptor 김용현
 * @date 2020.08.19 
 */

if(!OM) var OM = {};

OM.Map = (function() {
	return {
		maps: {},
		
		data: {},
		
		/**
		 * @description create basemap
		 * @param id basemap id
		 * @param options configuraion to need to create basemap
		 * @returns
		 */
		createBaseMap: function(id, options) {
			var that = this;
			var map = L.map(id, { 
				zoomControl: false, 
				scrollWheelZoom: false, 
				maxZoom: 18, 
				minZoom: 7, 
				closePopupOnClick: false
			});
//		}).setView([ 37.492334, 127.062444 ], 11);
			
			map.doubleClickZoom.disable();
			
			new L.Control.Zoom({position:'topright'}).addTo(map);
			
			if(options.tileMap) {
//				L.tileLayer( "${globalConfig['config.vworld.host']}/2d/gray/201411/{z}/{x}/{y}.png", { 
				L.tileLayer( 'https://trend-on.co.kr/xdworld/2d/gray/201512/{z}/{x}/{y}.png', {
					attribution : '© Vworld', 
					maxZoom : 19, 
					minZoom : 7
				}).addTo(map);
			}
			map.addControl(new this.customControl());
			
			this.maps[id] = map;
			
			return map;
		},
		
		/**
		 * @description check to exist basemap in target layer
		 * @param id basemap id
		 */
		checkBaseMap: function(id) {
			
			if(!id) id = 'empty';
			
			if(this.getBaseMap(id)) return true;
			else return false;
		},
		
		/**
		 * @description get basemap
		 * @param id basemap id
		 */
		getBaseMap: function(id) {
			
			if(!id) return this.maps;
			else return this.maps[id]; 
		},
		
		/**
		 * @description 배경지도 보임
		 */
		showBaseMap: function(id) {
			var baseMap = this.getBaseMap(id);
			
			if(!baseMap) return;
			
			var mapPane = baseMap.getPanes()['mapPane'];
			var controlContainer = baseMap['_controlContainer'];
			
			if(mapPane) mapPane.style.cssText = ['display: block;'].join('');
			if(controlContainer) controlContainer.style.cssText = ['display: block;'].join('');
		},
		
		/**
		 * @description 배경지도 보임
		 */
		hideBaseMap: function(id) {
			var baseMap = this.getBaseMap(id);
			
			if(!baseMap) return;
			
			var mapPane = baseMap.getPanes()['mapPane'];
			var controlContainer = baseMap['_controlContainer'];
			
			if(mapPane) mapPane.style.cssText = ['display: none;'].join('');
			if(controlContainer) controlContainer.style.cssText = ['display: none;'].join('');
		},
		
		/**
		 * @description 레이어 생성
		 * @param baseMap
		 * @param data
		 * @param style
		 * @returns
		 */
		createGeojsonLayer: function(baseMap, data, options) {
			var bounds = null;
			var layer = L.geoJSON(data, {
					style: options['style'],
					onEachFeature: options['onEachFeature'] 
				}).bindPopup(L.popup({
				closeButton:false,
				autoPan:false
				})
			);

			layer._isCustomLayer = true;
			layer._fid = baseMap._container.id;
			layer.addTo(baseMap);
			
			bounds = layer.getBounds();
			baseMap.fitBounds(bounds, {
				animate: true
			});
			
			return layer;
		},
		
		/**
		 * @description draw WMS
		 * @param {String} url WMS 응답 서버주소
		 * @param {Object} option WMS 옵션
		 */
		createWMSLayer: function(url, options, baseMap) {
		  if (url.length === 0) return;

		  L.tileLayer.wms(url, options).addTo(baseMap);
		},

		checkLayer: function(fid, map) {
			var flag = false;
			
			for(var l in map._layers){
				if(map._layers[l]._fid == fid){
					flag = true;
				}
			}
			
			return flag;
		},
		
		/**
		 * @param get layer
		 * @param layerId layer id
		 * @param map  
		 * @returns
		 */
		getLayer: function(layerId, map){
			var layers = map['_layers'];
			
			var id = Object.keys(layers).filter(function(id) {
			    return layers[id]['_fid'] === layerId
			})[0];
			
			if(!id) return null;
			
			return layers[id];
		},

		/**
		 * @description remove layer
		 * @param layerId layer id
		 * @param map basemap
		 */
		removeLayer: function(layerId, map){
			var layers = map._layers;
			
			for(var l in layers) {
				if(layerId === layers[l]._fid){
					map.removeLayer(layers[l]);
				}
			}
		},
		
		/**
		 * @description show the layer
		 */
		showLayer: function() {},
		
		/**
		 * @description hide the layer
		 */
		hideLayer: function() {},
		
		// feature 변경
		changeFeature: function(layer, style) {
			
			if(!layer) return;
			if(!style) return;
			
			layer.setStyle(style);
		},
		
		// 모든 레이어 가져옴
		getAllLayer: function() {},

		// 모든 레이어 삭제
		removeAllLayer: function() {},
		
		// 모든 레이어 색상 변경
		setFeatureAllLayer: function() {}, 
		
		/**
		 * 초기 map의 bound로 이동.(지도 초기화)
		 * @param id 지도 fid
		 */
		mapReload: function(baseMap, layer){
			if(!baseMap) return;
			if(!layer) return;
			
			var bounds = layer.getBounds();
//			
			baseMap.fitBounds(bounds);
		},

		/**
		 * @description zoom Object
		 * init: initialize zoom controller
		 * active: active zoom controller
		 * active: inActive zoom controller
		 */
		zoom: {
			init: function(map) {
				
				if(!map) return;
				
				map.setMaxZoom(18);
				map.setMinZoom(7);
				
				var zoomoutDOM = map._controlContainer.getElementsByClassName('leaflet-control-zoom-out')[0];
				
				if(!zoomoutDOM) return;
				
				zoomoutDOM.classList.remove('leaflet-disabled');
			},
			
			min: {
				active: function(map) {
					if(!map) return;
					
					map.setMinZoom(7);
					
					var zoomoutDOM = map._controlContainer.getElementsByClassName('leaflet-control-zoom-out')[0];
					
					if(!zoomoutDOM) return;
					
					zoomoutDOM.classList.remove('leaflet-disabled');
				},
				
				inActive: function(map) {
					
					if(!map) return;
					
					map.setMinZoom(map.getZoom());
					
					var zoomoutDOM = map._controlContainer.getElementsByClassName('leaflet-control-zoom-out')[0];
					
					if(!zoomoutDOM) return;
					
					zoomoutDOM.classList.add('leaflet-disabled');
				}
			}
		},
		
		/**
		 * @description 레이어 mouseover event 
		 * @param layer
		 * @param callback
		 * @returns
		 */
		mouseoverOfLayer: function(layer, callback) {
			
			if(!layer) return;
			
			layer.on('mouseover', function(e) {
				if(callback && typeof callback === 'function') callback(e);
				
			});
		},

		/**
		 * @description 레이어 mouseout event
		 * @param layer
		 * @param callback
		 * @returns
		 */
		mouseoutOfLayer: function(layer, callback) {
			
			if(!layer) return;
			
			layer.on('mouseout', function(e) {
				if(callback && typeof callback === 'function') callback(e);
			});
		},
		
		/**
		 * @description 레이어 moveend event
		 * @param layer
		 * @param callback
		 * @returns
		 */
		moveendOfLayer: function(layer, callback) {
			
			if(!layer) return;
			
			layer.on('moveend', function(e) {
				if(callback && typeof callback === 'function') callback(e);
			});
		},
		
		/**
		 * @description 레이어 zoomend event
		 * @param layer
		 * @param callback
		 * @returns
		 */
		zoomendOfLayer: function(layer, callback) {
			
			if(!layer) return;
			
			layer.on('zoomend', function(e) {
				if(callback && typeof callback === 'function') callback(e);
			});
		},

		/**
		 * @description 지도 색상 가져옴
		 * @param index
		 * @returns Array
		 */
		getMapColor: function(index) {
			return [
		        [ '#fdae61'],
		        [ '#fdae61', '#d7191c'],
		        [ '#ffffbf', '#fdae61', '#d7191c'],
		        [ '#abdda4', '#ffffbf', '#fdae61', '#d7191c'],
		        [ '#2c7bb6', '#abdda4', '#ffffbf', '#fdae61', '#d7191c']
		       ][index];
		},

		/**
		 * @description Choropleth 스타일 가져옴
		 * @param data
		 * @param options
		 * @returns Function
		 */
		getChoroplethStyle: function(data, options) {
			
			var that = this;
			var series = null;
			var quantiles = [];  // 등급 갯수에 따른 등급 값 배열
			var tmpArr = []; // 등급 값 생성 시 필요 데이터
			var gradeSection = options['gradeSection']; // 등급 갯수
			var mappingKey = options['mappingKey']; // feature 데이터와 연결 데이터를 매핑시킬 KEY
			var callback = options['callback']; // 콜백함수
			// 배열데이터 생성
			tmpArr = data.map(function(item) {
				return item['value'];
			});
			
			// 중복제거
			tmpArr = this.removeDuplication(tmpArr);

			
			// 오름차순 정렬
//			sort(tmpArr, 'asc');
			
			// 등급 값 배열 생성
			if(gradeSection > tmpArr.length){
				gradeSection = tmpArr.length;
				if(tmpArr.length > 1) OM.Comm.sort(tmpArr,'asc');
				quantiles = tmpArr;
				
			}else{
				series = new geostats(tmpArr);
				quantiles = series.getQuantiles(gradeSection);  // 현재는 등개수만 지원하지만 추후 등간격 등 더 지원할 예정		
			}
			
			return function(feature) {
				
				// feature데이터와 연결 데이터를 매핑
				var id = feature.properties[mappingKey]; 
				var filterVal = data.filter(function(item) {
					return item[mappingKey] === id;
				})[0];
				
				var colorIdx = 0;
				
				if(filterVal) {
		 			var grade = that.getApproximation(filterVal['value'] , quantiles);  // 근사치
		 			colorIdx = quantiles.indexOf(grade);  // 등급에 따른 색상 인덱스
		 		}else{
		 			colorIdx = null;
		 		}
				
				var style = that.getStyle();
				
				if(!options.style) {
					style['fillColor'] = getMapColor([quantiles.length - 1])[colorIdx];;
				} else if (options.style['fillColor']){
					style['fillColor'] = options.style['fillColor'](colorIdx);
				}
				
				if(callback && typeof callback === 'function') callback(feature, style, data);
				
				return style;
			}
		},

		//근사치 가져옴
		getApproximation: function(value, grades) {
			var curr = grades[0];

			grades.reduce(function(acc, v, i) {
				
				if(Math.abs(value - v) < Math.abs(value - curr)) {
					curr = v;
				}
			}, []);
			
			return curr;
		},

		/**
		 * @description 배열 중복제거
		 * @param data
		 * @returns
		 */
		removeDuplication: function(data) {
			
			if(!Array.isArray(data)) return;
			
			return data.filter(function(item, index) {
				return data.indexOf(item) === index;
			});
		},

		createPopup: function() {},
		updatePopup: function() {},
		openPopup: function() {},
		closePopup: function() {},

		/**
		 * 지도 범례  -> leaflet API로 변경
		 * @param divId		범례를 담을 div id 
		 * @param colorVal 	컬러 맵
		 * @param vals 
		 */
		createLegend: function(id , colorVal , vals, title) {
			
			var colors = d3.scale.quantize().range(colorVal);
			var rootDOM = d3.select(['#', id,' .map', ' .legend'].join(''));
			
			if(!rootDOM.empty()) return;
			
			rootDOM = d3.select(['#', id, ' .map'].join(''))
			.append("div")
			.attr('class', 'legend');
			
			var titleDOM = rootDOM.append('small').text(title);
			var legend = rootDOM.append('ul').attr('class', 'list-inline');
		    var keys = legend.selectAll('li.key').data(colors.range());
		    var liWidth = 100/(colorVal.length);
		    
		    keys.enter()
		    	   .append('li')
				   .attr('class', 'key')
				   .style({'border-top-color' : String, 'width':liWidth+'%'})
				   .text(function(d,i) {
				     	var result = " ";
				     	
				    	if(i == 0) {
				    		result = "적음";
				    	} else if(i == (vals.length-1)) {
				    		result = "많음";			    		
				    	}
				    	
				        return result;
					});
		},

		/**
		 * tooltip -> leaflet API로 변경
		 * @param title []      제목 색 과 제목 값
		 * @param data          내용에 들어갈 data
		 * @returns {String}    popup html
		 */
		getMapTooltip: function(tooltip){

			var title = tooltip['title'];
			var data = tooltip['data'];
			
			if(!title || !title['value']) return;
			if(!data || data.length ===0 ) return;
			
			var html = [];
			
			html.push('<div class="tooltip-header">');
			html.push('<div class="tooltip-title" style="color:' + title.color+';"><b>' + title.value + '</b></div>');
			html.push('</div>');
			html.push('<div class="tooltip-data">');
			
			data.reduce(function(acc, v, i) {
				html.push('<div class="tooltip-block">');
				html.push('<div class="tooltip-name">' + v['name'] + '</div>');
				html.push('<div class="tooltip-value">' + v['value'] + '</div>');
				html.push('</div>');
				
				if(i < (data.length - 1)) {
					html.push('<div class="tooltip-seperator"></div>');
				}
			}, []);
			
			html.push('</div>');
				
			return html.join('');
		},

		//커스텀 맵 컨트롤 버튼
		customControl:  L.Control.extend({

			  options: {
			    position: 'topright'
			  },

			  onAdd: function (map) {
			    var container = L.DomUtil.create('input');
			    container.type="button";

			    container.style.cssText = ''.concat(
		    		'background-image: url(/images/common/icon_reload.png);',
		    		'background-repeat: no-repeat;',
		    		'background-color: white;',
		    		'background-size: auto;',
		    		'background-position: center;',
		    		'width: 34px;',
		    		'height: 35px;',
				    'border: 2px solid #bbb;',
				    'border-radius: 4px;',
				    'cursor: pointer;'
		    	);
			  
			    container.onmouseover = function(e) {}
			    container.onmouseout = function(e) {}

			    container.onclick = function(e) {
			    	var layer = null;
			    	
			    	for(var l in map._layers){
			    		if(map._layers[l]._isCustomLayer) layer = map._layers[l];
			    	}
			    	
			    	OM.Map.mapReload(map, layer);
			    }

			    return container;
			  }
		}),

		getStyle: function(custom) {
			
			var style = {
				fillColor: '#ff0000',
				fillOpacity : 0.8,
				color: '#d3d3d3',
//				dashArray: '1',
				opacity : 1,
				weight : 1
			}

			if(custom) style = $.extend(style, custom, {});
			
			return style;
		}
	}
})();