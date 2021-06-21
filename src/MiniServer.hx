package;

import tink.http.containers.*;
import tink.web.routing.*;
import tink.http.Response;
import tink.http.middleware.Static;
import js.node.http.Server;
import tink.http.Request.IncomingRequestHeader;

using tink.CoreApi;
using tink.io.Source;

import MiniApi;

/* server side */
class MiniServer {
	public static var handler:tink.http.Handler;

	static function main() {
		var here = js.node.Os.hostname();
		trace("here=" + here);

		// var host:tink.url.Host=new tink.url.Host('localhost',8080);
		var server:Server = js.node.Http.createServer();
		var container = new NodeContainer(server);

		var router = new Router<Ruut>(new Ruut());
		var handler:tink.http.Handler = function(req) {
			return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		}

		handler = handler.applyMiddleware(new Static('./statics', '/'));
		handler = handler.applyMiddleware(new Static('./assets', '/assets'));

		server.listen(8080, 'localhost');
		container.run(handler);
	}
}

class Ruut {
	var miniApi:MiniApi;

	public function new() {
		miniApi = new MiniApi(Lite.connect());
	}

	@:produces("text/html")
	@:get("/")
	public function home():tink.template.Html {
		return Layout.render("david");
	}

	@:produces('application/json')
	@:get('/test/$arg')
	public function test(arg:String) {
		return {msg: 'hello $arg'};
	}

	@:produces('application/json')
	@:get
	public function setup()
		return miniApi.setup().next(n -> {msg: "setup ok"});

	@:get('user/new/$name')
	public function usernew(name:String)
		return miniApi.insert(name);

	@:get('user/$name')
	public function user(name:String)
		return miniApi.get(name);

	@:produces('application/json')
	@:get('users')
	public function users(){
		return miniApi.all();
	}

	
}
