var webserver = require('webserver');
var webpage = require('webpage');
var fs = require('fs');

phantom.injectJs('js-yaml.js');



var config = jsyaml.safeLoad(fs.read('config.yml', 'utf-8'));
config = config.config;


var PORT = config.port || 48080;

//이미지 그리기
function renderElement(page, selector) {
	var clipRect = page.evaluate(function(selector) {
		var selectedObject = document.querySelector(selector);
		if(selectedObject == null)
			return null;
		return selectedObject.getBoundingClientRect();
	}, selector);
	
	
    var rWdith = page.evaluate(function() { return document.body.offsetHeight }),
    rHeight = page.evaluate(function() { return document.body.offsetWidth });
	if(clipRect != null){
		page.clipRect = {
			top: clipRect.top,
			left: clipRect.left,
			width: clipRect.width,
			height: clipRect.height
		};
		
		rWdith = clipRect.width  || "unknown";
		rHeight = clipRect.height|| "unknown";
	}
	var pic = page.renderBase64('png');

	console.log("Rendered image of size: " + rWdith + ' x ' + rHeight + " (" + pic.length + " bytes)");

	return pic;
};
//request Get
function parseGET(url) {

	var query = url.substr(url.indexOf("?") + 1);
	var result = {};
	query.split("&").forEach(function(part) {
		var e = part.indexOf("=")
		var key = part.substr(0, e);
		var value = part.substr(e + 1);
		result[key] = decodeURIComponent(value);
	});

	return result;
}
//대기
function waitFor(testFx, onReady, timeOutMillis,page) {

	var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 5000, //< Default Max Timout is 5s
		start = new Date().getTime(),
		condition = false,
		interval = setInterval(function() {
			if ((new Date().getTime() - start < maxtimeOutMillis) && !condition) {
				// If not time-out yet and condition not yet fulfilled
				condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
			} else {
				if (!condition) {
                    typeof(onReady) === "string" ? eval(onReady): onReady();
                    clearInterval(interval);
					//phantom.exit(1);
				} else {
					// Condition fulfilled (timeout and/or condition is 'true')
					console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
					typeof(onReady) === "string" ? eval(onReady): onReady(); //< Do what it's supposed to do once the condition is fulfilled
					clearInterval(interval); //< Stop this interval
				}
			}
		}, 50); //< repeat check every 500ms
};

console.log("-> Starting server on port " + PORT + ".");


webserver.create().listen(PORT, function(request, response) {
	if (request.url === '/favicon.ico') return ;
	
	response.setHeader('Access-Control-Allow-Origin', '*');
	console.log('method :' + request.method);
	console.log('length :' + request.url.length);
	console.log(request.url);

	var requestparam = parseGET(request.url);

	var url = request.url;
	url = url.split('?').shift();



	if (request.url == '/') {
		response.statusCode = 200;
		response.setHeader('Content-Type', 'text/html; charset=utf-8');
		response.write("openmate d3 chart service");
		response.close();
	} else {
		
		var page = webpage.create();
		var resources = {};
		var pstart = new Date().getTime();
		var onErrorCnt = 0;
		var onErrorTraceArr = 0;
		
		page.settings.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.101 Safari/537.36';
		page.onError = function(msg, trace) {
			var msgStack = ['ERROR: ' + msg];
			if (trace && trace.length) {
				msgStack.push('TRACE:');
				trace.forEach(function(t) {
					msgStack.push(' -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function+'")' : ''));
				});
			}
			onErrorCnt++;
			onErrorTraceArr.push( msgStack.join('\n') );
			if(onErrorCnt > 10	){
				page.close();
				response.statusCode = 200;
				response.setHeader('Content-Type', 'text/html; charset=utf-8');
				for(var i = 0 ;i<onErrorTraceArr.length;i++)
					response.write(onErrorTraceArr+"<br/>");
				response.close();
			}
			console.error(onErrorCnt+";;;"+msgStack.join('\n'));
		};
		page.onConsoleMessage = function(msg, lineNum, sourceId) {
			console.log('client console ->: ' + msg + ' (from line #' + lineNum + ' in "' + sourceId + '")');
		};
		page.onClosing = function(closingPage) {
			console.log("close-> "+closingPage.url+" finished in " + (new Date().getTime() - pstart) + "ms.");
		};
		page.onResourceRequested = function(request) {
			//console.log('Request (#' + request.id + '): ' + JSON.stringify(request));
			if (request.stage)
				resources[request.id] = 'start';
		};
		page.onResourceReceived = function(response) {
			//console.log('Response (#' + response.id + ', stage "' + response.stage + '"): ' + JSON.stringify(response));
			if (response.stage)
				resources[response.id] = response.stage;
		};
		page.onCallback = function(data) {
			//최대 5초간 기다린다.
			waitFor(
				function() {
					//모든 리소스를 내려 받은 후 title이 complete가 될때까지 기다린다.
					for (var o in resources) {
						if (resources[o] != 'end') {
							return false;
						}
					}

					return page.evaluate(function() {
						return document.title == 'complete';
					});
				},
				function() {
					var r = renderElement(page, '#viewport');
					page.close();
					if (r) {
						response.statusCode = 200;
						response.headers = {
							'Cache': 'no-cache',
							'Content-Type': 'image/png'
						};
						response.setEncoding('binary');
						response.write(atob(r));
					} else {
						response.statusCode = 500;
						response.write("No image rendered after evaluating: \n" + render_fn);
					}
					response.close();
				});
		};

		//page.open('html/' + pageName, function(status) {

		function getUrl(){
			var rtnUrl = "";
			for (var i = 0; i < config.resourceMappingList.length; i++) {
				var item = config.resourceMappingList[i];
				var lastIndexStr = (item.resource || '/d3/');
				var pageName = url.substring(url.lastIndexOf(lastIndexStr) + lastIndexStr.length);
				var targetUrl = (item.url || 'http://localhost:8090/') + pageName;

				if (request.url.lastIndexOf(lastIndexStr + pageName, 0) === 0) {
					
					rtnUrl = targetUrl;
					break;
				}
			}
			return rtnUrl;
		}
		var targetUrl = getUrl()  ;
		targetUrl = (targetUrl == "") ? (requestparam["url"]) ? requestparam["url"] : "" : targetUrl;
		
		if(targetUrl != ""){
			console.log("open->" + targetUrl);
			page.open(targetUrl, function(status) {
				if (status != 'success') {
					console.log("Failed to load shell page, status: " + status);
					page.close();
					response.close();
					return;
				}
				//client evaluate
				page.evaluate(function(param) {
					var options = {};
					var res = 1;
					if (param["t"] == "pdf")//res로 변경해야 하는지.//viewport를 옵션으로 변경해야 하는지
						res = 1.5;
					
					if (param["o"]) {
						eval("options = " + unescape(param["o"]));
					}
					if(param.w)
						options.width = (param.w || 128) * res;
					
					if(param.h)
						options.height = (param.h || 128) * res;

					if(typeof (drawChart) =='function') {
						drawChart(options);
					}else{
						document.title == 'complete';
					}
					window.callPhantom();
				}, requestparam);
//				setTimeout(function(){page.close()},20000);
			});
		}

	}

});