import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactos = "contactos";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contactos2.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int versaoNova) async {
      await db.execute(
          "CREATE TABLE $contactos ($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT,"
          "$emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    });
    
  }

  Future<Contacto> salvarContacto(Contacto contacto) async {
    Database dbContacto = await db;
    contacto.id = await dbContacto.insert(contactos, contacto.toMap());
    return contacto;
  }

  Future<Contacto> getContacto(int id) async {
    Database dbContacto = await db;
    List<Map> map = await dbContacto.query(contactos,
        columns: [idColumn, nomeColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (map.length > 0)
      return Contacto.fromMap(map.first);
    else
      return null;
  }

  Future<int> deleteContacto(int id) async {
    Database dbContacto = await db;
    return await dbContacto
        .delete(contactos, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> updateContacto(Contacto contacto) async {
    Database dbContacto = await db;
    return await dbContacto.update(contactos, contacto.toMap(),
        where: "$idColumn = ?", whereArgs: [contacto.id]);
  }

  Future<List> getTodosContactos() async {
    Database dbContacto = await db;
    List listaMapa = await dbContacto.rawQuery("SELECT * FROM $contactos");
    List<Contacto> listaContactos = List();
    for (Map m in listaMapa) {
      listaContactos.add(Contacto.fromMap(m));
    }
    return listaContactos;
  }

  Future<int> getNumber() async {
    Database dbContacto = await db;
    return Sqflite.firstIntValue(
        await dbContacto.rawQuery("SELECT COUNT(*) FROM $contactos"));
  }

  Future fechar() async {
    Database dbContacto = await db;
    dbContacto.close();
  }

  
}

class Contacto {
  int id;
  String nome;
  String email;
  String phone;
  String img;

  Contacto.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }
  Contacto();
  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) map[idColumn] = id;

    return map;
  }

  @override
  String toString() {
    return "Contacto(id: $id, nome: $nome, phone: $phone, img: $img)";
  }
}
