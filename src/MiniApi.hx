
import tink.sql.Types;
using tink.CoreApi;


typedef User={
    @:autoIncrement @:primary @:optional public var id(default, null):Id<User>;
	public var name(default,null):VarChar<255>;
}


@:tables(User)
class Db extends tink.sql.Database {}

class Lite{

   static var db:Db;

   static public function connect(){
      var driver = new tink.sql.drivers.Sqlite();
       db = new Db('./lite.db', driver);
       return db;
     }

}
@:publicFields
class MiniApi{



    var db:Db;
    function new(db:Db){
        this.db=db;
    }

    function all(){
        return db.User.all();
    }


    function get(name:String):Promise<User>{
        return db.User.where(User.name==name).first();
    }

    function insert(name:String){
        return db.User.insertOne({name:name});
    }


    function setup(){
       return  db.User.create();
    }

}