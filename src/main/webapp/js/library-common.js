/**
 * @description 공통함수를 정의한 라이브러리 
 * @descriptor 김용현
 * @date 2020.08.19
 */

if(!OM) var OM = {};

OM.Comm = (function() {
	return {
		
		addSign: function(number, langauge) {
			var sign = "";
			
			if(langauge === 'korean') {
				if (Number(number) > 0) sign = "증가";
				else if(Number(number) > 0) sign = "감소";
			} else {
				if (Number(number) > 0) sign = "+";
				else if(Number(number) > 0) sign = "-";
			}
			
			
			return sign;
		},
		
		print: function(message) {
			console.log(message);
		},
		
		/** 
		 * @description 예외처리
		 */
		tryCatch: function(callback) {
			
			try {
				if(callback['try'] && typeof callback['try'] === 'function') callback['try']();
			} catch (exception){
				console.log('BUG : ',  exception);
				if(callback['catch'] && typeof callback['catch'] === 'function') callback['catch']();
			} finally {
				if(callback['finally'] && typeof callback['finally'] === 'function') callback['finally']();
			}
		},
		
		/**
		 * 
		 * @description 
		 * kr: 데이터를 서버에서 가져옴
		 * eng: get data from server
		 * @param path
		 * @param params
		 * @returns Array or Object or String or Number
		 */
		getData: function(path, params, callback, message) {
			
			if(!path || typeof path !== 'string' || path.length < 1) return;
			if(!params) params = {}; 
			
			var that = this;
			var backendURL = location.protocol + "//" + location.hostname + ":" + location.port;
			var requestURL = backendURL + path;
			
			$.ajax({
				url: requestURL, 
				data: params,
				beforeSend: function(jqXHR) {
					if(callback && typeof callback['beforeSend'] === 'function') callback['beforeSend']();
				},
				success: function(data) {
					
					if(!Array.isArray(message)) message = [message, false];
					
					if(message[1]) console.log(message[0], data);
					
					if(callback && typeof callback['success'] === 'function') {
						
						try {
							callback['success'](data, params);
						} catch (exception){
							console.log('BUG : ',  exception);
						} finally {
							if(callback && typeof callback['complete'] === 'function') callback['complete']();
						}
					}
						
					return data;
				},
				error: function(request, status, error) {
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					if(callback && typeof callback['complete'] === 'function') callback['complete']();
				},
				complete: function(jqXHR, textStatus) {
					if(callback && typeof callback['complete'] === 'function') callback['complete']();
				}
			});
		},

		/**
		 * @description 3자리 단위로 콤마 추가
		 * @param {*} x
		 * @returns {String} 
		 * @example xxxxxx -> xxx,xxx
		 */
		addCommaToNum: function(x) {

		  if (!x) return "0";
		  
		  return ("" + x).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		},

		/**
		 * @description 화폐단위 변경하는
		 * @param {String} won  화폐
		 * @returns {String} 단위 붙인 화폐
		 */
		numToKR: function(num) {
		  var units = {
			basic: "",
		    man: "만",
		    uk: "억",
		    jo: "조"
		  }
		  var refinedNum = "" + num; // 정제된 화폐
		  var length = refinedNum.split('.')[0].length; // 정제된 화폐길이
		  var unit = "basic"; // 단위
		  var int = 0; // 정수
		  var deci = 0; // 소수
		  var returnVal = refinedNum; // 리턴할 화폐 
		  var classifyPos = 0; // 구분위치

		  // 단위가 만원일 경우
		  if (length >= 5) {
		    classifyPos = length - 5;
		    unit = "man"
		  }

		  // 단위가 억원일 경우
		  if (length >= 9) {
		    classifyPos = length - 9;
		    unit = "uk"
		  }

		  // 단위가 조일 경우
		  if (length >= 13) {
		    classifyPos = length - 13;
		    unit = "jo"
		  }
		  
		  // 단위가 만원 이상일 경우 컨버팅 로직
		  if(length >= 5) {
			  int = refinedNum.substr(0, classifyPos + 1);
			  deci = refinedNum.substr(classifyPos + 1, 2);
			  returnVal = [this.addCommaToNum(int), Math.round((deci / 10))].join('.');
		  } else {
			  returnVal = this.addCommaToNum(returnVal);
		  }
		  
		  return [returnVal, units[unit]];
		},

		/**
		 * @description 객체를 얕은 복사
		 * @param {Object} obj 복사할 객체
		 * @returns {Object} copy 복사된 객체
		 */
		deepCloneObj: function(obj) {
		  if (obj === null || typeof obj !== "object") return obj;

		  let copy = obj.constructor();

		  for (let attr in obj) {
		    if (obj.hasOwnProperty(attr)) {
		      copy[attr] = obj[attr];
		    }
		  }

		  return copy;
		},

		/**
		 * @description convert rgb to hex 
		 * @param r
		 * @param g
		 * @param b
		 * @returns rgb
		 */
		rgbToHex: function(r, g, b) {
			function toHex(c) {
			      var hex = c.toString(16);
			      return hex.length == 1 ? "0" + hex : hex;
		    }
		    
		    return "#" + toHex(r) + toHex(g) + toHex(b);
	    },
	    
	    /**
	     * @description convert rem to px
	     * @param size
	     * @param defaultSize
	     * @returns px
	     */
	    remToPx: function(size, defaultSize) {
	    	var value = size * defaultSize;
	    	return Math.round(value);
	    },

		/**
		 * @description 기본 스크롤 이동
		 * @param {*} offset 이동할 위치
		 */
		  defaultScroll: function(offset) {

			if(!offset || isNaN(offset)) offset = 0;
			
		  // ie 제외한 브라우저
		  if (document.scrollingElement) {
		    document.scrollingElement.scrollTop = offset;

		  // ie
		  } else {
		    document.documentElement.scrollTop = offset;
		  }
		},

		/**
		 * @description 쿠키 가져옴
		 * @param {*} name 쿠키 속성
		 * @returns value 쿠키 값
		 */
		getCookie: function(name) {
		  const value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
		  return value ? value[2] : null;
		},

		/**
		 * @description 쿠기 설정
		 * @param {*} name  쿠키 속성
		 * @param {*} value 쿠키 값
		 * @param {*} day 만료일자
		 */
		setCookie: function(name, value, day) {
		  const date = new Date();
		  const ONE_DAY = 60 * 60 * 24 * 1000;
		  date.setTime(date.getTime() + day * ONE_DAY);
		  document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
		},

		/**
		 * @description 쿠키 삭제
		 * @param {*} name 쿠키 속성
		 */
		deleteCookie: function(name) {
		  const date = new Date();
		  document.cookie = name + "= " + "; expires=" + date.toUTCString() + "; path=/";
		},

		/**
		 * @description querystring 생성 
		 * @param data
		 * @returns
		 */
		buildQuery: function(data) {

			// If the data is already a string, return it as-is
			if (typeof (data) === 'string') return data;

			// Create a query array to hold the key/value pairs
			var query = [];

			// Loop through the data object
			for (var key in data) {
				if (data.hasOwnProperty(key)) {

					// Encode each key and value, concatenate them into a string, and push them to the array
					query.push(key + '=' + data[key]);
				}
			}

			// Join each item in the array with a `&` and return the resulting string
			return query.join('&');
		},

		//넘어온 값이 빈값인지 체크합니다. 
		// !value 하면 생기는 논리적 오류를 제거하기 위해 
		// 명시적으로 value == 사용
		// [], {} 도 빈값으로 처리 
		isEmpty: function(value) { 
			if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ) { 
				return true 
			} else { 
				return false 
			}
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


		/**
		 * @description 배열정렬
		 * @param data
		 * @param orderBy
		 * @returns
		 */
		sort: function(data, orderBy) {
			
			if(!data || data.length === 0) return;
			if(!(orderBy === 'asc' || orderBy === 'desc')) return;
			
			// 오름차순
			if(orderBy === 'asc') {
				data.sort(function (a,b) { return a < b ? -1 : a > b ?  1 : 0; });
			
			// 내림차순
			} else {
				data.sort(function (a, b) { return a > b ? -1 : a < b ? 1 : 0; });
				
			}
		},

		/**
		 * @description 객체정렬
		 * @param data
		 * @param orderBy
		 * @param column
		 * @returns
		 */
		sortObject: function(data, orderBy, column) {
			
			// 오름차순
		    if (orderBy === "asc") {
		    	
		    	data.sort(function(a, b) {
			        let aVal = Number(a[column]);
			        let bVal = Number(b[column]);
			
			        if (isNaN(aVal)) aVal = Number(a[column].replace(/\./g, ""));
			        if (isNaN(bVal)) bVal = Number(b[column].replace(/\./g, ""));
			
			        return aVal < bVal ? -1 : aVal > bVal ? 1 : 0; 
			      });

		    // 내림차순
		    } else {
		    	data.sort(function(a, b) {
			        let aVal = Number(a[column]);
			        let bVal = Number(b[column]);
			
			        if (isNaN(aVal)) aVal = Number(a[column].replace(/\./g, ""));
			        if (isNaN(bVal)) bVal = Number(b[column].replace(/\./g, ""));
			
			        return aVal > bVal ? -1 : aVal < bVal ? 1 : 0;
			      });
		    }
		},

		/**
		* 배열 group by
		* @param data group by를 할 배열
		* @param key group을 형성할 기준이 되는 colum 값
		**/
		groupBy: function(data, key) {
			
			if(!key) return;
			
			return data.reduce(function(rv, x) {
				
				(rv[x[key]] = rv[x[key]] || []).push(x);
				
				return rv;
				
			}, {});
		},

		/**
		 * @description 근사치 가져옴
		 * @param value
		 * @param grades
		 * @returns
		 */
		getApproximation: function(value, grades) {
			var curr = grades[0];

			grades.reduce(function(acc, v, i) {
				
				if(Math.abs(value - v) < Math.abs(value - curr)) {
					curr = v;
				}
			}, []);
			
			return curr;
		}
	}
})();