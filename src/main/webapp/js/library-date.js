/**
 * @description Date 메소드를 정의한 라이브러리 
 * @descriptor 김용현
 * @date 2020.08.19
 */

if(!OM) var OM = {};

OM.Date = (function() {
	return {
		/**
		 * @description Date객체를 년/월/일로 나누어 배열로 리턴
		 * @param {String type} 구분값: yyyy, yyyymm, yyyymmdd
		 * @param {Date date} 시간
		 * @returns Array 
		 */
		getArr: function(date) {
			
		  if (!date) var date = new Date();

		  if(typeof(date) === 'string') {
			  return stringToArr(date);
		  } else {
			  return dateToArr(date);
		  }
		  
		  function stringToArr(d) {
			  if(!d || d.length < 8) return;
			  
			  return [ 
					d.substr(0, 4),
					d.substr(4, 2),
					d.substr(6, 2)
				];
		  }
		  
		  function dateToArr(d) {
			  var tempMonth = d.getMonth() + 1;
			  var tempDay = d.getDate(); 
			  var year = d.getFullYear().toString();
			  var month = tempMonth.toString().length === 1 ? "0" + tempMonth : tempMonth.toString();
			  var day = tempDay.toString().length === 1 ? "0" + tempDay : tempDay.toString();

			  return [year, month, day];
		  }
		},
	}
})();